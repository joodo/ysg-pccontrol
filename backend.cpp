﻿#include "backend.h"

Backend* Backend::m_instance = nullptr;

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Backend::instance()->log(QDateTime::currentDateTime().toString(Qt::ISODate) + ": " + msg);
}

Backend::Backend(QObject *parent) : QObject(parent)
{
    m_server = new QTcpServer();
    m_server->listen(QHostAddress::Any, 8899);
    connect(m_server, &QTcpServer::newConnection, this, &Backend::onNewConnection);
    connect(this, &Backend::commandReceived, &Backend::onCommandReceived);

    QTimer::singleShot(3000, []() {SetCursorPos(10000, 10000);});

    qInstallMessageHandler(myMessageOutput);
    connect(this, &Backend::log, &Backend::writeLogToFile);

    // UDP 广播 ip 地址
    m_udpsocket = new QUdpSocket();
    QTimer *timer = new QTimer();
    timer->setInterval(500);
    connect(timer, &QTimer::timeout, [=](){
        if (m_localAddress.isEmpty()) {
            m_localAddress = getLocalAddress();
            if (!m_localAddress.isEmpty()) {
                qDebug(("Local Address: "+m_localAddress).toUtf8());
            }
        }
        if (!m_localAddress.isEmpty()) {
            m_udpsocket->writeDatagram(("ysgserver:"+m_localAddress).toUtf8(), QHostAddress::Broadcast, 8901);
        }
    });
    timer->start();
}

Backend *Backend::instance()
{
    if (m_instance == nullptr) {
        m_instance = new Backend();
    }
    return m_instance;
}

void Backend::writeLogToFile(const QString &message)
{
    if (m_logFile == nullptr) {
        m_logFile = new QFile("ysg-log.txt");
    }
    if (QFileInfo("ysg-log.txt").size() > 1024) {
        m_logFile->open(QIODevice::WriteOnly | QIODevice::Text);
    } else {
        m_logFile->open(QIODevice::Append | QIODevice::Text);
    }
    m_logFile->write((message+'\n').toUtf8());
    m_logFile->close();
}

void Backend::saveToFile(const QString &data, const QString &path)
{
    QFile file(path);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    file.write(data.toUtf8());
    file.close();
}

QString Backend::loadFromFile(const QString &path)
{
    QFile file(path);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return file.readAll();
    } else {
        return "";
    }
    file.close();
}

void Backend::lightAction(const QString &command)
{
    m_socketSandBox.sendCommand(command);
}

void Backend::openChrome(const QString &chromePath)
{
    auto path = QUrl(chromePath).toLocalFile();
    m_process.start(path + " --disable-infobars --kiosk localhost");
}

void Backend::shutdown()
{
    QProcess::startDetached("shutdown -s -f -t 00");
}

QString Backend::getLocalAddress()
{
    QString localAddress;
    for (const QHostAddress& address : QNetworkInterface::allAddresses()) {
        localAddress = address.toString();
        if (localAddress.startsWith("192.168.1.")) {
            break;
        }
    }
    if (localAddress.startsWith("192.168.1.")) {
        return localAddress;
    } else {
        return QString();
    }
}

void Backend::onCommandReceived(const QString &command)
{
   // qDebug(command.toUtf8());
}

void Backend::onNewConnection()
{
    m_socket = m_server->nextPendingConnection();
    connect(m_socket, &QAbstractSocket::readyRead, this, &Backend::onReadyRead);
}

void Backend::onReadyRead()
{
    auto socket = qobject_cast<QAbstractSocket*>(sender());
    auto message = QString(socket->readAll());
    if (message == "ping") {
        socket->write("pong");
    }
    emit commandReceived(message);
}

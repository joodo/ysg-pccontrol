#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
    m_server = new QTcpServer();
    m_server->listen(QHostAddress::Any, 8899);
    connect(m_server, &QTcpServer::newConnection, this, &Backend::onNewConnection);
    connect(this, &Backend::commandReceived, &Backend::onCommandReceived);
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

void Backend::onCommandReceived(const QString &command)
{
    qDebug(command.toUtf8());
}

void Backend::onNewConnection()
{
    m_socket = m_server->nextPendingConnection();
    connect(m_socket, &QAbstractSocket::readyRead, this, &Backend::onReadyRead);
}

void Backend::onReadyRead()
{
    auto socket = qobject_cast<QAbstractSocket*>(sender());
    emit commandReceived(socket->readAll());
}

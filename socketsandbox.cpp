#include "socketsandbox.h"

SocketSandBox::SocketSandBox(QObject *parent) : QTcpSocket(parent)
{
    connectToSandBox();
}

void SocketSandBox::sendCommand(const QString &command)
{
    if (state() != QAbstractSocket::ConnectedState) {
        connectToSandBox();
    }
    QStringList commands = command.split(',', QString::SkipEmptyParts);
    write(QByteArray::fromHex(commands.at(0).toUtf8()));
    qDebug("send to sandbox: %s", commands.at(0).toStdString().c_str());
    if (commands.count() > 1) {
        QTimer::singleShot(50, [=]() { write(QByteArray::fromHex(commands.at(1).toUtf8())); });
    }
}

void SocketSandBox::connectToSandBox()
{
    connectToHost("192.168.1.247", 8899);
}

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
    for (const QString& c : command.split(',', QString::SkipEmptyParts)) {
        write(QByteArray::fromHex(c.toUtf8()));
        qDebug(c.toUtf8());
    }
}

void SocketSandBox::connectToSandBox()
{
    connectToHost("192.168.1.247", 8899);
}

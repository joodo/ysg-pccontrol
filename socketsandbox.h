#ifndef SOCKETSANDBOX_H
#define SOCKETSANDBOX_H

#include <QTcpSocket>
#include <QTimer>

class SocketSandBox : public QTcpSocket
{
    Q_OBJECT
public:
    explicit SocketSandBox(QObject *parent = nullptr);

signals:

public slots:
    void sendCommand(const QString& command);

private:
    void connectToSandBox();
};

#endif // SOCKETSANDBOX_H

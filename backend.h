#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>
#include <QTcpServer>
#include <QTcpSocket>
#include <QProcess>
#include <QUrl>
#include <QFileInfo>
#include <QDateTime>

#include <Windows.h>
#pragma comment(lib, "User32.lib")

#include "socketsandbox.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);
    static Backend* instance();
private:
    static Backend* m_instance;

signals:
    void commandReceived(const QString& command);

signals:
    void log(const QString& message);
private slots:
    void writeLogToFile(const QString& message);
private:
    QFile *m_logFile = nullptr;

public slots:
    void saveToFile(const QString& data, const QString& path);
    QString loadFromFile(const QString& path);
    void lightAction(const QString& command);
    void openChrome(const QString& chromePath);
    void shutdown();

private:
    QTcpServer *m_server;
    QTcpSocket *m_socket;
    QProcess m_process;

    SocketSandBox m_socketSandBox;

private slots:
    void onCommandReceived(const QString& command);
    void onNewConnection();
    void onReadyRead();
};

#endif // BACKEND_H

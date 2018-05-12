#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>
#include <QTcpServer>
#include <QTcpSocket>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

signals:
    void commandReceived(const QString& command);

public slots:
    void saveToFile(const QString& data, const QString& path);
    QString loadFromFile(const QString& path);

private:
    QTcpServer *m_server;
    QTcpSocket *m_socket;

private:
    void onCommandReceived(const QString& command);
};

#endif // BACKEND_H

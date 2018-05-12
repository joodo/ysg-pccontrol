#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

signals:

public slots:
    void saveToFile(const QString& data, const QString& path);
    QString loadFromFile(const QString& path);
};

#endif // BACKEND_H

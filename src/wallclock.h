#ifndef WALLCLOCK_H
#define WALLCLOCK_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

class WallClock : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QDateTime dateTime READ dateTime NOTIFY dateTimeChanged)

public:
    WallClock(QObject *parent = nullptr);

    QDateTime dateTime() const;

signals:
    void dateTimeChanged();

private:
    QTimer m_timer;
};

#endif // WALLCLOCK_H

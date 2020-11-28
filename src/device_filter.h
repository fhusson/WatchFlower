/*!
 * This file is part of WatchFlower.
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2020
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

#ifndef DEVICE_FILTER_H
#define DEVICE_FILTER_H
/* ************************************************************************** */

#include "device.h"
#include "device_sensors.h"

#include <QObject>
#include <QMetaType>
#include <QAbstractListModel>
#include <QSortFilterProxyModel>

/* ************************************************************************** */

class DeviceFilter : public QSortFilterProxyModel
{
    Q_OBJECT

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

public:
    DeviceFilter(QObject *parent = nullptr);
    ~DeviceFilter();
};

/* ************************************************************************** */

class DeviceModel : public QAbstractListModel
{
    Q_OBJECT

protected:
    QHash<int, QByteArray> roleNames() const;

public:
    DeviceModel(QObject *parent = nullptr);
    DeviceModel(const DeviceModel &other, QObject *parent = nullptr);
    ~DeviceModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    bool hasDevices() const { return !m_devices.empty(); }
    void getDevices(QList<Device *> &device);
    int getDeviceCount() const { return m_devices.size(); }

    QList<Device *> m_devices;

    enum DeviceRoles {
        DeviceModelRole = Qt::UserRole+1,
        DeviceNameRole,
        DeviceLocationRole,
        RssiRole,

        AssociatedNameRole,
        PlantNameRole,
        SoilMoistureRole,

        PointerRole,
    };
    Q_ENUM(DeviceRoles)

public slots:
    void addDevice(Device *d);
    void removeDevice(Device *d);
    void sanetize();
};

/* ************************************************************************** */
#endif // DEVICE_FILTER_H

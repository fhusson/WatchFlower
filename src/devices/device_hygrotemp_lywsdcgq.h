/*!
 * This file is part of WatchFlower.
 * Copyright (c) 2022 Emeric Grange - All Rights Reserved
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
 * \date      2018
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

#ifndef DEVICE_HYGROTEMP_LYWSDCGQ_H
#define DEVICE_HYGROTEMP_LYWSDCGQ_H
/* ************************************************************************** */

#include "device_sensor.h"

#include <QObject>
#include <QList>

#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>

/* ************************************************************************** */

/*!
 * Xiaomi MiJia "Bluetooth Hygrometer"
 * Xiaomi "Bluetooth Temperature and Humidity sensor with LCD"
 * LYWSDCGQ device / round body / LCD
 *
 * Protocol infos:
 * - WatchFlower/docs/lywsdcgq-ble-api.md
 */
class DeviceHygrotempLYWSDCGQ: public DeviceSensor
{
    Q_OBJECT

public:
    DeviceHygrotempLYWSDCGQ(const QString &deviceAddr, const QString &deviceName, QObject *parent = nullptr);
    DeviceHygrotempLYWSDCGQ(const QBluetoothDeviceInfo &d, QObject *parent = nullptr);
    ~DeviceHygrotempLYWSDCGQ();

private:
    // QLowEnergyController related
    void serviceScanDone();
    void addLowEnergyService(const QBluetoothUuid &uuid);
    void serviceDetailsDiscovered_infos(QLowEnergyService::ServiceState newState);
    void serviceDetailsDiscovered_battery(QLowEnergyService::ServiceState newState);
    void serviceDetailsDiscovered_data(QLowEnergyService::ServiceState newState);

    QLowEnergyService *serviceInfos = nullptr;
    QLowEnergyService *serviceBattery = nullptr;
    QLowEnergyService *serviceData = nullptr;

    QLowEnergyDescriptor m_notificationDesc;
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value);

    void bleWriteDone(const QLowEnergyCharacteristic &c, const QByteArray &value);
    void bleReadDone(const QLowEnergyCharacteristic &c, const QByteArray &value);
    void bleReadNotify(const QLowEnergyCharacteristic &c, const QByteArray &value);
};

/* ************************************************************************** */
#endif // DEVICE_HYGROTEMP_LYWSDCGQ_H
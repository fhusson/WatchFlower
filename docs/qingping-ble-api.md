
## About Qingping advertisement

The Qingping data protocol is used by devices from Qingping (formerly Cleargrass) company to advertise data over Bluetooth Low Energy.  

<img src="endianness.png" width="400px" alt="Endianness" align="right" />

## Data structure

Bluetooth payload data typically uses little-endian byte order.  
This means that the data is represented with the least significant byte first.  

To understand multi-byte integer representation, you can read the [endianness](https://en.wikipedia.org/wiki/Endianness) Wikipedia page.

## Advertisement data

Qingping data protocol usually broadcast 14-21+ bytes `service data` messages, over `0xFDCD` 16 bits service UUID.  

Multiple measurement can be sent per advertisement message.  

#### Example data

| Device       | Position | 00 | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
| ------------ | -------- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
| CGP1W        | values > | 08 | 09 | XX | XX | 40 | 34 | 2d | 58 | 01 | 04 | 08 | 01 | 87 | 02 | 07 | 02 | 4f | 27 | 02 | 01 | 5c |
| CGP1W        |          | 08 | 09 | XX | XX | 12 | 34 | 2d | 58 | 01 | 04 | 0b | 01 | ce | 00 | 07 | 02 | ea | 26 | 02 | 01 | 5a |
| CGD1         |          | 08 | 0c | XX | XX | 50 | 34 | 2d | 58 | 01 | 04 | 0a | 01 | 7f | 02 | 02 | 01 | 2a | -  | -  | -  | -  |
| CGDK2        |          | 08 | 10 | XX | XX | 11 | 34 | 2d | 58 | 01 | 04 | e9 | 00 | 1d | 02 | 02 | 01 | 0b | -  | -  | -  | -  |
| CGDK2        |          | 08 | 10 | XX | XX | 12 | 34 | 2d | 58 | 01 | 04 | 31 | 01 | c9 | 01 | 02 | 01 | 51 | -  | -  | -  | -  |
| CGG1         |          | 80 | 07 | XX | XX | 12 | 34 | 2d | 58 | 01 | 04 | 2b | 01 | 90 | 02 | 02 | 01 | 24 | -  | -  | -  | -  |
| CGG1-M       |          | 88 | 16 | XX | XX | 12 | 34 | 2d | 58 | 01 | 04 | 1d | 01 | d5 | 01 | 02 | 01 | 55 | -  | -  | -  | -  |
| CGH1         |          | 08 | 04 | XX | XX | 60 | 34 | 2d | 58 | 02 | 01 | 60 | 0f | 01 | 2b | 0f | 01 | 00 | -  | -  | -  | -  |
| CGPR1        |          | 08 | 12 | XX | XX | 60 | 34 | 2d | 58 | 02 | 01 | 53 | 0f | 01 | 18 | 09 | 04 | 00 | 00 | 00 | 00 | -  |

#### Protocol

| Bytes | Type      | Value             | Description                          |
| ----- | --------- | ----------------- | ------------------------------------ |
| 00-01 | bytes     | 0x0810            | Product ID?                          |
| 02-07 | bytes     | 58:2D:34:12:XX:XX | MAC address                          |

Then each payload element use this format: (and can be chainloaded)

| Bytes | Type      | Description                                              |
| ----- | --------- | -------------------------------------------------------- |
| 08    | byte      | payload data type (see 'type of measurement' table)      |
| 09    | uint8     | payload data size (in bytes)                             |
| 10-0x | data      | payload data                                             |

Example with a CGP1W advertisement message:

| Bytes | Type      | Value             | Description                          |
| ----- | --------- | ----------------- | ------------------------------------ |
| 00-01 | bytes     | 0x0809            | Product ID                           |
| 02-07 | bytes     | 58:2D:34:12:XX:XX | MAC address                          |
| 08    | byte      | 0x01              | (1) data is 'temperature + humidity' |
| 09    | uint8     | 0x04              | (1) 4 bytes of data                  |
| 10-11 | int16_le  | 0x0108 = 26.4°    | (1) temperature (2 bytes)            |
| 12-13 | int16_le  | 0x0287 = 64.7%    | (1) humidity (2 bytes)               |
| 14    | byte      | 0x07              | (2) data is 'air pressure'           |
| 15    | uint8     | 0x02              | (2) 2 bytes of data                  |
| 16-17 | int16_le  | 0x274f = 998.8 hPa| (2) air pressure (2 bytes)           |
| 18    | byte      | 0x02              | (3) data is 'battery level'          |
| 19    | uint8     | 0x01              | (3) 2 bytes of data                  |
| 20    | int8_le   | 0x5c = 92%        | (3) air pressure (2 bytes)           |

#### Product IDs

| Device       | Product IDs              |
| ------------ | ------------------------ |
| CGG1         | 0x0807 / 0x8816          |
| CGDK2        | 0x0810 / 0x8810          |
| CGD1         | 0x080C                   |
| CGP1W        | 0x0809                   |
| CGPR1        | 0x0812                   |
| CGH1         | 0x0804 / 0x4804          |

#### Type of measurement

```
0x01 = temperature + humidity
0x02 = battery level
0x07 = air pressure
0x09 = ?
0x0f = door state?
```

#### Payload format

###### Temperature and humidity

| name        | length    | description                                        |
| ------------| --------- | -------------------------------------------------- |
| temperature | int16_le  | Temperature in °C (signed value, divide by 10)     |
| humidity    | uint16_le | Humidity percentage (divide by 10), range is 0-100 |

###### Battery level

| name       | length     | description                                        |
| ---------- | ---------- | -------------------------------------------------- |
| battery    | uint8      | Battery level in %, range is 0-100                 |

###### Air pressure

| name       | length     | description                                        |
| ---------- | ---------- | -------------------------------------------------- |
| pressure   | uint16_le  | Air pressure in kPa, divide by 10 to get hPa       |

## Reference

[1] -  

## License

MIT
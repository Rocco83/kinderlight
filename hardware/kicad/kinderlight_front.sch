Eagle CAD Schematic v7.7
[Title] KinderLight Front Board
[Description] PCB frontale con LED e sensore BH1750
[Revision] 1.0
[Date] 2025-04-26
[Author] Daniele Palumbo
[License] GPLv3

Components:
- LED1: Cree XP-G3 5V
- SENS1: BH1750 modulo breakout
- Q1: IRLML6344 MOSFET PWM
- R1, R2: 10kΩ resistenze
- J1: Header 5 pin (5V, GND, PWM_OUT, SDA, SCL)
- TC1: Tag-Connect footprint 6-pin

Connections:
- PWM from ESP32 → Gate Q1
- Drain Q1 → LED1 cathode
- 5V → LED1 anode, BH1750 VCC
- GND comune
- I2C → SDA/SCL → BH1750
- Tag-Connect: Debug/Flash ESP32

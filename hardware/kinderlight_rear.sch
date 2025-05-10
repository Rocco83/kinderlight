Eagle CAD Schematic v7.7
[Title] KinderLight Rear Board
[Description] PCB retro con ESP32 + Buck + opzionale batteria
[Revision] 1.0
[Date] 2025-04-26
[Author] Daniele Palumbo
[License] GPLv3

Components:
- U1: ESP32-C3 Mini DevKit
- U2: MP1584 Buck Converter 12V→5V
- U3: TP4056 + DW01 Battery Charger
- P1: Connessione 5P (JST) verso Front PCB
- P2: Connettore 2P batteria opzionale
- F1: PTC Fuse 500mA (opzionale)

Connections:
- 12V IN → MP1584 VIN
- MP1584 VOUT → 5V Rail
- 5V Rail → ESP32 VIN
- 5V Rail → Front PCB via P1
- TP4056 gestisce batteria in parallelo
- Fusibile opzionale protezione ingresso

# KinderLight RGB - Note Integrazione YAML

## 📋 Informazioni generali

- Firmware compatibile con ESPHome 2024.x
- Sensore BH1750 su bus I2C
- LED RGB controllati tramite PWM su 3 canali separati.

## 🛠️ GPIO assegnati (default)

| Funzione | GPIO |
|---|---|
| PWM_R (Rosso) | GPIO4 |
| PWM_G (Verde) | GPIO5 |
| PWM_B (Blu) | GPIO6 |
| SDA (I2C) | GPIO8 |
| SCL (I2C) | GPIO9 |

**Nota**: Gli assegnamenti possono essere cambiati se necessario nel file YAML.

## 📋 Considerazioni

- Utilizzare resistenze limitatrici per i LED (150Ω Rosso, 100Ω Verde/Blu).
- Utilizzare IRLML6344 SOT-23 per PCB reale.
- Per breadboard è possibile usare 2N7000 (TO-92) senza modifiche logiche.
- Frequenza PWM suggerita: 1000Hz o superiore.

## 📋 Altri dettagli

- Input Voltage: 10V–12V DC → regolato a 5V tramite Buck converter MP1584EN.
- Snap-in compatibile Vimar 14041, 14026 (supporto 3D in sviluppo).

---

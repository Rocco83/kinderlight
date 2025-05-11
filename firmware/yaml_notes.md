# KinderLight RGB - YAML Notes

## 📋 General Information

- Firmware is compatible with ESPHome 2024.x versions.
- Ambient light detection using BH1750 sensor over I2C bus.
- RGB LED controlled through independent PWM channels.

## 🛠️ GPIO Pin Assignments

| Function        | GPIO |
|-----------------|------|
| PWM Red (LED)   | GPIO1 |
| PWM Green (LED) | GPIO2 |
| PWM Blue (LED)  | GPIO3 |
| SDA (I2C Data)  | GPIO8 |
| SCL (I2C Clock) | GPIO9 |

> **Note**:  
> These pin assignments can be modified if needed in the `kinderlight_rgb.yaml` file.

## 🔥 Key Recommendations

- Use **IRLML6344** SOT-23 MOSFETs for production PCB (small, efficient).
- For breadboard testing, you can use **2N7000** MOSFETs (TO-92 package) **without any circuit changes**.
- Recommended PWM frequency: **at least 1000Hz** to avoid visible flicker.

## ⚙️ Electrical Characteristics

- Input voltage range: **10V–12V DC**.
- Buck converter module MP1584EN reduces voltage to stable 5V.
- Ambient light detection threshold: adjustable via YAML, default is **<50 lux** to consider it dark.

## 🛜 Network & OTA

- OTA updates are enabled.
- A fallback Access Point will be created if Wi-Fi is not available during boot.
- Web server interface available at device's IP address (port 80).

---

# 📦 Important Notes

- ESP32-C3 board must be properly connected to the rear PCB via a 5P JST-SH connector.
- Ambient light sensor BH1750 uses I2C address `0x23`.
- RGB light can be fully controlled from Home Assistant dashboards.
- Automation examples are available under `example_automation.yaml`.

---

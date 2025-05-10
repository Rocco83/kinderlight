# KinderLight Firmware

This directory contains the ESPHome configuration for the KinderLight RGB nightlight device.

## 📦 Files

- `kinderlight.yaml`: main ESPHome configuration file for the ESP32 controller.
- `secrets.yaml.example`: example of the secrets file you need to set up for WiFi credentials.

## 🔧 Hardware Configuration

| Component           | GPIO  | Notes                          |
|---------------------|--------|-------------------------------|
| RGB LED - Red PWM   | GPIO14 | Controlled via IRLML6344 MOSFET |
| RGB LED - Green PWM | GPIO27 | " |
| RGB LED - Blue PWM  | GPIO26 | " |
| I2C SDA             | GPIO21 | Used for BH1750 light sensor |
| I2C SCL             | GPIO22 | " |

## 💡 Functionality

- **RGB LED light** with full Home Assistant control.
- **Smooth fading** transitions.
- **BH1750 ambient light sensor** for automatic on/off logic.
- Optional **voltage/battery monitoring** (coming soon).

## 🚀 Flash Instructions

1. Copy `kinderlight.yaml` into your ESPHome config folder.
2. Duplicate `secrets.yaml.example` into your root ESPHome directory as `secrets.yaml`, and set your WiFi credentials.
3. Flash via USB or OTA:
   ```bash
   esphome run kinderlight.yaml

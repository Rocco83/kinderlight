# KinderLight RGB

KinderLight RGB is a smart night light based on an ESP32-C3 microcontroller,  
capable of automatically adjusting brightness and color based on ambient light using a BH1750 sensor.

Designed to integrate natively with **Home Assistant** via **ESPHome**.

---

## ✨ Features

- Automatic ambient light detection with BH1750 sensor.
- RGB LED control via PWM (independent channels for Red, Green, Blue).
- Wi-Fi control and OTA (Over The Air) firmware updates.
- Web server interface for local diagnostics.
- Optional manual serial debug connection via JST-SH 5P or Tag-Connect footprint.
- Easy snap-in mount inside a **Vimar Plana** 14041 or 14026 cover plate.
- Input voltage 10–12V regulated to 5V with buck converter.
- Smooth fade-in and fade-out effects.
- Automatic activation from sunset to sunrise.

## Hardware Required

- ESP32 Mini DevKit
- BH1750 light sensor module
- 3x IRLML6344 (or 2N7000 for breadboard)
- RGB LED (common anode preferred)
- MP1584 DC-DC Stepdown Module
- Optional: TP4056 charger for backup battery
- 3D printed snap-in panel for Vimar 14041

## Software

- ESPHome (latest)
- Home Assistant (latest)
- YAML automations provided.

## Installation

1. Flash the ESP32 using provided `kinderlight.yaml` ESPHome config.
2. Install the snap-in panel inside a Vimar 14041 (or custom box).
3. Wire the RGB LED, BH1750 sensor, and optionally the MP1584 converter.
4. Upload automations to Home Assistant.

## Entities Created

- `light.kinderlight_rgb`
- `sensor.ambient_light_lux`

(Optional Voltage monitor if configured.)

## Automation Logic

- Turns on at sunset, off at sunrise.
- During daytime, activates if ambient lux falls below threshold.
- Full color control from Home Assistant dashboard.

## Future Plans

- OTA updates for firmware.
- Support for multiple KinderLights via groups.
- Additional effects (color cycling, breathing mode).

## License

GPL-3.0 License

---

## 📂 Project Structure

```plaintext
kinderlight_rgb/
├── README.md
├── LICENSE
├── hardware/
│   ├── front/
│   │   ├── kinderlight_front.sch
│   │   ├── kinderlight_front.kicad_pcb
│   ├── rear/
│   │   ├── kinderlight_rear.sch
│   │   ├── kinderlight_rear.kicad_pcb
│   └── 3d_models/
│       ├── snapin_14041.stl
│       └── snapin_14026.stl
├── firmware/
│   ├── kinderlight_rgb.yaml
│   ├── yaml_notes.md
│   ├── example_automation.yaml
├── bom/
│   ├── bom_front.csv
│   ├── bom_rear.csv
└── tools/
    ├── wiring_diagram.svg
    └── wiring_diagram.png

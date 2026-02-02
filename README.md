# KinderLight RGB

KinderLight RGB is a smart night light based on an ESP32-C6 microcontroller,
capable of automatically adjusting brightness and color based on ambient light using a BH1750 sensor.

Designed to integrate natively with **Home Assistant** via **ESPHome**.

---

## Features

- Automatic ambient light detection with BH1750 sensor.
- RGB LED control via PWM (independent channels for Red, Green, Blue).
- Wi-Fi control and OTA (Over The Air) firmware updates.
- Web server interface for local diagnostics.
- Optional manual serial debug connection via JST-SH 5P or Tag-Connect footprint (future).
- Easy snap-in mount inside a **Vimar Plana** 14041 cover plate.
- Input voltage 7–24V regulated to 5V with buck converter.
- Smooth fade-in and fade-out effects.
- Automatic activation from sunset to sunrise (future).

## Hardware Required

- ESP32-C6 Supermini
- BH1750 light sensor module
- MP1584 DC-DC Stepdown Module
- RGB LED (common anode)
- 3D printed snap-in panel for Vimar 14041
- optionally, the PCB to host the components, otherwise replicate the same BOM

## Software

- ESPHome (latest)
- Home Assistant (latest)
- YAML automations provided.

## Installation

1. Flash the ESP32 using provided `kinderlight.yaml` ESPHome config.
2. Install the snap-in panel inside a Vimar 14041 (or custom box).
3. Wire the RGB LED and the BH1750 sensor
4. Upload automations to Home Assistant.

## Configuration

Lux table:
0.0 - 2.0 lx: Danger Zone (High risk of tripping/hitting furniture).
2.0 - 5.0 lx: Deep Twilight (Silhouettes only; no colors or textures visible).
5.0 - 10.0 lx: Twilight (General shapes visible; fine details are lost).
10.0 - 15.0 lx: Low Orientation (Safe to move; colors begin to be distinguishable).
15.0 - 20.0 lx: Dim Orientation (Comfortable for a nightlight; eye starts to adapt).
20.0 - 30.0 lx: Gloomy Interior (Environment feels "dark" but fully visible).

## Entities Created

- `light.kinderlight_rgb`
- `sensor.ambient_light_lux`

(Optional Voltage monitor if configured.)

## Automation Logic

- Turns on at sunset, off at sunrise.
- During daytime, activates if ambient lux falls below threshold.
- Full color control from Home Assistant dashboard.

## Future Plans

- Support for multiple KinderLights via groups.
- Additional effects (color cycling, breathing mode).

## License

GPL-3.0 License

---

## Project Structure

```plaintext
kinderlight_rgb/
├── README.md
├── LICENSE
├── hardware/
│   └── 3d_models/
│       ├── snapin_14041.stl
│       └── 
├── firmware/
│   ├── kinderlight_rgb.yaml
│   ├── example_automation.yaml
├── bom/
│   ├── bom_front.csv
│   ├── bom_rear.csv
└── tools/
    ├── wiring_diagram.svg
    └── wiring_diagram.png

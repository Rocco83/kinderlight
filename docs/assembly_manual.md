# KinderLight RGB - Assembly Manual

This guide will help you assemble both the Front PCB and the Rear PCB of the KinderLight RGB project.

---

## 📋 General Requirements

- Soldering iron with fine tip
- Solder wire (preferably leaded 60/40 for easier work)
- Flux (recommended for SMD parts)
- Tweezers (for SMD parts handling)
- Small wire cutters
- JST-SH 1.0mm crimping tool (optional but recommended)

---

## 🛠️ Front PCB Assembly Steps

1. **Place and solder resistors (Through-Hole):**
   - R1: 150Ω (Red LED current limit)
   - R2: 100Ω (Green LED current limit)
   - R3: 100Ω (Blue LED current limit)
   - R4, R5, R6: 10kΩ (Gate pull-down resistors)

2. **Place and solder SMD MOSFETs:**
   - Q1, Q2, Q3: IRLML6344 (SOT-23 package)
   - *(Use flux and tweezers, or reflow manually.)*

3. **Place and solder the RGB LED (Through-Hole):**
   - LED1: RGB common cathode, 5mm.

4. **Place and solder BH1750 Light Sensor:**
   - U1: BH1750 module (direct or via pin header).

5. **Place and solder JST-SH connectors:**
   - J1: 7P (Main RGB + I2C)
   - J2: 5P (Serial debug)

6. **(Optional)** Solder Tag-Connect TC2030 footprint pads if needed.

---

## 🛠️ Rear PCB Assembly Steps

1. **Place and solder JST-SH 5P connectors:**
   - J3: Input from Front PCB (serial + power).
   - J4: Output to ESP32 DevKit Mini (serial + reset).

2. **Place and solder Buck converter:**
   - DC1: MP1584EN module (12V → 5V).
   - Secure it mechanically if needed with glue or brackets.

3. **Mount ESP32-C3 Mini DevKit:**
   - Connect via header pins or female socket.

4. **(Optional)** Place and solder a battery connector:
   - BAT_CONN: 2-pin connector for backup battery.

5. **(Optional)** Solder Tag-Connect TC2030 footprint pads for programming/debugging.

---

## 🔥 Important Assembly Notes

- Always double-check MOSFET orientation (Drain, Source, Gate).
- Verify LED polarity: common cathode must go to GND.
- Use multimeter continuity mode to check shorts before applying power.
- Verify 5V stable output from Buck Converter before connecting ESP32.
- Use JST-SH cables correctly: color-code the wires if possible.

---

## 🎯 Initial Power-Up Checklist

- Check 12V input arriving to Buck Converter.
- Check 5V stable at ESP32 VCC.
- Confirm ESP32 boot by serial console or WebServer.
- Verify light sensor BH1750 detection (via ESPHome logs).
- Test LED RGB color control via Home Assistant.

---

# 🚀 Congratulations!

You have successfully assembled your KinderLight RGB unit!  
Enjoy your smart and modular nightlight system.

---

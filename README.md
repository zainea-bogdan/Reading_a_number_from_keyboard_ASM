# 📄 README — Floating-Point Conversion in x86 Assembly

<p align="center">
  <img src="asm number.png" alt="Logo" width="600">
</p>
<p align="center">
  <em>Created using Canva AI tools. I do not claim ownership of the visual elements.<br>
  If this image presents an issue, please feel free to contact me.</em>
</p>


## 📌 Overview
This assembly program reads an **integer input from the keyboard** (with optional sign), processes it, and **converts it into a 32-bit IEEE 754-style floating-point binary format**. The final result is stored in the `numero` variable as a `DWORD`.

## 🧠 Features

- **Keyboard Input Parsing**:
  - Accepts digits character by character.
  - Supports optional negative numbers via `-`.

- **Normalization & Floating-Point Decomposition**:
  - Calculates the binary **mantissa** and **exponent**.
  - Applies **normalization** similar to IEEE 754.
  - Constructs the floating-point value in parts:
    - **Sign bit**
    - **Exponent field** (with bias 127)
    - **Mantissa bits**

- **Binary Bit Manipulation**:
  - Implements shifting and bit rotation to isolate and assemble floating-point components.
  - Organizes the final 32-bit value in the `numero` variable using two `mov` blocks:
    - Lower 16 bits (mantissa part 2)
    - Upper 16 bits (sign + exponent + mantissa part 1)

## 🧪 Input Format

- Type a number using the keyboard.
  - Example: `-23` or `45`
- Press `Enter` to end input and trigger conversion.

## 🛠 Technical Notes

- Uses DOS interrupts (`int 21h`) for input/output.
- Assumes small memory model and a 200h stack.
- Relies on bitwise operations (`SHL`, `SHR`, `AND`, `ROR`) for floating-point logic.
- Emulates floating-point encoding manually (without FPU).

## 💾 Output

- The resulting 32-bit representation is stored in the `numero` variable in memory:
  - `numero` (DWORD): custom float in IEEE 754-like format

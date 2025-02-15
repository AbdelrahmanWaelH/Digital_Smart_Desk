# FPGA-Based Digital Clock & Smart Study Desk

## Overview
This project demonstrates FPGA-based digital design by implementing a **real-time digital clock** and a **smart study desk system** using **VHDL** on the **DE10-Lite FPGA board**. The project focuses on hardware design, real-time processing, and sensor integration.

## Digital Clock Design
### System Specifications
- Displays **hours, minutes, and seconds**.
- Operates on a **50 GHz system clock**.
- Each clock cycle is treated as **one second** for simplicity.
- Implements a **synchronous active-low reset**.
- Uses **VHDL** for implementation and a **testbench** for verification.
- Simulated and validated using **ModelSim**.

### Functional Requirements
- **Time Representation:** Hours, minutes, and seconds stored as integers.
- **Reset Handling:** The testbench must apply at least one reset.
- **Clock Continuity:** After reset, the clock resumes normal operation.

## Smart Study Desk Design
### System Features
- **User Presence Detection:** Detects when a user approaches.
- **Automatic Light Control:** Adjusts room light intensity if needed.
- **Automated Drawer System:** Opens for **10 seconds** when the user is near.
- **Usage Tracking:** Displays time spent at the desk on a **7-segment display**.

### Implementation Approach
- Sensors detect user presence and ambient light conditions.
- The system controls a **lamp** based on light intensity.
- A **timer module** records and displays desk usage duration.
- The design is simulated in **ModelSim** before hardware testing.

## Deliverables
- **VHDL Source Code** for both systems.
- **Testbench Code** with verification results.

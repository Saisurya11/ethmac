Ethernet MAC (EthMAC) – UVM Verification Project

This repository contains the complete UVM-based verification environment developed to validate an Ethernet MAC (EthMAC) design. The work focuses on verifying the transmit (TX) and receive (RX) data paths, MII operations, control frame handling, collision scenarios, and compliance with standard Ethernet frame formats.

Over the course of this project, a structured and coverage-driven verification flow was implemented, supported by extensive debugging, regression execution, and coverage analysis.

🚀 Project Highlights

Verification environment developed entirely using SystemVerilog and UVM

12 directed and constrained-random testcases covering complete TX/RX functionality

Verification of:

Control frames

MII read/write operations

Collision detection and handling

IFG (Inter-Frame Gap) compliance

Frame format validation

Full regression executed on QuestaSim

Achieved 75% code coverage and high functional coverage towards closure

UVM RAL Model implemented for register-level verification

Comprehensive debugging and testcase stability ensured before final sign-off


🔍 Verification Approach

The verification environment follows a layered UVM architecture:

1. Stimulus Generation

Randomized and directed sequences

Scenario coverage of:

Valid/invalid frames

Boundary conditions

Collision and MII interaction

2. Bus Functional Modelling

Driver translates sequence items into pin-level MII activity

Monitor reconstructs frames and sends them to scoreboard

3. Scoreboarding & Checking

End-to-end data integrity

Frame validation (preamble, SFD, CRC assumptions, payload size)

Control frame behaviour

IFG policy compliance

4. RAL Model Usage

Frontdoor and backdoor access

Register reset checks

Mirror and prediction checks

5. Coverage

Functional coverage for:

Frame types

Collision scenarios

IFG compliance

MII operations

Code coverage analysed from QuestaSim reports

📈 Results

All 12 tests stable and regression-clean

75% code coverage achieved through directed + CRV tests

Functional coverage indicates good closure across all bins of TX, RX, and MII features

Zero mismatches in final scoreboarding during regression

🛠 Tools & Technologies

SystemVerilog, UVM 1.2

QuestaSim / ModelSim

RAL Model (frontdoor + backdoor access)

MII interface modelling

Version control: Git

🧑‍💻 Author

Punyamurthy Sai Surya
Design Verification Engineer
LinkedIn: www.linkedin.com/in/psaisurya

GitHub: github.com/Saisurya11

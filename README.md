# Student Attendance Tracker – Deployment Agent
# Project Overview

This project contains a master shell script called setup_project.sh that automates the deployment of a Student Attendance Tracker application.

# The script:

Creates the required directory structure

Generates all necessary project files

Allows dynamic configuration using sed

Validates user input

Performs an environment health check

Handles system interrupts using a signal trap

Archives incomplete setups automatically

Repository Name:
deploy_agent_T-GIHOZA

# Directory Structure Created

When the script runs successfully, it generates the following structure:

attendance_tracker_<input>/
│
├── attendance_checker.py
├── image.png
│
├── Helpers/
│   ├── assets.csv
│   └── config.json
│
└── reports/
    └── reports.log


Where <input> is the suffix provided by the user during setup.

# How to Run the Project

Step 1: Clone the Repository
git clone https://github.com/T-GIHOZA/deploy_agent_T-GIHOZA.git
cd deploy_agent_T-GIHOZA

Step 2: Make Script Executable
chmod +x setup_project.sh

Step 3: Run the Setup Script
./setup_project.sh


You will be prompted to:

Enter a project name suffix

Choose whether to update attendance thresholds

Enter new Warning and Failure percentages (optional)

# Dynamic Configuration

If you choose to update thresholds:

The script validates that the values entered are numeric.

It uses the sed -i command to update the values directly inside:

Helpers/config.json


Default values:

Warning: 75%

Failure: 50%

# Environment Health Check

Before finishing, the script verifies whether Python3 is installed by running:

python3 --version


If Python3 is installed:

A success message is displayed.

If not installed:

A warning message is shown.

This ensures the application can run properly.

# Archive Feature (Signal Trap)

The script includes a SIGINT trap to handle interruptions.

How to Trigger It

While the script is running, press:

CTRL + C

What Happens

The current project directory is compressed into a .tar.gz archive

The incomplete project directory is deleted

The workspace remains clean

Archive naming format:

attendance_tracker_<name>_archive.tar.gz


This demonstrates proper process management and cleanup handling.

# Error Handling

The script includes validation for:

Empty project names

Duplicate directories

Invalid threshold input (non-numeric values)

Directory structure verification after creation

If an error occurs, the script exits safely with an appropriate message.

# Running the Attendance Application

After setup completes:

cd attendance_tracker_<input>
python3 attendance_checker.py


This will:

Read student attendance data from assets.csv

Compare attendance percentages against thresholds

Generate alerts

Write results to reports/reports.log

# Learning Objectives Demonstrated

This project demonstrates:

Shell scripting automation

Directory and file management

Stream editing using sed

Signal handling with trap

Process cleanup and archiving

Environment validation

Version control using Git

# Video Walkthrough

A run-through video is included in the submission explaining:

Script logic

Directory automation

Dynamic configuration

Signal trap demonstration

Health check process

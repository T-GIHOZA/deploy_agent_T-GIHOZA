#!/bin/bash

# ---- SIGNAL TRAP ----
cleanup_on_interrupt() {
    echo ""
    echo "Script interrupted! Archiving current state..."

    if [ -d "$PROJECT_DIR" ]; then
        tar -czf "${PROJECT_DIR}_archive.tar.gz" "$PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
        echo "Archived as ${PROJECT_DIR}_archive.tar.gz"
        echo "Incomplete directory removed."
    fi

    exit 1
}

trap cleanup_on_interrupt SIGINT

# ---- USER INPUT ----
read -p "Enter project name suffix: " USER_INPUT

if [ -z "$USER_INPUT" ]; then
    echo "Project name cannot be empty."
    exit 1
fi

PROJECT_DIR="attendance_tracker_${USER_INPUT}"

# ---- DIRECTORY CREATION ----
if [ -d "$PROJECT_DIR" ]; then
    echo "Directory already exists!"
    exit 1
fi

mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

# ---- CREATE FILES ----

# attendance_checker.py
cat > "$PROJECT_DIR/attendance_checker.py" << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)

    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log',
                  f'reports/reports_{timestamp}.log.archive')

    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log','w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")

        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])

            attendance_pct = (attended / total_sessions) * 100
            message = ""

            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."

            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF

# assets.csv
cat > "$PROJECT_DIR/Helpers/assets.csv" << 'EOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

# config.json
cat > "$PROJECT_DIR/Helpers/config.json" << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

# reports.log
touch "$PROJECT_DIR/reports/reports.log"

# image.png placeholder
touch "$PROJECT_DIR/image.png"

echo " Project structure created."

# ---- DYNAMIC CONFIGURATION ----
read -p "Would you like to update attendance thresholds? (y/n): " UPDATE_CHOICE

if [[ "$UPDATE_CHOICE" == "y" || "$UPDATE_CHOICE" == "Y" ]]; then

    read -p "Enter Warning threshold (default 75): " WARNING
    read -p "Enter Failure threshold (default 50): " FAILURE

    # Validate numeric input
    if [[ "$WARNING" =~ ^[0-9]+$ && "$FAILURE" =~ ^[0-9]+$ ]]; then
        sed -i "s/\"warning\": [0-9]*/\"warning\": $WARNING/" "$PROJECT_DIR/Helpers/config.json"
        sed -i "s/\"failure\": [0-9]*/\"failure\": $FAILURE/" "$PROJECT_DIR/Helpers/config.json"
        echo "Thresholds updated successfully."
    else
        echo "Invalid input detected. Keeping default values."
    fi
fi

# ---- HEALTH CHECK ----
echo "Running Environment Health Check..."

if python3 --version >/dev/null 2>&1; then
    echo "Python3 is installed."
else
    echo "Python3 is NOT installed. Please install it before running the application."
fi

# Verify structure
if [ -f "$PROJECT_DIR/attendance_checker.py" ] &&
   [ -f "$PROJECT_DIR/Helpers/assets.csv" ] &&
   [ -f "$PROJECT_DIR/Helpers/config.json" ] &&
   [ -f "$PROJECT_DIR/reports/reports.log" ]; then
    echo "Directory structure verified."
else
    echo "Directory structure validation failed."
fi

echo "Setup Complete!"


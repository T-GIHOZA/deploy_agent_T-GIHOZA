
# Student Attendance Tracker - Deployment Agent

## How to Run

1. Make script executable:
   chmod +x setup_project.sh

2. Run the script:
   ./setup_project.sh

3. Enter project name when prompted.

4. Optionally update thresholds.

---

## How to Trigger Archive Feature

While the script is running, press:

CTRL + C

This will:
- Archive the project directory
- Delete the incomplete directory
- Prevent workspace clutter

Archive format:
attendance_tracker_<name>_archive.tar.gz

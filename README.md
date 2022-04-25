# UR SVG Planner

A simple Processing tool to import SVG files and export URscript code to control Universal Robots.

## How to use

- replace input/output filenames in sketch file, lines `19` and `41`
- make sure you have a measured Feature Plane in the installation tab of the UR robot, with a known origin, use the same name in line `51` of the sketch for `feature` variable
- run sketch
- find exported UR script in `/data`
- transfer exported file onto UR robot via USB key or FTP
- create new Program with Script node, set it to File and select the loaded script file
- Run the program with 10% speed override to make sure everything is fine

### ONLY PLAY PROGRAM FULLSPEED IF YOU ARE SURE OF WHAT YOU ARE DOING!
### NEVER CHANGE THE SPEED SETTINGS IF YOU ARE NOT SURE OF WHAT YOU ARE DOING!

## TODO

- add CP5 to build GUI
  - File select
  - Feature text
  - Approach height
  - Rapid speed input
  - Feed speed input
  - Accel input
  - Export filename
  - Export button
- Build standalone App into `/dist` folder
- turn the UR export syntax post-processor into a standalone library

## Develop & Contribute

Clone this repository and edit/modify the `UR_SVG_Planner` Processing sketch in the `/src` folder.

# License

see LICENSE.md

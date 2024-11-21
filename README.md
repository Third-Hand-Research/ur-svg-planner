# UR SVG Planner

A simple Processing tool to import SVG files and export URscript code to control Universal Robots.

## Configurable options

### Bounds limit
`minX` minimum X coordinate, meters (default: `0.0`)  
`maxX` maximum X coordinate, meters (default: `1.0`)  
`minY` minimum Y coordinate, meters (default: `0.0`)  
`maxY` maximum Y coordinate, meters (default: `1.0`)  
`minZ` minimum Z coordinate, meters (default: `0.0`)  
`maxZ` maximum Z coordinate, meters (default: `1.0`)

### Homing
`homeAtStart` go home on program start (default `true`)  
`homeAtEnd` go home on program end (default `true`)  
`homeAfterEveryPath` go home after every path processed (default `false`)  
`homeX` home X coordinate, meter (default: `0.0`)  
`homeY` home Y coordinate, meter (default: `0.0`)  
`homeZ` home Z coordinate, meter (default: `-0.1`)

### Tool dipping
`dipBeforeEveryPath` enable tool dipping (default `false`)  
`dipX` dip X coordinate, meter (default `0.0`)  
`dipY` dip Y coordinate, meter (default `0.0`)  
`dipZ` dip Z coordinate, meter (default `0.0`)  
`dipApproach` dip approach Z coordinate, meter (default `-0.1`)

### Popups to pause program
`popUpBeforeStart` display a popup before starting the program (default `false`)  
`popUpBeforeEveryPath` display a popup before processing every path (default `false`)  
`loopProgram` loop program when finished (default `false`)

### Path following or straight Up/Down move per path
`useOnlyCentroid` disable path following, enable pure vertical move, for example when punching holes with needles or making dots with a pen. Will use the XY centroid coordinate of each path (default `false`)  
`followPathVector` TODO follow path`s vector to orient tool in direction of motion, can cause trouble if exceeding axis max rotation (2 turns on axis 6 of a UR5/10, unlimited rotation on axis 6 of UR3)

### Digital Output
`useDigitalOutput` enable digital output toggling to turn on/off powered tools (default `false`)  
`digitalOutputId` digital output id (default `0`)

### Feeds and Speeds
`rapid_ms` velocity during movement in air, meter/sec (default `0.25`)  
`feed_ms` velocity during process movement, meter/sec (default `0.01`)  
`accel_mss` global acceleration, meter/sec2 (default `0.2`)  
`blend_radius_m` blending radius to smooth out corners, meter (default `0.001`)

### Process heights
`approach` process approach Z coordinate, meter (default `-0.05`)  
`processZ` process Z coordinate, meter (default `0.0`)

### Feature
`feature` installation feature name to move relative to (default `plane_1`)

### Filenames
`filename_in` SVG input filename in /data folder (default `smiley.svg`)  
`filename_out` URScript output filename in /data (default `output.script`)


## OLD README to cleanup

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

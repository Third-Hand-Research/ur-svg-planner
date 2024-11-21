# UR SVG Planner

A simple Processing tool to import SVG files and export URscript code to control Universal Robots.

## Configurable options

### Bounds limit

For safety, no coordinates will be exported out of this bounding volume, configure it to be as small as possible. It is relative to the chosen installation `feature` configured.

`minX` minimum X coordinate, meters (default: `0.0`)  
`maxX` maximum X coordinate, meters (default: `1.0`)  
`minY` minimum Y coordinate, meters (default: `0.0`)  
`maxY` maximum Y coordinate, meters (default: `1.0`)  
`minZ` minimum Z coordinate, meters (default: `0.0`)  
`maxZ` maximum Z coordinate, meters (default: `1.0`)

### Homing

The robot can move to a Home position at various moments, for example if you have a mark at known coordinates on your work surface, you can use it to align a tool or verify that it is properly aligned and at the correct height, when using a magic arm to hold a tool.

`homeAtStart` go home on program start (default `true`)  
`homeAtEnd` go home on program end (default `true`)  
`homeAfterEveryPath` go home after every path processed (default `false`)  
`homeX` home X coordinate, meter (default: `0.0`)  
`homeY` home Y coordinate, meter (default: `0.0`)  
`homeZ` home Z coordinate, meter (default: `-0.1`)

### Tool dipping

If using paint or inks with a tool, the program can allow the robot to go dip the tool before processing every path. Configure the dip coordinate here to match your ink/paint container location, relative to the chosen installation `feature`.

`dipBeforeEveryPath` enable tool dipping (default `false`)  
`dipX` dip X coordinate, meter (default `0.0`)  
`dipY` dip Y coordinate, meter (default `0.0`)  
`dipZ` dip Z coordinate, meter (default `0.0`)  
`dipApproach` dip approach Z coordinate, meter (default `-0.1`)

### Popups to pause program

You can set optional popups that will pause the program at the start, or before processing each path, in case you need to pause the program automatically before continuing. Use `popUpBeforeEveryPath` in conjunction with `homeAfterEveryPath` if you desire the robot to move away of the work surface if you need to do anything between paths.

`popUpBeforeStart` display a popup before starting the program (default `false`)  
`popUpBeforeEveryPath` display a popup before processing every path (default `false`)  
`loopProgram` loop program when finished (default `false`)

### Path following or straight Up/Down move per path

If using tools such as needles or only making dots, enable `useOnlyCentroid` to only go down and up without any horizontal movement, otherwise disable it to follow path contours.

`useOnlyCentroid` disable path following, enable pure vertical move, for example when punching holes with needles or making dots with a pen. Will use the XY centroid coordinate of each path (default `false`)  
`followPathVector` TODO follow path`s vector to orient tool in direction of motion, can cause trouble if exceeding axis max rotation (2 turns on axis 6 of a UR5/10, unlimited rotation on axis 6 of UR3)

### Digital Output

If using external devices that should be controlled by the robot, enable this option to turn on/off your tool during path processing.

`useDigitalOutput` enable digital output toggling to turn on/off powered tools (default `false`)  
`digitalOutputId` digital output id (default `0`)

### Feeds and Speeds

Set tool velocities and acceleration here.

`rapid_ms` velocity during movement in air, meter/sec (default `0.25`)  
`feed_ms` velocity during process movement, meter/sec (default `0.01`)  
`accel_mss` global acceleration, meter/sec2 (default `0.2`)  
`blend_radius_m` blending radius to smooth out corners, meter (default `0.001`)

### Process heights
`approach` process approach Z coordinate, meter (default `-0.05`)  
`processZ` process Z coordinate, meter (default `0.0`)

### Feature

Calibrate a Plane feature in the Installation tab of the robot, you can then reference it here so that your file is processed with it's coordinates relative to this feature. If using screen conventions with X positive to the right and Y positive going down, Z axis will be negative when moving away of the work surface and positive to go into the work surface.

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

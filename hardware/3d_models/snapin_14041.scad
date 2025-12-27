// KinderLight RGB - Snap-in for Vimar 14041 with BH1750 Tower, M2 Towers, and True Snap Hooks
// License: GPL-3.0

$fn=80; // Smooth curves

// Main parameters
width = 19;
height = 40;
thickness = 3;

rib_offset    = 2.5;   // distance of rib from inner wall (mm)
rib_width     = 0.5;   // rib actual width   (mm)
rib_length    = 8;     // rib actual length  (mm)

clearance     = 0.2;   // safety gap around each rib (mm)
///////////////////////////////////////////////////////////////////

slot_width  = rib_width  + clearance * 2;  // notch width  (mm)
slot_depth  = rib_offset - clearance;      // how deep to cut inwards
slot_length = rib_length + clearance * 2;  // notch length (mm)

// LED and Sensor positions
led_pos_y = -9;
sensor_pos_y = 5;
hole_diameter_led = 6;
hole_diameter_sensor = 3;

// BH1750 main tower
tower_height = 8;
tower_outer_diameter = 4;
tower_inner_diameter = 3;

// Mini-towers M2 screws
m2_tower_outer_diameter = 5;
m2_tower_inner_diameter = 2.2; // m2, hole 3mm
m2_tower_offset_x = 4.5;
m2_tower_offset_y = sensor_pos_y + 4; // check

// Tag-Connect 6+2
tag_pitch = 1.27;
tag_hole_diameter = 1.5;
tag_anchor_diameter = 2.0;
tag_pos_y = -16;

// Snap simple hook shape
snap_base = 3;
snap_height = 6;
snap_thickness = 1.8;
snap_offset_y = 12;

// Snap-in base
module snapin_plate() {
    difference() {
        cube([width, height, thickness], center=true);

        // LED hole
        translate([0, led_pos_y, -2])
            cylinder(h=thickness + 4, d=hole_diameter_led);

        // Sensor hole
        translate([0, sensor_pos_y, -2])
            cylinder(h=thickness + 4, d=hole_diameter_sensor);


    // Four vertical notches on long sides
    for (side = [-1, 1]) {                        // left/right
      x_pos = side * ( width/2 - slot_depth );
      for (edge = [-1, 1]) {                      // bottom/top
        y_pos = edge * ( height/2 - slot_length/2 );
        translate([ x_pos, y_pos, -2 ])           // z=-1 to ensure full cut
          cube([ slot_depth, slot_length, thickness + 2 ]);

      }
    }



// tag connect must be rotated
/*
        // Tag-Connect signal pins
        for (i = [-1,0,1]) {
            for (j = [0,1]) {
                translate([i*tag_pitch, tag_pos_y+j*tag_pitch, -2])
                    cylinder(h=thickness + 4, d=tag_hole_diameter);
            }
        }

        // Tag-Connect anchors
        translate([0, tag_pos_y - tag_pitch*1.5, -2])
            cylinder(h=thickness + 4, d=tag_anchor_diameter);

        translate([0, tag_pos_y + tag_pitch*2.5, -2])
            cylinder(h=thickness + 4, d=tag_anchor_diameter);
            */
    }
}

// BH1750 tower
module tower() {
    difference() {
        translate([0, sensor_pos_y, 0])
            cylinder(h=tower_height, d=tower_outer_diameter);
        translate([0, sensor_pos_y, -2])
            cylinder(h=tower_height + 5, d=tower_inner_diameter);
    }
}

// M2 towers
module m2_tower_left() {
    difference() {
        translate([-m2_tower_offset_x, m2_tower_offset_y, 0])
            cylinder(h=tower_height, d=m2_tower_outer_diameter);
        translate([-m2_tower_offset_x, m2_tower_offset_y, -2])
            cylinder(h=tower_height + 5, d=m2_tower_inner_diameter);
    }
}

module m2_tower_right() {
    difference() {
        translate([m2_tower_offset_x, m2_tower_offset_y, 0])
            cylinder(h=tower_height, d=m2_tower_outer_diameter);
        translate([m2_tower_offset_x, m2_tower_offset_y, -2])
            cylinder(h=tower_height + 5, d=m2_tower_inner_diameter);
    }
}

// Snap hooks (simple inclined plane)
module snap_hook_left() {
    translate([-(width/2)-0.1, snap_offset_y, 0])
        linear_extrude(height=thickness)
            polygon(points=[[0,0],[snap_base,0],[0,snap_height]]);
}

module snap_hook_right() {
    translate([(width/2)+0.1, -snap_offset_y, 0])
        linear_extrude(height=thickness)
            polygon(points=[[0,0],[-snap_base,0],[0,snap_height]]);
}


// Final assembly
union() {
    snapin_plate();
    tower();
    m2_tower_left();
    m2_tower_right();
    //snap_hook_left();
    //snap_hook_right();
}
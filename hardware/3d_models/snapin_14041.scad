// KinderLight RGB - Snap-in for Vimar 14041 with BH1750 Tower, M2 Towers, and True Snap Hooks
// License: GPL-3.0

$fn=80; // Smooth curves

// Main parameters
width = 22.5;
height = 45;
thickness = 3;

// LED and Sensor positions
led_pos_y = -4;
sensor_pos_y = 8;
hole_diameter_led = 6;
hole_diameter_sensor = 6;

// BH1750 main tower
tower_height = 8;
tower_outer_diameter = 12;
tower_inner_diameter = 8;

// Mini-towers M2 screws
m2_tower_outer_diameter = 5;
m2_tower_inner_diameter = 2.2;
m2_tower_offset_x = 7;
m2_tower_offset_y = sensor_pos_y;

// Tag-Connect 6+2
tag_pitch = 1.27;
tag_hole_diameter = 1.5;
tag_anchor_diameter = 2.0;
tag_pos_y = -18;

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
    snap_hook_left();
    snap_hook_right();
}
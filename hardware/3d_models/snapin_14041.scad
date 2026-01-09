// KinderLight RGB - Snap-in for Vimar 14041 with BH1750 Tower, M2 Towers, and True Snap Hooks
// License: GPL-3.0

$fn=80; // Smooth curves

// Main parameters
// WARNING: PLANA 14041 changed over the time. ensure to have "new" modules
width = 19.30; // calibro 19,26 (loose) 19,51 (forcing the plastic)
height = 40.60; // calibro 40,54 (loose) 40,78 (forcing the plastic)
thickness = 3;

rib_offset    = 2.5;   // distance of rib from inner wall (mm)
rib_width     = 0.5;   // rib actual width   (mm)
rib_length    = 8;     // rib actual length  (mm)

clearance     = 0.2;   // safety gap around each rib (mm)
abbondanza    = 4;
///////////////////////////////////////////////////////////////////

//slot_width  = rib_width  + clearance * 2;  // notch width  (mm)
//slot_depth  = rib_offset - clearance;      // how deep to cut inwards
//slot_length = rib_length + clearance * 2;  // notch length (mm)
// cut of the upper and lower part
// final width calibro 12,45 (loose) 12,63 (forcing the plastic)
// the lower, the smaller
// subtract from width
// 19.3-(3.4*2)=12.5
slot_depth  = 3.4; // La tua "x" (quanto entra verso il centro dal bordo esterno)
slot_length = 9.5; // La tua "y" (lunghezza del taglio lungo il bordo)

// LED and Sensor positions
led_pos_y = -15;
// led diameter: 5mm (si incastra bene)
// led back diameter (che non esce): 5,5mm
// todo: fai il foro da 5mm precisi per max 0,1mm
//hole_diameter_led = 5.5;
/* original
hole_diameter_led_pass = 5.0; // Foro dove passa la testa del LED
hole_diameter_led_seat = 5.7; // Foro per la base/corpo del LED // era 5.5 stampa mario, non passa
flange_thickness = 0.5;       // Spessore della flangia rimanente // era 0.2 stampa mario, led veniva troppo fuori
*/
hole_diameter_led_pass = 6.50; // Foro dove passa la testa del porta LED
hole_diameter_led_seat = 7.10; // Foro per la base/corpo del porta LED 
flange_thickness = 0.5;        // Spessore della flangia per NON fare passare il led
gommino_clearance = 0; // 14041 have exactly 2mm spessore
// hole for the sensor: 4mm
sensor_pos_y = 4; // measured, posizione del *sensore* rispetto ad y=0 (centro del disegno)

// BH1750 main tower
// distance between sensor and towers: 4.5mm (ortogonale)
// distance between tower centers: 9mm 
tower_height = 2;
tower_outer_diameter = 9; // diametro massimo altrimenti tocca gli altri componenti
//tower_inner_diameter = tower_outer_diameter-2; // which is also sensor diameter // was 4.00 mm in the version from tresline 3d
tower_inner_diameter = 7; // which is also sensor diameter // was 4.00 mm in the version from tresline 3d
tower_gommino_diameter = tower_inner_diameter+2;

// Mini-towers M2 screws
// foro del modulo BH1750: 3mm 
m2_tower_outer_diameter = 5;
m2_tower_inner_diameter = 1.5; // 2.0mm filetto esterno, 1.7mm filetto interno // era 1.8, mario era OK, ma tresline no
m2_tower_offset_x = 4.5;
m2_tower_offset_y = sensor_pos_y + 4.5; // verificato con calibro

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
        union() {
        // piastra base
        cube([width, height, thickness], center=true);
        // cubo di rinforzo
        translate([0, sensor_pos_y, thickness/2]) // thickness/2 = inizia da subito sopra alla piastra
            cube([14, tower_outer_diameter, tower_height*2], center=true);
        }

        
        // LED hole
        //translate([0, led_pos_y, -2])
        //    cylinder(h=thickness + 4, d=hole_diameter_led);

        // --- SISTEMA FORO LED CON FLANGIA ---
        // 1. Foro passante centrale (5mm)
        translate([0, led_pos_y, 0])
            cylinder(h=thickness + abbondanza, d=hole_diameter_led_pass, center=true);

        // 2. Scasso per il corpo del LED (5.5mm)
        // Lo facciamo partire dal "sotto" (Z = -1.5) e salire fino a lasciare 0.2mm
        translate([0, led_pos_y, -thickness/2 + flange_thickness])
            // Non usiamo center=true qui, così la base è nel punto di translate
            cylinder(h=thickness + abbondanza, d=hole_diameter_led_seat);

        // Sensor hole
        
        scasso_cavi_sensore();


            
        // right+left hole for the screw
        buco_per_viti();
   
// Four vertical notches on long sides
    for (side = [-1, 1]) {                        // sinistra/destra
        // Posizionamento X: centro del buco basato sulla nuova profondità
        x_pos = side * ( width/2 - slot_depth/2 );
        
        for (edge = [-1, 1]) {                    // sopra/sotto
            // Posizionamento Y: centro del buco basato sulla nuova lunghezza
            y_pos = edge * ( height/2 - slot_length/2 );
            
            translate([ x_pos, y_pos, 0 ])
                cube([ slot_depth, slot_length, thickness + abbondanza ], center=true);
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

module scasso_cavi_sensore() {
    // Posizionamento sulla cima della torre tra M2 e Sensore
    // Z = spessore piastra/2 + altezza torre
    // crea il cubo (che rimuove)
    translate([0, m2_tower_offset_y, (thickness/2 + tower_height)]) 
        translate([-2, -4, -0.9]) 
            cube([4, 5, 0.91]);
    
    // cilindro:
    // #1 2mm dritto
    // #2 xmm cono
    // #3 2mm dritto
    
    // #1 2mm dritto dalla base
    translate([0, sensor_pos_y, -thickness/2]) 
        cylinder(h=2, d=tower_inner_diameter); 

    // xmm cono
    // fai il cilindro per "tagliare" il cubo, a partire dalla base +2mm (i primi 2mm devono essere dritti)
    translate([0, sensor_pos_y, -thickness/2+2]) // +2 la chiave per partire dalla fine di quello sopra
        //cylinder(h=tower_height + thickness + abbondanza, d=tower_inner_diameter);
          cylinder(h=thickness + tower_height - 2,
                   d1=tower_inner_diameter,
                   d2=3); // sensor longest side: 2.5mm. 3 for clearance
    
    // 2mm dritto
    // parte finale, "piatta"
    // parti dalla parte alta della base, aggiungi tower_height, togli 2mm. quella la partenza
    translate([0, sensor_pos_y, (-thickness/2)+2+thickness+tower_height-2])
          cylinder(h=2, d=3); // d3 come la parte finale del cono sopra, h2 come da posizione z definita sopra
          
          
    // OPZIONALE, spazio per il gommino
          
         // dalla base, altezza della base, fai scasso con diametro esterno
        // non serve piu`, c'e` il pezzo sotto piu` quello in scasso_cavi_sensore
        //translate([0, sensor_pos_y, -thickness/2]) 
        //    cylinder(h=thickness, d=tower_inner_diameter); 
        // lower part of the sensor hole, to host the gommino
        // spazio per incastro parte alta gommino
        /*
        translate([0, sensor_pos_y, -thickness/2 + gommino_clearance]) // attualmente gommino_clearance e` 0 per cui parte esattamente dalla base
          cylinder(h=2, d=tower_gommino_diameter);  // 4 e` l'altezza della parte interna del gommino piu` larga TODO REVIEW
          translate([0, sensor_pos_y, -thickness/2 + gommino_clearance+2]) // attualmente gommino_clearance e` 0 per cui parte esattamente dalla base
          cylinder(h=2, d1=tower_gommino_diameter, d2=tower_inner_diameter);  // 4 e`
          */
         //cylinder(h=thickness-flange_thickness, d1=tower_gommino_diameter, d2=tower_inner_diameter); 
}

// BH1750 tower
module tower() {
/*    difference() {
        translate([0, sensor_pos_y, 0])
            cylinder(h=tower_height, d=tower_outer_diameter);
        translate([0, sensor_pos_y, -2])
            cylinder(h=tower_height + 5, d=tower_inner_diameter);
    }*/
    
    difference() {
        // torre esterna
        // posizione X = 0 (centrato), Y = posizione impostata, Z = tickness (spessore piastra) / 2
        translate([0, sensor_pos_y, thickness/2]) // thickness/2 = inizia da subito sopra alla piastra
            cylinder(h=tower_height, d=tower_outer_diameter);
        // Il foro qui è passante e si allinea con quello della piastra
        scasso_cavi_sensore();
    }
    
   /* difference() {
        // blocco di sicurezza
        // posizione X = 0 (centrato), Y = posizione impostata, Z = tickness (spessore piastra) / 2
        translate([0, sensor_pos_y, thickness/2]) // thickness/2 = inizia da subito sopra alla piastra
            cube([14, 10.5, tower_height*2], center=true);
        // Il foro qui è passante e si allinea con quello della piastra
               buco_per_viti();
        scasso_cavi_sensore();
    }
    */
    
    difference() {
        // parallelepipedo di protezione
        // posizione X = 0 (centrato), Y = posizione impostata, Z = tickness (spessore piastra) / 2
        translate([0, m2_tower_offset_y, thickness/2]) // thickness/2 = inizia da subito sopra alla piastra
          translate([-3, -2.5, 0]) 
            cube([6, 5, tower_height]);

       scasso_cavi_sensore();
    }

}

// M2 holes (used in towers AND snapin
module buco_per_viti() {
    // create the hole for both left and right
    // as it is used into a difference, it doesn't matter if it is done twice
    
    // left
    // create 2 cilynder, one smaller below and one bigger above. just in case
    translate([-m2_tower_offset_x, m2_tower_offset_y, thickness/2])
    //cylinder(h=tower_height + abbondanza + thickness, d=m2_tower_inner_diameter);
    cylinder(h=tower_height + abbondanza, d=m2_tower_inner_diameter);
    
    translate([-m2_tower_offset_x, m2_tower_offset_y, -thickness/2])
    cylinder(h=thickness, d=m2_tower_inner_diameter/2);
    
    // right
    // create 2 cilynder, one smaller below and one bigger above. just in case
    translate([m2_tower_offset_x, m2_tower_offset_y, thickness/2])
    cylinder(h=tower_height + abbondanza, d=m2_tower_inner_diameter);
    
    translate([m2_tower_offset_x, m2_tower_offset_y, -thickness/2])
    cylinder(h=thickness, d=m2_tower_inner_diameter/2);
}

// M2 towers
module m2_tower_left() {
    difference() {
        translate([-m2_tower_offset_x, m2_tower_offset_y, thickness/2]) // thickness/2 = inizia da subito sopra alla piastra
            cylinder(h=tower_height, d=m2_tower_outer_diameter);
        buco_per_viti();
        scasso_cavi_sensore();
    }
}

module m2_tower_right() {
    difference() {
        translate([m2_tower_offset_x, m2_tower_offset_y, thickness/2]) // thickness/2 = inizia da subito sopra alla piastra
            cylinder(h=tower_height, d=m2_tower_outer_diameter);
        buco_per_viti();
        scasso_cavi_sensore();
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
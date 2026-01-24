// KinderLight RGB - Snap-in for Vimar 14041 with BH1750 Tower, M2 Towers, and True Snap Hooks
// License: GPL-3.0

//$fn = 20;  // rendering test
$fn = 200; // Smooth curves

// -----------------------------------------------------------------------------
// Main parameters
// -----------------------------------------------------------------------------
// WARNING: PLANA 14041 changed over the time. ensure to have "new" modules

width     = 19.27; // calibro 19,26 (loose) 19,51 (forcing the plastic) - lato non deve premere
height    = 40.58; // calibro 40,54 (loose) 40,78 (forcing the plastic)
thickness = 3;

abbondanza = 4;

// -----------------------------------------------------------------------------
// Cut of the upper and lower part
// -----------------------------------------------------------------------------
central_module_width = 12.5;

// 19.3-(3.4*2)=12.5 al contrario: (19.3-central_module_width)/2
slot_depth  = (width - central_module_width) / 2; // "x" (quanto entra verso il centro)
slot_length = 9.5;                                // "y" (lunghezza del taglio lungo il bordo)

// -----------------------------------------------------------------------------
// LED and Sensor positions
// -----------------------------------------------------------------------------
led_pos_y = -15;
// led diameter: 5mm (si incastra bene)
// led back diameter (che non esce): 5,5mm

hole_diameter_led_pass = 6.50; // Foro dove passa la testa del porta LED
hole_diameter_led_seat = 7.10; // Foro per la base/corpo del porta LED 
flange_thickness       = 1;    // Spessore della flangia per NON fare passare il led
gommino_clearance      = 0;    // 14041 have exactly 2mm spessore

// Sensor hole
sensor_pos_y = 4; // measured, posizione del *sensore* rispetto ad y=0

// -----------------------------------------------------------------------------
// BH1750 main tower
// -----------------------------------------------------------------------------
tower_height           = 3; // 1mm si intravede il foro. 2mm/3mm OK
tower_outer_diameter   = 9; // diametro massimo altrimenti tocca gli altri componenti
tower_inner_diameter   = 7; // which is also sensor diameter
tower_gommino_diameter = tower_inner_diameter + 2;

// -----------------------------------------------------------------------------
// Mini-towers M2 screws
// -----------------------------------------------------------------------------
m2_tower_outer_diameter = 5;
m2_tower_inner_diameter = 1.7; // 2.0mm filetto esterno, 1.7mm filetto interno
m2_tower_offset_x       = 4.5;
m2_tower_offset_y       = sensor_pos_y + 4.5; // verificato con calibro


// -----------------------------------------------------------------------------
// MODULES
// -----------------------------------------------------------------------------

// Snap-in base
module snapin_plate() {
    difference() {
        union() {
            // piastra base
            cube([width, height, thickness], center = true);
            // cubo di rinforzo
            translate([0, sensor_pos_y, thickness / 2])
                cube([14, tower_outer_diameter, tower_height * 2], center = true);
        }

        // --- SISTEMA FORO LED CON FLANGIA ---
        // 1. Foro passante centrale
        translate([0, led_pos_y, 0])
            cylinder(h = thickness + abbondanza, d = hole_diameter_led_pass, center = true);

        // 2. Scasso per il corpo del LED
        translate([0, led_pos_y, -thickness / 2 + flange_thickness])
            cylinder(h = thickness + abbondanza, d = hole_diameter_led_seat);

        // Sensor hole
        scasso_cavi_sensore();

        // Right+left hole for the screw
        buco_per_viti();

        // --- PARAMETRI EXTRA PER GLI SCASSI ---
        slot_extension_length = 2.5; // Lunghezza erosione rettangolare
        cutout_angle          = 35;  // Angolo dello scasso

        // Four vertical notches on long sides
        for (side = [-1, 1]) { // sinistra/destra
            x_pos = side * (width / 2 - slot_depth / 2);

            for (edge = [-1, 1]) { // sopra/sotto
                // Posizionamento Y base
                y_pos = edge * (height / 2 - slot_length / 2);

                // 1. Scasso originale standard
                translate([x_pos, y_pos, 0])
                    cube([slot_depth, slot_length, thickness + abbondanza], center = true);

                // --- MODIFICA SU RICHIESTA (edge -1) ---
                if (edge == -1) {
                    
                    // Direzione verso il centro (per Y neg è 1)
                    dir_to_center = 1;

                    // Bordo interno dello scasso originale
                    y_inner_edge = y_pos + dir_to_center * (slot_length / 2);

                    // 1) ERODI LUNGHEZZA PARAMETRICA
                    translate([x_pos, y_inner_edge + dir_to_center * (slot_extension_length / 2), 0])
                        cube([slot_depth, slot_extension_length, thickness + abbondanza], center = true);

                    // 2) SCAVO TRIANGOLARE PARAMETRICO
                    y_prism_start = y_inner_edge + dir_to_center * slot_extension_length;

                    // Calcolo dello sbalzo (cateto orizzontale) basato sull'angolo
                    offset_y = thickness * tan(cutout_angle);

                    translate([x_pos, y_prism_start, 0])
                        rotate([90, 0, 90])
                        linear_extrude(height = slot_depth, center = true)
                        polygon(points = [
                            // Largo sotto, stretto sopra
                            [0, thickness / 2], // In ALTO: Punta stretta
                            [0, -thickness / 2], // In BASSO: Inizio base larga
                            // In BASSO: Fine base larga calcolata trigonometricamente
                            [dir_to_center * offset_y, -thickness / 2]
                        ]);
                }
            }
        }
    }
}

module scasso_cavi_sensore() {
    // Posizionamento sulla cima della torre tra M2 e Sensore
    translate([0, m2_tower_offset_y, (thickness / 2 + tower_height)])
        translate([-2, -4, -0.9])
        cube([4, 5, 0.91]);

    vimar_tickness          = 1.9;
    base_cone               = 2;
    top_cone                = 2;
    sensor_minimum_diameter = 3;

    z0cone                     = -thickness / 2 - vimar_tickness;
    cone_groove_width          = 2;   // la parte del gommino che deve passare
    cone_groove_inner_diameter = 7.5; // gommino 7.00, tieni del margine 
    cone_groove_outer_diameter = 9;   // parte esterna gommino
    cone_top_width             = 3;   // altezza dopo groove fino a top

    // #1 2mm dritto dalla base (base_cone)
    translate([0, sensor_pos_y, z0cone])
        cylinder(h = base_cone, d = tower_inner_diameter);

    // #2 cono
    translate([0, sensor_pos_y, z0cone + base_cone])
        cylinder(h = thickness + tower_height - top_cone,
            d1 = tower_inner_diameter,
            d2 = 3); // sensor longest side: 2.5mm. 3 for clearance

    // #3 2mm dritto (top_cone)
    translate([0, sensor_pos_y, z0cone + base_cone + thickness + tower_height - top_cone])
        cylinder(h = top_cone, d = sensor_minimum_diameter);


    // OPZIONALE, spazio per il gommino
    spazio_per_gommino = 1;
    if (spazio_per_gommino == 1) {
        // dalla base, altezza della base, fai scasso con diametro esterno
        translate([0, sensor_pos_y, z0cone])
            cylinder(h = cone_groove_width, d = cone_groove_inner_diameter);

        // spazio per incastro parte alta gommino        
        translate([0, sensor_pos_y, z0cone + cone_groove_width])
            cylinder(h = cone_top_width, d1 = cone_groove_outer_diameter, d2 = cone_groove_inner_diameter);
    }
}

// BH1750 tower
module tower() {
    difference() {
        // torre esterna
        translate([0, sensor_pos_y, thickness / 2])
            cylinder(h = tower_height, d = tower_outer_diameter);
        
        // Il foro qui è passante e si allinea con quello della piastra
        scasso_cavi_sensore();
    }

    difference() {
        // parallelepipedo di protezione
        translate([0, m2_tower_offset_y, thickness / 2])
            translate([-3, -2.5, 0])
            cube([6, 5, tower_height]);

        scasso_cavi_sensore();
    }
}

// M2 holes (used in towers AND snapin)
module buco_per_viti() {
    // Left
    translate([-m2_tower_offset_x, m2_tower_offset_y, thickness / 2])
        cylinder(h = tower_height + abbondanza, d = m2_tower_inner_diameter);

    translate([-m2_tower_offset_x, m2_tower_offset_y, -thickness / 2])
        cylinder(h = thickness, d = m2_tower_inner_diameter / 2);

    // Right
    translate([m2_tower_offset_x, m2_tower_offset_y, thickness / 2])
        cylinder(h = tower_height + abbondanza, d = m2_tower_inner_diameter);

    translate([m2_tower_offset_x, m2_tower_offset_y, -thickness / 2])
        cylinder(h = thickness, d = m2_tower_inner_diameter / 2);
}

// M2 towers
module m2_tower_left() {
    difference() {
        translate([-m2_tower_offset_x, m2_tower_offset_y, thickness / 2])
            cylinder(h = tower_height, d = m2_tower_outer_diameter);
        buco_per_viti();
        scasso_cavi_sensore();
    }
}

module m2_tower_right() {
    difference() {
        translate([m2_tower_offset_x, m2_tower_offset_y, thickness / 2])
            cylinder(h = tower_height, d = m2_tower_outer_diameter);
        buco_per_viti();
        scasso_cavi_sensore();
    }
}


// -----------------------------------------------------------------------------
// Final assembly
// -----------------------------------------------------------------------------
union() {
    snapin_plate();
    tower();
    m2_tower_left();
    m2_tower_right();
}
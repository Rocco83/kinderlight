// KinderLight RGB - Snap-in for Vimar 14041 with BH1750 Tower, M2 Towers, and True Snap Hooks
// License: GPL-3.0

//$fn=20; // rendering test
$fn=200; // Smooth curves

// Main parameters
// WARNING: PLANA 14041 changed over the time. ensure to have "new" modules
// questo lato non deve premere, spancia. era 19.30
width = 19.27; // calibro 19,26 (loose) 19,51 (forcing the plastic)
// calibro dice 40.57 OK, 40.60 fa troppa forza?
height = 40.58; // calibro 40,54 (loose) 40,78 (forcing the plastic)
thickness = 3;

rib_offset    = 2.5;   // distance of rib from inner wall (mm)
rib_width     = 0.5;   // rib actual width   (mm)
rib_length    = 8;     // rib actual length  (mm)

clearance     = 0.2;   // safety gap around each rib (mm)
abbondanza    = 4;
///////////////////////////////////////////////////////////////////


// cut of the upper and lower part
// final width calibro 12,45 (loose) 12,63 (forcing the plastic)
// the lower, the smaller
// subtract from width

central_module_width=12.5;

// 19.3-(3.4*2)=12.5 al contrario: (19.3-central_module_width)/2
slot_depth  = (width-central_module_width)/2; // La tua "x" (quanto entra verso il centro dal bordo esterno)
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
flange_thickness = 1;        // Spessore della flangia per NON fare passare il led // 0.5 mm invisibile
gommino_clearance = 0; // 14041 have exactly 2mm spessore
// hole for the sensor: 4mm
sensor_pos_y = 4; // measured, posizione del *sensore* rispetto ad y=0 (centro del disegno)

// BH1750 main tower
// distance between sensor and towers: 4.5mm (ortogonale)
// distance between tower centers: 9mm 
tower_height = 3; // 1mm si intravede il foro della vite corta. 2mm ancora da testare come luminosita` -- 2mm e 1mm testati, vedi chatgpt
tower_outer_diameter = 9; // diametro massimo altrimenti tocca gli altri componenti
//tower_inner_diameter = tower_outer_diameter-2; // which is also sensor diameter // was 4.00 mm in the version from tresline 3d
tower_inner_diameter = 7; // which is also sensor diameter // was 4.00 mm in the version from tresline 3d
tower_gommino_diameter = tower_inner_diameter+2;

// Mini-towers M2 screws
// foro del modulo BH1750: 3mm 
m2_tower_outer_diameter = 5;
m2_tower_inner_diameter = 1.7; // 2.0mm filetto esterno, 1.7mm filetto interno // era 1.8, mario era OK, ma tresline no // era 1.5 filetto interno "non stampato bene"
m2_tower_offset_x = 4.5;
m2_tower_offset_y = sensor_pos_y + 4.5; // verificato con calibro

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
        
        

// --- PARAMETRI EXTRA ---
    slot_extension_length = 2.5; // Lunghezza erosione rettangolare
    cutout_angle = 35;         // Angolo dello scasso (in gradi rispetto alla verticale)

    // Four vertical notches on long sides
    for (side = [-1, 1]) {                        
        x_pos = side * ( width/2 - slot_depth/2 );
        
        for (edge = [-1, 1]) {                    
            // Posizionamento Y base
            y_pos = edge * ( height/2 - slot_length/2 );
            
            // 1. Scasso originale standard
            translate([ x_pos, y_pos, 0 ])
                cube([ slot_depth, slot_length, thickness + abbondanza ], center=true);

            // --- MODIFICA SU RICHIESTA (edge -1) ---
            if (edge == -1) { 
                
                // Direzione verso il centro (per Y neg è 1)
                dir_to_center = 1; 
                
                // Bordo interno dello scasso originale
                y_inner_edge = y_pos + dir_to_center * (slot_length/2);

                // 1) ERODI LUNGHEZZA PARAMETRICA
                translate([x_pos, y_inner_edge + dir_to_center * (slot_extension_length/2), 0])
                    cube([slot_depth, slot_extension_length, thickness + abbondanza], center=true);

                // 2) SCAVO TRIANGOLARE PARAMETRICO
                y_prism_start = y_inner_edge + dir_to_center * slot_extension_length;

                // Calcolo dello sbalzo (cateto orizzontale) basato sull'angolo
                // offset = altezza * tan(angolo)
                offset_y = thickness * tan(cutout_angle);

                translate([x_pos, y_prism_start, 0])
                    rotate([90, 0, 90]) 
                    linear_extrude(height = slot_depth, center = true)
                    polygon(points=[
                        // Largo sotto, stretto sopra
                        [0, thickness/2],         // In ALTO: Punta stretta
                        [0, -thickness/2],        // In BASSO: Inizio base larga
                        
                        // In BASSO: Fine base larga calcolata trigonometricamente
                        [dir_to_center * offset_y, -thickness/2] 
                    ]);
            }
        }
    }

    }

    
    }
}

module scasso_cavi_sensore() {
    // Posizionamento sulla cima della torre tra M2 e Sensore
    // Z = spessore piastra/2 + altezza torre
    // crea il cubo (che rimuove)
    translate([0, m2_tower_offset_y, (thickness/2 + tower_height)]) 
        translate([-2, -4, -0.9]) 
            cube([4, 5, 0.91]);
    
    vimar_tickness=1.9;
    base_cone=2;
    top_cone=2;
    sensor_minimum_diameter=3;
    
    z0cone=-thickness/2-vimar_tickness;
    cone_groove_width=2; // la parte del gommino che deve passare
    cone_groove_inner_diameter=7.5; // gommino 7.00, tieni del margine 
    cone_groove_outer_diameter=9; // parte esterna gommino
    cone_top_width=3; // altezza dopo groove fino a top
    
    // cilindro (comprendendo la parte vimar)
    // spessore vimar 14041 misurato: 1.91mm. consideriamo 2mm.
    // #1 2mm dritto
    // #2 xmm cono
    // #3 2mm dritto
    
    // #1 2mm dritto dalla base (base_cone)
    translate([0, sensor_pos_y, z0cone]) 
        cylinder(h=base_cone, d=tower_inner_diameter); 

    // xmm cono
    // fai il cilindro per "tagliare" il cubo, a partire dalla base +2mm (i primi 2mm devono essere dritti)
    translate([0, sensor_pos_y, z0cone+base_cone]) // +2 la chiave per partire dalla fine di quello sopra
        //cylinder(h=tower_height + thickness + abbondanza, d=tower_inner_diameter);
          cylinder(h=thickness + tower_height - top_cone,
                   d1=tower_inner_diameter,
                   d2=3); // sensor longest side: 2.5mm. 3 for clearance
    
    // 2mm dritto (top_cone)
    // parte finale, "piatta"
    // parti dalla parte alta della base, aggiungi tower_height, togli 2mm. quella la partenza
    translate([0, sensor_pos_y, z0cone+base_cone+thickness+tower_height-top_cone])
          cylinder(h=top_cone, d=sensor_minimum_diameter); // d3 come la parte finale del cono sopra, h2 come da posizione z definita sopra
          
          
    // OPZIONALE, spazio per il gommino
    spazio_per_gommino=1;
    if (spazio_per_gommino == 1) 
      {
         // dalla base, altezza della base, fai scasso con diametro esterno
        // non serve piu`, c'e` il pezzo sotto piu` quello in scasso_cavi_sensore
        translate([0, sensor_pos_y, z0cone]) // parte esattamente dallo zero (base vimar 14041)
            cylinder(h=cone_groove_width, d=cone_groove_inner_diameter); // parte stretta del gommino

        // spazio per incastro parte alta gommino       
        translate([0, sensor_pos_y, z0cone + cone_groove_width]) // 
          cylinder(h=cone_top_width, d1=cone_groove_outer_diameter, d2=cone_groove_inner_diameter);  //
      }  

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


// Final assembly
union() {
    snapin_plate();
    tower();
    m2_tower_left();
    m2_tower_right();
}
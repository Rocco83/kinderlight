// ============================================================
//  KinderLight 2025030502 — Scatola stampabile 3D
//  Generato da dati KiCad reali
//  
//  Struttura:
//    BASE  : vassoio con pareti + pilastri fissaggio PCB (H1,H2)
//            + colonnine angolo per viti M3 chiusura
//    COPERCHIO : pannello con:
//            - fori per xh_i2c, xh_led, ph_led, ph_i2c (connettori JST)
//            - finestra aperta per mkds (Phoenix terminal block)
//            - fori M3 agli angoli per chiusura
//
//  Orientamento: X=lunghezza, Y=larghezza, Z=altezza
//  Origine PCB: angolo in basso a sinistra della board
// ============================================================

// ── Render ──────────────────────────────────────────────────
SHOW = "both";  // "base" | "cover" | "both" | "assembled"
$fn = 48;

// ── Parametri PCB ────────────────────────────────────────────
pcb_x    = 52.5;    // larghezza board
pcb_y    = 30.48;   // profondità board
pcb_z    = 1.6;     // spessore PCB
comp_h   = 14.0;    // altezza massima componenti sopra PCB

// ── Parametri scatola ───────────────────────────────────────
wall     = 2.0;     // spessore pareti
floor_z  = 2.0;     // spessore fondo base
cover_z  = 2.0;     // spessore coperchio
pcb_lift = 3.0;     // distanza PCB dal fondo (altezza pilastri base)
margin   = 0.3;     // gioco laterale PCB in scatola

// Altezza interna utile = pcb_lift + pcb_z + comp_h
inner_h  = pcb_lift + pcb_z + comp_h;  // = 18.6mm

// Dimensioni esterne
ext_x = pcb_x + 2*wall + 2*margin;   // 56.5mm esterno X
ext_y = pcb_y + 2*wall + 2*margin;   // 35.08mm esterno Y
ext_z = floor_z + inner_h + cover_z; // 22.6mm totale Z

// ── Fori di montaggio PCB (coordinate relative board) ───────
// H1 e H2: fori M3, drill=3.2mm
h1_x = 43.594;  h1_y = 26.420;
h2_x = 16.800;  h2_y = 7.017;
mount_drill  = 3.2;   // foro passante
mount_boss_d = 6.5;   // diametro colonnina
mount_boss_h = pcb_lift; // altezza = pcb_lift

// ── Viti chiusura M3 agli angoli ─────────────────────────────
screw_d      = 3.2;   // foro M3
screw_boss_d = 7.0;   // colonnina (raggio=3.5, parete=2 → dentro di 1.5mm OK)
// Le torrette stanno DENTRO le pareti: centro a 4mm dal bordo esterno
// = 2mm parete + 2mm raggio interno → nessuna collisione con PCB
screw_margin = wall + screw_boss_d/2 - 0.5; // = 4.5mm dal bordo ext

// Posizioni colonnine angolo (nel sistema scatola = PCB + offset)
// Le metto agli angoli della base
function corner_pos(i) =
    i == 0 ? [screw_margin,            screw_margin           ] :
    i == 1 ? [ext_x - screw_margin,    screw_margin           ] :
    i == 2 ? [ext_x - screw_margin,    ext_y - screw_margin   ] :
             [screw_margin,            ext_y - screw_margin   ];

// ── Connettori coperchio ─────────────────────────────────────
// xh_i2c: JST XH 4pin, center (3.72, 26.42), rot=90
//   Footprint XH4: ~10mm x 7.5mm → buco 11x8.5mm
// xh_led: JST XH 4pin, center (3.70, 12.64), rot=90
// ph_led: JST PH 4pin, center (30.80, 21.12), rot=0
//   Footprint PH4: ~8mm x 5.5mm → buco 9x6.5mm
// ph_i2c: JST PH 4pin, center (36.80, 27.97), rot=180

// mkds: Phoenix MKDS-1,5-2 Horizontal, bbox x=[40.17,50.98] y=[14.22,25.39]
// Finestra aperta con margine +1mm per lato
mkds_x1 = 40.5;
mkds_x2 = 51.2;
mkds_y1 = 19.5;
mkds_y2 = 30;

// Helper: posizione nel sistema scatola (offset da wall+margin)
function pcb2box_x(px) = px + wall + margin;
function pcb2box_y(py) = py + wall + margin;

// ── Moduli ───────────────────────────────────────────────────

module rounded_box(x, y, z, r=2) {
    hull() {
        for (dx=[r, x-r]) for (dy=[r, y-r])
            translate([dx, dy, 0]) cylinder(h=z, r=r);
    }
}

module screw_boss_base(pos) {
    // Colonnina piena con foro passante M3
    translate([pos[0], pos[1], 0])
        difference() {
            cylinder(d=screw_boss_d, h=floor_z + inner_h);
            translate([0, 0, -0.1])
                cylinder(d=screw_d, h=floor_z + inner_h + 0.2);
        }
}

module screw_boss_cover(pos) {
    // Colonnina coperchio con foro cieco (per vite che viene dalla base)
    translate([pos[0], pos[1], 0])
        difference() {
            cylinder(d=screw_boss_d, h=cover_z);
            translate([0, 0, -0.1])
                cylinder(d=screw_d, h=cover_z + 0.2);
        }
}

module pcb_mount_boss(px, py) {
    // Pilastro per fissaggio PCB con foro M3
    bx = pcb2box_x(px);
    by = pcb2box_y(py);
    translate([bx, by, floor_z])
        difference() {
            cylinder(d=mount_boss_d, h=mount_boss_h);
            translate([0, 0, mount_boss_h - 3.0])  // foro cieco 3mm
                cylinder(d=mount_drill, h=3.1);
        }
}

// Slot centrato sul centro del courtyard globale (non sull'origine footprint!)
// Dimensioni ricavate dai dati KiCad reali + tolleranza 0.5mm per lato
// Nota: il centro del courtyard NON coincide con l'origine del footprint
//       per i JST con rot=90 (corpo asimmetrico rispetto ai pad)

module slot_xh_i2c() {
    // JST XH 4pin, rot=90 — CrtYd center=(3.866, 30.166), size=6.7x10.8mm
    translate([pcb2box_x(3.866) - 3.85, pcb2box_y(30.166) - 5.90, -0.1])
        cube([7.70, 11.80, cover_z + 0.2]);
}

module slot_xh_led() {
    // JST XH 4pin, rot=90 — CrtYd center=(3.849, 16.390), size=6.7x10.8mm
    translate([pcb2box_x(3.849) - 3.85, pcb2box_y(16.390) - 5.90, -0.1])
        cube([7.70, 11.80, cover_z + 0.2]);
}

module slot_ph_led() {
    // JST PH 4pin, rot=0  — CrtYd center=(33.798, 21.924), size=8.0x5.4mm
    translate([pcb2box_x(33.798) - 4.50, pcb2box_y(21.924) - 3.20, -0.1])
        cube([9.00, 6.40, cover_z + 0.2]);
}

module slot_ph_i2c() {
    // JST PH 4pin, rot=180 — CrtYd center=(33.800, 27.170), size=8.0x5.4mm
    translate([pcb2box_x(33.800) - 4.50, pcb2box_y(27.170) - 3.20, -0.1])
        cube([9.00, 6.40, cover_z + 0.2]);
}

// ── BASE ─────────────────────────────────────────────────────
module base() {
    color("SteelBlue", 0.85)
    difference() {
        union() {
            // Corpo principale (pareti + fondo)
            difference() {
                rounded_box(ext_x, ext_y, floor_z + inner_h, r=2);
                // Svuotamento interno
                translate([wall, wall, floor_z])
                    cube([ext_x - 2*wall, ext_y - 2*wall, inner_h + 0.1]);
            }
            
            // Colonnine angolo per viti M3
            //for (i=[0:3]) screw_boss_base(corner_pos(i));
            
            // Pilastri fissaggio PCB H1, H2
            pcb_mount_boss(h1_x, h1_y);
            pcb_mount_boss(h2_x, h2_y);
            
            // Battuta perimetrale per centrare PCB (opzionale, 1mm alta)
            translate([wall, wall, floor_z + pcb_lift - 1])
                difference() {
                    cube([ext_x - 2*wall, ext_y - 2*wall, 1]);
                    translate([margin, margin, -0.1])
                        cube([pcb_x, pcb_y, 1.2]);
                }
        }
        
        // Niente altro da togliere dalla base
    }
}

// ── COPERCHIO ────────────────────────────────────────────────
module cover() {
    color("LightSteelBlue", 0.85)
    difference() {
        union() {
            // Pannello piatto
            rounded_box(ext_x, ext_y, cover_z, r=2);
            // Colonnine angolo
            for (i=[0:3]) screw_boss_cover(corner_pos(i));
            
            // Bordo incastro (lip) che scende nelle pareti della base
            // Aiuta l'allineamento
            translate([wall - 0.2, wall - 0.2, -2.5])
                difference() {
                    cube([ext_x - 2*(wall-0.2), ext_y - 2*(wall-0.2), 2.6]);
                    translate([wall + 0.2, wall + 0.2, -0.1])
                        cube([pcb_x - 2*wall + 2*margin + 0.4,
                              pcb_y - 2*wall + 2*margin + 0.4,
                              2.8]);
                }
        }
        
        // ── Fori connettori ──────────────────────────────────
        slot_xh_i2c();
        slot_xh_led();
        slot_ph_led();
        slot_ph_i2c();
        
        // ── Finestra mkds (Phoenix terminal block) ─────────────
        // Finestra aperta rettangolare con +1mm margine
        translate([pcb2box_x(mkds_x1), pcb2box_y(mkds_y1), -0.1])
            cube([mkds_x2 - mkds_x1,
                  mkds_y2 - mkds_y1,
                  cover_z + 3.0]);  // extra Z per passare anche il corpo
        
        // ── Fori viti M3 ─────────────────────────────────────
        // già rimossi nei boss_cover (foro passante)
    }
}

// ── Assemblaggio / Stampa ────────────────────────────────────

if (SHOW == "base") {
    base();

} else if (SHOW == "cover") {
    // Ruota per stampa (piatto sul piano)
    translate([0, ext_y + 5, cover_z])
        rotate([180, 0, 0])
            cover();

} else if (SHOW == "both") {
    // Fianco a fianco per stampa
    base();
    translate([ext_x + 8, 0, 0]) {
        translate([0, ext_y, cover_z])
            rotate([180, 0, 0])
                cover();
    }

} else if (SHOW == "assembled") {
    // Assemblato
    base();
    translate([0, 0, floor_z + inner_h])
        cover();
}

// ============================================================
//  NOTE:
//  - Pilastri H1/H2: foro M3 cieco 3mm, inserire inserto M3
//    o vite autofilettante M3
//  - Viti angolo: M3x(inner_h + floor_z)mm ~22mm
//  - Lip del coperchio: scende 2.5mm nelle pareti base
//  - mkds finestra: 11.8 x 12.2mm, passa il corpo del Phoenix
//  - Gioco PCB laterale: 0.3mm per lato
// ============================================================

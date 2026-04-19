/*
Lucy’s Space Hub Case v2
Cleaned up after physical paper prototype.

Intent:
- 170x170x60 monoblock front+walls
- open back
- no magnetic front / no sliding backplate
- digit acrylic ledge
- dial held by rear screw ring + optional glue/tape only
- right-side slider cutout sized only for the movable tab
- top cable passthroughs for ear wiring
- separate printable ear caps / bezels
- separate printable mini cages for StickC and Echo

Workflow:
- tune front geometry in "fit_test"
- print main_shell()
- print stick_cage(), echo_cage(), ear_cap_left(), ear_cap_right()
*/

// projection(cut = false) front_plate_only();

$fn = 72;

// =========================================================
// VIEW / EXPORT CONTROL
// =========================================================
view_mode = "assembled";   // "assembled", "exploded", "fit_test", "front", "shell", "retainer_stick", "retainer_echo", "ear_caps"
show_guides = false;
explode = 18;

// =========================================================
// GLOBAL DIMENSIONS / TOLERANCES
// =========================================================
case_w = 170;
case_h = 170;
case_d = 60;
case_inset = 20;
corner_r = 14;

tol = 0.3;
wall = 2;
front_t = 2;

inner_margin = 2;          // shell wall thickness equivalent
open_back_margin = 8;      // rear opening leaves a frame

// =========================================================
// MODULE LAYOUT
// =========================================================
eps = 0.1;                    // anti-z-fighting clearance
through_extra = 0.2;          // extra depth for "cut through"
thin_guide_t = 0.2;
fit_test_t = 0.8;


// Digit display
digit_extra_tol = 0.2;
digit_w = 50 + tol*2 + digit_extra_tol;
digit_h = 23 + tol*2 + digit_extra_tol;
digit_x = 0;
digit_y = 56;
digit_ledge = 1.2;
digit_ledge_cut_t = digit_ledge + through_extra;
acrylic_t = 1.5;

// Dial
dial_open_d = 44 + tol;
dial_outer_support_d = 62;
dial_x = 0;
dial_y = 0;
dial_front_relief = 0.0;   // ring already holds well; keep cutout honest

// StickC / secondary admin display
stick_w = 48 + tol*2;
stick_h = 24 + tol*2;
stick_x = -20;
stick_y = -56;

// Stick retainer defaults
stick_ret_plate_pad = 2.5;
stick_ret_plate_t = 2;
stick_ret_post = 6;
stick_ret_post_h = 12 + tol;
stick_ret_inset_w = tol*6;
stick_ret_inset_h = tol;
stick_ret_center_open = 10;
stick_ret_cutout_delta = 0.4;
stick_ret_plate_cutout_delta = 3.5;

// Echo / ATOM Voice
echo_w = 24 + tol*2;
echo_h = 24 + tol*2;
echo_x = 32;
echo_y = -56;

// Echo retainer defaults
echo_ret_plate_pad = 3;
echo_ret_plate_t = 2;
echo_ret_post = 4;
echo_ret_post_h = 15 + tol;
echo_ret_inset = 0.35;
echo_ret_center_open = 10;
echo_ret_cutout_delta = 0.4;
echo_ret_plate_cutout_delta = 3.25;

// PIR sensor aperture (discreet)
pir_w = 8;
pir_h = 3.5;
pir_x = 40;
pir_y = 56;

// Slider side cutout (visible part only, adjust after physical test)
slider_slot_len =8;      // only the actually touchable travel
slider_slot_w =43 + tol*2;
slider_module_h = 24;
slider_z = (-1 * (case_d - case_inset) / 2) + slider_module_h / 2 + tol;
slider_y = 3;
slider_inset = 1.5;

// Ear wire passthroughs near top corners
ear_wire_w = 8;
ear_wire_h = 5;
ear_wire_x = 58;
ear_wire_y = 75;

// Ear caps / bezels (separate parts)
ear_cap_w = 34;
ear_cap_h = 48;
ear_cap_t = 3;
ear_cap_offset_x = 58;
ear_cap_top_overlap = 6;   // amount that sits on top of case


// =========================================================
// SHARED MODELING CONSTANTS
// =========================================================
retainer_mount_z = front_t + through_extra;
exploded_stick_dx = 18;
exploded_echo_dx = 18;





// Ear cap shape tuning
ear_cap_scale_primary_y = 1.05;
ear_cap_body_y_shift = 0.10;
ear_cap_scale_secondary_x = 0.62;
ear_cap_scale_secondary_y = 1.08;
ear_cap_open_y_shift = 0.50;

// =========================================================
// BASIC HELPERS
// =========================================================
module rounded_post(x=3.5, y=3.5, z=5, r=0.6) {
    linear_extrude(height = z)
        rounded_rect_2d(x, y, min(r, min(x,y)/2 - 0.01));
}
module rounded_rect_2d(w, h, r) {
    hull() {
        translate([ w/2-r,  h/2-r]) circle(r=r);
        translate([-w/2+r,  h/2-r]) circle(r=r);
        translate([-w/2+r, -h/2+r]) circle(r=r);
        translate([ w/2-r, -h/2+r]) circle(r=r);
    }
}

module rounded_box(w, h, d, r) {
    linear_extrude(d) rounded_rect_2d(w, h, r);
}

module centered_slot_2d(w, h, r=2) {
    rounded_rect_2d(w, h, min(r, min(w,h)/2 - 0.01));
}

module guide_cross(size=8, thickness=0.6) {
    color([1,0,0,0.35])
    union() {
        square([size, thickness], center=true);
        square([thickness, size], center=true);
    }
}

// =========================================================
// FRONT CUTOUTS
// =========================================================
module front_cutouts_2d() {
    translate([digit_x, digit_y]) centered_slot_2d(digit_w, digit_h, 2.5);
    translate([dial_x, dial_y]) circle(d = dial_open_d + dial_front_relief*2);
    translate([stick_x, stick_y]) centered_slot_2d(stick_w, stick_h, 3);
    translate([echo_x, echo_y]) centered_slot_2d(echo_w, echo_h, 3);
    translate([pir_x, pir_y]) centered_slot_2d(pir_w, pir_h, pir_h/2);
}

// =========================================================
// FRONT PLATE ONLY (for fit test / reference)
// =========================================================
module front_plate_only() {
    difference() {
        linear_extrude(front_t)
            rounded_rect_2d(case_w, case_h, corner_r);

        translate([0,0,-0.1])
        linear_extrude(front_t + 0.2)
            front_cutouts_2d();
    }

    // acrylic ledge behind digit window
    translate([digit_x, digit_y, -digit_ledge])
    difference() {
        linear_extrude(digit_ledge)
            centered_slot_2d(digit_w + digit_ledge*2, digit_h + digit_ledge*2, 3);
        translate([0,0,-eps/10])
        linear_extrude(digit_ledge_cut_t)
            centered_slot_2d(digit_w, digit_h, 2.5);
    }
}

// =========================================================
// MAIN SHELL (front + fixed walls, open back)
// =========================================================
module main_shell() {
    difference() {
        union() {
            // full outer shell
            rounded_box(case_w, case_h, case_d, corner_r);

            // digit ledge behind front
            translate([digit_x, digit_y, front_t - digit_ledge])
            difference() {
                linear_extrude(digit_ledge)
                    centered_slot_2d(digit_w + digit_ledge*2, digit_h + digit_ledge*2, 3);
                translate([0,0,-eps/10])
                linear_extrude(digit_ledge_cut_t)
                    centered_slot_2d(digit_w, digit_h, 2.5);
            }
        }

        // hollow interior from the rear, leaving front and side walls
        translate([0,0,front_t])
            rounded_box(
                case_w - inner_margin*2,
                case_h - inner_margin*2,
                case_d + 1,
                max(corner_r-inner_margin, 2)
            );

        // front cutouts
        translate([0,0,-eps])
            linear_extrude(front_t + through_extra)
                front_cutouts_2d();

        // open rear window (big service opening)
        translate([0,0,open_back_margin])
            linear_extrude(case_d - open_back_margin + 1)
                rounded_rect_2d(
                    case_w - open_back_margin*2,
                    case_h - open_back_margin*2,
                    max(corner_r-open_back_margin, 2)
                );

        // right-side slider opening: only the finger tab
        translate([case_w/2 - wall + eps, slider_y, case_d/2 + slider_z])
            rotate([0,90,0])
            linear_extrude(wall + through_extra*2)
                centered_slot_2d(slider_slot_len, slider_slot_w, slider_slot_w/2);

        // subtle recess / shadow frame around slider opening
        translate([case_w/2 - wall - slider_inset + eps, slider_y, case_d/2 + slider_z])
            rotate([0,90,0])
            linear_extrude(slider_inset + 0.3)
                centered_slot_2d(
                    slider_slot_len + 4,
                    slider_slot_w + 4,
                    (slider_slot_w + 4)/2
                );

        // ear wire passthroughs in top left/right walls
        for (sx=[-1,1]) {
            translate([sx*ear_wire_x, ear_wire_y, case_d - wall + eps])
                rotate([90,0,0])
                linear_extrude(wall + through_extra*2)
                    centered_slot_2d(ear_wire_w, ear_wire_h, ear_wire_h/2);
        }
    }
}

// =========================================================
// MINI CAGES / RETAINERS
// These are separate parts to glue from the rear.
// =========================================================
module retention_noses(cw, ch, nose=2, t=2) {
    // 4 tiny noses to stop lateral drift, no overkill
    for (sx=[-1,1], sy=[-1,1]) {
        translate([sx*(cw/2 - nose/2), sy*(ch/2 - 6), 0])
            cube([nose, 8, t], center=true);
    }
}

module digit_support_pads(
        pad = 2,
        pad_h = 11 + tol * 2,
        spacing_x = 32,
        spacing_y = 28,
        r = 0.75    ){

    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([
            digit_x + sx * (spacing_x / 2),
            digit_y + sy * (spacing_y / 2),
            front_t
        ])
            rounded_post(pad, pad, pad_h, r);
    }
}
module stick_module_cutout_2d() {

    centered_slot_2d(stick_w + stick_ret_cutout_delta, stick_h + stick_ret_cutout_delta, 3);
}

module stick_module_plate_cutout_2d() {
    centered_slot_2d(stick_w - stick_ret_plate_cutout_delta, stick_h - stick_ret_plate_cutout_delta, 3);
}
module stick_retainer_shell(
    plate_w = stick_w + stick_ret_plate_pad,
    plate_h = stick_h + stick_ret_plate_pad,
    plate_t = stick_ret_plate_t,
    post_h = stick_ret_post_h,
    inner_w = stick_w ,
    inner_h = stick_h ,
    outer_r = 3.5,
    inner_r = 3,
    relief_w = 6,
    relief_h = 4
) {
    difference() {
        union() {
            // Grundplatte
            linear_extrude(plate_t)
                centered_slot_2d(plate_w, plate_h, outer_r);

            // aufgedickter Aufbau darüber
            translate([0,0,plate_t])
                linear_extrude(post_h)
                    centered_slot_2d(plate_w, plate_h, outer_r);
        }

        // zentrales Modulfenster
        translate([0,0,plate_t - 0.1])
            linear_extrude(post_h + 0.2)
                centered_slot_2d(inner_w, inner_h, inner_r);

        // zusätzliche Relief-Cutouts, damit nicht wieder ein Vollrahmen bleibt
        translate([0,0,plate_t - 0.1])
            linear_extrude(post_h + 0.2)
                union() {
                    // horizontaler Relief-Schnitt
                    centered_slot_2d(max(inner_w - relief_w, 6), plate_h + 2, 2);

                    // vertikaler Relief-Schnitt
                    centered_slot_2d(plate_w + 2, max(inner_h - relief_h, 6), 2);
                }
        // kleinerer Cutout NUR durch die Grundplatte
        translate([0,0,-eps])
            linear_extrude(plate_t + through_extra)
                stick_module_plate_cutout_2d();
    }
}

module echo_module_cutout_2d() {
    centered_slot_2d(echo_w + echo_ret_cutout_delta, echo_h + echo_ret_cutout_delta, 3);
}
module echo_module_plate_cutout_2d() {
    centered_slot_2d(echo_w - echo_ret_plate_cutout_delta, echo_h - echo_ret_plate_cutout_delta, 3);
}
module echo_retainer_shell(
    plate_w = echo_w + echo_ret_plate_pad,
    plate_h = echo_h + echo_ret_plate_pad,
    plate_t = echo_ret_plate_t,
    post = echo_ret_post,
    post_h = echo_ret_post_h,
    inner_w = echo_w ,
    inner_h = echo_h ,
    outer_r = 3.5,
    inner_r = 3,
    relief_w = 5,
    relief_h = 5
) {

    difference() {
        union() {
            // Grundplatte
            linear_extrude(plate_t)
                centered_slot_2d(plate_w, plate_h, outer_r);

            // aufgedickter Aufbau darüber
            translate([0,0,plate_t])
                linear_extrude(post_h)
                    centered_slot_2d(plate_w, plate_h, outer_r);
        }

        // zentrales Modulfenster
        translate([0,0,plate_t - 0.1])
            linear_extrude(post_h + 0.2)
                centered_slot_2d(inner_w, inner_h, inner_r);

        // zusätzliche Relief-Cutouts, damit nicht wieder ein Vollrahmen bleibt
        translate([0,0,plate_t - 0.1])
            linear_extrude(post_h + 0.2)
                union() {
                    // horizontaler Relief-Schnitt
                    centered_slot_2d(max(inner_w - relief_w, 6), plate_h + 2, 2);

                    // vertikaler Relief-Schnitt
                    centered_slot_2d(plate_w + 2, max(inner_h - relief_h, 6), 2);
                }
        // kleinerer Cutout NUR durch die Grundplatte
        translate([0,0,-eps])
            linear_extrude(plate_t + through_extra)
                echo_module_plate_cutout_2d();
    }
}
// EAR CAPS / BEZELS
// Separate parts, same filament, glue on top of shell.
// Simple shells with open underside.
// =========================================================
module tiny_spacer(x=2.5, y=2.5, z=0.3, r=0.6) {
    linear_extrude(z)
        rounded_rect_2d(x, y, min(r, min(x,y)/2 - 0.01));
}
module ear_outer_2d(w = 30, h = 42, tip_scale = 0.62, body_scale_y = 1.08) {
    intersection() {
        scale([1, 1.05]) circle(d = w);
        translate([0, -h * 0.10])
            scale([tip_scale, body_scale_y]) circle(d = h);
    }
}
module ear_cap(
    pcb_w = 24,
    pcb_h = 35,
    clear = 0.3,
    wall_t = 1.5,
    front_t = 2,
    depth = 10,
    tip_latch_h = 1.2
) {
    difference() {
        // Außenform
        linear_extrude(depth)
            ear_outer_2d(30, 42);

        // Innenraum, hinten offen
        translate([0, 0, front_t])
            linear_extrude(depth - front_t + 0.1)
                centered_slot_2d(
                    pcb_w + clear*2,
                    pcb_h + clear*2,
                    2
                );
    }

    // 3 Front-Abstandshalter
    // oben mittig
    translate([0, pcb_h/2 - 6, front_t])
        tiny_spacer(3, 2.5, 0.3, 0.6);

    // unten links
    translate([-(pcb_w/2 - 5), -(pcb_h/2 - 6), front_t])
        tiny_spacer(2.5, 2.5, 0.3, 0.6);

    // unten rechts
    translate([ (pcb_w/2 - 5), -(pcb_h/2 - 6), front_t])
        tiny_spacer(2.5, 2.5, 0.3, 0.6);

    // minimale hintere Lasche oben gegen Umfallen
    translate([0, pcb_h/2 + clear/2, depth - 2])
        cube([6, 1.2, tip_latch_h], center=true);
}


module ear_cap_left() {
    ear_cap();
}

module ear_cap_right() {
    mirror([1, 0, 0]) ear_cap();
}


module ear_caps_pair(
    offset_x = 58,
    top_overlap = 20
) {
    translate([-offset_x, case_h/2 + top_overlap, 0])
        ear_cap_left();

    translate([ offset_x, case_h/2 + top_overlap, 0])
        ear_cap_right();
}

// =========================================================
// 2D FIT TEST FRONT
// =========================================================
module fit_test_front() {
    color("black")
    linear_extrude(fit_test_t)
    difference() {
        rounded_rect_2d(case_w, case_h, corner_r);
        front_cutouts_2d();
    }

    if (show_guides) {
        color([1,0,0,0.4]) linear_extrude(thin_guide_t) {
            translate([0,0]) guide_cross(12,0.7);
            translate([digit_x, digit_y]) guide_cross(10,0.6);
            translate([dial_x, dial_y]) guide_cross(10,0.6);
            translate([stick_x, stick_y]) guide_cross(10,0.6);
            translate([echo_x, echo_y]) guide_cross(10,0.6);
            translate([pir_x, pir_y]) guide_cross(8,0.6);
        }
    }
}

// =========================================================
// ASSEMBLY / VIEW MODES
// =========================================================
module assembled_view() {
    color("gainsboro") main_shell();
    color("silver") translate([stick_x, stick_y, retainer_mount_z]) stick_retainer_shell();
    color("silver") translate([echo_x, echo_y, retainer_mount_z]) echo_retainer_shell();
    digit_support_pads();    
    color("gainsboro") ear_caps_pair();
}

module exploded_view() {
    color("gainsboro") main_shell();
    color("silver") translate([stick_x - exploded_stick_dx, stick_y, case_d + explode]) stick_retainer_shell();
    color("silver") translate([echo_x + exploded_echo_dx, echo_y, case_d + explode]) echo_retainer_shell();
    color("gainsboro") translate([0,0,case_d + explode*1.6]) ear_caps_pair();
}

if (view_mode == "assembled") assembled_view();
if (view_mode == "exploded") exploded_view();
if (view_mode == "fit_test") fit_test_front();
if (view_mode == "front") front_plate_only();
if (view_mode == "shell") main_shell();
if (view_mode == "retainer_echo")
{ 
    
    echo_retainer_shell();
}
if (view_mode == "retainer_stick")
{ 
    stick_retainer_shell();
    
}
if (view_mode == "ear_caps") ear_caps_pair();

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

// 

$fn = 72;

// =========================================================
// VIEW / EXPORT CONTROL
// =========================================================
view_mode = "print_retainer";   // "assembled", "exploded", "fit_test", "front", "shell", "retainer_stick", "retainer_echo", "ear_caps"
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

tol = 0.35;
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
digit_extra_tol = 0.4;
digit_w = 51 + tol*2 + digit_extra_tol;
digit_h = 21 + tol*2 + digit_extra_tol;
digit_x = 35;
digit_y = 50;
digit_ledge = 1.2;
digit_ledge_cut_t = digit_ledge + through_extra;
acrylic_t = 1.5;

// Dial
dial_open_d = 44 + tol;
dial_outer_support_d = 62;
dial_x = 0;
dial_y = -45;
dial_front_relief = 0.0;   // ring already holds well; keep cutout honest

// StickC / secondary admin display
stick_w = 48 + tol*2;
stick_h = 24 + tol*2;
stick_x = -35;
stick_y = 50;

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
echo_x = -20;
echo_y = 8;

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
pir_w = 6;
pir_h = 6;
pir_x = 20;
pir_y = 8;

// Slider side cutout (visible part only, adjust after physical test)
slider_slot_len =8;      // only the actually touchable travel
slider_slot_w =43 + tol*2;
slider_module_h = 24;
slider_z = (-1 * (case_d - case_inset) / 2) + slider_module_h / 2 + tol;
slider_y = -20;
slider_inset = 1.5;

// =========================================================
// EARS - CURRENT BASELINE
// =========================================================
ear_w = 47.1 + tol;
ear_h = 44.6 + tol;

ear_x = 75;
ear_y = 88.5+tol*2;
ear_z = 5;
ear_rotate_deg = 2.7;

ear_clear = tol*4;
ear_wall_t = 2.0+tol*4;
ear_shell_d = case_d - ear_z - case_inset / 2;

ear_bridge_w = ear_w + 3.5+ear_wall_t;
ear_bridge_d = 16;
ear_bridge_h = ear_shell_d+ear_wall_t+tol;
ear_bridge_r = 0.3;

// derived
ear_bridge_x = -ear_x + 23.8;
ear_bridge_y = ear_y - 6.0;
ear_bridge_z = ear_z;

ear_feature_x = -1 * ear_x + ear_w / 2;
ear_feature_y = ear_y + ear_h / 2;
ear_feature_z = ear_z + ear_wall_t;

// inner cut
ear_inner_cut_z = ear_z + ear_wall_t + tol;
  // das was stehen bleiben soll
// case cut
ear_case_cut_x = -83;
ear_case_cut_y = 0;
ear_case_cut_z = 1;
ear_case_cut_w = 200;
ear_case_cut_d = 88;
ear_case_cut_h = 33;

ear_front_pad_h = 1.2;
ear_front_lip = 1 + ear_front_pad_h + tol;

ear_cutout_h = ear_h+tol*2;
ear_cutout_w = ear_shell_d + case_inset/2;
ear_cutout_x = ear_x - 20;
ear_cutout_y = case_h/2 + 1.5;

ear_cutout_z= ear_z+case_inset;
ear_cutout_recess = 0.8;
ear_cutout_recess_pad = 3;



ear_face_inset = 0.3;
retainer_mount_z = front_t + through_extra;
exploded_stick_dx = 18;
exploded_echo_dx = 18;

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


module front_cutouts_2d() {
    translate([digit_x, digit_y]) centered_slot_2d(digit_w, digit_h, 2.5);
    translate([dial_x, dial_y]) circle(d = dial_open_d + dial_front_relief*2);
    translate([stick_x, stick_y]) centered_slot_2d(stick_w, stick_h, 3);
    translate([echo_x, echo_y]) centered_slot_2d(echo_w, echo_h, 3);
    translate([pir_x, pir_y]) centered_slot_2d(pir_w, pir_h, 1);
}


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

module side_slot_cutout(
    len,
    wid,
    y,
    z,
    wall_t = wall,
    recess = slider_inset,
    recess_pad = 4,
    through_extra = 0.4,
    side = "right"
) {
    x_base = (side == "right")
        ? case_w/2 - wall_t + 0.01
        : -case_w/2 - 0.01;

    x_recess = (side == "right")
        ? case_w/2 - wall_t - recess + 0.01
        : -case_w/2 + 0.01;

    // echter Durchbruch
    translate([x_base, y, z])
        rotate([0,90,0])
            linear_extrude(wall_t + through_extra*2)
                centered_slot_2d(len, wid, wid/2);

    // Shadow / Recess
    if (recess > 0) {
        translate([x_recess, y, z])
            rotate([0,90,0])
                linear_extrude(recess + 0.3)
                    centered_slot_2d(
                        len + recess_pad,
                        wid + recess_pad,
                        (wid + recess_pad)/2
                    );
    }
}
module top_slot_cutout(
    len,
    wid,
    x,
    y,
    wall_t = wall,
    recess = 1.0,
    recess_pad = 4,
    through_extra = 0.4
) {
    z_base = case_d - wall_t + 0.01;
    z_recess = case_d - wall_t - recess + 0.01;

    // echter Durchbruch
    translate([x, y, z_base])
        rotate([90,0,0])
            linear_extrude(wall_t + through_extra*2)
                centered_slot_2d(len, wid, 1.5);

    // Shadow / Recess
    if (recess > 0) {
        translate([x, y, z_recess])
            rotate([90,0,0])
                linear_extrude(recess + 0.3)
                    centered_slot_2d(
                        len + recess_pad,
                        wid + recess_pad,
                        (wid + recess_pad)/2
                    );
    }
}
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

        side_slot_cutout(
            len = slider_slot_len,
            wid = slider_slot_w,
            y = slider_y,
            z = case_d/2 + slider_z,
            wall_t = wall,
            recess = slider_inset,
            recess_pad = 4,
            through_extra = through_extra,
            side = "left"
        );
        top_slot_cutout(
            len = ear_cutout_h,
            wid = ear_cutout_w,
            x = -1 * ear_cutout_x,
            y = ear_cutout_y,

            wall_t = ear_cutout_z,
            recess = ear_cutout_recess,
            recess_pad = ear_cutout_recess_pad,
            through_extra = through_extra
        );

        top_slot_cutout(
            len = ear_cutout_h,
            wid = ear_cutout_w,
            x = ear_cutout_x,
            y = ear_cutout_y,

            wall_t = ear_cutout_z,
            recess = ear_cutout_recess,
            recess_pad = ear_cutout_recess_pad,
            through_extra = through_extra
        );
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

module cable_pin_pair(
    pin_d = 2.0,
    pin_h = 6,
    gap = 3.5,
    vertical = false 
) {
    if(vertical == true)
        translate([0, -gap/2, 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
    else 
        translate([-gap/2,0 , 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
        
    if(vertical == true)
        translate([0, -gap/2, 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
    else 
        translate([-gap/2,0 , 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
                
    if(vertical == true)
        translate([0, gap/2, 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
    else 
        translate([gap/2,0 , 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
        
    if(vertical == true)
        translate([0, gap/2, 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);
    else 
        translate([gap/2,0 , 0]) cylinder(d = pin_d, h = pin_h, $fn = 28);

}

module ear_mount_posts(
    post_d = 4.2,
    post_h = 15,
    spacing_x = 43,
    y = -19.2
) {
    for (sx = [-1, 1]) {
        translate([sx * (spacing_x/2), y, 0])
            cylinder(d = post_d, h = post_h, $fn = 40);
    }
}
module ear_front_pads(
    pad_d = 3.0,
    pad_h = ear_front_pad_h
) {
    // oben mittig
    translate([0, 11.5, 1])
        cylinder(d = pad_d, h = pad_h, $fn = 32);

    // links mittig
    translate([-10.5, -3.5, 1])
        cylinder(d = pad_d, h = pad_h, $fn = 32);

    // rechts mittig
    translate([10.5, -3.5, 1])
        cylinder(d = pad_d, h = pad_h, $fn = 32);
}

module ear_face_recess_left(inset = ear_face_inset) {
    translate([-1 * ear_x, ear_y, ear_z - eps])
        linear_extrude(inset + eps)
            offset(delta = ear_clear)   // fein abstimmen
                neco_profile_2d();
}
module ear_bridge_block(w=ear_bridge_w, d=ear_bridge_d, h=ear_bridge_h, r=ear_bridge_r) {
    linear_extrude(h)
        rounded_rect_2d(w, d, r);
}

module ear_inner_cut_left() {
    // Grund-Hohlraum
    translate([-1 * ear_x, ear_y, ear_inner_cut_z])
        linear_extrude(ear_shell_d)
            offset(delta = ear_clear)
                neco_profile_2d();
    
    translate([0, 0, ear_front_lip])
    
    // zusätzlicher Innenraum-Cut zur Case-Seite hin
    translate([-1 * ear_x, ear_y - 15, ear_z + ear_front_lip])
        linear_extrude(ear_shell_d)
            offset(delta = ear_wall_t + tol)
                neco_profile_2d();
}
module neco_profile_2d() {
    resize([ear_w, ear_h], auto=true)
        import("neco.svg");
}
module ear_cap_from_svg(
    wall_t = ear_wall_t,
    clear = ear_clear,
    front_air = ear_clear,
    shell_d = ear_shell_d,

) {
    difference() {
        // Außenkörper
        linear_extrude(shell_d)
            offset(delta = wall_t)
                neco_profile_2d();

        // Innenraum
        translate([0, 0, wall_t + front_air])
            linear_extrude(shell_d - wall_t - front_air)
                offset(delta = clear)
                    neco_profile_2d();

        // Rückseite offen
        translate([0, 0, shell_d - 0.01])
            linear_extrude(0.2)
                square([200, 200], center = true);
    }


}
module ear_case_cut_volume(
    z0 = -eps,
    z1 = case_d + ear_shell_d + 2*eps,
    fit = 0.5
) {
    translate([0, 0, z0])
        linear_extrude(z1 - z0)
            offset(delta = fit)
                rounded_rect_2d(case_w, case_h, corner_r);

}

module ear_internal_features() {
    // Halteposts
    translate([ear_feature_x, ear_feature_y, ear_feature_z]) {
        ear_mount_posts(
            post_d = 1.4,
            post_h = 5,
            spacing_x = 43,
            y = -19.2
        );
        ear_mount_posts(
            post_d = 1.6,
            post_h = 5,
            spacing_x = 28,
            y = -16.4
        );
        // Front-Pads
        ear_front_pads(
            pad_d = 2.0
        );
    }
}
module ear_cap_left() {
   rotate(ear_rotate_deg) {
    difference() {
        union() {
            translate([-1 * ear_x, ear_y, ear_z]) {
                ear_cap_from_svg();
            }

            translate([ear_bridge_x, ear_bridge_y, ear_bridge_z]) {
                ear_bridge_block();       
            }
        }

        ear_case_cut_volume();
        ear_inner_cut_left();
        ear_face_recess_left();
    }
        
        ear_internal_features();     
}
}

module ear_cap_right() {
        mirror([1, 0, 0]) ear_cap_left();    
}
module top_cable_route(
    z = 2,
    y = 60,
    pin_d = 2.0,
    pin_h = 8,
    gap = 3.5
    
) {
 
        translate([-75, y, z])
            cable_pin_pair(pin_d = pin_d, pin_h = pin_h, gap = gap);
         translate([-75, echo_y+15, z])
            cable_pin_pair(pin_d = pin_d, pin_h = pin_h, gap = gap);
}
module left_cable_route(
    z = 2,
    pin_d = 2.0,
    pin_h = 5,
    gap = 3.5
) {


    translate([45, dial_y, z])
        cable_pin_pair(pin_d = pin_d, pin_h = pin_h, gap = gap, vertical=true);
        translate([echo_x-30, echo_y, z])
        cable_pin_pair(pin_d = pin_d, pin_h = pin_h, gap = gap, vertical=true);
}
module digit_stick_route(
    z = 2,
    pin_d = 2.0,
    pin_h = 5,
    gap = 3.5
) {
    translate([pir_x+30, pir_y-10, z])
        cable_pin_pair(pin_d = pin_d, pin_h = pin_h, gap = gap);
    translate([-45, dial_y, z])
        cable_pin_pair(pin_d = pin_d, pin_h = pin_h, gap = gap, vertical=true);    
}
module case_cable_helpers() {
    top_cable_route();
    left_cable_route();
    digit_stick_route();
}
module fit_test_front() {
    projection(cut = true)
        union() {
    color("pink") main_shell();


 ear_cap_left();
 ear_cap_right();
        }    


}

// =========================================================
// ASSEMBLY / VIEW MODES
// =========================================================
module assembled_view() {
    color("pink") main_shell();
    color("gold") translate([stick_x, stick_y, retainer_mount_z]) 
    stick_retainer_shell();
    color("gold") translate([echo_x, echo_y, retainer_mount_z]) echo_retainer_shell();
    color("gold") digit_support_pads();    
 ear_cap_left();
 ear_cap_right();
    color("red")
case_cable_helpers();
}
module print_case() {
    color("pink") main_shell();

    color("gold") digit_support_pads();    
 ear_cap_left();
 ear_cap_right();
    color("red")
case_cable_helpers();
}
module print_retainer() {
    color("gold") translate([stick_x, stick_y, 0]) 
    stick_retainer_shell();
    color("gold") translate([echo_x, echo_y, 0]) echo_retainer_shell();
}
module exploded_view() {
    color("gainsboro") main_shell();
    color("silver") translate([stick_x - exploded_stick_dx, stick_y, case_d + explode]) stick_retainer_shell();
    color("silver") translate([echo_x + exploded_echo_dx, echo_y, case_d + explode]) echo_retainer_shell();
    
}

if (view_mode == "assembled") assembled_view();
if (view_mode == "exploded") exploded_view();
if (view_mode == "fit_test")  fit_test_front(); 
if (view_mode == "front") front_plate_only();
if (view_mode == "shell") main_shell();
if (view_mode == "print_case")
{ 
    print_case();
}
if (view_mode == "print_retainer")
{ 
    print_retainer();
}
if (view_mode == "ear_caps")    linear_extrude(2)
    resize([47.1, 44.6], auto=true)
        import("neco.svg");

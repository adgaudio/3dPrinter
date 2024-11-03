include <BOSL2/std.scad>


th = 1;

CM = 10;

cuphole_d_o = 5.0 * CM;
cuphole_d_i = 4.2 * CM;
cuphole_spacing = 6.25 * CM;

maxh_above_tray = 0.8 * CM;

tray_w_inner = 25.25 * CM;
cupholes_per_row = floor(tray_w_inner / cuphole_spacing);
NUM_ROWS = 1;

tray_lip = 1 * CM;
tray_lip_overhang = 1 * CM;
tray_w_outer = tray_w_inner + tray_lip*2;



module main_part(_num_rows=NUM_ROWS) {
tray_d_outer = _num_rows * cuphole_spacing + tray_lip*2;
tray_d_inner = _num_rows * cuphole_spacing;
diff("hole") {
    cube([tray_w_outer, tray_d_outer, th]) {
        // cupholes
        tag("hole")grid_copies(spacing=cuphole_spacing, n=[cupholes_per_row, _num_rows]) {
        cylinder(d=cuphole_d_i, h=th+.1, center=true) position(RIGHT+FRONT) {
          zrot(-45)left(1.5)scale([7,14,1])cylinder(d=1, h=th+.1, center=true, $fs=.1);
          // #cylinder(r=2, h=10, $fs=.1);
        }

        }
        // riser to lift the cupholes out of (above) tray (on three sides)
        position(BOT)
        rect_tube(th+maxh_above_tray, [tray_w_outer, tray_d_outer], [tray_w_inner, tray_d_inner]);
        // little overhang lip that fits over tray
        position(BOT)
        rect_tube(th+maxh_above_tray + tray_lip_overhang, [tray_w_outer+th+th, tray_d_outer+th], [tray_w_outer, tray_d_outer], rounding=2) 
            // remove the corners so multiple of these things fit on a tray.
            tag("hole")down(.1)yflip_copy()xflip_copy()position([BOT+BACK+RIGHT])left(20-.1)fwd(.1+th+tray_lip)cube([20,20,100]);
        // bars for stability
        position(BOT+FWD)
            back(tray_lip+cuphole_spacing*_num_rows/2)grid_copies(n=[1, _num_rows-1], spacing=cuphole_spacing)
            cube([tray_w_inner, cuphole_spacing-cuphole_d_o, maxh_above_tray+th], anchor=BOT);
        }
    }
}

module one_row_inner() {
    intersection(){
    main_part(_num_rows=3);
    left(th)back(tray_lip + cuphole_spacing)
    cube([tray_w_outer+th+th, cuphole_spacing, maxh_above_tray+th + tray_lip_overhang]);
    
    }
}


module one_row_end() {
    difference(){
main_part(_num_rows=1);
up(maxh_above_tray+th)fwd(th)cube([tray_w_outer, th+.1, tray_lip_overhang+.1]);
}
}


one_row_inner();
// one_row_end();

module plug() {
    cylinder(d1=cuphole_d_o+1, d2=cuphole_d_o-1, h=2)
    // knob
    position(TOP)
    onion(r=20/2, ang=30, cap_h=10, anchor=TOP);
}
// plug();

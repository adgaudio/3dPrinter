include <BOSL2/std.scad>

L = 62 * 10;
H = 100;
ply_th = 2;

module middle_panel() {  // make me
right(10)cube([220, 1, H]);
fwd(1)
cube([220+10+10, 1, H]);
// fwd(2)
// cube([220+10, 1, H]);
}

module right_panel() {  // make me
// cube([220, 1, H]);
cube([220+10, 1, H]);
fwd(1)
cube([220, 1, H]);

// fwd(2)
// cube([220, 1, H]);



}

module left_panel() {  // make me
len = L - 220 - 240;
cube([len+10, 1, H]);
fwd(1)
right(10) cube([len, 1, H]);
// fwd(2)
// right(10)cube([182.5-10, 1, H]);

}

// right_panel();
// right(230-10) middle_panel();
// right(230*2-10) left_panel();

// sanity check
// fwd(3)cube([L, 1, H]);


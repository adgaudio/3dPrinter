include <BOSL2/std.scad>

L = 62.25 * 10;
H = 11.3 * 10;
ply_th = 2;

module middle_panel() {  // make me
right(10)down(20)cube([220-10-10, 1, H+20+2.5]);
fwd(1)
cube([220, 1, H]);
// fwd(2)
// cube([220+10, 1, H]);
}

module right_panel() {  // make me
// cube([220, 1, H]);
left(20)down(20)
cube([220+20+10, 1, 20+H+2.5]);

fwd(1)
cube([220, 1, H]);

// fwd(2)
// cube([220, 1, H]);



}

module left_panel() {  // make me
down(20)left(10)
cube([182.5+20, 1, H+20+2.5]);
fwd(1)
cube([182.5, 1, H]);
// fwd(2)
// right(10)cube([182.5-10, 1, H]);

}

// right_panel();
// %right(220) middle_panel();
// right(220*2+1) left_panel();


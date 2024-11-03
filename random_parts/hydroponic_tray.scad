include <BOSL2/std.scad>

/*
 * A little tray (to be printed in food safe material) that can grow hydroponic
 * seedlings. It has the same outer width 40x20 tray.  I have little inserts
 * that go on top hydroponic_4020_lettucegrow.scad.
 */

CM=10;
th = 2;  // wall thickness;
nrows = 2;

l_i = 63*nrows + 1;
l_o = l_i + 2*th;

w_o = 27*CM;
w_i = w_o - 2*th;

h_i = 3*CM;
h_o = h_i + th;


diff("remove") {
cuboid([w_o, l_o, h_o], rounding=10, except=[TOP]) {
    tag("remove")
    position(BOT)
    up(th)
    cuboid([w_i, l_i, h_i+.1], rounding=10, except=[TOP], anchor=BOT);
    }
}


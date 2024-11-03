include <BOSL2/std.scad>
include <BOSL2/screws.scad>
$fn=32;

difference(){
screw("M5",  thread="none", head="hex", length=6);
up(3.25)cylinder(r=10, h=20);
}

// down(10)cylinder(r=4.82/2, h=5);
up(1.25)cylinder(r=15/2, h=2, $fn=6);

include <bolts.scad>;
/*
This library generates rollers of different kinds and shapes.
They are intended to work with bearings like 608ZZ (though you could use other
size bearings if you adjust the radius, etc.

See example at bottom of this file
*/

module _two_bearings(z, r_o=r_608zz, r_i=r_608zz_hole, h=h_608zz) {
  union() {
    translate([0,0,(h+z)/2])cylinder(r=r_o, h=h, center=true);
    translate([0,0,(-h-z)/2])cylinder(r=r_o, h=h, center=true);
    cylinder(r=r_i, h=2*h+z, center=true);
  }
}

module roller(r, h, r_608zz, r_608zz_hole, r_rod) {
  difference() {
    cylinder(r=r, h=h, center=true);
    _two_bearings(1);
    rotate_extrude(convexity=10)
    translate([r+ r_rod/2,0,0])circle(r=r_rod, center=true);
    _two_bearings(h-2*h_608zz + .1);
  }
}

module roller_with_band(r, h, groove_width, groove_depth) {
  difference() {
    cylinder(r=r, h=h, center=true);
    rotate_extrude(convexity=10)
    translate([r+groove_width/2 - groove_depth,0,0])
      square(groove_width, center=true);

    _two_bearings(h-2*h_608zz + .1);


  }
}

module eccentric_cube(xyz, center_offsetxyz) {
  difference() {
    cube(xyz, center=true);
    translate(center_offsetxyz) {
      _two_bearings(z=1);
    }
  }
}


/* example usage:
roller_r = 22;
roller_h = 16;
r_608zz = 22/2 + .6;
r_608zz_hole = 8/2;
h_608zz = 7;
roller_r_rod = 8;

$fn=40;

translate([-2*roller_r - 5, 0, 0])
  eccentric_cube([30, 54, 10], [0, 10, 0]);
translate([2*roller_r + 5, 0, 0])
  roller(roller_r, roller_h, r_608zz, r_608zz_hole, roller_r_rod);
roller_with_band(roller_r, roller_h, 10, 5);
*/



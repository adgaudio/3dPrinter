include <bolts.scad>;

module _two_bearings(z, r_o=r_bearing, r_i=r_bearing_hole, h=h_bearing) {
  union() {
    translate([0,0,(h+z)/2])cylinder(r=r_o, h=h, center=true);
    translate([0,0,(-h-z)/2])cylinder(r=r_o, h=h, center=true);
    cylinder(r=r_i, h=2*h+z, center=true);
  }
}

module roller(r, h, r_bearing, r_bearing_hole, r_rod) {
  difference() {
    cylinder(r=r, h=h, center=true);
    _two_bearings(1);
    rotate_extrude(convexity=10)
    translate([r+ r_rod/2,0,0])circle(r=r_rod, center=true);
  }
}

module eccentric_roller(r_o, r_i, h, center_offset=1) {
  difference() {
    cylinder(r=r_o, h=h, center=true);
    translate([center_offset, 0, 0])
      cylinder(r=r_i, h=h, center=true);
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


/*$fn=100;*/

r_bearing = 22/2 + .6;
r_bearing_hole = 8/2;
h_bearing = 7;

roller_r_rod = 8/2;
roller_r = r_bearing + roller_r_rod + 1;
roller_h = 2*h_bearing + 1;


/*$fn=10;*/
roller(roller_r, roller_h, r_bearing, r_bearing_hole, roller_r_rod);
translate([2*roller_r + 5, 0, 0])
eccentric_roller(r_o=roller_r, r_i=default_boltsize/2, h=roller_h);

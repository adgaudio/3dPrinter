/*$fn=100;*/
roller_r_hole = 8/2;
roller_r_rod = 8/2;
roller_r_bearing = 22/2 + .6;
roller_r = roller_r_bearing + roller_r_rod + 1;
h_bearing = 7;
roller_h = 2*h_bearing + 1;


module roller(r, h, r_bearing, r_hole, r_rod) {
  difference() {
    cylinder(r=r, h=h, center=true);
    
    translate([0,0,h/2+.5])cylinder(r=r_bearing, h=h, center=true);
    cylinder(r=r_hole, h=h, center=true);
    translate([0,0,h/-2-.5])cylinder(r=r_bearing, h=h, center=true);
    cylinder(r=r_hole, h=h, center=true);

  rotate_extrude(convexity=10)
   translate([r+ r_rod/2,0,0])circle(r=r_rod, center=true);
  }
}

module eccentric_roller(r, h, r_hole, hole_offset=.25) {
  difference() {
    cylinder(r=r, h=h, center=true);
    translate([hole_offset*2*r_hole, 0, 0])
      cylinder(r=r_hole, h=roller_h, center=true);
  }
}

roller(roller_r, roller_h, roller_r_bearing, roller_r_hole, roller_r_rod, $fn=200);
translate([2*roller_r + 5, 0, 0])
eccentric_roller(roller_r, roller_h, roller_r_hole, $fn=300);

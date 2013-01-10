roller_r = 10;
roller_r_inner = 7;
roller_r_hole = 8/2;
roller_r_rod = 8/2;
roller_h = roller_r_rod + 4;


module roller() {
  difference() {
    cylinder(r=roller_r, h=roller_h, center=true);
#    translate([0,0,1])cylinder(r=roller_r_inner, h=roller_h, center=true);
    cylinder(r=roller_r_hole, h=roller_h, center=true);

  rotate_extrude(convexity=10)
   translate([roller_r+ roller_r_rod/2,0,0])circle(r=roller_r_rod, center=true);
  }
}

roller();

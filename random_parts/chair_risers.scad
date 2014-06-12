id = 40;
wall_thickness = 3;
od = id + wall_thickness;
h_rise = 100;
h = h_rise + 50;

h_ball = od/2;


module riser() {
  difference() {
  union() {
  translate([0, 0, h_ball/2])scale([1, 1, .5])sphere(r=od/2);
  translate([0, 0, h_ball/2])cylinder(r=od/2, h=h-h_ball/2);
  }
  translate([0, 0, h_rise])cylinder(r=id/2, h=h - h_rise+1);
  }
}

riser(); // make me

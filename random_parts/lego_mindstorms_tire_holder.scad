include <../shared_vars.scad>;

module lego_mindstorms_tire_holder() { // make me
  h_base = .7;
  difference() {
    union(){
      cylinder(r=40/2, h=h_base);
      cylinder(r=thickness+m5_bolt_radius, h=8);
    }
    translate([0, 0, -.5])
    cylinder(r=m5_bolt_radius, h=8+h_base+1);
  }
}
lego_mindstorms_tire_holder();


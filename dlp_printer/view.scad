include <print_parts.scad>;

module system() {
  translate([vat_r_o + vat_holder_width + 10, 0, vat_h]) {
  // Motor Mount
    rotate([0, vat_holder_angle, 0])translate([0, 0, motor_z])rotate([0, -vat_holder_angle, 0])
      motor_mount();

  // Motor Gear
    rotate([0, 0, 180])rotate([0, -vat_holder_angle, 0])
    eccentric_roller_shaft();
  }

  // Vat
  vat();

  translate([-20 + -vat_r_i - vat_hinge_r_o - vat_hinge_x_offset, 0, 0]) {
  // Hinge
    2Dhinge();

  // Hinge holder
      translate([-20 + -2*vat_hinge_r_o + vat_hinge_x_offset, 0, (-vat_hinge_thickness-2)/2])
        hinge_mount();
  }

  // Build Platform
  build_platform();
}


module build_platform_extrusions() {
translate([0, y_offset_build_platform, z_offset_build_platform + z_platform_mount + h_platform_shaft + 10]) {
  translate([0, 30, 0])
    cube([20, 420 + 30, 20], center=true);
}
}

module _frame() {
  difference() {
    cube([420, 420, 20], center=true);
    cube([420-20, 420-20, 21], center=true);
  }
}
module frame() {
  // threaded and smooth rod
  translate([0, 420/2, 0]) {
    translate([-30, 20 + 10, 0])
      cylinder(r=(3/8.)*25.4, h=420, center=true);
    translate([30, 20, 0])
      cylinder(r=8/2, h=420, center=true);
  }
  // smooth rod on other side of frame
  translate([20, -420/2 + 20, 0])
    cylinder(r=8/2, h=420, center=true);


translate([0, 0, -420/2])
  _frame();
translate([0, 0, 420/2]) {
  _frame();
  // top extrusion in middle (adjustable for motor mount)
  translate([0, 0, 20])
  cube([20, 420 + 40, 20], center=true);

  // small piece of extrusion for motor mount
  translate([20, 0, -420/8 + 20])
  cube([20, 20, 420/3], center=true);
}
// rods for motor mount
translate([10, 0, 420/4+20])
  for (sign=[-1, 1])
  translate([0, 20*sign, 0])
  rotate([0, 90, 0])
  cylinder(r=8/2, h=420/2);
// side - motor (rod) mount extrusion
translate([420/2, 0, 0])
  cube([20, 20, 420], center=true);
// side - vat mount extrusion
translate([-420/2, 0, 0])
  cube([20, 40, 420], center=true);
// other sides
for (sign = [-1, 1])
translate([0, sign*420/2, 0])
cube([20, 20, 420], center=true);

}
system();
build_platform_extrusions();
frame();










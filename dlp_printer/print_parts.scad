include <vat.scad>;
include <motor.scad>;
include <build_platform.scad>;

/*$fn=10;*/
$fn=100;

module print_motor_mount() { // make me
  motor_mount();
}
module print_eccentric_roller_shaft() { // make me
  eccentric_roller_shaft();
}
module print_vat() { // make me
  vat();
}
module print_2Dhinge() { // make me
  2Dhinge();
}
module print_hinge_mount() { // make me
  rotate([0, -90, 0])
  hinge_mount();
}

module print_build_platform() { // make me
  build_platform();
}

module print_rod_to_extrusion_stabilizing_mount() { // make me
  rotate([0, 90, 0])
  rod_to_extrusion_stabilizing_mount();
}

module print_rod_mount() { // make me
  rotate([0, 90, 0])
  rod_mount(0);
}

module print_rod_mount90() { // make me
  rotate([0, 90, 0])
  rod_mount(90);
}

module print_extrusion_vertical_support() {
  rotate([90, 0, 0])
  extrusion_vertical_support();
}

module print_extrusion_support() { // make me
  extrusion_support();
}
//print_motor_mount();
//print_build_platform();
//print_eccentric_roller_shaft();
//print_vat();
//print_2Dhinge();
//print_hinge_mount();
//print_rod_to_extrusion_stabilizing_mount();
//print_rod_mount();
//print_rod_mount90();
//print_extrusion_vertical_support();
//print_extrusion_support();
/*system();*/

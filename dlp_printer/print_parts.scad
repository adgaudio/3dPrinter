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
  rotate([180, 0, 0])
  hinge_mount();
}

module print_build_platform() { // make me
  build_platform();
}

module print_rod_to_extrusion_stabilizing_mount() { // make me
  rod_to_extrusion_stabilizing_mount();
}

/*print_motor_mount();*/
/*print_eccentric_roller_shaft();*/
/*print_vat();*/
/*print_2Dhinge();*/
/*print_hinge_mount();*/
/*print_rod_to_extrusion_stabilizing_mount();*/
/*system();*/

include <vat.scad>;
include <motor.scad>;
include <build_platform.scad>;

/*$fn=10;*/
$fn=100;

module print_motor_mount() { // make me
  rotate([180, 0, 0])
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

/*print_motor_mount();*/
/*print_eccentric_roller_shaft();*/
/*print_vat();*/
/*print_2Dhinge();*/
/*print_hinge_mount();*/
system();



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


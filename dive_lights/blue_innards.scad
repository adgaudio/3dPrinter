// measured vars
r_module = 15.0/2; // platform upon which led will sit
h_module = 15; // mm above base that led will sit

r_wireshaft = 1.5; // should be slightly larger than diameter of wire

x_module_base = 23;
y_module_base = 20.5;
z_module_base = 14;
x_module_arm = 20; // mm extending past x_module_base
y_module_arm = 11;
z_module_arm = 9;
r_module_arm_hold = 6.25/2; // a whole that fastens the base to the lamp

// derived vars
module_base_diff_scale = .85;
xyz_module_base = [x_module_base, y_module_base, z_module_base];
xyz_module_arm = [x_module_arm, y_module_arm, z_module_arm];

x_module_divider = 10;
y_module_divider = 1;
z_module_divider = z_module_base * module_base_diff_scale;


module arm() {
  difference() {
    cube(xyz_module_arm, center=true);
    hull() {
      for (sign = [-1, 1])
      translate([sign*((x_module_arm*.8))/2 - sign*r_module_arm_hold, 0, 0])
      cylinder(r=r_module_arm_hold, h=z_module_arm + 1, center=true, $fn=20);
    }
  }
}

module base() {
  difference() {
    union() {
    cube(xyz_module_base, center=true);
    translate([0, 0, (z_module_base+h_module)/2])
      cylinder(r=r_module, h=h_module, center=true);
    }
    translate([0, 0, 1/2*(h_module - .5)])
    for (deg = [45:45:360])
    rotate([0, 0, deg])translate([r_module, 0, 0])
      cylinder(r=r_wireshaft, h=z_module_base + h_module + 1,
               center=true, $fn=20);

    translate([0, 0, -(1-module_base_diff_scale)*z_module_base])
    scale(module_base_diff_scale)cube(xyz_module_base, center=true);
  }

  for (deg = [0+45/2, 90+45/2])rotate([0, 0, deg])
  translate([0, 0, -(1-module_base_diff_scale)/2*z_module_base])
  cube([x_module_divider, y_module_divider, z_module_divider], center=true);
}
module blue_led_holder() { // make me
  // base section
  base();

  // arms
  for (sign = [-1, 1])
  translate([sign*(x_module_base/2+x_module_arm/2), 0, -1/2*(z_module_base-z_module_arm)])
    arm();
}
blue_led_holder();

module bike_mount() {
  x = 100;
  y = 10;
  arm_angle = 45;
  thickness = 5;
  screw_distance=30;
  screw_plate_x = 10;
  screw_plate_x_arm = 20;
  screw_plate_x_offset = screw_plate_x_arm + screw_plate_x;
  // screw plates
  difference() {
    translate([-screw_plate_x_offset, 0, 0])
      cube([screw_plate_x, screw_distance + screw_plate_x, thickness]);
    translate([-screw_plate_x_offset/2, screw_distance+screw_plate_x/2, 0])
      cylinder(m=3, h=thickness);
    translate([-screw_plate_x_offset/2, screw_plate_x/2, 0])
      cylinder(m=3, h=thickness);
  }
  // arms
    arm_holder(screw_plate_x_arm, x, y, thickness, arm_angle);
  translate([0, screw_distance, 0])arm_holder(screw_plate_x_arm, x, y, thickness, arm_angle);
}

module arm_holder(x_screw_arm, x_angled, y, thickness, angle) {
  hull() {
    rotate([0, angle, 0])
      cube([x_angled, y, thickness]);
    cube([.01, y, thickness]);
  }
  translate([-x_screw_arm, 0, 0])cube([x_screw_arm, y, thickness]);
  // holder
  rotate([0, angle, 0])translate([x_angled, 0, 0])rotate([0, -angle, 0])
    difference() {
      translate([-15, 0, 0])cube([15, y, thickness]);
    }
}

bike_mount();

include <shared_vars.scad>;

module motor_mount() {
  z_slanted = tan(vat_holder_angle) * motor_x;
  hyp = (2*thickness_motor_mount + motor_x) / cos(vat_holder_angle);
  difference() {
    translate([motor_x/-2, motor_y/-2, motor_z/-2])
    union() {
      // bottom wall
      cube([motor_x, motor_y, thickness_motor_mount]);
      // long side wall
      translate([motor_x, 0, 0])
      cube([thickness_motor_mount, motor_y, motor_z+z_slanted+2*thickness_motor_mount]);
      // short side wall
      translate([-thickness_motor_mount, 0, 0])
      cube([thickness_motor_mount, motor_y, motor_z+2*thickness_motor_mount]);
      // top wall
      translate([-thickness_motor_mount, 0, motor_z+thickness_motor_mount])
      rotate([0, -vat_holder_angle, 0])
      cube([hyp, motor_y, thickness_motor_mount]);

    }
    // hole for shaft and that round part
    translate([0, 0, -motor_z/2 + thickness_motor_mount/2])
      cylinder(r=motor_r, h=thickness_motor_mount+1, center=true);
    // screw holes
    for (mirror1 = [-1, 1], mirror2 = [-1, 1]) {
      translate([mirror1 * (motor_x/2 - motor_mount_inset - motor_mount_bolt_size/2),
                 mirror2 * (motor_y/2 - motor_mount_inset - motor_mount_bolt_size/2),
                 -motor_z/2 - .5])
        cylinder(r=motor_mount_bolt_size, h=thickness_motor_mount+1);
    }

  }
}

module _shaft(r_o, r_i, h,
             w_nut=m3_nut_width, h_nut=m3_nut_height,
             r_bolt=m3_bolt_radius) {  // todo: define m3_bolt_radius
  difference() {
    cylinder(r=r_o, h=h, center=true);
    cylinder(r=r_i, h=h+1, center=true);
    translate([0, 0, h/2 - roller_nut_inset]) {
      for (mirror = [-1, 1]) {
        // slot for nuts
        translate([0, .01 + mirror*(r_i + h_nut/2), roller_nut_inset/2])
          cube([w_nut, h_nut, w_nut+roller_nut_inset], center=true);
        // hole for bolt
        rotate([0, 90*mirror, 90])
          cylinder(r=r_bolt, h=r_o);
      }
    }
  }
}

module _eccentric_roller(r_o, r_i, r_i2, h, r_i2_offset) {
  difference() {
    cylinder(r=r_o, h=h, center=true);
    cylinder(r=r_i, h=h+1, center=true);
    translate([r_i2_offset, 0, 0])
      cylinder(r=r_i2, h=h+1, center=true);
  }
}

module eccentric_roller_shaft() {
  r_o=eccentric_roller_r;
  r_i=r_motor_shaft;
  r_i2=r_608zz;
  h=roller_h;
  r_i2_offset=eccentric_roller_offset;
  r_o_shaft=eccentric_roller_r_o_shaft;
  h_shaft=h_motor_shaft;
  intersection() {
    _eccentric_roller(r_o, r_i, r_i2, h, r_i2_offset);
    translate([r_o/2, 0, 0])
    cube([r_o*2, r_o, 20], center=true);
  }

  translate([0, 0, (h+h_shaft) / 2])
    _shaft(r_o=r_o_shaft, r_i=r_i, h=h_shaft);
}

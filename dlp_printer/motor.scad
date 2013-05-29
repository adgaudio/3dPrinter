include <shared_vars.scad>;

// TODO: nut traps to mount lm8uu holders
module motor_mount() {
  module base() {
    cube([motor_x, motor_y, motor_mount_z], center=true);
    // attachment
    translate([motor_x/2 + mount_x_offset/2, 0, -z_slanted/2])
      cube([mount_x_offset, motor_y, motor_mount_z + z_slanted], center=true);
  }
  z_slanted = tan(vat_holder_angle) * motor_x;
  mount_x_offset = sin(vat_holder_angle)*z_slanted;

  translate([mount_x_offset, 0, z_slanted+motor_mount_z/2]) {
    difference() {
      hull() {
        // top of base
          base();

        // bottom (slanted part)
        translate([0, 0, -z_slanted/2])
        rotate([0, vat_holder_angle, 0]) {
            translate([-motor_x/2, -motor_y/2, -1])
              cube([motor_x, motor_y, 1]);
        }
      }

      // cut out bolt holes
      for (mirror1 = [-1, 1], mirror2 = [-1, 1]) {
        rotate([0, vat_holder_angle, 0])
        translate([mount_x_offset/2, 0, -10])
          translate([mirror1 * (motor_x - 2*motor_mount_inset - motor_mount_bolt_size)/2,
                     mirror2 * (motor_y - 2*motor_mount_inset - motor_mount_bolt_size)/2,
                     0])
            cylinder(r=motor_mount_bolt_size, h=3*(motor_mount_z + motor_mount_z), center=true);
      }
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

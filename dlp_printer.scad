module shaft(r_o, r_i, h,
             w_nut=m3_nut_width, h_nut=m3_nut_height,
             r_bolt=m3_bolt_radius) {  // todo: define m3_bolt_radius
  difference() {
    cylinder(r=r_o, h=h, center=true);
    cylinder(r=r_i, h=h, center=true);
    translate([0, 0, (h-w_nut)/2]) {
      for (mirror = [-1, 1]) {
        // slot for nuts
        translate([0, r_i*mirror, 0])
          cube([w_nut, h_nut, w_nut], center=true);
        // hole for bolt
        rotate([0, 90*mirror, 90])
          cylinder(r=r_bolt, h=r_o);
      }
    }
  }
}

module eccentric_roller(r_o, r_i, r_i2, h, r_i2_offset) {
  difference() {
    cylinder(r=r_o, h=h, center=true);
    cylinder(r=r_i, h=h, center=true);
    translate([r_i2_offset, 0, 0])
      cylinder(r=r_i2, h=h, center=true);
  }
}

module eccentric_roller_shaft(r_o, r_i, r_i2, h, r_i2_offset,
                              r_o_shaft, h_shaft) {
  eccentric_roller(r_o, r_i, r_i2, h, r_i2_offset);

  translate([0, 0, (h+h_shaft) / 2])
    shaft(r_o=r_o_shaft, r_i=r_i, h=h_shaft);
}


/*$fn=10;*/

m3_nut_height = 1;
m3_nut_width = 4;
m3_bolt_radius = 1.5; // TODO
m8_bolt_radius = 8/4;  // TODO

r_608zz = 22/2 + .6;
r_608zz_hole = 8/2;
h_608zz = 7;

h_motor_shaft = 5;
thickness_motor_shaft = 3;
r_motor_shaft = 5;

eccentric_roller_rim_width = 3;
eccentric_roller_offset = 3 + r_608zz + r_motor_shaft ;
eccentric_roller_r = eccentric_roller_rim_width + 
                     max(r_608zz, eccentric_roller_offset) + r_608zz;
eccentric_roller_r_o_shaft = thickness_motor_shaft + r_motor_shaft;

roller_r_rod = 8/2;
roller_r = r_608zz + roller_r_rod + 1;
roller_h = 2*h_608zz + 1;



vat_r_o = 55;
vat_r_i = 52;
vat_h = 30; // TODO
vat_z_holder = 5; // defines maximum possible z movement there can be when tilting vat
vat_holder_width = 30; // TODO - just seems right
vat_holder_angle = asin(vat_z_holder / vat_holder_width);
vat_hinge_r_o = r_608zz + 3;
vat_hinge_thickness = h_608zz;
vat_hinge_y_offset = 20;
_y = (vat_hinge_y_offset- vat_hinge_thickness/2);
vat_hinge_x_offset = vat_r_i - sqrt(pow(vat_r_i, 2) - pow(_y, 2));  // via geometric translation & pythagorean theorum

module vat(r_o, r_i, h, z_holder, w_holder, angle_holder,
           r_o_hinge, r_i_hinge, thickness_hinge, y_offset_hinge,
           r_m8_bolt) {

  // main body of vat with handle for tilt mechanism
  difference() {
    hull() {
      // main body
      cylinder(r=r_o, h=h, center=true);
      // slanted bolt holder
      translate([r_o + w_holder/2, 0, 0])
        cube([w_holder, 10, h-z_holder], center=true);
    }
    // hollow out center
    cylinder(r=r_i, h=h, center=true);
    // holder bolt hole
    translate([r_o + w_holder/2, 0, 0])rotate([0, angle_holder, 0])
      cylinder(r=r_m8_bolt, h=h, center=true);
  }
  module _vat_hinge() {
    // hinge
    difference() {
      hull() {
        translate([-r_o + (r_o - r_i)/2 + x_offset_hinge, y_offset_hinge, 0])
          cube([1/1000, thickness_hinge, h], center=true);
        translate([-r_o - r_o_hinge + x_offset_hinge, y_offset_hinge, -h/2])rotate([90, 0, 0])
          cylinder(r=r_o_hinge, h=thickness_hinge, center=true); // TODO: remove hardcoded
      }
      // hinge bearing hole
      translate([-r_o - r_o_hinge + x_offset_hinge, y_offset_hinge, -h/2])rotate([90, 0, 0])
        cylinder(r=r_i_hinge, h=thickness_hinge, center=true);
    }
  }
  _vat_hinge();
  mirror([0, 1, 0]) _vat_hinge();
}

module 2Dhinge(r_o, r_i, y_offset, x_offset, thickness) {

  difference() {
    union() {
      for (mirror = [-1, 1], sign=[-1, 1]) {
        translate([x_offset, mirror * (y_offset + sign * thickness), 0])rotate([90, 0, 0])
          hinge_connector(r_o, r_i, thickness);
        translate([-2*(r_o-x_offset/2), mirror * (y_offset), thickness + sign*thickness])
          translate([0, 0, -r_o+thickness/2])rotate([0, 180, 0])
            hinge_connector(r_o, r_i, thickness);
      }
    }
    for (mirror = [-1, 1], sign=[-1, 1]) {
      translate([x_offset, mirror * (y_offset + sign * thickness), 0])rotate([90, 0, 0])
        cylinder(r=r_i, h=r_o+thickness, center=true);
      translate([-2*(r_o-x_offset/2), mirror * (y_offset), 0])rotate([0, 180, 0])
        cylinder(r=r_i, h=2*r_o+thickness, center=true);
    }
  }
}

module hinge_connector(r_o, r_i, thickness) {
  difference() {
    hull() {
      cylinder(r=r_o, h=thickness, center=true);
      translate([-r_o, 0, 0])
        cube([2*r_o, 2*r_o, thickness], center=true);
    }
    cylinder(r=r_i, h=thickness, center=true);
  }
}

translate([vat_r_o + vat_holder_width + 10, 0, vat_h])rotate([0, 0, 180])rotate([0, -vat_holder_angle, 0])
  eccentric_roller_shaft(
    r_o=eccentric_roller_r, r_i=r_motor_shaft, r_i2=r_608zz, h=roller_h, r_i2_offset=eccentric_roller_offset,
    r_o_shaft=eccentric_roller_r_o_shaft, h_shaft=h_motor_shaft);

vat(r_o=vat_r_o, r_i=vat_r_i, h=vat_h,
    z_holder=vat_z_holder, w_holder=vat_holder_width, angle_holder=vat_holder_angle,
    r_o_hinge=vat_hinge_r_o, r_i_hinge=r_608zz,
    thickness_hinge=vat_hinge_thickness, y_offset_hinge=vat_hinge_y_offset, x_offset_hinge=vat_hinge_x_offset,
    r_m8_bolt=m8_bolt_radius
    );

translate([-20 + -vat_r_i - vat_hinge_r_o - vat_hinge_x_offset, 0, -vat_hinge_r_o]) {
  2Dhinge(r_o=vat_hinge_r_o, r_i=r_608zz,
          y_offset=vat_hinge_y_offset, x_offset=vat_hinge_x_offset,
          thickness=vat_hinge_thickness);

  for (mirror = [-1, 1]) {
    translate([-20 + -2*vat_hinge_r_o + vat_hinge_x_offset, vat_hinge_y_offset * mirror, -vat_hinge_thickness/2])
      hinge_connector(vat_hinge_r_o, r_608zz, vat_hinge_thickness);
  }
}


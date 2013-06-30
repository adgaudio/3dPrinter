include <shared_vars.scad>;
include <../shape_primitives.scad>;


module vat(r_lense_lip=vat_r_lense_lip,
           h_lense_lip=vat_h_lense_lip,
           z_lense_lip_offset=vat_z_lense_lip_offset,
           r_o=vat_r_o,
           r_i=vat_r_i,
           h=vat_h,
           z_holder=vat_z_holder,
           w_holder=vat_holder_width,
           angle_holder=vat_holder_angle,
           r_o_hinge=vat_hinge_r_o,
           r_i_hinge=r_608zz,
           thickness_hinge=vat_hinge_thickness,
           y_offset_hinge=vat_hinge_y_offset,
           x_offset_hinge=vat_hinge_x_offset,
           r_m8_bolt=m8_bolt_radius,
          ) {

  module _vat_hinge() {
    // hinge
    difference() {
      hull() {
        translate([-r_o/2 + (r_o - r_i)/2 + x_offset_hinge, y_offset_hinge, 0])
          cube([r_o, thickness_hinge, h], center=true);
        translate([-r_o - r_o_hinge + x_offset_hinge, y_offset_hinge, 0])
        rotate([90, 0, 0])
          cylinder(r=r_o_hinge, h=thickness_hinge, center=true);
      }
    // hinge bearing hole
    translate([-r_o - r_o_hinge + x_offset_hinge, y_offset_hinge, 0])rotate([90, 0, 0])
      cylinder(r=r_i_hinge, h=thickness_hinge+r_o, center=true);
  }
}

  // main body of vat with handle for tilt mechanism
  difference() {
    union() {
      hull() {
        // main body
        cylinder(r=r_o, h=h, center=true);
        // slanted bolt holder
        translate([r_o + w_holder/2, 0, -z_holder/2])
          cube([w_holder, 10, h-z_holder], center=true);
      }
      _vat_hinge();
      mirror([0, 1, 0]) _vat_hinge();
    }
    // remove corner caused by vat_hinge hull
    translate([0, 0, -h])
      cylinder(r=r_o, h=h, center=true);
    // hollow out center
    cylinder(r=r_i, h=h+2*r_o_hinge, center=true);
    // holder bolt hole
    translate([r_o + w_holder/2, 0, 0])rotate([0, angle_holder, 0])
      cylinder(r=r_m8_bolt, h=2*h, center=true);
  }
  translate([0, 0, (-h+h_lense_lip)/2 + z_lense_lip_offset])
    donut(r_o, r_lense_lip, h_lense_lip, $fn=$fn, center=true);
}

module 2Dhinge() {
  // TODO: get rid of x_offset, because it shouldnt be here!
  r_o=vat_hinge_r_o;
  r_i=r_608zz;
  y_offset=vat_hinge_y_offset;
  x_offset=vat_hinge_x_offset;
  thickness=vat_hinge_thickness;

  difference() {
    union() {
      for (mirror = [-1, 1], sign=[-1, 1]) {
        translate([x_offset, mirror * (y_offset + sign * thickness), 0])
          rotate([90, 0, 0])
            _hinge_connector(r_o, r_i, thickness-1);

        translate([-2*(r_o-x_offset/2), mirror * (y_offset), thickness + sign*thickness -.5])
        translate([0, 0, -r_o+(thickness)/2])rotate([0, 180, 0])
          _hinge_connector(r_o, r_i, thickness-1);

      translate([-1*(r_o -x_offset), mirror*y_offset, 0])
        cube([r_o+2*x_offset, 2*r_o, 2*r_o], center=true);
      }
    }
    for (mirror = [-1, 1], sign=[-1, 1]) {
      // cut out female ends of hinge
      translate([x_offset, mirror * (y_offset), 0])
        rotate([90, 180, 0])
          cylinder(r=r_o, h=thickness, center=true);

      // cut out female ends of hinge along other dimension
      translate([-2*(r_o-x_offset/2), mirror * (y_offset), thickness + sign*thickness])
      translate([0, 0, -r_o-thickness/2])rotate([0, 180, 0])
        cylinder(r=r_o, h=thickness, center=true);

      // cut out holes for bearings on male end
      translate([x_offset, mirror * (y_offset + sign * thickness), 0])rotate([90, 0, 0])
        cylinder(r=r_i, h=r_o+thickness, center=true);

      // cut out holes for bearings on male end along other dimension
      translate([-2*(r_o-x_offset/2), mirror * (y_offset), 0])rotate([0, 180, 0])
        cylinder(r=r_i, h=2*r_o+thickness, center=true);

    }
  }
}

module _hinge_connector(r_o, r_i, thickness) {
  difference() {
    hull() {
      cylinder(r=r_o, h=thickness, center=true);
      translate([-r_o, 0, 0])
        cube([2*r_o, 2*r_o, thickness], center=true);
    }
    cylinder(r=r_i, h=thickness+1, center=true);
  }
}


module hinge_mount() {
  extrusion_conn = (20+2*thickness);
  difference() {
    union() {
      for (mirror = [-1, 1]) {
        translate([0, vat_hinge_y_offset * mirror, 0])
          _hinge_connector(vat_hinge_r_o, r_608zz, vat_hinge_thickness);
      }
      translate([-2*vat_hinge_r_o, 0, 0]) {
        cube([2*vat_hinge_r_o, 2*(vat_hinge_r_o + vat_hinge_y_offset), vat_hinge_thickness], center=true);
        cube([extrusion_conn, extrusion_conn, 30+vat_hinge_thickness], center=true);
      }
    }
    // bolt holes
    for (x_sign = [-1, 1], y_sign = [-1, 1]) {
      translate([-2*vat_hinge_r_o - (vat_hinge_r_o - 5) * x_sign,
                 y_sign * (vat_hinge_r_o + vat_hinge_y_offset - 5),
                 -1.5*vat_hinge_thickness])
        cylinder(r=m3_bolt_radius, h=2*vat_hinge_thickness);
    }
    for (angle=[0, 1], z_mirror=[-1, 1]) translate([-2*vat_hinge_r_o, 0, z_mirror*(30+vat_hinge_thickness)/4])
        rotate([[1, 0][angle] * 90, angle*90, 0])
        cylinder(r=m5_bolt_radius, h=21 + vat_hinge_thickness, center=true);
    // extrusion cutout
    translate([-(2*vat_hinge_r_o), 0, 0])
      cube([20, 20, 40+vat_hinge_thickness + 1], center=true);
  }
}

include <bolts.scad>;
include <bead_chain_gear.scad>;

x_gear_offset = 20;  // x distance between gears
y_gear_offset = 10;  // y distance between gears

// Horseshoe Dimensions
h_horseshoe = h_g;
w_horseshoe = 2 + bead_radius;
r_horseshoe = r_g + w_horseshoe;
horseshoe_handle_radius = default_boltsize + 7;
// Define the centers of the gears
x_offset = r_g + .5 * x_gear_offset;
y_offset = .5 * y_gear_offset;
z_offset = -.5 * l_motor_shaft;
x_handle_offset = -1 * r_horseshoe - .5 * (horseshoe_handle_radius-w_horseshoe);

// Plate Dimensions
inset = default_boltsize + 2;
d_motor_screw_holes = 42;
x_plate = 2 * (x_offset + r_horseshoe + horseshoe_handle_radius);
y_plate = 2 * (y_offset + max(r_horseshoe, d_motor_screw_holes/2+inset));
d_plate = 2;
z_plate_offset = l_motor_shaft + .5 * h_g;

r_spacer = default_boltsize+2;

////////////////////////////
// Horseshoes
////////////////////////////


module horseshoe_base(center=true) {
  difference() {
    union() {
      cylinder(r=r_horseshoe, h=h_horseshoe, center=center);
      // Add handle
      translate([x_handle_offset, 0, 0])
      bolt(m=horseshoe_handle_radius, h=h_horseshoe, center=center);
    }
    cylinder(r=r_horseshoe + bead_radius - w_horseshoe, h=2*h_horseshoe, center=center);
    translate([.5*r_horseshoe, 0, 0])
      cube([r_horseshoe, 2*r_horseshoe, 2*h_horseshoe], center=center);

    translate([x_handle_offset, 0, 0])
      bolt(default_boltsize, h=100, center=center);
  }
}
module make_left_horseshoe() {
  horseshoe_base();
}
module make_right_horseshoe() {
  rotate([0, 0, 180])horseshoe_base();
}

module make_gears_with_horseshoes() {
  translate([x_offset, y_offset, z_offset])
    make_gear_for_motor();
  translate([-1 * x_offset, -1 * y_offset, z_offset])
    make_gear_for_608ZZ_bearing();

  translate([x_offset, y_offset, z_offset])
    make_right_horseshoe();
  translate([-1 * x_offset, -1 * y_offset, z_offset])
    make_left_horseshoe();
}

/////////////////////////////////
// Plates and body
////////////////////////////////
//NOTE: I by mistake swapped x and y axes, so rotate everything at end

module plate_base(center=true) {
  difference() {
    cube([x_plate, y_plate, d_plate], center=center);
    // Corner bolt holes
    translate([x_plate/2 - inset, y_plate/2 - inset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([x_plate/-2 + inset, y_plate/2 - inset - y_offset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([x_plate/2 - inset, y_plate/-2 + inset + y_offset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([x_plate/-2 + inset, y_plate/-2 + inset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    // Center bolt holes
    translate([0, y_offset + r_g - r_spacer, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([0, -y_offset - r_g + r_spacer, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    // Sliding holes for horseshoe handle
    hull() {
      translate([-x_plate/2 + inset, -y_offset, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
      translate([-x_offset - inset - d_bearing_inner, -y_offset, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
    }
    hull() {
      translate([x_plate/2 - inset, y_offset, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
      translate([x_offset + inset + d_bearing_inner, y_offset, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
    }
    // Holes for gears
    translate([x_offset, y_offset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);  // # add 5th and 6th holes
    translate([-x_offset, -y_offset, 0])
      bolt(m=d_bearing_inner, h=2*d_plate, center=center);
    // Holes for motor mount
    translate([x_offset, y_offset + d_motor_screw_holes/2, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([x_offset, y_offset - d_motor_screw_holes/2, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
  }
}
module make_top_plate(center=true) {
  plate_base();
}
module make_bottom_plate(center=true) {
  rail_height = h_horseshoe;
  union() {
    plate_base();
    translate([-x_offset, y_offset + r_g, (d_plate + rail_height)/2])
      cube([2*r_g, 2, rail_height], center=center);
    translate([x_offset, -y_offset - r_g, (d_plate + rail_height)/2])
      cube([2*r_g, 2, rail_height], center=center);
  }
}
module plates() {
  translate([0, 0, -.25 * h_g + .5 * (z_plate_offset + d_plate)])
    make_top_plate();
  translate([0, 0, -.25 * h_g + -.5 * (z_plate_offset + d_plate)])
    make_bottom_plate();
}

module plate_spacer() {
  difference() {
    cylinder(r=r_spacer, h=z_plate_offset, center=true);
    cylinder(r=default_boltsize, h=z_plate_offset*2, center=true);
  }
}

module plate_spacers() {
    translate([x_plate/2 - inset, y_plate/2 - inset, -d_plate])
      plate_spacer();
    translate([x_plate/-2 + inset, y_plate/2 - inset - y_offset, -d_plate])
      plate_spacer();
    translate([x_plate/2 - inset, y_plate/-2 + inset + y_offset, -d_plate])
      plate_spacer();
    translate([x_plate/-2 + inset, y_plate/-2 + inset, -d_plate])
      plate_spacer();

    translate([0, y_offset + r_g - r_spacer, -d_plate])
      plate_spacer();
    translate([0, -1 * (y_offset + r_g - r_spacer), -d_plate])
      plate_spacer();
}

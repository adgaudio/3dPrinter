default_boltsize = 3;  // TODO: verify that this is properly applied everywhere

bead_radius = 4.6/2; //6.05/2; //4.45/2;
link_radius=.5;

d_motor_screw_holes = 32;  // # TODO

// Gear Dimensions
cover_height=2;
h_g = bead_radius * 2 * (1 + .25 + .2 );
n_teeth = 21;
r_g = 19.7940105953;
r_motor_shaft = 5.5/2;
l_motor_shaft = 10;  // TODO: get length of motor shaft
r_bearing = 14.5; // TODO: bearings
h_bearing = 20;
x_gear_offset = 20;  // TODO
y_gear_offset = 10;

///////////////////////////
// Bolt + nut
///////////////////////////


// Bolt and nut dimensions
module bolt(default_boltsize, h=10, center=true, $fn=10) {
  // TODO: find size for each m type
  /*bolt_diameter = m / cos(180 / 8) + 0.4;*/
  /*bolt_radius = bolt_diameter / 2;*/
  cylinder(r=m, h=h, center=center);
}
module nut(default_boltsize, center=true, $fn=8) {
  // TODO: find size for each m type
  nut_diameter = 1.1*m / cos(180 / 6) + 0.4;
  nut_depth = 2.6;  // also TODO
  nut_radius = nut_diameter / 2;
  cylinder(r=nut_radius, h=nut_depth, center=center);
}

///////////////////////////
// Gears
///////////////////////////


module make_sphere_ring(r=r_g, r_tooth=bead_radius, n_teeth=n_teeth, $fn=15) {
  union(){
    for (i = [0:n_teeth]){
      rotate([0,0,i*360/n_teeth])
      translate([r_g,0,0])
      hull() {
        sphere(r_tooth);
        translate([-.5 * r_tooth,0,0])sphere(r_tooth);
        translate([0,0,.25 * r_tooth])sphere(r_tooth);
        translate([0,0,-.25 * r_tooth])sphere(r_tooth);
      }
    }
  }
}

module make_torus(r=r_g, r_link=link_radius) {
  // openscad apparently can't handle rotate_extrude in a difference, so this isn't a real cylinder
  //rotate_extrude(convexity=10)translate([ring_radius, 0, 0])circle(inner_radius);
  d_link = r_link * 2;
  difference() {
    cylinder (h=d_link, r=r, center=true);
    cylinder (h=d_link, r=r - d_link, center=true);
  }
}

module bead_ring() {
  union() {
    make_sphere_ring();
    make_torus();
  }
}

module gear_base() {
  difference() {
    union() {
      cylinder(h=h_g, r=r_g, center=true, $fn=n_teeth);
      // Covers
      /*translate([0,0,.5 * (h_g + cover_height)])*/
        /*cylinder(h=cover_height, r=r_g+bead_radius, center=true, $fn=n_teeth);*/
      /*translate([0,0,-.5 * (h_g + cover_height)])*/
        /*cylinder(h=cover_height, r=r_g+bead_radius, center=true, $fn=n_teeth);*/
    }
    # bead_ring();
  }
}

module make_gear_for_motor() {
  difference() {
    union() {
      gear_base();
      cylinder(h=l_motor_shaft, r=r_motor_shaft + 2, center=false);
    }
    bolt(m=r_motor_shaft, h=l_motor_shaft * 200);
} }

module make_gear_for_608ZZ_bearing() {
  difference() {
    gear_base();
    bolt(m=8, h=20*20);
     translate([0,0,1])cylinder(r=r_bearing, h=h_bearing * 20, center=false);
  }
}

////////////////////////////
// Horseshoes
////////////////////////////

h_horseshoe = 1 + 2 * bead_radius;
w_horseshoe = 2 + bead_radius;
r_horseshoe = r_g + w_horseshoe;
horseshoe_handle_radius = 3 + 7;  // TODO: fix handle.  plates don't know where the end of it is
// Define the centers of the gears
x_offset = r_g + .5 * x_gear_offset;
y_offset = .5 * y_gear_offset;
z_offset = -.5 * l_motor_shaft;
x_handle_offset = -1 * r_horseshoe - .5 * (horseshoe_handle_radius-w_horseshoe);



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
#      bolt(default_boltsize, h=100, center=center);
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
x_plate_wiggle_room = 0;
y_plate_wiggle_room = 0;
z_plate_wiggle_room = 0;
x_plate = x_offset * 2;
y_plate = y_offset * 4 + 4 * r_horseshoe + 2 * (horseshoe_handle_radius) - w_horseshoe; // This may not be parametric
d_plate = 2;
z_plate_offset = l_motor_shaft + .5 * h_g + z_plate_wiggle_room;

module plate_base(center=true) {
  inset = default_boltsize + 2;
  difference() {
    cube([x_plate, y_plate, d_plate], center=center);
    // Corner bolt holes
    translate([5/8*x_plate/2 - inset, 7/8*y_plate/2 - inset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([x_plate/-2 + inset, y_plate/2 - inset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([x_plate/2 - inset, y_plate/-2 + inset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    translate([5/8*x_plate/-2 + inset, 7/8*y_plate/-2 + inset, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    // Center bolt holes
    translate([-5*x_plate/(2*8), 0, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);  // # add 5th and 6th holes
    translate([5*x_plate/(2*8), 0, 0])
      bolt(m=default_boltsize, h=2*d_plate, center=center);
    // Sliding holes for horseshoe handle
    hull() {
      translate([-.25 * x_gear_offset , 14.5/16 * y_plate/2, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
      translate([-.25 * x_gear_offset , 11/16 * y_plate/2, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
    }
    hull() {
      translate([.25 * x_gear_offset , -14.5/16 * y_plate/2, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
      translate([.25 * x_gear_offset , -11/16 * y_plate/2, 0])
        bolt(m=default_boltsize, h=2*d_plate, center=center);
    }
    // Holes for gears
    translate([-1 * y_offset, x_offset, 0])
      bolt(m=8, h=2*d_plate, center=center);
    translate([y_offset, -1*x_offset, 0])
      bolt(m=r_motor_shaft*2, h=2*d_plate, center=center);
    // Holes for motor mount
    translate([y_offset + d_motor_screw_holes/2, -1*x_offset, 0])
      bolt(m=3, h=2*d_plate, center=center);
    translate([y_offset - d_motor_screw_holes/2, -1*x_offset, 0])
      bolt(m=3, h=2*d_plate, center=center);
  }
}
module make_top_plate(center=true) {
  plate_base();
}
module make_bottom_plate(center=true) {
  union() {
    plate_base();
    translate([6/8 * x_plate/2, 1/2 * y_plate/2, d_plate])
      rotate([0, 0, 90])
      cube([50, 2, 2], center=center);
    translate([-6/8 * x_plate/2, -1/2 * y_plate/2, d_plate])
      rotate([0, 0, 90])
      cube([50, 2, 2], center=center);
  }
}
module plates() {
  translate([0, 0, -.25 * h_g + .5 * (z_plate_offset + d_plate)])
    make_top_plate();
  translate([0, 0, -.25 * h_g + -.5 * (z_plate_offset + d_plate)])
    make_bottom_plate();
}

make_gears_with_horseshoes();
rotate([0, 0, 90])plates();

/*translate([.15*x_plate, 0, -.25 * h_g])cylinder(r=.2, h=l_motor_shaft+.5*h_g, center=true);*/
/*translate([0, 0, 0]) make_gears();*/

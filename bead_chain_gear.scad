include <bolts.scad>;

bead_radius = 4.6/2; //6.05/2; //4.45/2;
link_radius=.5;

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


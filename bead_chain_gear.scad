$fn=21;

r = 20.1275367222;
h = 5.5;
ball_radius = 4.6/2; //6.05/2; //4.45/2;
n_teeth=21;
link_radius=.5;
cover_height=2;

shaft_radius = 5.5/2;

module make_sphere_ring(ring_radius, sphere_radius, num_spheres) {
  union(){
    for (i = [0:num_spheres]){
      rotate([0,0,i*360/num_spheres])
        translate([ring_radius,0,0])hull() {
          sphere(sphere_radius);
          translate([-.5 * sphere_radius,0,0])sphere(sphere_radius);
        }
    }
  }
}

module make_torus(ring_radius, inner_radius) {
  // openscad apparently can't handle rotate_extrude in a difference, so this isn't a real cylinder
  /*rotate_extrude(convexity=10)translate([ring_radius, 0, 0])circle(inner_radius);*/
  difference() {
    cylinder (
        h = inner_radius*2,
        r = ring_radius,
        center = true);
    cylinder (
        h = inner_radius * 2,
        r = ring_radius - 2*inner_radius,
        center = true);
  }
}

module bead_ring() {
  union() {
    make_sphere_ring(r, ball_radius, n_teeth);
    make_torus(r, link_radius);
  }
}
module make_gear() {
  difference() {
    /*union() {*/
      /*cylinder(h=h, r=r, center=true);*/
      /*translate([0,0,-1*(h-cover_height)])*/
        /*cylinder(h=cover_height, r=r+ball_radius, center=true);*/
      /*translate([0,0,1*(h-cover_height)])*/
        /*cylinder(h=cover_height, r=r+ball_radius, center=true);*/
    /*}*/

    cylinder(h=h, r=r, center=true);
    cylinder (
        r=shaft_radius,
        h=h + 2.1 * cover_height,
        center=true);
    bead_ring();
  }
}
make_gear();
/*bead_ring() ;*/
/*make_torus(r, link_radius);*/

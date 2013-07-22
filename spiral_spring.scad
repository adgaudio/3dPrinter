// EXAMPLES:
//spiral_spring(50, 0, 10, 20, trim_width=1);
//translate([20, 0, 0])
//spiral_spring_with_fun_properties(10, 0, 1, 5, 1, .1);

pi = 3.14159265359;

module spiral_spring(r_o, r_i, h, n_coils, resolution=45, trim_width=1) {
  /* Generate a 3d archimedes spiral
   * resolution: determine how long each cube-step is.
      - you can think of it as how many sides each coil will have
     trim_width: a multiplier that represents how thick to make the spring
   */
  // radial dist from one coil to next
  width = (r_o - r_i) / (n_coils);
  // radial distance from origin
  function radial_dist(nth_coil) = r_o - nth_coil * width;
  // dist between two cube-steps on circle:
  // = circumference_of_circle / (360 / resolution)
  function arc_len(nth_coil) = (pi * 2*radial_dist(nth_coil)) / (resolution);
  // pythagorean theorum
  function hyp(a, b) = sqrt(pow(a, 2) + pow(b, 2));
  // current degree around circle
  function get_deg(nth_coil, nth_step) = 360.0 / n_steps(nth_coil) * nth_step;
  // number of cube-steps around the circle depends on which nth coil we're building
  function n_steps(nth_coil) = 2*pi*radial_dist(nth_coil+.5) / (arc_len(nth_coil+.5));
  //function n_steps(nth_coil) = 2*pi*radial_dist(nth_coil) / (arc_len(nth_coil));

  union() {
  for (nth_coil=[1:n_coils])
  for (nth_step=[0:n_steps(nth_coil)])
    rotate([0, 0, get_deg(nth_coil, nth_step)]) // move cube around circle
    rotate([0, 0, get_deg(nth_coil, 1)/-2]) // put the starting point of the circle on x axis
    translate([radial_dist(nth_coil) + width / n_steps(nth_coil)*nth_step, 0, 0]) // move cube proper radial distance
      cube([width/2*trim_width, hyp(width, arc_len(nth_coil+.5)), h], center=true); // I think arc_len estimates the distance and may underestimate for very large n_coils.
  }
}

module spiral_spring_with_fun_properties(r_o, r_i, h, n_coils, resolution=1, trim_width=1) {
  // if you uncomment out combinations of the lines below, the spiral transforms into beautiful shapes
  width = (r_o - r_i) / n_coils;
  union() {
    for (deg=[0:resolution:360*n_coils]) {
      translate([(r_o+deg)/360*sin(deg), (r_o+deg)/360*cos(deg), 0]) {
      // interesting shapes can be had once you enable the line below and any of the other ones
      //rotate([90, 0, 0])
      //rotate([0, deg*atan(deg), deg*cos(deg)])
      //rotate([0, 0, deg*cos(deg)])
      //cube([width/2*trim_width, trim_width*width/2, h], center=true);
      cylinder(r=width*trim_width/4, h=h, center=true);
      }
    }
  }
}

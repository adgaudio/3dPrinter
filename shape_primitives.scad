module donut(r_o, r_i, h, $fn, center=false) {
  difference() {
    cylinder(r=r_o, h=h, $fn=$fn, center=center);
    translate([0, 0, -.5])
    cylinder(r=r_i, h=h+1.5, $fn=$fn, center=center);
  }
}

module cone_hollow(r1, r2, h) {
  /* make a hollow cone of height h.
   * r1 and r2 are both arrays of form: [outer_radius, inner_radius]
   */
  difference() {
    cylinder(r1=r1[0], r2=r2[0], h=h);
    cylinder(r1=r1[1], r2=r2[1], h=h);
    translate([0, 0, -.5])
    cylinder(r=r1[1], h=1);
    translate([0, 0, h-.5])
    cylinder(r=r2[1], h=1);
  }
}

module U(r_o, r_i, w, thick) {
  difference () {
    hull () {
      cylinder(r=r_o, h=thick, center=true);
      translate([r_o, 0, 0])
        cube([w-r_o, 2*r_o, thick], center=true);
    }
    cylinder(r=r_i, h=thick+1, center=true);
  }
}


use <../lib/shape_primitives.scad>
cutout = 6; // extra dimensions to make clear difference() operations


////////////////////////
// NEON light
////////////////////////
neon_r_o = 29/2;
pi = 3.14159;

module neon_spacer() {
  r_o1 = neon_r_o;
  r_i1 = 24/2;
  h1 = 5;
  r_o2 = 32/2;
  r_i2 = r_o2 - 5;
  h2 = 10;
  h_overlap = 3;
  $fn=50;

  donut(r_o1, r_i1, h1+h_overlap, $fn);
  translate([0, 0, h1])
    donut(r_o2, r_o1, h2, $fn);
}
/*neon_spacer();*/

module neon_dichroic_filter_spacer() { // make me
  // measured vars
  r_lense = 29/2;
  r_lense_lip = 1;  // section that holds filter
  wall_thickness = 1;
  h_total = 15.5;
  h_lense = 2;
  // derived vars
  r_i = r_lense - r_lense_lip;
  r_o = r_lense + wall_thickness;
  lense_inset = 2 * h_lense;

  $fn = 90;

  donut(r_lense, r_i, h_total - lense_inset, $fn);
  translate([0, 0, h_total - lense_inset - 3])
  donut(r_o, r_lense, lense_inset + 3, $fn);
}
neon_dichroic_filter_spacer();

module neon_module() {
  r_o = neon_r_o;
  r_wireshaft = 2;
  y_groovemount = 2.5;
  x_groovemount = 1.5;
  x_offset_groovemount = 6/2;
  angle = 360 * x_offset_groovemount / (pi * 2*r_o);
  h = 18;

  difference() {
    cylinder(r=r_o, h=h, $fn=50);

    // part for wires
    translate([r_o, 0, 0])
      cylinder(r=r_wireshaft, h=h+cutout);
    translate([-r_o, 0, 0])
      cylinder(r=r_wireshaft, h=h+cutout);

    // part to attach into flashlight
    #translate([0, r_o - y_groovemount, 0])
      cube([x_groovemount, y_groovemount, h+cutout]);
    #rotate([0,0,angle])translate([0, -r_o, 0])
      cube([x_groovemount, y_groovemount, h+cutout]);
    #rotate([0,0,-angle])translate([0, -r_o, 0])
      cube([x_groovemount, y_groovemount, h+cutout]);
  }
}

/*$fn=20;*/
/*translate([20 + 2*neon_r_o, 0, 0])*/
  /*neon_spacer();*/
/*neon_module();*/




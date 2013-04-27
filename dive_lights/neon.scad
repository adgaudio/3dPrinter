cutout = 6; // extra dimensions to make clear difference() operations

////////////////////////
// NEON light
////////////////////////
neon_r_o = 29/2;
pi = 3.14159;

module neon_spacer() {
  r_o1 = neon_r_o;
  r_i1 = 24/2;
  h1 = 4;
  r_o2 = 32/2;
  r_i2 = r_o2 - 5;
  h2 = 11;
  h_overlap = 3;

  $fn=50;
  difference() {
    cylinder(r=r_o1, h=h1+h_overlap);
    cylinder(r=r_i1, h=h1+h_overlap + cutout);
  }
  translate([0, 0, h1])difference() {
    cylinder(r=r_o2, h=h2);
    cylinder(r=r_o1, h=h2 + cutout);
  }
}


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




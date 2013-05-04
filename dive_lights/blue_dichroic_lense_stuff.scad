use <../shape_primitives.scad>
function avg(a, b) = (a + b) / 2;

r_dichroic = 47.5/2;
r_glass = 54/2;
h_dichroic = 2;
_h_glass = 2.25;
_h_silicone_lense_tape = 1.1; // tape that secures lense to holder

r_lip = 1;
wall_thickness = 1;

//derived vars
r_o_dichroic = r_glass;
r_i_dichroic = r_dichroic - r_lip;
r_o_glass = r_glass + wall_thickness;
z_to_dichroic = 2;
z_to_glass = h_dichroic+_h_silicone_lense_tape+z_to_dichroic - .8;
h_glass = 2*_h_glass;

// additional vars for mount to lamp
r_top_lamp_mount = 95/2;
r_bottom_lamp_mount = 100/2;
h_lamp_mount = 28;
r_bolt = 2.5/2;

//derived vars
r_o_bottom_lamp_mount = r_bottom_lamp_mount + wall_thickness;
r_o_top_lamp_mount = r_top_lamp_mount + wall_thickness;
r_middle_lamp_mount = avg(r_top_lamp_mount, r_bottom_lamp_mount);
h_middle_lamp_mount = h_lamp_mount/2;

h_skirt= 2;
r_skirt = r_top_lamp_mount - 2*wall_thickness;
r_i_skirt = r_skirt - 2; // the lip that the skirt gets mounted onto
r_o_skirt = r_skirt + wall_thickness;


$fn=50;


module lens_cap() { // make me
  rotate([0, 180, 0]) {
  difference() {
  cylinder(r=(56.5+1)/2, h=6);
  cylinder(r=56.5/2, h=7);
  }
  translate([0, 0, 5])
    donut(56.4/2, avg(r_dichroic, r_glass), h=1);
  }
}


module _blue_dichroic_lense_holder() {

  donut(r_dichroic, r_i_dichroic, h=z_to_dichroic, $fn=$fn);
  donut(r_glass, r_dichroic, z_to_glass, $fn=$fn);
  donut(r_o_glass, r_glass, z_to_glass + h_glass, $fn=$fn);
}

module blue_dichroic_lense_holder_with_skirt() { // make me
  _blue_dichroic_lense_holder();
  donut(r_skirt, r_o_glass, h_skirt, $fn=$fn);
}

module blue_dichroic_lense_mount() {
  difference() {
  cone_hollow([r_o_bottom_lamp_mount, r_bottom_lamp_mount],
              [r_o_top_lamp_mount, r_top_lamp_mount],
              h_lamp_mount, $fn=$fn);
  // 4 bolt holes
  for (deg = [-90, 0, 90, 180])
  rotate([0, 0, deg])
  translate([r_middle_lamp_mount-.5, 0, h_middle_lamp_mount])
  rotate([0, 90, 0])
  cylinder(r=r_bolt, h=wall_thickness+1, $fn=8);
  }
  // insert for skirt
  translate([0, 0, h_lamp_mount]) {
    translate([0, 0, h_skirt])
    donut(r_o_top_lamp_mount, r_i_skirt, h_skirt, $fn=$fn);
    donut(r_o_top_lamp_mount, r_skirt, h_skirt, $fn=$fn);
  }
}
module print_blue_dichroic_lense_mount() { // make me
  rotate([180, 0, 0])
blue_dichroic_lense_mount();
}
/*print_blue_dichroic_lense_mount();*/
/*translate([0, 0, h_lamp_mount])*/
/*blue_dichroic_lense_holder_with_skirt();*/

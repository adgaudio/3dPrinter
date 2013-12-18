
module guitarpick(r_big=12, r_small=5, h=.66) {
  hull() {
    cylinder(r=r_big, h=h);
    translate([r_big, 0, 0])cylinder(r=r_small, h=h);
  }
}

module thumbpick() {
  r_i = 8.5;
  r_o = 10.5;
  thickness=2;
  pick_thickness=.66;

  /*18 x _ x 10*/
  /*21 x _ x 17*/
  translate([0, .5*r_o, r_o+thickness])rotate([90, 0, 0])
    difference() {
      hull() {
        cylinder(r=r_i+thickness, h=1);
        translate([0, 0, 5])cylinder(r=r_o+thickness, h=1);
        translate([-r_o, -r_o-thickness, 0])cube([2*r_o, 1, 5]);
      }
      hull() {
        cylinder(r=r_i, h=1);
        translate([0, 0, 5])cylinder(r=r_o, h=1);
      }
    }
    hull() {
      translate([-r_o, 0, 1])cube([2*r_o, 1, 1]);
      guitarpick(r_big=12, r_small=5.01, h=.66);
    }
}

/*guitarpick(); // make me*/
/*thumbpick(); // make me*/

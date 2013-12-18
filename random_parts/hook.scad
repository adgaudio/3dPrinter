
module _halfcircle(r_o, r_i, h) {
  difference() {
    cylinder(r=r_o, h=h);
    cylinder(r=r_i, h=h);
    translate([-r_o, 0, 0])cube([2*r_o, 2*r_o, h]);
  }
}

module ikea_kitchen_hook(r_o=12.5, xy_thickness=2.5, z_thickness=5, straight_length=45, hook_tip_length=10) {
  // maximum length of hook is r_o + r_o + straight_length
  /*translate([0, -r_o, 4])cube([2, 2*r_o + straight_length, 2]);*/
  // maximum width of hook is 4 * r_o - xy_thickness
  /*translate([-r_o, 50, 4])cube([4*r_o - xy_thickness, 2, 2]);*/

  r_i = r_o-xy_thickness;
  union() {
    _halfcircle(r_o, r_i, h=z_thickness);
    translate([r_i, 0, 0])cube([xy_thickness, straight_length, z_thickness]);
    translate([2*r_i+xy_thickness, straight_length, z_thickness])rotate([180, 0, 0])
      _halfcircle(r_o, r_i, h=z_thickness);

    // add longer ends
    translate([-r_i-xy_thickness, 0, 0])cube([xy_thickness, hook_tip_length, z_thickness]);
    translate([2*r_i+xy_thickness, straight_length-hook_tip_length, 0])translate([r_i, 0, 0])
      cube([xy_thickness, hook_tip_length, z_thickness]);
  }
}

ikea_kitchen_hook(); // make me

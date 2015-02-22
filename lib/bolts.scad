default_boltsize = 3.6;  // TODO: verify that this is properly applied everywhere

///////////////////////////
// Bolt + nut
///////////////////////////


// Bolt and nut dimensions
module bolt(m=default_boltsize, h=10, center=true, $fn=10) {
  // TODO: find size for each m type
  /*bolt_diameter = m / cos(180 / 8) + 0.4;*/
  /*bolt_radius = bolt_diameter / 2;*/
  cylinder(r=m/2, h=h, center=center);
}
module nut(m=default_boltsize, center=true, $fn=8) {
  // TODO: find size for each m type
  /*nut_diameter = 1.1*m / cos(180 / 6) + 0.4;*/
  nut_depth = 2.6;  // also TODO
  /*nut_radius = nut_diameter / 2;*/
  /*cylinder(r=nut_radius, h=nut_depth, center=center);*/
  cylinder(r=m/2, h=nut_depth, center=center);
}


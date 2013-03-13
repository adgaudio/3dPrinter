$fn=20;

module donut(r_i, height) {
  translate([0, 0, height/2 - r_i/4])
    rotate_extrude(convexity=10) {
      translate([r_i+height/2,0,0])circle(r=height/2, center=true);
    }
}

module washer(r_i, width, height) {
  // edges
  donut(r_i, height);
  translate([0, 0, width-height])donut(r_i, height);
  // center
  difference() {
    cylinder(r=r_i+height, h=width-height, center=true);
    cylinder(r=r_i, h=width-height, center=true);
  }
} 

module bowl(r_i, height, width, n_legs, twist) {
  for (pos=[0:360/n_legs:360]) {
    rotate([0, 0, pos])
      linear_extrude(height=height, center = false, convexity = 10, twist = twist)
        translate([0,r_i,0])circle(r=width, center=true, $fn=5);
  }
}

module gem_mold(side_length, angle) {
  difference() {
    cube([side_length, side_length, side_length], center=true, $fn=1);
    rotate([angle, 0, 0])cube([side_length, side_length, side_length], center=true, $fn=1);
  }
}

module gem_base(side_length, height, angle) {
  // make the bottom half of a base in the shape of a tetrahedron
  difference() {
    cube([side_length, side_length, side_length+height], center=true, $fn=1);
    for (ang2=[0,90]) {
      rotate([0, 0, ang2]) {
        translate([side_length/2, 0, 0])rotate([0, angle, 0])
          cube([side_length, side_length, side_length], center=true, $fn=1);
        translate([-side_length/2, 0, 0])rotate([0, -angle, 0])
          cube([side_length, side_length, side_length], center=true, $fn=1);
      }
    }
    // hack to openscad junk (remove bottom) probably makes this not parametric and might cut off important parts
    translate([0, 0, -height])cube([side_length*1.1,side_length*1.1,height*1.1], center=true, $fn=1);
  }
}

module gemstone(side_length, height, angle) {
  difference() {
    union() {
      difference() {
        cube([side_length, side_length, side_length], center=true, $fn=1);
        // cut off base
        translate([0, .5*height, 0])
          cube([side_length, side_length, side_length], center=true, $fn=1);
      }
      // add better base
      translate([0, height, 0])rotate([90, 0, 0])
        gem_base(gem_side_length, height, angle);
    }
    // crown
    for (ang = [0: angle: 180 - angle]) {
      rotate([ang, 0, 0])gem_mold(side_length, angle);
      rotate([0, ang, 0])gem_mold(side_length, angle);
      rotate([0, 0, ang])gem_mold(side_length, angle);
    }
  // hack: remove junk probably due to openscad bug
  translate([.999*side_length, 0, 0])cube([side_length, side_length, side_length], center=true, $fn=1);
  translate([.999*-side_length, 0, 0])cube([side_length, side_length, side_length], center=true, $fn=1);
  translate([0, .999*side_length, 0])cube([side_length, side_length, side_length], center=true, $fn=1);
  translate([0, .999*-side_length, 0])cube([side_length, side_length, side_length], center=true, $fn=1);
  translate([0, 0, .999*-side_length])cube([side_length, side_length, side_length], center=true, $fn=1);
  translate([0, 0, .999*side_length])cube([side_length, side_length, side_length], center=true, $fn=1);
  }
}


module ring() {
  washer_r_i=10;
  washer_width=5;
  washer_height=1;
  bowl_r_i = 4;
  bowl_width=.5;
  bowl_height=3.5;

  gem_side_length=2.5*(bowl_r_i-bowl_width);
  gem_angle = 45;
  gem_height=6/5*gem_side_length*4*gem_angle/360;

  // ring body
  rotate([0, 90, 0])
    washer(washer_r_i, washer_width, washer_height);
  // gem holder
  translate([0, 0, washer_r_i]) {
    scale([.75, .999, 1]) // TODO: set scale as scale([1, bowl_height, bowl_width])
    rotate([0, 0, 45]) {
      cylinder(r=bowl_r_i+.5*bowl_width, h=washer_height);
      bowl(bowl_r_i, bowl_height, bowl_width, n_legs=10, twist=180/3);
      bowl(bowl_r_i, bowl_height, bowl_width, n_legs=8, twist=-180/3);
    }
    // gem stone
    difference() {
      translate([0, 0, gem_height/3])rotate([360-90, 0, 90])
        gemstone(gem_side_length, gem_height, gem_angle);
      // remove any piece of gemstone that may hit finger
      translate([0, 0, -gem_side_length*.5])cube([gem_side_length, gem_side_length, gem_side_length], center=true);
    }
  }
}

rotate([0, 180, 0])ring();

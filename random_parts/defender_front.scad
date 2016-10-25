/*
This module is a component for my bicycle.  It attaches the Defender front
fender to the fork of the frame.
  Topeak DeFender M1 Mountain Bike Fender (Front)

To use this on your fork, simply adjust the r_fork
*/
r_fork = 17/2;  // TODO
h_fork_insert = 27; // max height
ri_insert = 3.5;

angle = 45;
xyz_base = [24, 40, 5];
$fn=150;

module insert_with_base() {  // make me
  difference(){
    union(){
      translate([xyz_base[0]/-2, xyz_base[1]/-2,xyz_base[2]*-1]) cube(xyz_base);
      solid_insert();
    }
    insert_cutout();
    translate([0,0,xyz_base[2]*-1-.1])
    insert_cutout();
  }
  for(i=[-1,1]){
  #translate([0,i*(31.5-3.5)/2,xyz_base[2]*-1-4])cylinder(r=3.5/2,h=4);
  }
}

module solid_insert() {
  difference(){
    cylinder(r=r_fork, h=h_fork_insert);
    translate([0,0,h_fork_insert - tan(angle)*r_fork])
      rotate([-angle,0,0])translate([-0,-50,0])
        cube([100,100,100], center=true);
    translate([0,0,25+h_fork_insert-1])cube([50,50,50],center=true);

      // holes for traction
      union(){
      for (z=[1:4]) for (i=[1:10])
          translate([0,0,z*5])
          rotate([0,0,360/10*i])translate([r_fork,0,0])
          cube([2,2,2],center=true);
      }
  }
}

module insert_cutout() {
    //washer cutout
      cylinder(r=ri_insert,h=h_fork_insert);
}

module insert() {  // make me
  difference(){
    solid_insert();
    // bolt hole
    cylinder(r=5.5/2, h=h_fork_insert);
    translate([0,0,7]) insert_cutout();
    // nut cutout
    intersection_for(i=[0,1,2]) {
      translate([0,0,4/2-.1])rotate([0,0,360/3*i])cube([12,8.5,4],center=true);
    }
  }
}
/* translate([100,100,0]) */
/* insert(); */

/* insert_with_base(); */

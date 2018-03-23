// Raspberry pi display case for official 7" display
// and option for a "sleeve" that fits right beside the display to hold 
// things like a microchip.

th = 3.175;  // general wall thickness (1/8th inch)
m3_r = 2;  // AMES loose, after nopead's polyhole
m3_tight_r = 1.732;  // AMES close, after nopead's polyhole
m5_r = 3;  // AMES loose, after nopead's polyhole
m5_tight_r = 2.76;  // AMES close, after nopead's polyhole

// specs from datasheet:  https://www.raspberrypi.org/documentation/hardware/display/7InchDisplayDrawing-1large_enclosure_h92015.pdf;
display_x = 192.96;
display_y = 110.76;
display_glass_th = 1.4;
display_glass_to_metal_back_h = 5.96;  // thickness from glass face to back metal
display_h = display_glass_to_metal_back_h + 2.5;
display_m3_inset_x = 20 + 12.54 - m3_r;  // position of m3 nut mount
display_m3_inset_y = 21.58 - m3_r;  // position of m3 nut mount
display_m3_holder_y = 10;  // size not specified in datasheet. little metal knob for m3 bolt to mount display
display_metal_back_y = 100.6;
display_metal_back_inset_x = 11.89;
display_metal_back_inset_y = 6.63;  // fyi the metal back is not centered in y

ext_chip_space_x = 70; // adjustable
ext_chip_space_y = display_y - 2*th;
ext_stability_bar_x = 2*th + 2*m3_r;
ext_x = ext_chip_space_x + th + ext_stability_bar_x;
ext_y = display_y;
ext_inset_x = display_m3_inset_x +m3_r+th;//+ th + m3_r + 5;
large_enclosure_h = 40;  // adjustable, somewhat

corner_r = 11.01;  // corner radius


module display() {
  minkowski() {
    square([display_x-2*corner_r, display_y-2*corner_r]);
    translate([corner_r, corner_r, 0])circle(corner_r);
  }
}


module display_case() {
  pi_hole_inset_x = 20 + 12.54 + 10;
  pi_hole_inset_y = (20.58 + 6.63) / 2;
  pi_hole_x = display_x - 2*pi_hole_inset_x;
  pi_hole_y = display_y - 2*pi_hole_inset_y;
  linear_extrude(display_h) {
    difference(){
      display();
      translate([th, th])resize([display_x - 2*th, display_y - 2*th])
        display();
    }
  }
  // back face plate
  translate([0,0,display_h]) {
    difference(){
      linear_extrude(th)display();
      translate([display_m3_inset_x,display_m3_inset_y,-.5])cylinder(r=m3_r, h=th+1);
      translate([display_m3_inset_x,display_y-display_m3_inset_y,-.5])cylinder(r=m3_r, h=th+1);
      translate([display_x-display_m3_inset_x,display_m3_inset_y,-.5])cylinder(r=m3_r, h=th+1);
      translate([display_x-display_m3_inset_x,display_y-display_m3_inset_y,-.01])cylinder(r=m3_r, h=th+1);
      translate([pi_hole_inset_x,pi_hole_inset_y,-.5])cube([pi_hole_x, pi_hole_y, th+1]);
    }
  }
}

module _ext_top() {
  linear_extrude(display_h) hull(){
    translate([corner_r, corner_r])circle(corner_r);
    translate([corner_r,ext_y-corner_r])circle(corner_r);
    translate([ext_x + ext_inset_x -1, 0])square([1, display_y]);
  }

  // Extra little bit of wall on side so back of this module is flush with
  // display_case
  difference(){
    union(){
      translate([0,0,display_h])linear_extrude(th)hull(){
        translate([ext_x-1,0])square([1, display_y]);
        translate([corner_r, corner_r])circle(corner_r);
        translate([corner_r, display_y-corner_r])circle(corner_r);
      }
    }
    union(){
      translate([ext_x-ext_stability_bar_x,0,-.1])linear_extrude(display_h+th+.2)hull(){
        translate([corner_r, corner_r])circle(corner_r);
        translate([corner_r, display_y-corner_r])circle(corner_r);
      }
      translate([ext_x-2,0])cube([3,display_y+.2,display_h+th]);
      translate([th+corner_r,th+corner_r,display_h-.1])linear_extrude(th+.2)minkowski(){
        square([ext_chip_space_x-2*corner_r,ext_chip_space_y-2*corner_r]);
        circle(corner_r);
      }
    }
  }
}

module _ext_sleeve() {
  difference() {
    _ext_top();

    // metal backing of display
    translate([ext_x,display_metal_back_inset_y,-.1])
      cube([1000, display_metal_back_y, display_glass_to_metal_back_h]);

    // slots for m3 screw
    translate([ext_x+ext_stability_bar_x-.1,display_m3_inset_y - display_m3_holder_y/2, -.1])
      cube([.2+20 + ext_stability_bar_x,display_m3_holder_y,display_h+80]);
    translate([ext_x+ext_stability_bar_x-.1,display_y - (display_m3_inset_y + display_m3_holder_y/2), -.1])
      cube([.2+20 + ext_stability_bar_x,display_m3_holder_y,display_h+80]);

    // screw hole for extension
    translate([ext_x -m3_r-th, display_y / 2, 1.5]) {
      cylinder(r=m3_tight_r, h=display_h+.2+100);
    }

    // space for the microchip
    translate([th,th,th])
      linear_extrude(display_h)difference(){
        square([ext_chip_space_x, ext_chip_space_y]);
        circle(corner_r);
        translate([0,display_y-th-th])circle(corner_r);
      }

    // screw hole for corner of sleeve
    translate([corner_r/2+m3_r,corner_r/2+m3_r,2])
      cylinder(r=m3_tight_r, h=display_h+th+.2);
    translate([corner_r/2+m3_r,display_y-(corner_r/2+m3_r),2])
      cylinder(r=m3_tight_r, h=display_h+th+.2);

    // screw holes grid
    _screw_step = (2*m3_r + 2*th);
    for (idx = [1:1:(ext_chip_space_x -2*th)/ _screw_step]) {
      for (idy = [0:1:(ext_chip_space_y-2*th) / _screw_step]) {
        if (idx *_screw_step < corner_r && idy *_screw_step < corner_r) {
        } else if (idx * _screw_step < corner_r &&
            idy * _screw_step >ext_chip_space_y - corner_r-_screw_step) {
        } else {
          translate([_screw_step/2+idx * _screw_step, _screw_step/2+ idy * _screw_step, 2])
            cylinder(r=m3_tight_r, h=display_h+.2);
        }
      }
    }

  }
}

module sleeve_extension() {  // make me
  _ext_sleeve();
}

module display_case_with_sleeve() {  // make me
  // cut out holes in the display for the extension
  difference(){
    union() {
      display_case();
      // extend the back side of display to fit over the extension stability bar
      translate([-ext_stability_bar_x, 0, display_h])hull(){
        translate([ext_stability_bar_x+corner_r, 0,0])cube([1, display_y, th]);
        translate([corner_r, corner_r, 0])cylinder(r=corner_r, h=th);
        translate([corner_r, display_y-corner_r,0])cylinder(r=corner_r, h=th);
      }
    }
    translate([-.1,-.1,-.1])cube([ext_inset_x+.1, display_y+.2, display_h+.09999]);

    // screw hole for extension
    translate([-m3_r-th,display_y/2,th-.1])cylinder(r=m3_r, h=display_h+.2);
  }
}

module spacer(r_o=m3_r+5, r_i=m3_r, h=large_enclosure_h) {  // make me
  color("green")difference() {
    cylinder(r=r_o, h=h);
    translate([0,0,-.1])cylinder(r=r_i, h=h+.2);
  }
}

module large_enclosure(extension=true) {  // make me
  // The huge bulky back.
  // There are plenty of attachment options on thingiverse.
  // This is just one more way...
  ext_opt_x = (extension ? ext_x : ext_stability_bar_x);
  difference(){
    linear_extrude(large_enclosure_h)minkowski(){
      translate([corner_r, corner_r])square([ext_opt_x +display_x-2*corner_r, display_y-2*corner_r]);
      circle(corner_r);
    }
    translate([0,0,-.1])linear_extrude(large_enclosure_h+.2)minkowski(){
      translate([corner_r+th, corner_r+th])square([ext_opt_x+display_x-2*corner_r-2*th, display_y-2*corner_r-2*th]);
      circle(corner_r);
    }
  }
}

module large_enclosure_back_cover(extension=true){  // make me
  ext_opt_x = (extension ? ext_x : ext_stability_bar_x);
  difference(){
    translate([corner_r,corner_r,0])linear_extrude(th)minkowski(){
      square([ext_opt_x+display_x-corner_r*2, display_y-corner_r*2]);
      circle(corner_r);
    }
    translate([ext_opt_x,0,0]){

      translate([display_m3_inset_x, display_m3_inset_y, -.1])
        cylinder(r=m3_r, h=th+.2);
      translate([display_x- display_m3_inset_x, display_m3_inset_y, -.1])
        cylinder(r=m3_r, h=th+.2);
      translate([display_m3_inset_x, display_y-display_m3_inset_y, -.1])
        cylinder(r=m3_r, h=th+.2);
      translate([display_x- display_m3_inset_x, display_y -display_m3_inset_y, -.1])
        cylinder(r=m3_r, h=th+.2);
    }
    _screw_step = (2*m5_r + 2*th);
    for (idx = [1:1:(ext_opt_x+display_x -2*th)/ _screw_step]) {
      for (idy = [0:1:(display_y-2*th) / _screw_step]) {
        translate([_screw_step/2+idx * _screw_step, _screw_step/2+ idy * _screw_step, -th])
          cylinder(r=m5_tight_r, h=display_h+.2);
      }
    }
  }
}

module sleeve_blank() {  // make me
  translate([-ext_stability_bar_x+corner_r,0,0])
    difference() {
      linear_extrude(display_h)
        difference(){hull(){
          square([ext_inset_x, display_y]);
          translate([0,corner_r])circle(corner_r);
          translate([0,display_y-corner_r])circle(corner_r);
        }
        translate([display_metal_back_inset_x, display_metal_back_inset_y])
          square([display_x, display_metal_back_y]);
        }
      translate([-ext_stability_bar_x+m3_tight_r+th, display_y / 2, 1.5])
        cylinder(r=m3_tight_r, h=display_h+10);
    }
}

module view() {
  color("orange", 1)sleeve_extension();

  translate([ext_x, 0, 0]) {
    color("yellow", .8)display_case_with_sleeve();
    %color("black", .4)
      translate([0,0,-display_glass_th])linear_extrude(display_glass_th)
      display();
    translate([display_m3_inset_x, display_m3_inset_y, display_h+th])
      spacer();
    translate([display_x- display_m3_inset_x, display_m3_inset_y, display_h+th])
      spacer();
    translate([display_m3_inset_x, display_y-display_m3_inset_y, display_h+th])
      spacer();
    translate([display_x- display_m3_inset_x, display_y -display_m3_inset_y, display_h+th])
      spacer();
  }
  translate([0,0,display_h+th]) {
    color("white", .6)large_enclosure();
    translate([0,0,large_enclosure_h]) color("black", .4)large_enclosure_back_cover();
  }
}

module view2() {
  translate([corner_r,0]){
    display_case_with_sleeve();
    color("blue", .6)sleeve_blank();
  }
  translate([0,0,display_h+th]) {
    color("white", .6)large_enclosure(false);
    translate([0,0,large_enclosure_h]) color("black", .4)large_enclosure_back_cover(false);
  }
}

view();

translate([0,display_y + 50,0])
  view2();

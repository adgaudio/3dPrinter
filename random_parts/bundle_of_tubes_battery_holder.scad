/*
This script creates a bundle of up to 6 tubes, with endcaps

Each tube is meant to be filled with batteries, and
I use it as a battery pack for my bike light!

The script is parametric, so you can really just use it if you
want a bundle of up to 6 pvc pipes wrapped together and sharing borders
*/

// How many tubes would you like to bundle together?
// You must specify a number 1 <= X <= 6
n_tubes = 1;

// Do you want a hole in the center of the endcap?  Define its radius:
r_endcap_hole = 0;

// How many batteries long is this tube?
n_cells_long = 1;
// battery dimensions (these are for an AA battery)
l_cell = 50.5;
d_cell = 14.5 + .5;  // .5 for extra clearance

// Do you wish to add any extra length to the tube?
// FYI: You could set l_cell=0 and use this to explicitly define tube length
h_tube_extra_length = 10;
// l_cell = 0;

// How thick do you want your separating walls to be?
th = 1.5;  // wall thickness

/////////////////////
// Internal settings
/////////////////////
h_tube = n_cells_long*l_cell +h_tube_extra_length;
ri_tube = d_cell/2;
ro_tube = ri_tube+th;
h_endcap = 10+th;
ri_endcap = ro_tube+.2;
ro_endcap = ri_endcap+th;
// Figure out the appropriate radius to translate each tube
// This is known as a disc packing problem.
_h = ro_tube - th/2;
_h_arr = [0, _h, 2*_h/sqrt(3), 2*_h/sqrt(2), _h/.609382, _h*2];
deg = 360/n_tubes;
r_translation = _h_arr[n_tubes-1];


module _tube(ro, ri, h) {
  difference() {
    cylinder(r=ro, h=h);
    translate([0, 0, -.05])
      cylinder(r=ri, h=h+.1);
  }
}
module tube(ro=ro_tube, ri=ri_tube, h=h_tube) {  // make me
  for (i = [0:n_tubes-1]) {
      rotate([0,0,360/n_tubes * i], [0,0,0]) {
    translate([r_translation, 0, 0]) {
      _tube(ro, ri, h);
      }
    }
  }
  if (n_tubes == 6) {
    _tube(ro, ri, h);
  }
}


module endcap(ro=ro_endcap, ri=ri_endcap, h=h_endcap) {  // make me
  difference() {
    union() {
      tube(ro, ri, h);
      // base of endcap
      tube(ro, 0, th);
      cylinder(r=ro_tube, h=th);
    }
    translate([0,0,th])hull(){tube(ri/2 + th/2, 0, h);}
    translate([0,0,-.01])cylinder(r=r_endcap_hole, h=th+.1);
  }
}


/* // TEST */
/* translate([0, 0, -010]) */
/* tube(); */
/* rotate([180, 0, 0]) */
/* endcap(); */

/* // VIEW or print */
/* translate([0,ro_tube+th+ ro_tube*n_tubes, 0]) */
/* tube(); */
/* endcap(); */

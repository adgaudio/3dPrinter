/*
   This script creates a bundle of up to 6 tubes, with endcaps

   Each tube is meant to be filled with batteries, and
   I use it as a battery pack for my bike light!

   The script is parametric, so you can really just use it if you
   want a bundle of up to 6 pvc pipes wrapped together and sharing borders
 */

// How many tubes would you like to bundle together?
// You must specify a number 1 <= X <= 6
n_tubes = 2;

// Do you want a hole in the center of the endcap?  Define its radius:
r_endcap_hole = 1;

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
th = 1;  // wall thickness

$fn=25;
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
_h_arr = [0, _h, 2*_h/sqrt(3), 2*_h/sqrt(2), _h/.59, _h*2];
deg = 360/n_tubes;
r_translation = _h_arr[n_tubes-1];


module tube(ro=ro_tube, ri=ri_tube, h=h_tube) {  // make me
  difference() {
    union() {
      for (i = [0:n_tubes-1]) {
        rotate([0,0,360/n_tubes * i], [0,0,0]) {
          translate([r_translation, 0, 0]) {
            cylinder(r=ro, h=h);
          }
        }
      }
    }
    for (i = [0:n_tubes-1]) {
      rotate([0,0,360/n_tubes * i], [0,0,0]) {
        translate([r_translation, 0, -.05]) {
          cylinder(r=ri, h=h+.1);
        }
      }
    }
  }
  if (n_tubes == 6) {
    _tube(ro-th, ri-th, h);
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
    translate([0,0,th+.00001])hull(){tube(ri/2 + th/2, 0, h);}
    translate([0,0,-.01])cylinder(r=r_endcap_hole, h=th+.1);
  }
}


hi_chip = 2*th+1;  // TODO
r_chip = r_translation;
module endcap_with_microchip_compartment() { // make me
  translate([0, 0, -th]){
    difference(){
      union(){
        hull() {
          tube(ro=ro_endcap, ri=ri_endcap, h=th);
          translate([0, 0, -hi_chip/2])cylinder(r=r_chip, h=hi_chip, center=true);
        }
        endcap();
      }
      hull() {
        tube(ro=ro_endcap-th, ri=ri_endcap-th, h=th);
        translate([0, 0, -hi_chip/2])cylinder(r=r_chip-th, h=hi_chip-th, center=true);
      }
      // prettier visual rendering
      translate([0, 0, .1])hull(){tube(ro=ro_tube, ri=ri_tube, h=th);}
      /* rotate([180, 0, 0])cylinder(r=r_chip, h=hi_chip+.1); */
      translate([0, 0, -hi_chip-.05])cylinder(r=r_endcap_hole, h=th+.1);
    }
    translate([0, 0, .1]) // translate fixes bug introduced by rendering above
      difference(){
        hull(){tube(ro=ro_endcap, ri=ri_endcap, h=th);}
        translate([0,0,-.1])hull(){tube(ri_endcap/2 + th/2, 0, h=th+2);}
        translate([0,0,-.1])tube(ri_endcap-th, 0, h=th+2);
      }
  }
}


module endcap_insert() {
  intersection() {
    union(){
      tube(ro=ri_endcap-th/2, ri=ri_endcap-2.5*th, h=th);
      rotate([0, 0, 360/n_tubes/2])
        tube(ro=ro_endcap, ri=ri_endcap-th, h=th);
    }
    translate([0, 0, -th-hi_chip])
      hull(){tube(ro=ri_endcap-th/2, ri=ri_endcap-th/2-th, h=hi_chip+2*th+.1);}
  }
}

/* // TEST                          */
/* translate([0, 0, -010 - 20])rotate([180, 0, 0])              */
/*   tube();                                                    */
/*   translate([0, 0, -1*(10+hi_chip+2*th)]) endcap_insert();   */
/* rotate([180, 0, 0])                                          */
/*   endcap();                                                  */
/*   translate([0, 0, -10 - 20 -20 - 10 -n_cells_long*h_tube]){ */
/*     endcap_with_microchip_compartment();                     */
/*     translate([0, 0, 10+hi_chip+2*th]) endcap_insert();      */
/*   }                                                          */

/* // VIEW or print */
/* translate([0,ro_tube+th+ ro_tube*n_tubes, 0]) { */
/* tube();                                         */
/* translate([0, ro_tube*n_tubes +ro_tube])        */
/* endcap_with_microchip_compartment();            */
/* }                                               */
/* endcap();                                       */
/* translate([0, -3*ro_tube, 0]) endcap_insert();  */
/* translate([0, -6*ro_tube, 0]) endcap_insert();  */

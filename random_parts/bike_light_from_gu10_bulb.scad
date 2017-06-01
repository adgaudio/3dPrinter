
/*
   Bought the following items:
   SUNTHIN 5w GU10 Led Bulbs, 50w Equivalent, Recessed Lighting, GU10 LED, LED spotlight, 360lm, 45°
   --> broke into two parts, and only using the metal part
   Power converter step up boost module XL6009 DC-DC
   --> Dimensions: 43mm x 21mm x 14mm (L x W x H)

   button component:  E-Switch TL3315NF250Q
 */


th=1;

ri_gu10 = 27 / 2;
ro_gu10 = 32/2;
h_gu10_lip = 4.2;

r_bike_handlebar = 30/2; // TODO
w_bike_handlebar = 10; // TODO


l_boost = 44;
w_boost = 22;
h_boost = 15;

l_cc = 30;
h_cc = 31;
w_cc = 20;

r_wire_power_line = 5.5/2;
h_compartment1 = l_boost + 2;  // inside space
x_compartment1 = h_boost + 2;  // inside space
y_compartment1 = w_boost + 2;  // inside space
h_compartment2 = l_cc + 2;  // inside space
x_compartment2 = h_cc + 2+1;  // inside space  +1 for button
y_compartment2 = w_cc + 2;  // inside space
h_lamp1_cap = 10;
h_inside_lamp1_cap = h_lamp1_cap - 3;
y_button_base = 15;
z_button_base = 20;  //h_compartment2-h_inside_lamp1_cap-2*th;
r_button_clicker = 2.5/2;  // the point that touches the button
xyz_button = [th,5,5];  // electrical component
r_wire_cutout_22g = 2.2/2;


_y=max(y_compartment2+2*th,y_compartment1);
xyzshell = [x_compartment1+2*th, _y, .01]; // outside space
xyzshell2 = [x_compartment2+2*th,_y,h_compartment2+2*th]; // outside space

handlebar_origin = [-r_bike_handlebar-ri_gu10,0,-50+r_bike_handlebar*2];

module lamphead(){
  color("Fuchsia"){
    difference(){
      cylinder(r1=ro_gu10, r2=50/2, h=21.5);
      translate([0,0,-1])cylinder(r=ri_gu10+0.2, h=h_gu10_lip+1);
      translate([0,0,7.5])cylinder(r=35/2,h=14+1);
    }
  }
  color("Blue"){  // for debugging
    translate([0,0,7.5/2+2])
      cylinder(r=ri_gu10,h=7.5-h_gu10_lip,center=true);
  }
}
module handlebar(){
  color("Fuchsia"){
    translate(handlebar_origin ) rotate([90,0,0])
      cylinder(r=r_bike_handlebar, h=100, center=true);
  }
}


module donut(ro, ri, h){
  difference(){
    cylinder(r=ro,h=h,center=true);
    cylinder(r=ri,h=h+1,center=true);
  }}

module round_cube(xyz) {
  minkowski(){
    cube(xyz - [10,10,0],center=true);
    cylinder(r=5,h=.01,center=true);
  }
}

module _lamp_shell(){
  difference(){
    // main compartment for the boost converter
    hull(){
      translate([0,0,-1])cylinder(r=ro_gu10, h=1,$fn=100);  // +1 for extra lip
      translate([0,0,-h_compartment1+.5-th])
        round_cube(xyzshell,center=true,$fn=80);
    }
    hull(){
      translate([0,0,-1-th])cylinder(r=ro_gu10-th, h=1);  // +1 for extra lip
      translate([0,0,-h_compartment1+.5-th])
        round_cube(xyzshell - [2*th,2*th,0],center=true);
    }
    // cut out spaces at ends
    translate([0,0,h_gu10_lip/2-1])
      cylinder(r=ri_gu10-th, h=h_gu10_lip+1,center=true);
    translate([0,0,-h_compartment1-th])
      round_cube([x_compartment1,_y,3*th],center=true);
    // cut out hole for wires (battery / power supply)
    translate([0,0,-h_compartment1+th+r_wire_power_line])rotate([0, 90, -45])
      translate([0,0,(x_compartment1+y_compartment1)/-2])
      cylinder(r=r_wire_power_line, h=x_compartment1+y_compartment1, center=true, $fn=30);
  }
  // secondary compartment for the constant current driver
  translate([(x_compartment1-x_compartment2)/2,0,-h_compartment1 -h_compartment2/2]){
    difference(){
      round_cube(xyzshell2,$fn=80);
      round_cube(xyzshell2 -[2*th,2*th,2*th],center=true);
      translate([0,0,-h_compartment2/2])
        round_cube(xyzshell2 -[2*th,2*th,0]);
      translate([(x_compartment1-x_compartment2)/-2-th/2,0,h_compartment2/2])
        round_cube(xyzshell -[2*th,2*th,-3*th]);
      translate([(x_compartment2+th)/-2,0,h_inside_lamp1_cap+3+(z_button_base-xyzshell2[2])/2]){
    /* cube([th+.1,y_button_base,z_button_base], center=true); */
    translate([2*th-.01,0,0]) button1_base();
    translate([2*th+.01,0,0]) button1_base();
  }

    }
  }
}

module lamp1(){ // make me
  // this lamp has a step up converter and default led that comes with the
  // gu10 bulb
  w_strap = 10;

  translate([0,0,h_gu10_lip/2-th/2])
    donut(ri_gu10,ri_gu10-th,h_gu10_lip+th,$fn=90);
  _lamp_shell();
}


module lamp1_cap(){ // make me
  difference(){
    minkowski(){
      round_cube(xyzshell2 + [2*th-3,2*th-3,-xyzshell2[2]+h_inside_lamp1_cap]);
      sphere(r=3,$fn=20);
    }
    translate([0,0,xyzshell2[2]/2 +th -h_lamp1_cap/2])
      round_cube(xyzshell2+[.8,.8,.8], $fn=80);
  }
}

module button1_base() {
  union(){
    translate([-1.5*th,0,0])
    cube([2*th,y_button_base,z_button_base], center=true);
    cube([th,y_compartment2-2*th,h_compartment2-h_inside_lamp1_cap-2*th], center=true);
  }
}

module button1() { // make me
rotate([0,90,0]){
  difference(){
    translate([2*th,0,0])button1_base();
    // wire cutouts (~22 gauge)
    for(z=[-1,1]) {
      translate([2*th/2,0,z*(xyz_button[2]/2+r_wire_cutout_22g+th)])
      rotate([0,90,0])for(i=[-1,1]){
        translate([0,i*xyz_button[1] / 2,0],$fn=10)
        cylinder(r=r_wire_cutout_22g, h=xyz_button[0] + 2*th+.1, center=true);
      }
    }
    cube([th+.01,y_button_base-th,z_button_base-th],center=true);
  }
  // button holder
  intersection(){
    difference(){
      cube(xyz_button+[0,2*th,2*th], center=true);
      cube(xyz_button+[.02,0,0], center=true);
    }
    union(){
      cube(xyz_button+[.1,2*th,-2*th],center=true);
      cube(xyz_button+[.1,-2*th,2*th],center=true);
    }
  }
}}

xyz_button1_frame = [2,y_button_base-th-1,z_button_base-th-1];
module button1_frame(xyz=xyz_button1_frame) { // make me
rotate([0,90,0])
  // a little piece to help fix the cover
  difference(){
  cube(xyz_button1_frame,center=true);
  cube(xyz_button1_frame - [-.1,2,2],center=true);
  }
}

xyz_button1_cover = xyz_button1_frame - [0,2,2];
/* xyz_button1_cover = xyz_button1_frame; */
module button1_cover() { // make me
// debug: axis
/* color("red")cube([.1,20,.1], center=true); */
/* color("green")cube([.1,.1,20], center=true); */

/* translate([0,0,xyz_button1_cover[0]/2]) */
/* button1_frame(xyz_button1_cover); */
rotate([0,-90,0]) {
  // tip that touches the button
  translate([xyz_button1_frame[0]/2-th/2,0,0])rotate([0,90,0])
    cylinder(r=r_button_clicker,h=xyz_button1_frame[0],center=true,$fn=10);

  /* cube(xyz_button1_cover,center=true); */
  difference(){
    intersection(){
      scale([2,xyz_button1_cover[1]/th/2,1])
        cylinder(r=th,h=xyz_button1_cover[2],center=true,$fn=20);
      scale([2,1,xyz_button1_cover[2]/th/2])
        rotate([90,0,0])cylinder(r=th,h=xyz_button1_cover[1],center=true,$fn=20);
    }
    translate([xyz_button1_cover[0]/2,0,0])
      cube(xyz_button1_cover - [0,2*th,2*th],center=true);
  }
}}


// View
/* translate([0,0,.1]){ */
  /* lamphead(); */
/* } */
/* translate([0,0,0])handlebar(); */
/* lamp1(); */

/* translate([ro_gu10+ro_gu10+15,0,0]) */
  /* lamp1_cap(); */

/* translate([-30, 30, -(xyzshell2[2]+h_compartment1/2)]){ */
/* rotate([0,-90,0]) */
/* button1(); */
/* translate([-10,0,0]) { */
  /* rotate([0,-90,0]) button1_frame(); */

  /* translate([-10, 0, 0]) rotate([0,90,0]) button1_cover(); */
/* } */
/* } */

// test gu10
/* difference() {                   */
/* lamp1();                         */
/* translate([0,0,-50-1])           */
/* cube([100,100,100],center=true); */
/* }                                */
// test cap
/* lamp1_cap(); */


/*
   Bought the following items:
   SUNTHIN 5w GU10 Led Bulbs, 50w Equivalent, Recessed Lighting, GU10 LED, LED spotlight, 360lm, 45°
   --> broke into two parts, and only using the metal part
   Power converter step up boost module XL6009 DC-DC
   --> Dimensions: 43mm x 21mm x 14mm (L x W x H)
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

h_compartment1 = l_boost + 2;  // inside space
x_compartment1 = h_boost + 2;  // inside space
y_compartment1 = w_boost + 2;  // inside space
h_compartment2 = l_cc + 2;  // inside space
x_compartment2 = h_cc + 2;  // inside space
y_compartment2 = w_cc + 2;  // inside space

_y=max(y_compartment2+2*th,y_compartment1);
xyzshell = [x_compartment1+2*th, _y, .01];
xyzshell2 = [x_compartment2+2*th,_y,h_compartment2+2*th];

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
  }
  // secondary compartment for the constant current driver
  translate([(x_compartment1-x_compartment2)/2,0,-h_compartment1 -h_compartment2/2])
    difference(){
      round_cube(xyzshell2,$fn=80);
      round_cube(xyzshell2 -[2*th,2*th,2*th],center=true);
      translate([0,0,-h_compartment2/2])
        round_cube(xyzshell2 -[2*th,2*th,0]);
      translate([(x_compartment1-x_compartment2)/-2-th/2,0,h_compartment2/2])
        round_cube(xyzshell -[2*th,2*th,-3*th]);
    }
}
module lamp1(){ // make me
  // this lamp has a step up converter and default led that comes with the
  // gu10 bulb
  w_strap = 10;

  translate([0,0,h_gu10_lip/2-th/2]) donut(ri_gu10,ri_gu10-th,h_gu10_lip+th);
  _lamp_shell();
}


h_lamp1_cap = 10;
module lamp1_cap(){ // make me
rotate([180,0,0])
  difference(){
    minkowski(){
      round_cube(xyzshell2 + [2*th-3,2*th-3,-xyzshell2[2]+h_lamp1_cap-3]);
      sphere(r=3,$fn=20);
    }
    translate([0,0,xyzshell2[2]/2 +th -h_lamp1_cap/2])
      round_cube(xyzshell2);
  }
}

translate([0,0,.1]){
  lamphead();
}
translate([0,0,0])handlebar();
lamp1();

/* translate([ro_gu10+ro_gu10+15,0,0]) */
/*   lamp1_cap();                      */


  // TODO
  module plastic_mount(){  // make me
    // If going the route of building a plastic mount for this light:
    /* translate([-ri_gu10-r_bike_handlebar,0,-r_bike_handlebar]) */
    /* rotate([90,0,0])                                          */
    /*   donut(r_bike_handlebar+th,r_bike_handlebar,w_strap);    */
  }

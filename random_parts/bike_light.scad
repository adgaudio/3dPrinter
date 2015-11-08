// Configurable Settings
th = 1;

h_terminal_neg = 5;
h_terminal_pos = 1.5;
// FYI:
// h_AA_battery = 50.5;
// r_AA_battery = 14.5/2;
// r_18650_battery = 18/2;
// h_18650_battery = 65;
h_battery = 65;
r_battery = 18.1/2;
/* h_battery = 50.5; */
/* r_battery = 14.5/2; */
w_wire_canister = 2;
_h_cap_canister = 20;
h_cap_plug = 10;

r_led_star = 17/2;
r_led_lens = 23/2;
h_led_lens_support_wall = 3;
_h_led_star = 7;

l_rocker_switch = 20+1;  // +1 for waterproofing silicone sheet .5mm thick
w_rocker_switch = 13+1;
h_rocker_switch = 12.25;

w_velcro_bar = 8;  // limited based on battery diameter
gap_velcro = 3;
// Derived settings
ri_canister = r_battery + .3;
ro_canister = ri_canister + th;
h_canister = h_battery + h_terminal_neg + h_terminal_pos;
h_canister_extension = w_wire_canister+th+h_cap_plug;

final_height = h_canister_extension*2-th*2+h_canister;

ro_cap_canister = ro_canister+th+.5;  // .5 is for silicone sheet or glue
ri_cap_canister = ro_canister+.2;
h_cap_canister = min(h_canister/2, _h_cap_canister);

xyz_between_leds = [
0,-(ro_canister+w_wire_canister),final_height/2];
z_between_leds = max(th, h_canister-4*r_led_lens-2*th);

h_led_star = _h_led_star+ w_wire_canister+th;
z_led_cutout = (h_canister_extension-th)+max(
    _h_led_star+h_led_lens_support_wall, abs(xyz_between_leds[1]));


module _canister_shell(err=0) {
  hull($fn=150) {
    for (sn=[-1,1])
      translate([sn*ri_canister, 0, 0])
        cylinder(r=ro_canister+err, h=h_canister);
  }
}


module canister() { // make me
  difference(){
    // build outer shell
    _canister_shell();
    // cut out space for batteries
    for (sn=[-1,1])
      translate([sn*ri_canister, 0, -.05])
        cylinder(r=ri_canister, h=h_canister+.1, $fn=100);
    // cut out middle section
    translate([-r_battery/2, -r_battery/2, -.05])
      cube([r_battery, r_battery, h_canister+.1]);
    // cutout space for wires
    for (sn2=[0,1]) for (sn=[0, 1]) {
      translate([0, 0, sn2*(h_canister)])

        rotate([0, sn2*180, 0])
        rotate([0, sn*180, 0])
        translate([
            ri_canister/2,
            ri_canister,
            -(2*sn-1)*.5*(w_wire_canister-.1)])
        rotate([0, 90, 90+atan((ri_canister*.5-w_wire_canister) / ro_canister)])
        cube([
            .1+w_wire_canister,
            w_wire_canister,
            sqrt(pow(ro_canister,2) + pow(ri_canister,2))
            ], center=true);
      translate([-ri_canister/2,
          ro_canister-w_wire_canister*2+.1,
          sn*(h_canister-w_wire_canister)+(2*sn -1)*.1])
        cube([ri_canister, 2*w_wire_canister, w_wire_canister+.1]);
    }
  }
}


module canister_cap(h=h_cap_canister) { // make me
  difference(){
    hull() {
      translate([+ri_cap_canister, 0, 0])
        cylinder(r=ro_cap_canister, h=h);
      translate([-ri_cap_canister, 0, 0])
        cylinder(r=ro_cap_canister, h=h);
    }
    hull($fn=150) {
      translate([+ri_canister, 0, th])
        cylinder(r=ri_cap_canister, h=h);
      translate([-ri_canister, 0, th])
        cylinder(r=ri_cap_canister, h=h);
    }
  }

}


module _cap(smaller_by, r, h=h_cap_plug) {
  hull($fn=150) {
    translate([+ri_canister, 0, 0])
      cylinder(r2=r, r1=r-smaller_by, h=h);
    translate([-ri_canister, 0, 0])
      cylinder(r2=r, r1=r-smaller_by, h=h);
  }
}
module cap_plug(smaller_by=.5) {  // make me
  _cap(smaller_by, r=ri_cap_canister);
  // little hands-friendly handle
  translate([0, 0, h_cap_plug])
    minkowski() {
      scale([2.5, 1, 1])cylinder(r2=ri_cap_canister-2, r1=ri_cap_canister/2, h=10);
      rotate([90, 0, 0])cylinder(r=2,h=1, $fn=30);
    }
}


module cap_rocker_switch(){  // make me
  h=h_rocker_switch+h_cap_plug;
  final_cannister_shell_x = 4*ro_canister;
  final_cannister_shell_y = 2*ro_canister+ro_canister/2+th;
  xyz_scale_factor = [  // scale_factor = outer / inner
    (final_cannister_shell_x+2*th)/final_cannister_shell_x,
    (final_cannister_shell_y+2*th)/final_cannister_shell_y,
    1];
  // test cubes
  /* xyz_inner = [final_cannister_shell_x, final_cannister_shell_y,h];               */
  /* %translate([0,ro_canister/4-th/2,15])                                           */
  /*   cube([4*ro_canister, 2*ro_canister+ro_canister/2+th, h], center=true);        */
  /* %translate([0,ro_canister/4-th/2,8])                                            */
  /*   cube([xyz_inner[0]+2*th, xyz_inner[1]+2*th, xyz_inner[2]+2*th], center=true); */


  translate([0,0,13])
    difference(){
      hull()
        intersection(){
          cube([100,100,h], center=true);
          translate([0,0,0])
            scale(xyz_scale_factor)canister_shell(version=1);
        }
      translate([0,0,max(0,h_rocker_switch-h_cap_plug)]){
        canister_shell(version=1);
        _canister_shell(.1);
      }
      // cut out space for rocker switch
      translate([0,0,h/2])
        cube([l_rocker_switch, w_rocker_switch, h+1], center=true);//h_cap_plug+1], center=true);
    }
}


module battery_terminal_insert() {  // make me
  rotate([180,0,0]){
    difference(){
      hull(){
        translate([-ri_canister,0,0])cylinder(r=ri_canister,h=.5);
        translate([ri_canister,0,0])cylinder(r=ri_canister,h=.5);
      }
      for(sn=[0,1])
        translate([(2*sn-1)*(2*ri_canister)-sn*3,-3/2,-.25])
          cube([3,3,1]);
      translate([-3,ri_canister-ri_canister/2,-.25])
        cube([ri_canister+3,ri_canister/2+.1,1]);
    }
    translate([0,-ri_canister/4,0])cube([1, ri_canister*1.5, 1], center=true);
  }}


module _extension(holes=true) {
  difference(){
    hull($fn=150) {
      translate([+ri_canister, 0, 0])
        cylinder(r=ro_canister+th, h=h_canister_extension);
      translate([-ri_canister, 0, 0])
        cylinder(r=ro_canister+th, h=h_canister_extension);
    }
    hull($fn=150) {
      translate([+ri_canister, 0, -.1])
        cylinder(r=ro_canister, h=h_canister_extension+.2);
      translate([-ri_canister, 0, -.1])
        cylinder(r=ro_canister, h=h_canister_extension+.2);
    }

    if(holes) {
      // wire holes through to the outside for pcb (need to waterproof)
      _extension_wire_holes_cutout();

    }
  }
}


module _extension_wire_holes_cutout() {
  for(sn=[-1,1])
    translate([sn*ri_canister/2-sn*w_wire_canister/2,
        -ro_canister-w_wire_canister/2, h_canister_extension-th+w_wire_canister/2]) {
      // vertical
      cylinder(r=w_wire_canister/2, h=w_wire_canister+r_led_lens, $fn=25);
      // horizontal
      translate([0, w_wire_canister/2+.1, 0]) rotate([90, 0, 0])
        cylinder(r=w_wire_canister/2, h=w_wire_canister+.1, $fn=25);
      // angled (for easier insertion and to remove the L shape)
      translate([0, w_wire_canister/2+.1, 0]) rotate([90-45, 0, 0])
        cylinder(r=w_wire_canister/2, h=w_wire_canister, $fn=25);
      /* } */
}
}


module _led_cutout() {
  /* z = h_cap_plug+w_wire_canister; */
  rotate([90,0,0]) {
    // outer lens
    translate([0,0,h_led_star])
      cylinder(r=r_led_lens, h=h_led_lens_support_wall+.5, $fn=100);
    // led star
    cylinder(r=r_led_star, h=h_led_star+.5, $fn=100);
  }
}


module _velcro_handle(h_velcro=ro_canister*2, curved_bottom=true) {
  translate([0,-th-gap_velcro/2,0])
    rotate([-90,0,0])
    difference(){
      hull(){
        cube([h_velcro,w_velcro_bar,th], center=true);
        for(sn=[-1,1]) for(sn2=[-1,1]){
          translate([sn*h_velcro/2 - sn*th,0,0])
            scale([1,.5,1])
            translate([0,0,gap_velcro])
            cylinder(r1=w_velcro_bar, r2=ro_canister, h=ro_cap_canister+gap_velcro/2-gap_velcro);
        }
      }
      if(curved_bottom){
        translate([0,h_canister/2,ri_canister+gap_velcro/2+2*th])
          rotate([90,0,0])_canister_shell();
      } else {
        translate([(h_velcro+2*ro_canister)*-1/2,-ro_canister/2,gap_velcro-th/2])
          cube([h_velcro+2*ro_canister,ro_canister,ro_canister+th+.1]);
      }
      translate([0,0,(ro_cap_canister+th-.1)/2+th])
        cube([h_velcro,ro_canister+.1, ro_cap_canister+th+.2], center=true);
    }
}


module canister_shell(version=1) {  // make me

  translate([0, 0, h_canister_extension-th])
    canister();
  // extend the top of canister with a "shell" that the plug can fit in
  translate([0, 0, h_canister+2*h_canister_extension-2*th])rotate([180, 0, 0])
    _extension(holes=false);
  // extend the bottom of the canister but don't add holes
  rotate([180, 180, 0]) _extension(holes=true);
  if (version == 1){
    /* translate([0,th,0]) */
    _v1();
  }
  translate([0,-ro_canister,h_canister_extension+ro_canister/2+gap_velcro])
    _velcro_handle();
  translate([0,-ro_canister,h_canister+h_canister_extension-2*th-ro_canister/2-gap_velcro])
    _velcro_handle();
  // vertical bar down middle
  translate([0,-ro_canister,h_canister/2+h_canister_extension-th])
    rotate([0,90,0])_velcro_handle(curved_bottom=false);
}


module _v1_curved_outer_shell() {
  union(){
    translate(xyz_between_leds)
      hull(){
        cube([th*2+w_wire_canister*2, th*2+w_wire_canister*2, z_between_leds],
            center=true);
        translate([0, w_wire_canister+th/2, 0])
          cube([ro_canister*3, th, z_between_leds], center=true);
      }
    translate([0, ro_canister/-2, final_height/2])
      scale([2, 1, 1])cylinder(r=ro_canister, h=final_height, center=true, $fn=100);
  }
}


module _v1() {
  // add curved space where I'll attach led strip
  rotate([0, 0, 180]) {
    difference(){
      union(){
        _v1_curved_outer_shell();
        // also add extra support for the led's glass lens
        for (sn=[0,1])
          translate([0, -ro_canister, sn*final_height - (2*sn-1)*z_led_cutout])
            rotate([90,0,0])
            cylinder(
                r2=r_led_lens+th,
                r1=ro_canister*1.5,
                h=h_led_star+h_led_lens_support_wall,
                $fn=100);
      }
      translate([0, 0, h_canister-1])hull(){canister();}
      translate([0, 0, 0])hull(){canister();}
      translate([0, 0, -h_canister+1])hull(){canister();}

      // cutout the top led hole (and give wire holes leading to it)
      _extension_wire_holes_cutout();

      // cutout spaces for the led star and led lens
      for (sn=[0,1])
        translate([0, -ro_canister, sn*final_height - (2*sn-1)*z_led_cutout])
          _led_cutout();

      // a space between the 2 led holes where wires can travel
      translate(xyz_between_leds)
        cube([w_wire_canister*2, w_wire_canister*2, z_between_leds],
            center=true);
    }
  }
}

// TODO: v2 using boost converter and 12v led tape
// mounts for circuit board
/* module _v2() { */
/* x=20; */
/* y=10; */
/* z=40; */
// mimic the circuit board
// TODO: dimensions!
/* translate([x/2, ro_canister, h_canister-w_wire_canister-th]) { */
/* rotate([0, 180, 0])%cube([x, y,z]); */
// put circuit board encasing
/* } */
/* } */


// Visualize the modules below

// Simplest version
/* translate([100, 0, 0]) { */
/* translate([0, ro_canister*2 + 10, 0]) { */
/* canister_cap(); */
/* translate([0, ro_cap_canister*2+10, 0]) */
/* canister(); */
/* } */
/* } */

// Complex version
/* translate([0, -ro_cap_canister*2-10, 0])     */
/* translate([0,0,-19.4])                       */
/* cap_rocker_switch();                         */

/* canister_shell(version=1);                   */

/* translate([0,ro_cap_canister*3,0])           */
/* battery_terminal_insert();                   */

/* translate([0, ro_cap_canister*6, 0])         */
/*   cap_plug();                                */

/* cube([100,100,10]);                          */

//test
/* difference(){ */
/* rotate([90,0,0]) */
/* canister_shell(version=1);                   */
/* cube([100,100,ro_canister*2+11], center=true); */
/* #translate([-40,-ro_canister*4-100,-50])cube([100,100,100]); */
/* } */

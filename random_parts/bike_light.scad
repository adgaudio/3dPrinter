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
r_battery = 18.5/2;
/* h_battery = 50.5; */
/* r_battery = 14.5/2; */
w_wire_canister = 2;
_h_cap_canister = 20;
h_cap_plug = 10;

r_led_star = 18.5/2;
r_led_lens = 21/2;
h_led_lens_support_wall = 3;
_h_led_star = 8;

l_rocker_switch = 19;
w_rocker_switch = 13;
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
0,-(ro_canister+h_led_lens_support_wall),final_height/2];
z_between_leds = (h_canister/2-r_led_lens*2)*2;

h_led_star = _h_led_star+ w_wire_canister+th/2;
z_led_cutout = final_height/2+z_between_leds/2+r_led_star-th;

// Settings for the light mount
r_handlebar = 30/2;
th_arm = 5;
th_handlebar = 3;
w_handlebar = 5;
gap_handlebar = 5;

// how long to extend the mount past the ring that wraps around handlebar?
l_arm = 20;  // TODO
l_mount_plate = final_height;

r_m3 = 3/2;
h_m3 = 4;
r_m3_bolt_head = 5.5/2;
w_m3_nut = 6.1;  // max possible diameter of nut
ro_bolt = max(r_m3_bolt_head+th, w_m3_nut/2+th);

ro = r_handlebar + th_handlebar;
h_mount_plate = 3*ro_canister;
th_mount_plate = 3+ro_canister/3;


module _canister_shell(err=0, h=h_canister) {
  hull($fn=150) {
    for (sn=[-1,1])
      translate([sn*ri_canister, 0, 0])
        cylinder(r=ro_canister+err, h=h);
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
    (final_cannister_shell_x+1+2*th)/final_cannister_shell_x,
    (final_cannister_shell_y+1+2*th)/final_cannister_shell_y,
    1];
  xyz_cutout_scale_factor = [  // scale_factor = outer / inner
    (final_cannister_shell_x+1)/final_cannister_shell_x,
    (final_cannister_shell_y+1)/final_cannister_shell_y,
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
      translate([0,0,max(0,h_rocker_switch-h_cap_plug)])
        scale(xyz_cutout_scale_factor) {
          canister_shell(version=1);
          _canister_shell(.3);
        }
      // cut out space for rocker switch
      translate([0,0,h/2])
        cube([l_rocker_switch, w_rocker_switch, h+1], center=true);//h_cap_plug+1], center=true);
    }
}


module battery_terminal_insert() {  // make me
  rotate([180,0,0]){
    difference(){
      _canister_shell(err=-th/2, h=0.5);
      for(sn=[0,1]) {
        translate([(2*sn-1)*(2*ro_canister)-sn*3,-3/2,-.25])
          cube([3,3.5,1]);
        translate([(2*sn-1)*1.5*w_wire_canister,ro_canister-w_wire_canister/2,0])
          cube([w_wire_canister*2,w_wire_canister,2], center=true);
      }
    }
    translate([0,-ro_canister/4,0])cube([1, ro_canister*1.5, 1], center=true);
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

  _v1_velcro_handles();
}

module _v1_velcro_handles() {
  _v1_velcro_handles();
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

module _donut(ro, ri, h) {
  difference(){
    cylinder(r=ro, h=h, center=true);
    cylinder(r=ri, h=1+h, center=true);
  }
}

module _mount_handlebar_attachment() {
  // main ring that attaches to handlebar
  translate([0,ro,0]){
    translate([0, 0,0]) rotate([0,90,0])
      difference() {
        hull()minkowski(){
          _donut(ro=ro-1.5, ri=r_handlebar-2, h=w_handlebar-4);
          rotate([90,0,0])cylinder(r=2,h=2,center=true,$fn=20);
        }
        cylinder(r=r_handlebar,h=w_handlebar+1,center=true,$fn=150);
        rotate([0,-90,0])translate([0,0,-(ro-th_handlebar/2)])
          cube([1+w_handlebar, gap_handlebar,1+th_handlebar], center=true);
        rotate([0,+90,0])translate([0,0,-(ro-th_handlebar/2)])
          cube([1+w_handlebar, gap_handlebar,1+th_handlebar], center=true);
      }
    // bolt and nut to attach ring to handlebar
    _mount_bolts_and_nuts();
    rotate([180,0,0])
      _mount_bolts_and_nuts();

    // the mount brackets
    minkowski(){hull(){
      translate([0,-gap_handlebar,ro-th_handlebar/2])
        cube([w_handlebar-.9, 1, th_handlebar-.9],center=true);
      rotate([-(90-acos(r_handlebar / ro)),0,0])translate([0,-ro+1/2,0])
        cube([w_handlebar, 1, 1],center=true);
      translate([0,-ro+1/2 -l_arm, ro-th_arm/2])
        cube([th_arm-.9, 1, th_arm-.9], center=true);
    }
    rotate([90,0,0])cylinder(r=.9,h=.9,center=true,$fn=20);
    }
  }
  difference(){
    translate([0,-r_handlebar,0])
      rotate([0,90,0])_donut(ro=ro, ri=r_handlebar, h=th_arm);
    translate([ro+.5,-ro-r_handlebar,0]){
      rotate([0,180,0]) cube([2*ro+1,2*ro+1,2*ro+1]);
      translate([0,-ro,ro])rotate([0,180,0]) cube([2*ro+1,2*ro+1,2*ro+1]);
    }
  }
  r_stabilizer = l_arm/2+th_arm;
  difference(){  // TODO
    minkowski(){
    translate([0,-(l_arm)+r_stabilizer,0])
      rotate([0,90,0])_donut(ro=r_stabilizer-.9, ri=l_arm/2-.9, h=th_arm, $fn=10);
    rotate([90,0,0])cylinder(r=.9,h=.9,center=true,$fn=20);
    }
    translate([0,r_stabilizer+th_handlebar,0])rotate([0,90,0])cylinder(r=ro, h=2*r_stabilizer+1, center=true);
    translate([0,-r_stabilizer,-(r_stabilizer)/2-1/1])cube([l_mount_plate, 4*r_stabilizer, r_stabilizer+1], center=true);
  }
}


module _mount_bolts_and_nuts() {
  difference() {
    // ...the solid part
    for(sn=[-1,1]) hull() {
      translate([0,0,-ro -ro_bolt]) {
        translate([0,sn*(gap_handlebar/2+h_m3/2),0]) {
          // the bolt and goes through this
          rotate([90,0,0])
            cylinder(r=ro_bolt, h=h_m3, center=true, $fn=50);
          // attach bolt holder to the ring
          translate([0,-sn*(h_m3/2 - 1/2),ro_bolt +th_handlebar-.5/2])
            cube([w_handlebar,1,.5], center=true);
        }
      }
      /* rotate([-90+sn*acos(r_handlebar / ro),0,0]) */
      rotate([-90+sn*45,0,0])  // aesthetic... requires cutout
        translate([0,ro-1/2,0])
        cube([w_handlebar,1,1], center=true);
    }
    // cutout the center of ring again so I can make above aesthetic chng
    rotate([0,90,0])cylinder(r=r_handlebar, h=ro_bolt*2, center=true,$fn=150);

    // ...the cutout part
    translate([0,0,-ro-ro_bolt]) {
      // bolt hole
      rotate([90,0,0]) cylinder(r=r_m3, h=100, center=true, $fn=80);
      // bolt head
      translate([0,-(gap_handlebar/2+th)-ro/2,0]) rotate([90,0,0])
        cylinder(r=r_m3_bolt_head, h=ro, center=true, $fn=80);
      // nut
      translate([0,(gap_handlebar/2+th)+ro/2,0]) rotate([90,0,0])
        cylinder(r=w_m3_nut/2, h=ro, center=true, $fn=6);
    }
  }
}

module bike_mount_one_piece() {
  translate([(l_mount_plate/2-th_arm/2),0,0])
    _mount_handlebar_attachment();
  translate([-(l_mount_plate/2-th_arm/2),0,0])
    _mount_handlebar_attachment();
  translate([0,-l_arm,ro-h_mount_plate/2])
    difference(){
      hull()minkowski(){
        cube([l_mount_plate-2,th_mount_plate-2,h_mount_plate-2], center=true);
        union(){
          cylinder(r=2, h=2,center=true,$fn=50);
          rotate([0,90,0])cylinder(r=2, h=2,center=true, $fn=50);
        }
      }
      translate([final_height/2,
          -ro_cap_canister-gap_velcro-th+th_mount_plate-3,
          0])rotate([0,90,180]){
        /* canister_shell(); */
        translate([0,-.1,h_canister_extension-th])
          _canister_shell();
        _v1_velcro_handles();
        translate([0,0,-1])hull()_canister_shell(h=h_canister_extension+2, err=th+.1);
        translate([0,0,final_height-h_canister_extension-1])
          hull()_canister_shell(h=h_canister_extension+2, err=th+.1);
      }
      cube([2*ro_cap_canister,gap_velcro+th,w_velcro_bar+1], center=true);
      for(sn=[-1,1])
        translate([sn*(h_cap_canister+w_velcro_bar-1.5*th),0,0])
          cube([w_velcro_bar+1,gap_velcro+th,2*ro_cap_canister], center=true);
    }
}

module bike_mount_handle() { // make me
  rotate([90,0,0])
    difference(){
      bike_mount_one_piece();
      translate([0,-gap_handlebar/2,0])
        cube([l_mount_plate+th_handlebar*2+th_arm*2,ro+l_arm+th_mount_plate,2*ro+4*ro_bolt],center=true);
    }
}
module bike_mount_plate() { // make me
  rotate([-90,0,0])
    difference(){
      bike_mount_one_piece();
      translate([0,ro+gap_handlebar*2,0])cube([l_mount_plate+th_handlebar*2+th_arm*2,ro+gap_handlebar,2*ro+4*ro_bolt],center=true);
    }
}

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
/* cap_plug();                                */

/* translate([ro_cap_canister*4+l_arm,0,0])          */
/*   bike_mount_plate();                             */
/*   translate([ro_cap_canister*4+ro*2+l_arm*2,0,0]) */
  bike_mount_handle();                           

  //test
  /* difference(){ */
  /* rotate([90,0,0]) */
  /* canister_shell(version=1);                   */
  /* cube([100,100,ro_canister*2+0], center=true); */
  /* translate([0, 0, -10])cube([100, 100, 10], center=true); */
  /* translate([-40,-ro_canister*4-100,-50])cube([100,100,100]); */
  /* } */

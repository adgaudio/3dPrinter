// Configurable Settings
th = 2;

h_AA_terminal_neg = 5;
h_AA_terminal_pos = 1.5;
h_AA_battery = 50.5;
r_AA_battery = 14.5/2;
w_wire_AA_canister = 2;
_h_cap_AA_canister = 20;
h_AA_cap_plug = 10;

r_led_star = 20/2;

// Derived settings
ri_AA_canister = r_AA_battery + .3;
ro_AA_canister = ri_AA_canister + th;
h_AA_canister = h_AA_battery + h_AA_terminal_neg + h_AA_terminal_pos;
h_AA_canister_extension = w_wire_AA_canister+th+h_AA_cap_plug;

ro_cap_AA_canister = ro_AA_canister+th;
ri_cap_AA_canister = ro_AA_canister+.2;
h_cap_AA_canister = min(h_AA_canister/2, _h_cap_AA_canister);

module AAx2_canister() { // make me
  difference(){
    // build outer shell
    hull($fn=150) {
      for (sn=[-1,1])
        translate([sn*ri_AA_canister, 0, 0])
          cylinder(r=ro_AA_canister, h=h_AA_canister);
    }
    // cut out space for batteries
    for (sn=[-1,1])
      translate([sn*ri_AA_canister, 0, -.05])
        cylinder(r=ri_AA_canister, h=h_AA_canister+.1, $fn=100);
    // cut out middle section
    translate([-r_AA_battery/2, -r_AA_battery/2, -.05])
      cube([r_AA_battery, r_AA_battery, h_AA_canister+.1]);
    // cutout space for wires
    for (sn2=[0,1]) for (sn=[0, 1]) {
      translate([0, 0, sn2*(h_AA_canister)])

        rotate([0, sn2*180, 0])
        rotate([0, sn*180, 0])
        translate([
            ri_AA_canister/2,
            ri_AA_canister,
            -(2*sn-1)*.5*(w_wire_AA_canister-.1)])
        rotate([0, 90, 90+atan(ri_AA_canister*.5 / ro_AA_canister)])
        cube([
            .1+w_wire_AA_canister,
            w_wire_AA_canister,
            sqrt(pow(ro_AA_canister,2) + pow(ri_AA_canister,2))
            ], center=true);
      translate([-ri_AA_canister/2,
          ro_AA_canister-w_wire_AA_canister+.1,
          sn*(h_AA_canister-w_wire_AA_canister)+(2*sn -1)*.1])
        cube([ri_AA_canister, w_wire_AA_canister, w_wire_AA_canister+.1]);
    }
  }
}


module AAx2_canister_cap(h=h_cap_AA_canister) { // make me
  difference(){
    hull() {
      translate([+ri_cap_AA_canister, 0, 0])
        cylinder(r=ro_cap_AA_canister, h=h);
      translate([-ri_cap_AA_canister, 0, 0])
        cylinder(r=ro_cap_AA_canister, h=h);
    }
    hull($fn=150) {
      translate([+ri_AA_canister, 0, th])
        cylinder(r=ri_cap_AA_canister, h=h);
      translate([-ri_AA_canister, 0, th])
        cylinder(r=ri_cap_AA_canister, h=h);
    }
  }

}


module AAx2_cap_plug(r=ri_cap_AA_canister, h=h_AA_cap_plug, smaller_by=.5) {
  hull($fn=150) {
    translate([+ri_AA_canister, 0, 0])
      cylinder(r2=r, r1=r-smaller_by, h=h);
    translate([-ri_AA_canister, 0, 0])
      cylinder(r2=r, r1=r-smaller_by, h=h);
  }
  // little hands-friendly handle
  translate([0, 0, h])
    minkowski() {
      scale([2.5, 1, 1])cylinder(r2=ri_AA_canister-2, r1=ri_AA_canister/2, h=10);
      rotate([90, 0, 0])cylinder(r=2,h=1, $fn=30);
    }
}


module _extension(holes=true) {
  difference(){
    hull($fn=150) {
      translate([+ri_AA_canister, 0, 0])
        cylinder(r=ro_cap_AA_canister, h=h_AA_canister_extension);
      translate([-ri_AA_canister, 0, 0])
        cylinder(r=ro_cap_AA_canister, h=h_AA_canister_extension);
    }
    hull($fn=150) {
      translate([+ri_AA_canister, 0, -.1])
        cylinder(r=ro_AA_canister, h=h_AA_canister_extension+.2);
      translate([-ri_AA_canister, 0, -.1])
        cylinder(r=ro_AA_canister, h=h_AA_canister_extension+.2);
    }

    if(holes) {
      // wire holes through to the outside for pcb (need to waterproof)
      _extension_wire_holes_cutout();

    }
  }
}


module _extension_wire_holes_cutout(h=10) {
  for(sn=[-1,1])
    translate([sn*ri_AA_canister/2-sn*w_wire_AA_canister/2,
        -ro_AA_canister+w_wire_AA_canister, h_AA_canister_extension-w_wire_AA_canister/2]) {
      rotate([90-45, 0, 0])
        cylinder(r=w_wire_AA_canister/2, h=h+w_wire_AA_canister, $fn=25);
    }
}


module _led_star_cutout() {
  z = h_AA_cap_plug+w_wire_AA_canister+th;
  translate([0, -ro_AA_canister, z +ro_AA_canister])
    rotate([90,0,0])
    cylinder(r=r_led_star, h=abs(xyz_between_led_stars[1]), $fn=100);
}


/* AAx2_canister_cap(); */
module AAx2_canister_shell(version=1) {

  /* h_AA_electronics = h_AA_canister+h_AA_cap_plug; */
  /* AAx2_canister_cap(h=h_AA_electronics); */
  translate([0, 0, h_AA_canister_extension])
    AAx2_canister();
  // extend the top of canister with a "shell" that the plug can fit in
  translate([0, 0, h_AA_canister+2*h_AA_canister_extension])rotate([180, 0, 0])
    _extension(holes=false);
  // extend the bottom of the canister but don't add holes
  rotate([180, 180, 0]) _extension(holes=true);
  if (version == 1){
    /* translate([0,th,0]) */
      _v1();
  }
}


module _v1_curved_outer_shell() {
  union(){
    translate(xyz_between_led_stars)
      hull(){
        cube([th*2+w_wire_AA_canister*2, th*2+w_wire_AA_canister*2, z_between_led_stars],
            center=true);
        translate([0, w_wire_AA_canister+th/2, 0])
          cube([ro_AA_canister*3, th, z_between_led_stars], center=true);
      }
    translate([0, ro_AA_canister/-2, h_led_mount/2])
      scale([2, 1, 1])cylinder(r=ro_AA_canister, h=h_led_mount, center=true, $fn=100);
  }
}


z_between_led_stars = h_AA_canister-4*r_led_star-2*th;
h_led_mount = h_AA_canister+h_AA_canister_extension*2;
xyz_between_led_stars = [
0,-(ro_AA_canister+w_wire_AA_canister),h_AA_cap_plug + h_AA_canister/2];
module _v1() {
  // add curved space where I'll attach led strip
  rotate([0, 0, 180]) {
    difference(){
      _v1_curved_outer_shell();
      translate([0, 0, h_AA_canister-1])hull(){AAx2_canister();}
      translate([0, 0, 0])hull(){AAx2_canister();}
      translate([0, 0, -h_AA_canister+1])hull(){AAx2_canister();}

      // cutout the top led star hole (and give wire holes leading to it)
      _extension_wire_holes_cutout(
          h=ro_AA_canister*1.5);
      _led_star_cutout();
      // a space between the 2 led stars where wires can travel
      translate(xyz_between_led_stars)
        cube([w_wire_AA_canister*2, w_wire_AA_canister*2, z_between_led_stars],
            center=true);

      // cutout the bottom led star hole (do not give wire holes leading to it)
      translate([0, 0, h_AA_canister-th*2]) {
        // bottom led star cutout with link to both
        translate([0,0,-(h_AA_cap_plug+w_wire_AA_canister/2+th+r_led_star)])
          _led_star_cutout();
      }
    }
  }
}

// mounts for circuit board
/* module _v2() { */
/* x=20; */
/* y=10; */
/* z=40; */
// mimic the circuit board
// TODO: dimensions!
/* translate([x/2, ro_AA_canister, h_AA_canister-w_wire_AA_canister-th]) { */
/* rotate([0, 180, 0])%cube([x, y,z]); */
// put circuit board encasing
/* } */
/* } */



/* translate([100, 0, 0]) { */
/* translate([0, ro_AA_canister*2 + 10, 0]) { */
/* AAx2_canister_cap(); */
/* translate([0, ro_cap_AA_canister*2+10, 0]) */
/* AAx2_canister(); */
/* } */
/* [> translate([0, -ro_AA_canister*2-10, 0]) { <] */
/* translate([0, -ro_cap_AA_canister*2-10, +ro_AA_canister*2+48]) { */
/* AAx2_cap_plug(); */
/* } */
/* } */
AAx2_canister_shell(version=1);

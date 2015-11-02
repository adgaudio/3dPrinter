// Configurable Settings
th = 1;

h_AA_terminal_neg = 5;
h_AA_terminal_pos = 1.5;
h_AA_battery = 50.5;
r_AA_battery = 14.5/2;
w_wire_AA_canister = 3;
_h_cap_AA_canister = 20;
h_AA_cap_plug = 10;

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
        cylinder(r=ri_AA_canister, h=h_AA_canister+.1);
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
        rotate([0, 90, -45])
        cube([.1+w_wire_AA_canister, w_wire_AA_canister, r_AA_battery],
            center=true);
      translate([-ri_AA_canister/2, ro_AA_canister-w_wire_AA_canister+.1, -.1])
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
    for(sn=[-1,1])
      translate([sn*ri_AA_canister/2-sn*w_wire_AA_canister/2,
          0, h_AA_cap_plug+w_wire_AA_canister/2])
        rotate([90, 0, 0])
        cylinder(r=w_wire_AA_canister/2, h=10, $fn=25);
    }
  }
}


/* AAx2_canister_cap(); */
module AAx2_canister_cap_electronics() {

  /* h_AA_electronics = h_AA_canister+h_AA_cap_plug; */
  /* AAx2_canister_cap(h=h_AA_electronics); */
  AAx2_canister();
  // extend the top of canister with a "shell" that the plug can fit in
  translate([0, 0, h_AA_canister+h_AA_cap_plug])rotate([180, 0, 0])
    _extension();
  // extend the bottom of the canister but don't add holes
  translate([0, 0, -h_AA_canister_extension+w_wire_AA_canister+th])
    _extension(holes=false);

  // add curved space where I'll attach led strip
  h_led_mount = h_AA_canister+h_AA_cap_plug*2;
  difference(){
    translate([0, ro_AA_canister/-2, h_led_mount/2-h_AA_cap_plug])
      scale([2, 1, 1])cylinder(r=ro_AA_canister, h=h_led_mount, center=true);
    translate([0, 0, h_AA_canister-1])hull(){AAx2_canister();}
    translate([0, 0, 0])hull(){AAx2_canister();}
    translate([0, 0, -h_AA_canister+1])hull(){AAx2_canister();}
  }

  // mounts for circuit board
  x=20;
  y=10;
  z=40;
  // mimic the circuit board
  // TODO: dimensions!
  translate([x/2, ro_AA_canister, h_AA_canister-w_wire_AA_canister-th]) {
    rotate([0, 180, 0])%cube([x, y,z]);
    // put circuit board encasing
  }
}



translate([100, 0, 0]) {
translate([0, ro_AA_canister*2 + 10, 0]) {
  AAx2_canister_cap();
  translate([0, ro_cap_AA_canister*2+10, 0])
    AAx2_canister();
}
/* translate([0, -ro_AA_canister*2-10, 0]) { */
translate([0, -ro_cap_AA_canister*2-10, +ro_AA_canister*2+48]) {
  AAx2_cap_plug();
}
}
AAx2_canister_cap_electronics();

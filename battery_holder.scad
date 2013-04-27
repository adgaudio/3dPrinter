h_AA_battery = 50.5;
r_AA_battery = 15.8/2;
h_pad = 5;
h_contact_slot = 3;
h_battery_inset = h_pad/2;
h_bolt_cutout = h_AA_battery + h_pad;
r_bolt = 3.6/2;
r_wire = 3.6/2;
w_nut = 6.5;
h_nut = 4;
h_nut_inset = 7;
battery_offset = .5;


module battery() {
  cylinder(r=r_AA_battery, h=h_AA_battery);
  /*translate([0,0,h_AA_battery - 2])cylinder(r=3, h=2, center=true);*/
}

module _2x2_battery_cutouts() {
  // battery cutouts
  for (sign1 = [-1, 1], sign2 = [-1, 1])
    translate([sign1 * (r_AA_battery + battery_offset),
               sign2 * (r_AA_battery + battery_offset),
               h_battery_inset]) {
      battery();

      // slot for wire to contacts
      translate([0, 0, -1/2*h_AA_battery])
        cylinder(r=r_wire, h=h_AA_battery + h_AA_battery);
    }

  // slot for contacts
  translate([0, 0, h_pad - h_battery_inset]) {
    for (sign = [-1, 1]) {
      translate([0, sign * (r_AA_battery + battery_offset), 0])
        cube([4*r_AA_battery,
              r_AA_battery,
              h_contact_slot], center=true);

      translate([sign * r_AA_battery, 0, h_AA_battery])
        cube([r_AA_battery,
              4*r_AA_battery,
              h_contact_slot], center=true);
    }
  }
}


module _2x2_battery_pad() {
  translate([-(2*(r_AA_battery + battery_offset)),
             -(2*(r_AA_battery + battery_offset)),
             0])
    cube([4*r_AA_battery + 4*battery_offset,
          4*r_AA_battery + 4*battery_offset,
          h_pad]);
}

module 2x2_battery_pack() {
  difference() {
    union() {
      // bottom pad
      _2x2_battery_pad();
      // center pole
      cylinder(r=2*r_AA_battery, h=h_AA_battery + h_battery_inset);
    }
    _2x2_battery_cutouts();
    // bolt cutout
    cylinder(r=r_bolt, h=h_bolt_cutout + cutout);
    //nut cutout
    translate([-w_nut/2, -w_nut/2, h_AA_battery + h_battery_inset - h_nut - h_nut_inset])
      cube([2*r_AA_battery + w_nut/2, w_nut, h_nut]);
  }
}

module 2x2_battery_pack_top_pad() {
  difference() {
    translate([0, 0, h_AA_battery])
      _2x2_battery_pad();
    _2x2_battery_cutouts();
    2x2_battery_pack();
    // bolt cutout
    cylinder(r=r_bolt, h=h_bolt_cutout + cutout);
  }
}

module print_2x2_battery_pack() { // make me
  /*for (sign1 = [-1, 1], sign2 = [-1, 1])*/
    /*translate([sign1 * (2*r_AA_battery + battery_offset +15),*/
               /*sign2 * (2*r_AA_battery + battery_offset +15),*/
               /*z_lense_offset/2])*/
      2x2_battery_pack();
}

module print_2x2_battery_pack_top_pad() { // make me
  /*for (sign1 = [-1, 1], sign2 = [-1, 1])*/
    /*translate([sign1 * (2*r_AA_battery + battery_offset +15),*/
               /*sign2 * (2*r_AA_battery + battery_offset +15),*/
               /*z_lense_offset/2])*/
      rotate([180, 0, 0])
        2x2_battery_pack_top_pad();
}


module slim_2x2_battery_pack() { // make me
  difference() {
    cylinder(r=2*r_AA_battery-.01, h=h_AA_battery + 2*h_battery_inset + 2*h_nut);

    for (sign1 = [-1, 1], sign2 = [-1, 1]) {
    translate([sign1 * (r_AA_battery),
               sign2 * (r_AA_battery),
               h_battery_inset]) {
      translate([0, 0, -1.5*h_battery_inset])
      cylinder(r=r_bolt, h=h_AA_battery + 3*h_battery_inset +2*h_nut);

      cylinder(r=r_AA_battery, h=h_AA_battery+2*h_nut);
    }}

    cylinder(r=r_bolt, h=h_AA_battery);
  }
}
module slim_2x2_battery_top_pad() { // make me
  difference() {
    cylinder(r=2*r_AA_battery-.01, h=h_pad);

    for (sign1 = [-1, 1], sign2 = [-1, 1]) {
    translate([sign1 * (r_AA_battery),
               sign2 * (r_AA_battery),
               h_battery_inset]){
      translate([0, 0, -2*h_battery_inset])
#      cylinder(r=r_bolt, h=h_AA_battery + 3*h_battery_inset);
      battery();
    }}

    cylinder(r=r_bolt, h=h_AA_battery);
  }
}

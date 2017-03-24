// Window AC unit needs better supports do avoid potential window frame damage

l = 55;
w = 28;

h_window_lip = 46;
h_ac_leg = 17;
h_ext = h_window_lip - h_ac_leg;  // 23;
h_overlap = 5;

th = 3;

module ac_block() { // make me
  difference() {
    translate([0, 0, (h_ext+h_overlap)/2])cube([l+2*th, w +2*th, h_ext+h_overlap], center=true);
    #translate([0, 0, h_ext + h_overlap/2+.01])cube([l, w, h_overlap], center=true);
  }
}

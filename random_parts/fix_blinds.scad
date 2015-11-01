h_blind=3;
th=1.6;

y = 2*th + h_blind;
x = 40;
z = 10;

module U() {
cube([x, y, th]);
translate([0, 0, th]) {
translate([0, h_blind+th, 0])
  #cube([x, th, z]);
  cube([x, th, z]);
}
}
rotate([0, -90, 0])
U();

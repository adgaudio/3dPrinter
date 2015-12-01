th = .7;

ro1 = 23/2;
ho1 = 6;

ho2 = 10;
ri2 = 19.2/2;
ro2 = ri2 + th;

module cabinet_roller_cap() { // make me
rotate([0, 180, 0]){
  #translate([0, 0, (ho1 + ho2)/2])
    cylinder(r=ro2, h=ho1, center=true, $fn=200);
  difference(){
    cylinder(r=ro2, h=ho2, center=true, $fn=200);
    cylinder(r=ri2, h=ho2+.1, center=true, $fn=200);
  }
}
}
cabinet_roller_cap();

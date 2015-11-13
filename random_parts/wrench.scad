l = 14;  // side length of hex nut
th=3;  // wall thickness
h=10;  // height
l_handle = 80;  // length of handle
w_handle = th;  // width of handle
r=l+th;  // outer radius of wrench head

module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}

// hexagon cutout head
difference(){
  hull(){
    cylinder(r=r, h=h);
    translate([r+5,0,h/2])
      cube([min(5, l_handle), l+th, h], center=true);
  }
  translate([0,0,h/2])
    hexagon(l, h+.1);
}

// handle
translate([r+l_handle/2+5,0,h/2]) {
#cube([l_handle-5, r, h], center=true);
}

// regular wrench head

translate([r+l_handle+r,0,0]) {
  difference(){
    hull(){
      translate([-r,0,h/2])cube([1,r,h], center=true);
      cylinder(r=r, h=h);
    }
    translate([0,0,h/2])hexagon(l, h+.1);
    translate([r/2+l/4,0,h/2])
      cube([r, 2*r, h+1], center=true);

  }
}

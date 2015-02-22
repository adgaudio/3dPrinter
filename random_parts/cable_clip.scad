

s = 12;  // side length
th = 3;  // wall thickness

// wire diameter size (size of clip notch, not inner radius)
wd = 6;
wd = 3/16*s +th;  // suggested wire diameter (size of the clip notch).
/* wd = s-2*th; // max wire diameter (size of clip notch) */


module _cutout() {
  difference() {
    cube([wd, s+1, s+1], center=true);
    #hull() {
    translate([-wd/2, -wd/2 , 0])cylinder(r=wd/2, h=s+2, center=true, $fn=40);
    translate([-wd/2, -s/2-th/2, 0]) cylinder(r=.1, h=s+2, center=true);
    }
  }
}


module cable_clip() {  // make me
  translate([(s*3/8+th)/2, 0, 0]) rotate([0, 90, 0])
    cube([s, s, th], center=true);

  difference() {
    cylinder(r=s/2, h=s, center=true);
    cylinder(r=s/2 - th, h=s+1, center=true, $fn=40);
    // cutout excess cylinder
    translate([(s*3/8)/2 + s/2 + th, 0, 0])cube([s, s, s+1], center=true);
    // cutout space to insert wire into clip with rounded edge
    translate([(s*3/8)/2 - wd/2, s/2,0]) _cutout();
  }
}
cable_clip();

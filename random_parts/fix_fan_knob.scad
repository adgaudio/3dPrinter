h=4;
$fs=.8;
$fa=.3;

module star(r, h, wing_x, wing_y) {
cylinder(r=r, h=h);
translate([0,0,h/2]){
cube([wing_x*2+2*r, wing_y, h], center=true);
rotate([0,0,90])cube([wing_x*2+2*r, wing_y, h], center=true);
}
}

t=0.1;

difference(){
star(10.6/2,h,5.5, 3.5);
translate([0,0,-.05])star((9+t)/2, h+.1, 5+t, 1.5+t);
}


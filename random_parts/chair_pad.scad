// cylinder(r=2.54/2*10, h=10);
// cylinder(r=22/2, h=10);
// cylinder(r=4/2, h=10);

// chair leg split and needs a little pad at bottom to hold the leg together
// and balance height of rest of chair.
module chair_pad(
    d1 = 1*2.54*10,
    d2 = 1.25 * 2.54*10,
    d3 = .75*2.54*10,
    h1 = 10,
    h2 = 1*2.54*10,
    h3 = .5*2.54*10
) {
    module cap(inside=false) {
        th = inside? 0  : .75;
        hdelta = inside ? .01 : 0;
    translate([0,0,-hdelta/2]){
    if (!inside) {
    cylinder(r=d1/2+th, h=h1);
    }
    translate([0,0,h1]) {
        cylinder(r1=d1/2+th, r2=d2/2+th, h=h2);
        translate([0,0,h2]) {
        cylinder(r1=d2/2+th, r2=d3/2+th, h=h3 + hdelta);
    }} } 
    }
    difference(){
        cap(inside=false);
        cap(inside=true);
    }
}
chair_pad();

include <BOSL2/std.scad>

// modeled to replicate a guitar string winder model on thingiverse
// but with rounded edges and slightly larger hole
// % import("string_winder_body_1.7.stl");

$fs=.01;
$fn=80;
diff("hole"){
hull(){
    cyl(d=13+6, h=9, anchor=BOTTOM, rounding=2);
    back(30)//cyl(d=6+9.5, h=9, anchor=BOTTOM, rounding=1);
scale([1,1.75]) cyl(d=9.5+6, h=9, anchor=BOTTOM, rounding1=2);

}
tag("hole")cyl(d=13, h=5, $fs=.1, anchor=BOTTOM, rounding1=-1) position(TOP)up(.1)cyl(d=4+4, h=4, anchor=BOTTOM, rounding2=-1);

move([0,30,9]) scale([1,1.75])
{
    intersection(){
    cyl(d=9.5+6, h=20, anchor=BOTTOM, rounding2=1);
    prismoid(size1=[9.5+6,9.5+6], size2=[15.5, 15.5-3], h=20, anchor=BOTTOM, rounding=2);
    }
    tag("hole")up(8)scale([1,2.0,1])cyl(d=9.5, h=20-8+.01, anchor=BOTTOM, rounding1=1, rounding2=-2);
}
}

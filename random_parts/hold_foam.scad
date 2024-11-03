include <BOSL2/std.scad>

difference(){
// flat against door
cuboid([10+2, 25, 2], anchor=BOTTOM)
position(LEFT)
// supporting side of the foam
{cuboid([2, 25, 12], anchor=BOTTOM+LEFT)
position(TOP+RIGHT)
// holding foam in place
cuboid([12, 25, 2], anchor=RIGHT);
} ;
right(2){
    down(.01)cylinder(r=1.5, h=3, $fn=10);
    up(1.5)cylinder(r1=1.5, r2=3, h=.51, $fn=10);
}
}

// Little corner to attach things with.  It has chamfered slot-shaped bolt holes and a reinforced corner.

include <BOSL2/std.scad>
include <BOSL2/screws.scad>

diff("hole"){
    cuboid([6,28.5,6], anchor=BOTTOM+LEFT+FWD, chamfer=3);
    union(){cuboid([28.5, 28.5, 3], rounding=.5, anchor=BOTTOM+LEFT+FWD)
    attach(TOP) tag("hole")up(.01){
        //screw_hole("M4,2.51",head="flat",counterbore=0,anchor=TOP);
        hull(){
        fwd(2)cyl(r2=8/2, r1=4.2/2, h=2, anchor=TOP, $fn=30);
        fwd(2)cyl(r=4/2, h=3.1, anchor=TOP, $fn=30);
        back(2)cyl(r2=8/2, r1=4.2/2, h=2, anchor=TOP, $fn=30);
        back(2)cyl(r=4/2, h=3.1, anchor=TOP, $fn=30);
        }
    }
    cuboid([3, 28.5, 28.5], rounding=.5, anchor=BOTTOM+LEFT+FWD)
    attach(RIGHT) tag("hole")up(.01){
        hull(){
        fwd(2)cyl(r2=8/2, r1=4.2/2, h=2, anchor=TOP, $fn=30);
        fwd(2)cyl(r=4.2/2, h=3.1, anchor=TOP, $fn=30);
        back(3)cyl(r2=8/2, r1=4.2/2, h=2, anchor=TOP, $fn=30);
        back(3)cyl(r=4.2/2, h=3.1, anchor=TOP, $fn=30);
        }
    }
    }
    back(1.5)zrot(-90)yrot(-90)fillet(3, 20, 90, 0, chamfer=3);
    back(-1.5+28.5)zrot(-90)yrot(-90)fillet(3, 20, 90, 0, chamfer=3);
    //translate([28.5/2+3/2,28.5/2,-.01])cylinder(r=4.8/2, h=3.02, $fn=20);
    //translate([-.01,28.5/2,28.5/2+3/2])rotate([0,90,0])cylinder(r=4.8/2, h=3.02, $fn=20);
}

//cube([14,14,14]);

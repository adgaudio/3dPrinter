include <BOSL2/std.scad>

th = 4;  // wall thickness
h = 62+th*2;
screw_hole_diameter=3.9;

diff("hole") {
cuboid([125, 150, th], rounding=5, except=[TOP,BOT,BACK], anchor=BOT) {
    // align(TOP, [for(i=[-1,1], j=[-1,1]) [i,j]], inset=10)
    // charger
    // align(TOP)
    // #up(5)cuboid([90, 150, 25]);

    // little extension piece
    position(BACK)
    cuboid([125,30,th], rounding=5, except=[TOP,BOT,FRONT], anchor=FRONT);

     position(BOT){
     // walls
     cuboid([125,150, h], anchor=BOT, rounding=5, except=[TOP,BOT]) {
         position(BOT)
         tag("hole") {
             // main large center section front-back
             up(th)cuboid([125-th-th,150-th-th, h+1-th], anchor=BOT, chamfer=5);
             // another redundant main large center section front-back
             up(th)cuboid([100,155, h-th+1], anchor=BOT, rounding=0, except=[TOP,BOT]);
             // side wall holes
             up(th)fwd(45/2+5)cuboid([125+1,45, h-th-th], anchor=BOT, chamfer=15, except=[LEFT,RIGHT]);
             up(th)back(45/2+5)cuboid([125+1,45, h-th-th], anchor=BOT, chamfer=15, except=[LEFT,RIGHT]);
         }

        // side on top that has the edge to make it so it's printable
        // tag("keep")attach(TOP, BOT, align=[LEFT, RIGHT]) {
        // down(12-.5)cuboid([18, 150-21*2, 12], chamfer=9, except=[FRONT,BACK, TOP]);
        // down(12-.5)cuboid([9, 150-21*2, 12]);

        // fwd(150/2-th/2)
        // down(12-.5)cuboid([18, th, 12], chamfer=9, except=[FRONT,BACK, TOP]);
        // // down(12-.5)cuboid([9, th, 12]);
        // back(150/2-th/2)
        // down(12-.5)cuboid([18, th, 12], chamfer=9, except=[FRONT,BACK, TOP]);
        // // down(12-.5)cuboid([9, th, 12]);
        // }
         }

     }
}
}  // end diff

     // %cuboid([125,150,h], anchor=BOT)
diff("hole") up(h) {
     // upper part
    up(.5)cuboid([125,150, th+15], anchor=TOP, rounding=5, except=[TOP,BOT]) {
        tag("hole") cuboid([125-15, 150, th+15+1], chamfer=40, except=[TOP,BOT]);
        tag("hole") cuboid([90, 155, th+15+1]);
        tag("hole") down(th)up(.5)cuboid([125, 151, 15], chamfer=15, except=[BOT, FRONT,BACK]);
    }

    // screw holes
    grid_copies(size=[125-20,150-30], n=2) {
     tag("hole")up(.5)cylinder(r=screw_hole_diameter/2, h=th+1+th, anchor=TOP);
     tag("hole")down(th)cuboid([20, 20, 15+th], anchor=TOP);
    }
}


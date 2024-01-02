include <BOSL2/std.scad>


function path_spiral(N, r, f) = [
    for (i = [0: 1: N])
    [i/N*r*sin(i/N*360), i/N*r*cos(i/N*360)] ];

module large_drain() {  // make me
    echo(path_spiral(10, 20, 1));
    r_drain = 6*25.4/2;

    difference(){
        circle(r=r_drain);
        for (ang=[0, 90, 180, 270]) {
            rot(ang) move_copies(path_spiral(200, r_drain-25.4, 1)) circle(8);
        }
    }
    scale([r_drain/25.4, 1])circle(25.4);
    scale([1, r_drain/25.4])circle(25.4);
    // scale(r_drain, 5)circle(1);
    }

module small_drain() {  // make me
    r_drain = 5*25.4/2;
    difference(){
        circle(r=r_drain);
        grid_copies([20, 20], size=[r_drain*2, r_drain*2], inside=circle(r_drain-25.4/2)) circle(r=5);
    }
}
module medium_drain() {  // make me
    r_drain = 6*25.4/2;
    difference(){
        circle(r=r_drain);
        grid_copies([20, 20], size=[r_drain*2, r_drain*2], inside=circle(r_drain-25.4/2)) circle(r=5);
    }
}

// large_drain();
medium_drain();
// small_drain();

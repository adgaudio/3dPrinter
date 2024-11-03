include <BOSL2/std.scad>

// todo: texture
// in tpu
module inner() {
    cyl(r1=10.3/2, r2=10.3/2, h=38+.2);
}

module outer() {
    cyl(r1=13.9/2, r2=12.0/2, h=38, texture="rough");
}

difference(){
    outer();
    inner();
}

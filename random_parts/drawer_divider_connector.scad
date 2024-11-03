
$fn=100;
side_len = 5+ 2*8;
wall_th = 3;
wall_h = 25.4*2;
connector_minth = 3;
cylinder(r=side_len/2, h=2);
// translate([0,0,55])
//cylinder(r=5/2, h=1, $fn=20);
translate([0,0,2])
linear_extrude(25.4 * 1.95)
difference(){
    circle(r=side_len/2);
    for (i=[0:3]) {
        rotate([0,0,360/4*i])
        translate([5/2, wall_th/-2,0])
        square([8, wall_th]);
    }
}

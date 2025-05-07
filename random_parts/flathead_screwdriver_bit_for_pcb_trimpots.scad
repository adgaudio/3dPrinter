include <BOSL2/std.scad>
$fa = .1;
$fs = .1;

module flathead_screwdriver_bit()
{
    // The flathead screwdriver bit for turning trim pots on PCBs.  compatible with 5/32" shank (like on wiha #739)
    hull()
    {
        // tip
        linear_extrude(28) square([ 2.5, .5 ], center = true);
        linear_extrude(20) circle(r = 3 / 2);
    }
    hull()
    {
        // cylinder
        linear_extrude(20) circle(r = 3 / 2);
        // hexagon
        translate([ 0, 0, 1 ])
        {
            linear_extrude(16) circle(r = 4.6 / 2, $fn = 6);
        }
        linear_extrude(1) circle(r = 1.75);
    }

    // % cube([ 3.96, 3.96, 10 ], center = true);
}
flathead_screwdriver_bit();

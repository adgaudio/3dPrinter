// cylinder(r=2.54/2*10, h=10);
// cylinder(r=22/2, h=10);
// cylinder(r=4/2, h=10);
include <BOSL2/std.scad>
$fa = 1;
$fs = 1;

// chair leg split and needs a little pad at bottom to hold the leg together
// and balance height of rest of chair.  Dimensions are of the chair leg.
module chair_pad_v1(d1 = 29, d2 = 31, d3 = .95 * 2.54 * 10, h1 = 3, h2 = 1 * 2.54 * 10, h3 = .5 * 2.54 * 10)
{
    module cap(inside = false)
    {
        th = inside ? 0 : .75;
        hdelta = inside ? .01 : 0;
        translate([ 0, 0, -hdelta / 2 ])
        {
            if (!inside)
            {
                cyl(r = d1 / 2 + th, h = h1, rounding1 = h1, anchor = BOT);
            }
            translate([ 0, 0, h1 ])
            {
                cyl(r1 = d1 / 2 + th, r2 = d2 / 2 + th, h = h2, anchor = BOT);
                translate([ 0, 0, h2 ])
                {
                    cyl(r1 = d2 / 2 + th, r2 = d3 / 2 + th, h = h3 + hdelta, anchor = BOT);
                }
            }
        }
    }
    difference()
    {
        cap(inside = false);
        cap(inside = true);
    }
}

module chair_pad_v2()
{
    diff()
    {
        cyl(d1 = 25.5 + .75 * 2, d2 = 26 + .75 * 2, h = 26 + 3, rounding1 = 1);
        up(3) tag("remove") cyl(d1 = 25.5, d2 = 26, h = 26);
    }
}

// problematic chairs
chair_pad_v1(); // make me

right(30)
{
    // nicer chairs
    chair_pad_v2(); // make me
}

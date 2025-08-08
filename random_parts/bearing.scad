include <BOSL2/std.scad>;

$fa = .1; // Smoothness
$fs = .1; // Smoothness

od = 12;
height = 3.5;
id = 8;

module bearing_MR128()
{
    rotate_extrude()
    {
        outer_ring_2d();
        inner_ring_2d();
    }
    difference()
    {
        cylinder(r = od / 2, h = height, center = true);
        cylinder(r = od / 2 - .3 / 2, h = height, center = true);
    }
}

module outer_ring_2d()
{

    right(od / 2) difference()
    {
        scale([ .55, .80 ]) circle(r = height / 2);
        right(height / 2) square(height, center = true);
    }
}

module inner_ring_2d()
{
    union()
    {
        outer_ring_2d();

        // inner ring
        difference()
        {
            // note: the +.1 is an extra tolerance to make the inside of the cirle
            // larger, assuming 3d printed item has slightly smaller hole
            right(height / 2 / 2 + id / 2 + .1) square([ height / 2, height ], center = true);
            union()
            {

                right(od / 2) difference()
                {
                    scale([ .75, 1 ]) circle(r = height / 2);
                    right(height / 2) square(height, center = true);
                }
            }
        }
    }
}

module visualize_MR128()
{
    difference()
    {
        bearing_MR128(); // make me
        cube([ 100, 100, 100 ]);
    }
    % right(od / 2 - 1.3) cube([ .3, .3, .3 ]);
    % cylinder(d = id, h = 5, center = true);
    % up(height / 2 + 2) cylinder(d = od, h = 5);
}
// outer_ring_2d();
// inner_ring_2d();
visualize_MR128();
// bearing_MR128();

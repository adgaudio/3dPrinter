include <BOSL2/std.scad>
// The battery positions are not quite correct, so need to drill them.  but otherwise works excellently.

// components: tp4056, boost converter, 120mm fan, rocker switch.

$fa = .5;
$fs = .5;

th_wall = 2;
h_inside = 5 + 25 + 2;
x_o = 125 + 1;
y_o = 125 + 50 + 1;

module _fan_cutout(w_fan = 120)
{
    tag("fan") down(.01) fwd(3 / 2) cyl(r = (w_fan - 3) / 2, h = 25);
    up(th_wall) tag("fan_square") cuboid([ w_fan, w_fan, 25 ])
    {
        corners = [ LEFT + FWD, LEFT + BACK, RIGHT + FWD, RIGHT + BACK ];
        for (corner = corners)
        {
            align(BOT, corner, inside = true) tag("fan_screw_hole") children();
        }
    }
    // grid_copies(125, 2) cylinder(r = 10, h = 5);
}

module enclosure_body() // make me
{
    diff("inside fan fan_square", "fan_screw_hole keep")
    {
        cuboid([ x_o, y_o, h_inside + th_wall ], rounding = 8, except = [ TOP, BOT ], anchor = BOT)
        {
            // TODO: replace 125 with x_o and 125+50 with y_o
            tag("inside") position(TOP) up(.01) cuboid([ 125 - th_wall, 125 + 50 - th_wall, h_inside ], rounding = 8,
                                                       except = [ TOP, BOT ], anchor = TOP);

            fwd(th_wall + 1) align(BOT, BACK, inside = true) _fan_cutout() tube(h = 5, or = 11, ir = 3.4 / 2);

            position(FRONT + BOT) back(10) up(th_wall) down(.01)
            {
                tag("keep") tube(h = h_inside, or = 6, ir = 3.4 / 2, anchor = BOT);
            }
        }
    }
}

module enclosure_lid() // make me
{
    hide("fan_square") diff("hole fan fan_screw_hole third_screw_hole rocker_switch")
    {
        up(50) cuboid([ x_o, y_o, th_wall ], rounding = 8, except = [ TOP, BOT ], anchor = BOT)
        {
            // TODO: replace 125 with x_o and 125+50 with y_o
            // little "liner" around the inside
            position(TOP)
                cuboid([ 125 - th_wall, 125 + 50 - th_wall, 1.9 ], rounding = 8, except = [ TOP, BOT ], anchor = BOT);
            tag("hole") position(TOP)
                cuboid([ 125 - th_wall - 2 * th_wall, 125 + 50 - th_wall - 2 * th_wall, 1.9 + .01 ], rounding = 8,
                       except = [ TOP, BOT ], anchor = BOT);
            // remove the liner around the fan... the fan is the liner
            tag("hole") position(TOP + BACK) cuboid([ 125 + 2, 125 + 2, 1.9 + .01 ], anchor = BOT + BACK);

            // fan screw holes
            fwd(th_wall + 1) align(BOT, BACK, inside = true, inset = 11.75 / 2) _fan_cutout(120 - 11.75)
                down(th_wall + .01) cylinder(h = 10, r = 4.8 / 2);
            fwd(th_wall + 1) align(BOT, BACK, inside = true, inset = 9.55 / 2) _fan_cutout(120 - 9.55)
                down(th_wall + .01) cylinder(h = 1, r = 7.8 / 2);
            tag("third_screw_hole") position(FRONT + BOT) back(10) down(.01)
            {
                cylinder(r = 4.8 / 2, th_wall + .01 + .01);
                cylinder(r = 7.8 / 2, h = 1);
            }

            tag("rocker_switch") down(.01) right(8) back(8) align(BOT, LEFT + FRONT, inside = true)
                // actually it's a large rectangle that can be used for different control knobs or whatever
                cuboid([ 21.5, 37.5, th_wall + .1 ]);
            // cuboid([ 13, 20, th_wall + .1 ]);
        }
    }
}

module rocker_switch() // make me
{

    diff("rocker_switch_hole usbc_hole")
    {
        rect_tube(th_wall, [ 21.5 - .4, 37.5 - .4 ], [ 21.5 - .4 - 2 * th_wall, 37.5 - .4 - 2 * th_wall ]);
        up(th_wall)
        {
            cuboid([ 21.5 + 3 + 3, 37.5 + 3 + 3, th_wall ], anchor = BOT, rounding = 2, except = [BOT]);
            tag("rocker_switch_hole") fwd(8) down(8) cuboid([ 20, 13, 15 ], anchor = BOT);

            tag("usbc_hole") back(13) down(8)
                cuboid([ 9.5, 3.4, 15 ], anchor = BOT, rounding = 1.5, except = [ TOP, BOT ]);
        }
    }
}
// rocker_switch();
// % up(th_wall) cuboid([ 15, 21, 2 ], anchor = BOT);

// enclosure_body();
enclosure_lid();
// up(55 + h_inside + 3) zflip() enclosure_lid();
// countersunk_screwhole_m4();
// cuboid([ 70, 20, 20 ], anchor = BOT);  // 18650 battery case

// up(5 + th_wall) back(25) resize([ 120, 120, 25 ]) xrot(90) import("Arctic P12 slim.stl");

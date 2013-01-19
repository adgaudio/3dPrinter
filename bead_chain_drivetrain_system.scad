include <drivetrain_system.scad>;

/*translate([0,0,0])make_gears_with_horseshoes();*/
/*translate([0,70,0])rotate([0, 0, 90])plate_spacers();*/
/*translate([0,150,0])rotate([0, 0, 90])make_bottom_plate();*/
/*translate([0,250,0])rotate([0, 0, 90])make_top_plate();*/


module system() {
make_gears_with_horseshoes();
plate_spacers();
plates();
}

/*translate([0, -1.5*y_plate, 0])system();*/


translate([-x_plate/4,0,0])make_gear_for_motor(); // make me
translate([x_plate/4,0,0])make_gear_for_608ZZ_bearing(); // make me
translate([x_plate/2, 0, 0])make_right_horseshoe(); // make me
translate([-x_plate/2, 0, 0])make_left_horseshoe(); // make me
translate([0, 1.1*y_plate, 0])plate_spacers(); // make me
translate([0, 2.2*y_plate, 0])make_top_plate(); // make me
translate([0, 3.3*y_plate, 0])make_bottom_plate(); // make me

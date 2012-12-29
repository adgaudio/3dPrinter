include <drivetrain_system.scad>;

translate([0,0,0])make_gears_with_horseshoes();
translate([0,70,0])rotate([0, 0, 90])plate_spacers();
translate([0,150,0])rotate([0, 0, 90])make_bottom_plate();
translate([0,250,0])rotate([0, 0, 90])make_top_plate();


module system() {
make_gears_with_horseshoes();
rotate([0, 0, 90])plate_spacers();
rotate([0, 0, 90])plates();
}

translate([0, -100,0])system();

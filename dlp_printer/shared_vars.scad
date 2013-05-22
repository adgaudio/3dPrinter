m3_nut_height = 1;
m3_nut_width = 4;
m3_bolt_radius = 1.5; // TODO
m8_bolt_radius = 8/4;  // TODO

r_608zz = 22/2 + .6;
r_608zz_hole = 8/2;
h_608zz = 7;

motor_z = 50;
motor_x = 80;
motor_y = 80;
motor_mount_z = 8;
motor_mount_inset = 5;
motor_mount_bolt_size = m3_bolt_radius;  // TODO

h_motor_shaft = 5;
thickness_motor_shaft = 3;
r_motor_shaft = 5;

eccentric_roller_rim_width = 3;
eccentric_roller_offset = 3 + r_608zz + r_motor_shaft ;
eccentric_roller_r = eccentric_roller_rim_width + 
                     max(r_608zz, eccentric_roller_offset) + r_608zz;
eccentric_roller_r_o_shaft = thickness_motor_shaft + r_motor_shaft;

roller_r_rod = 8/2;
roller_r = r_608zz + roller_r_rod + 1;
roller_h = 2*h_608zz + 1;

vat_r_i = 52/2;
vat_r_o = vat_r_i + 3;
vat_h = 30; // TODO
vat_r_lense_lip = vat_r_i - 5;
vat_h_lense_lip = 5;  // thickness of lip holding glass to vat
vat_z_lense_lip_offset = 5;
vat_z_holder = 10; // defines maximum possible z movement there can be when tilting vat
vat_holder_width = 30; // TODO - just seems right.  
vat_holder_angle = asin(vat_z_holder / vat_holder_width);
echo(vat_holder_angle);
vat_hinge_r_o = r_608zz + 3;
vat_hinge_thickness = h_608zz;
vat_hinge_y_offset = 20;
_y = (vat_hinge_y_offset- vat_hinge_thickness/2);
vat_hinge_x_offset = vat_r_o - sqrt(pow(vat_r_o, 2) - pow(_y, 2));  // via geometric translation & pythagorean theorum

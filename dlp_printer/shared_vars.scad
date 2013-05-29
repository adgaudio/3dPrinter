m3_nut_height = 1;
m3_nut_width = 4;
m3_bolt_radius = 1.5; // TODO
m5_bolt_radius = 5/2; // TODO
m8_bolt_radius = 8/4;  // TODO

r_608zz = 22/2 + .6;
r_608zz_hole = 8/2;
h_608zz = 7;

motor_z = 50; // actually, this is just aesthetic
motor_x = 4 + 56.39;
motor_y = 4 + 56.58;
motor_mount_z = 8;
motor_mount_inset = 2 + 2.0;
motor_mount_bolt_size = m5_bolt_radius;

h_motor_shaft = 10;
thickness_motor_shaft = 6.34/2;
r_motor_shaft = 3;

eccentric_roller_rim_width = 3;
eccentric_roller_offset = thickness_motor_shaft + r_608zz + r_motor_shaft ;
eccentric_roller_r = eccentric_roller_rim_width + 
                     max(r_608zz, eccentric_roller_offset) + r_608zz;
eccentric_roller_r_o_shaft = thickness_motor_shaft + r_motor_shaft;
roller_h = 2*h_608zz + 1;

vat_r_i = 54/2;
vat_r_o = vat_r_i + 3;
vat_h = 30; // TODO
vat_r_lense_lip = vat_r_i - 5;
vat_h_lense_lip = 5;  // thickness of lip holding glass to vat
vat_z_lense_lip_offset = 5;
vat_z_holder = 10; // defines maximum possible z movement there can be when tilting vat
vat_holder_width = 30; // TODO - just seems right.  
vat_holder_angle = asin(vat_z_holder / vat_holder_width);
vat_hinge_r_o = r_608zz + 3;
vat_hinge_thickness = h_608zz;
vat_hinge_y_offset = 20;
_y = (vat_hinge_y_offset- vat_hinge_thickness/2);
vat_hinge_x_offset = vat_r_o - sqrt(pow(vat_r_o, 2) - pow(_y, 2));  // via geometric translation & pythagorean theorum

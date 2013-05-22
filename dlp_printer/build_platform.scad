include <shared_vars.scad>;


thickness_platform = 5;
r_platform = vat_r_i - eccentric_roller_offset/2; // made up number - just seems like a good value
y_offset_platform_mount = 10;
r_platform_shaft = 8;
h_platform_shaft = 20 + vat_h-vat_z_lense_lip_offset - vat_h_lense_lip;
z_platform_mount = 3;
xyz_platform_mount = [2*r_platform_shaft, 30, z_platform_mount];
dist_between_platform_mount_screws = 20;

z_offset_build_platform = vat_z_lense_lip_offset; // TODO: 50
y_offset_build_platform = vat_r_i - r_platform; // how much extra room is between the vat and the platform


module build_platform() {
translate([0, y_offset_build_platform, z_offset_build_platform]) {
  cylinder(r=r_platform, h=thickness_platform);
  // shaft connecting top to bottom
  cylinder(r=r_platform_shaft, h=h_platform_shaft);
  translate([0, 0, h_platform_shaft + z_platform_mount/2]) {
    difference() {
    // top mount connecting to z axis
        cube(xyz_platform_mount, center=true);
      // screw holes
      for (sign = [-1, 1])
      translate([0, sign * dist_between_platform_mount_screws/2, 0])
        cylinder(r=m3_bolt_radius, h=z_platform_mount + 1, center=true);
    }
  }
}
}







module build_platform_extrusions() {
translate([0, y_offset_build_platform, z_offset_build_platform + z_platform_mount + h_platform_shaft + 10]) {
  translate([0, 30, 0])
    cube([20, 420 + 30, 20], center=true);
}
}
build_platform_extrusions();

module _frame() {
  difference() {
    cube([420, 420, 20], center=true);
    cube([420-20, 420-20, 21], center=true);
  }
}
module frame() {
  // threaded and smooth rod
  translate([0, 420/2, 0]) {
    translate([-30, 20 + 10, 0])
      cylinder(r=(3/8.)*25.4, h=420, center=true);
    translate([30, 20, 0])
      cylinder(r=8/2, h=420, center=true);
  }
  // smooth rod on other side of frame
  translate([20, -420/2 + 20, 0])
    cylinder(r=8/2, h=420, center=true);


translate([0, 0, -420/2])
  _frame();
translate([0, 0, 420/2]) {
  _frame();
  // top extrusion in middle (adjustable for motor mount)
  translate([0, 0, 20])
  cube([20, 420 + 40, 20], center=true);

  // small piece of extrusion for motor mount
  translate([20, 0, -420/8 + 20])
  cube([20, 20, 420/3], center=true);
}
// rods for motor mount
translate([10, 0, 420/4+20])
  for (sign=[-1, 1])
  translate([0, 20*sign, 0])
  rotate([0, 90, 0])
  cylinder(r=8/2, h=420/2);
// side - motor (rod) mount extrusion
translate([420/2, 0, 0])
  cube([20, 20, 420], center=true);
// side - vat mount extrusion
translate([-420/2, 0, 0])
  cube([20, 40, 420], center=true);
// other sides
for (sign = [-1, 1])
translate([0, sign*420/2, 0])
cube([20, 20, 420], center=true);

}
frame()

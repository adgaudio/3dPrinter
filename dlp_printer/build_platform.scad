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
y_offset_build_platform = vat_r_i - r_platform; // make vat disc eccentricly place


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

module rod_to_extrusion_mount() {

}

rod_to_extrusion_mount();

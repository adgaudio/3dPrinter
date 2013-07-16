include <../shape_primitives.scad>;
include <shared_vars.scad>;


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

module rod_to_extrusion_stabilizing_mount() {
  difference () {
    union () {
      for (sign=[-1, 1]) translate ([0, 0, sign*(rod_mount_length)/2])
        rod_mount();
    }
    for (sign=[-1, 1]) {
      translate ([xy_extrusion/2, 0, sign*(rod_mount_length - xy_extrusion/2 + 5/2)])
      cube([xy_extrusion+5, 5+xy_extrusion, xy_extrusion+5], center=true);
    }
  }
}

module rod_mount(mount_angle=0) {
  difference () {
    union () {
      U(r_rod_holder, r_lm8uu, r_rod_holder+thickness, r_rod_holder);
      translate ([r_rod_holder, 0, 0])rotate([mount_angle, 0, 0])
        cube ([thickness, xy_extrusion, rod_mount_length], center=true);
    }
    // screw holes
    rotate([mount_angle, 0, 0])
    rotate([0, 90, 0])for (sign=[1, -1])
      translate([sign*(rod_mount_length-xy_extrusion)/2, 0, 1])
        cylinder(r=m5_bolt_radius, h=2*r_rod_holder+thickness, center=true);
  }
}

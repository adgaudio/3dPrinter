/* (in progress) A fan duct mount for reprap-style printers

Inspired by: http://www.thingiverse.com/thing:16970
*/
default_boltsize = 3;
inset = 2 + default_boltsize;  // distance from an edge to center of bolt holes

mount_width = 40;
mount_depth = 5;

cone_ri_base = mount_width/2 - 3;
cone_ro_top = 20/2;
cone_thickness = 3;
cone_h = 40;
cone_angle = 50;


arm_length = 20 + default_boltsize;
arm_width = 5;
arm_depth = mount_depth;

module cone() {
  difference() {
    cylinder(r2=cone_ri_base + cone_thickness, r1=cone_ro_top, h=cone_h, center=false);
    cylinder(r2=cone_ri_base, r1=cone_ro_top - cone_thickness, h=cone_h, center=false);
  }
}


module angled_bracket() {
  hull() {
    cube([arm_width, 1, arm_depth], center=false);
    rotate([0, cone_angle, 90])translate([0, -arm_width, 0])
      cube([arm_length, arm_width, arm_depth], center=false);
  }
}

module arm() {
  union() {
    angled_bracket();
    // add bolt holes
    rotate([0, cone_angle, 90])translate([arm_length+default_boltsize/2, -arm_width/2, 0])
      difference(){
        cylinder(r=inset, h=arm_depth);
        cylinder(r=default_boltsize/2, h=arm_depth);
      }
  }
}

module fan_mount() {
  union() {
    difference() {
      cube([mount_width, mount_width, mount_depth], center=true);
      cylinder(r=cone_ri_base, h=mount_depth, center=true);
      // make bolt holes on corners
      for (sign = [-1, 1], sign2 = [-1, 1]) {
        assign (corner = sign * (mount_width/2 - inset)) {
          translate([corner, sign2 * corner, -mount_depth/2])cylinder(r=default_boltsize/2, h=mount_depth);
        }
      }
    }
    // add arms
    translate([-mount_width/2, mount_width/2, -mount_depth/2])
      difference() {
        union() {
        arm();
        translate([mount_width-arm_width, 0, 0])arm();
        }
      }
  }
}

module mounted_fan_duct() {
  union() {
    translate([0, 0, -cone_h + mount_depth/2])cone();
    fan_mount();
  }
}

rotate([cone_angle, 0, 0])
  mounted_fan_duct();

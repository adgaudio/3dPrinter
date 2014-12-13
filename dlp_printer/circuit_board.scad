include <../shape_primitives.scad>;
include <shared_vars.scad>;


pcb_ri = m3_bolt_radius;
pcb_ro = pcb_ri + 2;
pcb_separator = thickness + pcb_ro;

pcb_extrusion_dist = max(m3_nut_height+1, 3);  // extra distance between pcb and extrusion


module _extrusion_attachment() {
  // attach to extrusion with m5 screw
  difference() {
    cube([xy_extrusion, xy_extrusion, thickness], center=true);
    cylinder(r=m5_bolt_radius, h=thickness+.1, center=true);
  }
}

module _pcb_attachment() {
  // attach to the pcb with m3 screw
  difference(){
    hull() {

      cube([thickness, xy_extrusion, thickness], center=true);
      for (sign=[-1,1]) {
        translate([sign*pcb_separator, 0, 0])
          cylinder(r=pcb_ro, h=thickness, center=true);
      }
    }
    for (sign=[-1,1]) {
      translate([sign*pcb_separator, 0, 0]) cylinder(r=pcb_ri, h=thickness+1, center=true);
      translate([sign*pcb_separator, 0, 0]) cylinder(r=pcb_ri, h=thickness+1, center=true);
    }
  }
}


module pcb_screw_attachment() {
  // for pcbs with screw holes in corners, use this to attach them to aluminum
  // extrusions
  translate([xy_extrusion/2 + thickness/2, 0, 0])
    _extrusion_attachment();
  cube([pcb_extrusion_dist+thickness/2, xy_extrusion, thickness], center=true);
  translate([-pcb_extrusion_dist, 0, 0]) rotate([0, 90, 0])
    _pcb_attachment();
}

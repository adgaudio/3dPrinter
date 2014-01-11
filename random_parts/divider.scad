/* A drawer divider for small parts, utensils, etc
 *
 * inspired by: http://www.thingiverse.com/thing:25581/#files
 * also inspired by: http://makezine.com/2012/04/13/cnc-panel-joinery-notebook/
 *
 * By: Alex Gaudio <adgaudio@gmail.com>
 */

// Main configurable vars:
num_slots = 3;
thickness = 3;
min_height = 20; // there is a hardcoded min height
min_length = 0; // there is a hardcoded min length.  you can either choose the number of slots, or a length

// Advanced Configurable vars:
detent_width=thickness/3/3;
detent_arm_min_tolerance=thickness/25;
detent_angle = 3;  // TODO: adjust this based on detent_width
lower_gap_height = thickness/4;
height = max(min_height, 2*(2*thickness + lower_gap_height));
divider_upper_gap_height = height/2;
insert_upper_gap_height = (height - divider_upper_gap_height - thickness - lower_gap_height);
detent_arm_height= detent_width*2 + thickness;//5;//height/2 + lower_gap_height;
detent_arm_width = sin(detent_angle) * detent_arm_height + detent_width/2 + detent_arm_min_tolerance;
dist_between_gaps = thickness + 2*sin(detent_angle)*detent_arm_height;

length = max(min_length, num_slots * thickness + num_slots*dist_between_gaps + thickness);
// length calculates the end-to-end length
gap_width = dist_between_gaps + thickness;

module ticks_cutout(type) {
  /* Meant to be used like below.  `type` is either "divider" or "insert"
   *
   *    difference() { some_object; ticks_cutout(type="divider"); }
   */
  _inner_length = length - 3*thickness;
  for (x=[0:_inner_length/gap_width]) {
    translate([_inner_length/-2 + x*gap_width, 0, 0]) {
      if (type == "divider") {
        divider_cutout();
      } else if (type == "insert") {
        insert_cutout();
      }
    }
  }
}

module divider_cutout() {
  // upper hole
  translate([0, 0, height/2 + 1 - divider_upper_gap_height/2])
    cube([thickness, thickness + 1, divider_upper_gap_height + 2], center=true);
  // lower hole
  translate([0, 0, height/2 - divider_upper_gap_height - thickness - lower_gap_height/2])
    cube([thickness, thickness + 1, lower_gap_height], center=true);
}

module insert_cutout() {
  // small middle section between detents running through insert
  translate([0, 0, height/2 - (height - divider_upper_gap_height)/2 + 1])
    cube([thickness - 2 * detent_width, thickness + 1, height - divider_upper_gap_height + 2], center=true);
  // hole towards middle of insert
  translate([0, 0, thickness/2])
    cube([thickness, thickness + 1, thickness], center=true);
  // hole towards tip of insert
  translate([0, 0, thickness + lower_gap_height + insert_upper_gap_height/2 + 1])
    cube([thickness, thickness + 1, insert_upper_gap_height + 2], center=true);
  // detent
  translate([0, 0, thickness + lower_gap_height/2]) {
    rotate([90, 0, 0]) {
    for (sign=[-1, 1]) {
    translate([(thickness/2 - detent_width/2) * sign, 0, 0]) {
    difference() {
      translate([sign*-.01, 0, 0])
        scale([detent_width + .02, thickness + 1, thickness + 1])
          cube([1, 1, 1], center=true);
      translate([detent_width/3 * sign, 0, 0])
        scale([detent_width, lower_gap_height/2, 1])
          cylinder(r=1, h=thickness, center=true, $fn=10);
    }
  }}}}
  // make detent have a space to compress inwards when inserting
  translate([0, 0, thickness + lower_gap_height])
  for (sign=[-1, 1]) {
    translate([sign*thickness/2 + sign*1/2, 0, 0]) {
      // small horizontal line to make space for detent to arm inwards
      cube([detent_arm_width*2, thickness + 1, detent_arm_min_tolerance],
            center=true);
      // cut out a hull of hollow space for detent to arm inwards
      translate([sign*detent_arm_width/2, 0, detent_arm_height/-2]) {
        hull() {
          rotate([0, sign*detent_angle, 180])
            cube([detent_arm_min_tolerance, thickness+1, detent_arm_height], center=true);
          translate([sign * sin(detent_angle) * detent_arm_height, 0, 0])
          cube([detent_arm_min_tolerance, thickness+1, detent_arm_height], center=true);
        }
      }
    }
  }
}

module divider() {
  difference() {
    cube([length, thickness, height], center=true);
    ticks_cutout(type="divider");
  }
}

module insert() {
  difference() {
    cube([length, thickness, height], center=true);
    ticks_cutout("insert");
  }
}
translate([0, height/2 + 5, 0])
rotate([90, 0, 0])
divider();
translate([0, -height/2 - 5, 0])
rotate([-90, 0, 0])
insert();

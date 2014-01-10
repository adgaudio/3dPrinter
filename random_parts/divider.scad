/* A drawer divider
 *
 * inspired by: http://www.thingiverse.com/thing:25581/#files
 * also inspired by: http://makezine.com/2012/04/13/cnc-panel-joinery-notebook/
 *
 * By: Alex Gaudio <adgaudio@gmail.com>
 */

// Configurable vars:

thickness = 3;
lower_gap_height = 2;
// end-to-end length
length = 7 * thickness * 3; // suggested min length: thickness * 3

height = 2*(2*thickness + lower_gap_height); // suggested min height: 2*(2 * thickness + lower_gap_height);
dist_between_gaps = 2*thickness;


// Suggested Non-customizable vars
detent_height=lower_gap_height/3;
detent_width=thickness/3/2; // suggested: don't bother too much with this. it's finicky
detent_swing_min_tolerance=0.2;
detent_angle = 3;  // TODO: adjust this based on detent_width
// todo: adjust dist_between gaps based on detent_width and thickness
divider_upper_gap_height = height/2;
insert_upper_gap_height = (height - divider_upper_gap_height - thickness - lower_gap_height);
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
      // small horizontal line to make space for detent to swing inwards
      translate([sign*(-1/2+detent_swing_min_tolerance), 0, 0])
        cube([detent_swing_min_tolerance+1,
              thickness + 1,
              detent_swing_min_tolerance],
             center=true);
      // cut out a hull of hollow space for detent to swing inwards
      translate([sign*1/2, 0, 5/-2])
      hull() {
        rotate([0, sign*detent_angle, 180])
          cube([detent_swing_min_tolerance, thickness+1, 5], center=true);
        translate([sign * sin(detent_angle) * 5, 0, 0])
        cube([detent_swing_min_tolerance, thickness+1, 5], center=true);
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
translate([0, thickness + 15, 0])
/*rotate([180, 0, 90])*/
divider();
insert();

// prevent window from moving down or up.  attaches underneath or above frame
// of my double hung window.
//  --  for double hung metal frame windows

h = 30;
th = 4;
nut_gap = 5;  // extra space to be able to install tool and insert nut.  must
// be greater than y - y_i

// measurements to build a U shaped hook to latch onto window frame
_y = 8.5;  // length of frame that is parallel to my eyes as I look out window
y = _y + nut_gap;
x_i = 3.5;  // length of window frame that is parallel to the bottom of the frame (and perpendicular to y)
_y_i = 5;  // inner space of frame that we use to craft the "hook"
y_i = _y_i + nut_gap;
x = 15;  // length of outer part of frame sticking out of wall.  it measures a line parallel to bottom of frame.

r_m5_bolt = 5/2;


module window_stop() { // make me
  difference(){
  union(){
  cube([x_i+2*th, y + 2*th, h]);
  translate([th, 0, 0])cube([x, th, h]);
  }
  translate([th, _y/2, -.005]) cube([x_i, y, h+.01]);
  translate([th, th, -.005]) cube([x_i+th+.01, y_i, h+.01]);

  // screw holes
  translate([th+x/2, th+.005, h/7*2])rotate([90, 0, 0])cylinder(r=r_m5_bolt, h=th+.01, $fn=70);
  translate([th+x/2, th+.005, h/7*5])rotate([90, 0, 0])cylinder(r=r_m5_bolt, h=th+.01, $fn=70);
  }
}
/* window_stop(); */

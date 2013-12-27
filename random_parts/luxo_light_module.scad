// A very simple insert for the luxo lamp head
//
// See example: http://www.flickr.com/photos/92244914@N04/11577951703/
// Luxo lamp available on Thingiverse:  http://www.thingiverse.com/thing:27350
//
// Instructions:
// Attach leds, switch and wire to this part, and then push it into the
// lamp head.

 r_module = 68/2;
h_module = 3;

w_switch = 13;
l_switch = 20;
h_switch = 3;

r_led_mount = 40/2/2;

module luxo_led_module() { // make me
  difference() {
    union() {
    cylinder(r=r_module, h=h_module, center=true);
    translate([r_module - w_switch/2 - 1, 0, h_switch/2])
      cube([w_switch+2, l_switch+2, h_module + h_switch], center=true);
    }
    // cutout for led module
    translate([-2, 0, 0])
    cylinder(r=r_led_mount, h=h_module + 1, center=true);
    // cutout for switch
    translate([r_module - w_switch/2 - 1, 0, h_switch/2])
      cube([w_switch, l_switch, h_module + h_switch + 1], center=true);
  }
}

luxo_led_module();

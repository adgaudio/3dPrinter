// Configurable Settings
th=1;

// FYI:
// h_AA_battery = 50.5;
// r_AA_battery = 14.5/2;
// r_18650_battery = 18/2;
// h_18650_battery = 65;
h_battery = 65;
r_battery = 18.5/2;


r_led_star_6_side = 20/2;

h_led_star_6_side = 1;  // TODO
// derived configuration
ro_battery = r_battery + th;
h_led_star_holder = h_led_star_6_side + .5 + th + 1.5;



module _led_star(h=h_led_star_6_side){
  r_holder = 3/2;
  difference(){
    // hexagon
    union(){
      cube([h, 2*r_led_star_6_side/1.75, 2*r_led_star_6_side], center=true);
      rotate([-60,0,0])cube([h, 2*r_led_star_6_side/1.75, 2*r_led_star_6_side], center=true);
      rotate([60,0,0])cube([h, 2*r_led_star_6_side/1.75, 2*r_led_star_6_side], center=true);
    }
    rotate([0,90,0]) {
      for (d=[0:360/6:360-360/6]) {
        rotate([0,0,360/6/2 +d])translate([r_led_star_6_side+r_holder/2,0,0])
          cylinder(r=3/2, h=h+1, center=true, $fn=20);
      }
      /* cylinder(r=r_led_star_6_side, h=h, center=true, $fn=6); */
    }

  }
}
module _led_star_holder(){
  difference(){
    rotate([0,90,0])
      cylinder(r=r_led_star_6_side+th, h=h_led_star_holder, $fn=20);
    translate([h_led_star_holder/2+th,0,0])_led_star(h=h_led_star_holder);
  }
}

module _battery_cutout(){
  difference(){
    cylinder(r=ro_battery, h=h_battery, center=true);
    cylinder(r=r_battery, h=h_battery+1, center=true);
  }
}

// battery
translate([-ro_battery,0,h_battery/2])
  _battery_cutout();
  // led star
translate([h_led_star_6_side/2,0,h_battery-r_led_star_6_side])
  _led_star_holder();

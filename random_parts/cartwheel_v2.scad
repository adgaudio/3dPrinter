module cartbody() {
  x = 100;
  y = 25;
  h_max = 25;
  r_axle = 8/2;

  seat_backrest_width = 15;
  seat_width = 10;
  seat_height = 2;

  legspace_offset_from_edge = 5;
  legspace_y = 10;
  legspace_x = x - seat_width - seat_backrest_width - 2*legspace_offset_from_edge;
  legspace_z = 10;

  text_string="TSEGUY";
  text_size=3;
  text_thickness=1;

  difference(){
    cube([x,y,h_max]);
    translate([x*.15,-.5,8])rotate([-90,0,0])cylinder(r=r_axle,h=y+1);
    translate([x*.85,-.5,8])rotate([-90,0,0])cylinder(r=r_axle,h=y+1);
    translate([seat_backrest_width,-.05,h_max-5]) {
      cube([x - seat_backrest_width+.1,y+.1,5+.1]);
      translate([seat_width,0,-seat_height]) {
        cube([x - seat_backrest_width-seat_width+.1,y+.1,seat_height+.1]);

        translate([legspace_offset_from_edge,(y-legspace_y)/2,-legspace_z])
          cube([legspace_x, legspace_y, legspace_z+.1]);
      }
    }
  }
  translate([0,y/2,h_max/2])rotate([90,0,-90])linear_extrude(text_thickness)
    text(text_string, size=text_size, halign="center");

}


module cartwheel() {
  ro=60/2;  // outer wheel radius
  ro_i=50/2;  // the inner portion of outer wheel radius.  ro - ro_i denotes thickness of the "tire" part of wheel.
  r_bearing_holder=15;  // a bearing gets mounted into the center of wheel
  r_spoke=6/2;  // thickness of the spokes
  num_spokes=6;  // number of wheel spokes

  r_bearing=22/2;  // the radius of the bearing.  this is a 608 size bearing (roller blades and skate boards)
  h_bearing = 8;  // how wide the bearing is.  this is set for 608 size bearing.
  r_axle = 8/2;  // radius of the axle that goes through the cart

  // the "tire" of the wheel
  difference(){
    cylinder(r=ro,h=10);
    translate([0,0,-.5])cylinder(r=ro_i,h=11);
  }

  difference(){
    union(){
      cylinder(r=r_bearing_holder, h=10, $fn=num_spokes);
      for (i=[0:1:num_spokes]) {
        translate([0,0,5])rotate([-90,0,i*360/num_spokes])cylinder(r=r_spoke, h=ro_i+(ro-ro_i)/2);
      }
    }
    translate([0,0,2])cylinder(r=r_bearing, h=h_bearing+2, $fs=2, $fa=.1);
    translate([0,0,-.5])cylinder(r=r_axle, h=3);
  }

}

translate([-50,61,0])
  cartbody();
translate([30.5,30.5,0])
  cartwheel();
translate([-30.5,30.5,0])
  cartwheel();
translate([-30.5,-30.5,0])
  cartwheel();
translate([30.5,-30.5,0])
  cartwheel();

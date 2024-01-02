// little circle thingie like a bike mount for a light...

$fn=100;
rod_r = 10.5/2;
th = 3;  // overall wall thickness
w = 35;  // width of the holder  // should be diameter of the little circle on the quadlock part
m3_nut_height=5;
m3_nut_diameter=9.24+.1;  // corner to corner length (diameter of circle that circumscribes the nut
m3_nut_width_across=8.1; // side to side length
m3_screw_hole_diameter = 5.1;  // don't bind to threads

module adapter_smallside(){
    _adapter(th+m3_nut_height);
}

module adapter_largeside() {
    connector_height=m3_nut_height+th;
    difference() {
        union(){
        _adapter(th+rod_r);
        let ( sidelen=th*2+m3_nut_width_across) {
            translate([-sidelen/2, th+rod_r,0])
                linear_extrude(w)
                offset(r=.2)offset(delta=-.2)
                square([sidelen, connector_height]);
        }
        }
        // screw hole
        translate([0,rod_r+th+.001,w/2])
        rotate([-90,0,0])cylinder(r=m3_screw_hole_diameter/2, h=connector_height);
        // nut catch
        translate([m3_nut_width_across/-2,rod_r+th,-.001]) {
            cube([m3_nut_width_across, m3_nut_height, w/2, ]);
            translate([m3_nut_width_across/2,0,w/2])rotate([-90,360/6/2,0])cylinder(r=m3_nut_diameter/2, h=m3_nut_height, $fn=6);
        }
    }
}
module _adapter(_height) {
difference(){
    linear_extrude(w)
difference(){
    // the main body of the adapter
    union(){
        offset(.5)offset(delta=-.5)
        // offset(-.5)offset(delta=.5)
            polygon([[-10-rod_r-th,0], [-rod_r-th-10, _height], [0, rod_r+th], [10+rod_r+th,_height], [10+rod_r+th, 0]]);
        difference(){circle(rod_r+th);
           translate([-rod_r-th,2*(-rod_r-th)])square(rod_r+th+th+rod_r);
        }
    }
    // hole for rod
    circle(rod_r);
}

    // m3 screw and nut holes
for (sign=[-1,1]) {
translate([sign*(rod_r+th+th),-0.001,w/2])
rotate([-90,0,0]){
    // screw hole
    cylinder(r=m3_screw_hole_diameter/2, h=_height+.01);
    // nut hole
    translate([0,0,th])rotate([0,0,360/6/2])cylinder(r=m3_nut_diameter/2, h=_height, $fn=6);
    }
}
}
}
adapter_smallside();
mirror([0,1,0])
    translate([0,1,w])rotate([0,180,0])
adapter_largeside();

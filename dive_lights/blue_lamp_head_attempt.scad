/*
 * Replace existing head on a dive light with new one.
 * This could also be my first robot's eyes some day :)
 */
use <../external/Thread_Library.scad>
use <../battery_holder.scad>

function euclidean(a, b) = sqrt(pow(a, 2) + pow(b, 2));
cutout = 6; // extra dimensions to make clear difference() operations

////////////////////////
// BLUE LIGHT
////////////////////////

// vars
wall_thickness = 5;
z_handle_mnt = 50 + 10;
x_handle_mnt = 18;
y_handle_mnt = 18;

x_crossbar = 13;  // cylinder height
y_crossbar = 3;  // diameter
r_shaft = 7/2;
z_crossbar = 4;
z_crossbar_cavity = 2*r_shaft;

r_o_oring = 88.0/2;
r_i_oring_wall = r_o_oring - wall_thickness;
r_o_oring_2nd_wall = 96.5/2 + wall_thickness;
r_i_oring_2nd_wall = 103/2;
h_oring = 11;
h_oring_wall = 10;

r_lense = 57/2;
/*h_lense = 26;*/
r_lense_offset = 2+max(x_crossbar, y_crossbar)/2; // distance from perimiter of lense to closest xy axis
r_lense_lip = 45/2; // actual radius may be smaller than this
h_lense_lip = 10; //h_lense / 3;
h_lense_lip_offset = 0;  // fit up to 2 glass lenses. must be less than h_lense_lip

pitch_module = 10;
r_module = r_lense - pitch_module/2;
h_module = 10;
h_module_holder = 15;

z_lense_offset = 2*wall_thickness + 2*h_module;  // distance from top of oring to lenses

r_wire = 1.3;
x_offset_wire = 10;
y_offset_wire = 5;
h_knob = 10;
y_knob = .3 * r_module;
angle_offset_knob = 10;
y_offset_knob = r_module / 2;
thickness_knob = 3;

r_i_lamp_head = euclidean(2*r_lense, 2*r_lense) - 10; // some bug somewhere for this
r_o_lamp_head = wall_thickness + r_i_lamp_head;
h_shell = z_lense_offset + h_oring - h_module_holder;

module _lamp_head_oring_holder() {
  difference() {
    union() {
      cylinder(r=r_o_oring, h=h_oring_wall, $fn=94);
      translate([0, 0, h_oring_wall])
        cylinder(r=r_o_oring_2nd_wall, h=wall_thickness, $fn=94);
    }
    translate([0, 0, -cutout/2])
    cylinder(r=r_i_oring_wall, h=h_oring+h_oring_wall + cutout);
  }
}

module _lamp_head_attachment(h_extension=0) {
  // part that handle latches onto
  translate([0, 0, -z_handle_mnt]) {
    difference() {
      hull() {
        // main shaft
        cylinder(r=max(x_handle_mnt, y_handle_mnt)/2, h=z_crossbar_cavity + z_crossbar);

        // connect to (ie extend) latch.  Could do it above, but in case design changes...
        translate([0, 0, z_handle_mnt])
          cylinder(r=max(x_handle_mnt, y_handle_mnt)/2, h=h_oring);
      }
      // crossbar
      translate([-x_crossbar/2, -y_crossbar/2, 0])
        cube([x_crossbar, y_crossbar, z_crossbar]);
      // center rod
      cylinder(r=r_shaft, h=z_crossbar);
      // cavity
      translate([0, 0, z_crossbar])
        cylinder(r=max(x_crossbar, y_crossbar)/2, h=z_crossbar_cavity);
    }
  }
  // extension
  cylinder(r=max(x_handle_mnt, y_handle_mnt)/2, h=h_extension);
}

module _led_module_holder() {
  difference() {
    cylinder(r=r_lense, h=h_module_holder);
    // Call to external threaded rod making library
    trapezoidThreadNegativeSpace(
        length=h_module_holder + cutout,
        pitch=pitch_module,
        pitchRadius=r_module);
  }
  translate([0, 0, h_module_holder - wall_thickness]) {
    difference() {
      cylinder(r=r_lense+wall_thickness, h=wall_thickness);
      translate([0, 0, -cutout])
        cylinder(r=r_lense, h=wall_thickness+2*cutout);
    }
  }
}

module _shell(outer=true) {
  r1 = (outer==true ? r_lense + wall_thickness : r_lense);
  r2 = (outer==true ? r_o_oring_2nd_wall : r_i_oring_wall);
  h = (outer==true ? h_shell-h_oring_wall : h_shell-h_oring_wall);

  hull() {
    for (sign = [-1, 1])
      translate([0, sign * (r_lense + r_lense_offset), h])
        cylinder(r=r1, h=2*h_module_holder+h_lense_lip);
    if (outer != true) translate([0, 0, -1]) {
      cylinder(r=r2, h=2*h_module_holder+h_lense_lip);
    } else {
      cylinder(r=r2, h=2*h_module_holder+h_lense_lip);
    }
  }
}

module 2_lense_lamp_head() {
  // lamp head attachment
  _lamp_head_attachment(h_extension=h_oring_wall+h_shell+h_module_holder+h_lense_lip);

  // oring
  _lamp_head_oring_holder();

  // shell
  translate([0, 0, h_oring_wall]) difference() {
    union() {
      _shell();
      // face plate
      hull() {
        for (sign = [-1, 1]) {
          translate([0, sign * (r_lense + r_lense_offset), h_shell+h_module_holder+h_lense_lip+wall_thickness]) {
            cylinder(r=r_lense+wall_thickness, h=wall_thickness); // +1 is cutout
          }
        }
      }
    }
    _shell(false);
    // cutout lense holes
    difference() {
      for (sign = [-1, 1]) {
        translate([0, sign * (r_lense + r_lense_offset), h_shell+wall_thickness]) {
          cylinder(r=r_lense, h=h_shell+h_lense_lip + cutout); // +1 is cutout
        }
      }
    }
  }
  // shell - handle lense lip
  for (sign = [-1, 1]) {
    translate([0,
               sign * (r_lense + r_lense_offset),
               h_shell+2*h_module_holder-wall_thickness]) {
      difference() {
        cylinder(r=r_lense+wall_thickness, h=h_lense_lip+wall_thickness);
        translate([0, 0, -cutout/2])
          cylinder(r=min(r_lense_lip, r_lense - wall_thickness),
                   h=h_lense_lip + wall_thickness + cutout);
        translate([0, 0, max(h_lense_lip_offset, wall_thickness)])
          cylinder(r=r_lense, h=100);
      }
    }
  }

  // lense and light module holder
  for (sign = [-1, 1]) {
    translate([0, sign * (r_lense + r_lense_offset),
               h_shell+h_module_holder-wall_thickness]) {
      _led_module_holder();
    }
  }
}

/*difference() {*/
/*cylinder(r=0, h=0);*/
/*for (sign = [-1, 1]) {*/
/*#  translate([0, sign * (r_lense + r_lense_offset), 0]) {*/
  /*cylinder(r=r_lense, h=100);*/
/*}*/
/*}*/
/*}*/

module 4_lense_lamp_head() {
  _lamp_head_attachment();
  _lamp_head_oring_holder();

  // lense and light module holder
  translate([0, 0, z_lense_offset + h_oring]) {
    difference() {
      union() {
        // main lamp mass
        translate([0, 0, -z_lense_offset])
          cylinder(r2=r_o_lamp_head, r1=max(r_o_oring, +r_o_lamp_head),
                   h=h_lense+z_lense_offset);
        // center circle
        translate([r_lense_offset, r_lense_offset, -z_lense_offset])
          cylinder(r=r_lense, h=z_lense_offset);
      }
      for (sign1 = [-1, 1], sign2 = [-1, 1]) {
        translate([sign1 * (r_lense + r_lense_offset),
                    sign2 * (r_lense + r_lense_offset),
                    -z_lense_offset]) {
          cylinder(r=r_lense, h=h_lense+z_lense_offset + cutout);
        }
      }
    }
    for (sign1 = [-1, 1], sign2 = [-1, 1]) {
      translate([sign1 * (r_lense + r_lense_offset),
                  sign2 * (r_lense + r_lense_offset),
                  -(h_module_holder/2)])
        _led_module_holder();
    }
    for (sign1 = [-1, 1], sign2 = [-1, 1]) {
      translate([sign1 * (r_lense + r_lense_offset),
                  sign2 * (r_lense + r_lense_offset),
                  h_lense_lip_offset]) {
        _lense_holder();
      }
    }
  }
}

module led_module() {
  // body
  difference() {
    intersection() {
      cylinder(r=r_module + pitch_module/2, h=h_module+pitch_module/2);
      trapezoidThread(
          length=h_module,
          pitch=pitch_module,
          pitchRadius=r_module);
    }
    // through-hole wire
    for (sign = [-1, 1], sign2 = [-1, 1])
    translate([sign * x_offset_wire, 0, 0])
    translate([0, sign2 * y_offset_wire, 0])
    cylinder(r=r_wire, h=h_module+pitch_module + cutout, $fn=8);
    /*translate([0, sign * y_offset_wire, 0])*/
    /*cylinder(r=r_wire, h=h_module+pitch_module + cutout, $fn=8);*/
  }
  // knob
  rotate([0, 180, 0]) {

  for (sign = [-1, 1])
  translate([0, sign * y_offset_knob, h_knob/2])
    translate([0, 0, -h_knob/2])
        cube([thickness_knob, y_knob, h_knob], center=true);
  }

}

module print_lamp_head() { // make me
  rotate([180, 0, 0]) {
    2_lense_lamp_head();
    }
}

module print_led_module() { // make me
  /*for (sign1 = [-1, 1], sign2 = [-1, 1])*/
    /*translate([sign1 * r_lense, sign2 * r_lense, z_lense_offset/2])*/
      rotate([180, 0, 0])
      led_module();
}

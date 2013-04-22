use <lib/Thread_Library.scad>

function euclidean(a, b) = sqrt(pow(a, 2) + pow(b, 2));
cutout = 5; // extra dimensions to make clear difference() operations

module neon() {
  neon_r_o = 29/2;
  pi = 3.14159;

  module neon_spacer() {
    r_o1 = neon_r_o;
    r_i1 = 24/2;
    h1 = 4;
    r_o2 = 32/2;
    r_i2 = r_o2 - 5;
    h2 = 11;
    h_overlap = 3;

    $fn=50;
    difference() {
      cylinder(r=r_o1, h=h1+h_overlap);
      cylinder(r=r_i1, h=h1+h_overlap + cutout);
    }
    translate([0, 0, h1])difference() {
      cylinder(r=r_o2, h=h2);
      cylinder(r=r_o1, h=h2 + cutout);
    }
  }


  module neon_module() {
    r_o = neon_r_o;
    r_wireshaft = 2;
    y_groovemount = 2.5;
    x_groovemount = 1.5;
    x_offset_groovemount = 6/2;
    angle = 360 * x_offset_groovemount / (pi * 2*r_o);
    h = 18;

    difference() {
      cylinder(r=r_o, h=h, $fn=50);

      // part for wires
      translate([r_o, 0, 0])
        cylinder(r=r_wireshaft, h=h+cutout);
      translate([-r_o, 0, 0])
        cylinder(r=r_wireshaft, h=h+cutout);

      // part to attach into flashlight
      #translate([0, r_o - y_groovemount, 0])
        cube([x_groovemount, y_groovemount, h+cutout]);
      #rotate([0,0,angle])translate([0, -r_o, 0])
        cube([x_groovemount, y_groovemount, h+cutout]);
      #rotate([0,0,-angle])translate([0, -r_o, 0])
        cube([x_groovemount, y_groovemount, h+cutout]);
    }
  }

  $fn=20;
  translate([20 + 2*neon_r_o, 0, 0])
    neon_spacer();
  neon_module();
}


module blue() {
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

  r_o_oring = 96.5;
  r_o_oring_wall = r_o_oring - (6 - 2.5);
  r_i_oring_wall = r_o_oring_wall - 5;
  h_oring = 11;
  h_oring_wall = 10;

  r_lense = 53/2;
  h_lense = 16;
  r_lense_offset = 1; // distance from perimiter of lense to closest xy axis
  r_lense_lip = r_lense - 5;  // fit up to 2 glass lenses
  h_lense_lip = h_lense / 3;
  h_lense_lip_offset = h_lense / 3;
  z_lense_offset = 25;  // distance from top of oring to lenses

  pitch_module = 6;
  r_module = r_lense - pitch_module/2;
  h_module = 20;
  h_module_holder = 20;

  r_i_lamp_head = r_lense + euclidean(r_lense, r_lense);
  r_o_lamp_head = wall_thickness + r_i_lamp_head;

  h_AA_battery = 50.5;
  r_AA_battery = 14.5;  // TODO
  h_pad = 10;
  h_inset = h_pad/2;
  h_bolt_cutout = h_AA_battery + h_pad;
  r_bolt = 3.2;
  w_nut = 6;
  h_nut = 3;

  module _lamp_head_shell() {
    translate([0, 0, h_oring])
      difference() {
        cylinder(
            r1=r_o_oring_wall + wall_thickness,
            r2=r_o_lamp_head + wall_thickness,
            h=z_lense_offset + h_lense);
        cylinder(
            r1=r_o_oring_wall,
            r2=r_o_lamp_head,
            h=z_lense_offset + h_lense + cutout);
    }
  }

  module _lamp_head_innards() {
    // part that handle latches onto
    translate([0, 0, -z_handle_mnt]) {
      difference() {
        hull() {
          // main shaft
          translate([-x_handle_mnt/2, -y_handle_mnt/2, 0])
            cube([x_handle_mnt, y_handle_mnt, z_crossbar_cavity + z_crossbar]);
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

    // oring holder
    difference() {
      union() {
        translate([0, 0, h_oring_wall])
          cylinder(r=r_o_oring, h=h_oring - h_oring_wall);
        cylinder(r=r_o_oring_wall, h=h_oring_wall, $fn=94);
      }
      cylinder(r=r_i_oring_wall, h=h_oring+h_oring_wall + cutout);
    }

    // lense and light module holder
    translate([0, 0, z_lense_offset + h_oring]) {
      difference() {
        union() {
          // main lamp mass
          translate([0, 0, -z_lense_offset])
            cylinder(r2=r_o_lamp_head, r1=r_o_oring, h=h_lense+z_lense_offset);
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
      // module holders
      for (sign1 = [-1, 1], sign2 = [-1, 1]) {
        translate([sign1 * (r_lense + r_lense_offset),
                   sign2 * (r_lense + r_lense_offset),
                   -(h_module_holder)]) {
         difference() {
          cylinder(r=r_lense, h=h_module_holder);
          translate([0, 0, 0])
            // Call to external threaded rod making library
            trapezoidThreadNegativeSpace(
               length=h_module_holder + cutout,
               pitch=pitch_module,
               pitchRadius=r_module);
          }
        }
      }
      for (sign1 = [-1, 1], sign2 = [-1, 1]) {
        translate([sign1 * (r_lense + r_lense_offset),
                   sign2 * (r_lense + r_lense_offset),
                   h_lense_lip_offset]) {
          difference() {
            cylinder(r=r_lense, h=h_lense_lip);
            cylinder(r=r_lense_lip, h=h_lense_lip);
          }
        }
      }
    }
  }

  module lamp_head() {
    _lamp_head_innards();
    _lamp_head_shell();
  }

  module blue_module() {
    r_wire = 1;
    x_offset_wire = 5;
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
      for (sign = [-1, 1])
      translate([sign * x_offset_wire, 0, 0])
      cylinder(r=r_wire, h=h_module+pitch_module + cutout, $fn=8);
    }
    // knob
    h_knob = 10;
    y_knob = .3 * r_module;
    angle_offset_knob = 10;
    y_offset_knob = r_module / 2;
    thickness_knob = 3;
    rotate([0, 180, 0]) {

    for (sign = [-1, 1]) 
    translate([0, sign * y_offset_knob, h_knob/2])
      translate([0, 0, -h_knob/2])
          cube([thickness_knob, y_knob, h_knob], center=true);
    }

  }

  module battery() {
    cylinder(r=r_AA_battery, h=h_AA_battery);
    /*translate([0,0,h_AA_battery - 2])cylinder(r=3, h=2, center=true);*/
  }

  module _battery_cutouts() {
    // battery cutouts
    for (sign1 = [-1, 1], sign2 = [-1, 1])
      translate([sign1 * r_AA_battery, sign2 * r_AA_battery, h_pad/2])
      battery();
  }

  module battery_pack() {
    difference() {
        union() {
          // bottom pad
          translate([-2*r_AA_battery, -2*r_AA_battery, 0])
            cube([4*r_AA_battery, 4*r_AA_battery, h_pad]);
          // center pole
          cylinder(r=2*r_AA_battery, h=h_AA_battery + h_pad/2);
        }
       _battery_cutouts();
      // bolt cutout
      cylinder(r=r_bolt, h=h_bolt_cutout + cutout);
      //nut cutout
      translate([-w_nut/2, -w_nut/2, h_AA_battery])
        cube([2*r_AA_battery + w_nut/2, w_nut, h_nut]);
    }
  }

  module battery_pack_top_pad() {
    difference() {
    translate([-2*r_AA_battery, -2*r_AA_battery, h_AA_battery])
      cube([4*r_AA_battery, 4*r_AA_battery, h_pad]);
    _battery_cutouts();
    // bolt cutout
    cylinder(r=r_bolt, h=h_bolt_cutout + cutout);
    }
  }

    rotate([180, 0, 0]) {
      lamp_head();
      }

  /*for (sign1 = [-1, 1], sign2 = [-1, 1])*/
    /*translate([sign1 * r_lense, sign2 * r_lense, z_lense_offset/2])*/
      /*rotate([180, 0, 0])*/
      /*blue_module();*/

  /*battery_pack();*/
  /*rotate([180, 0, 0])*/
  /*battery_pack_top_pad();*/
}
/*neon();*/
blue();



/* basic idea */
module v1(n_twist=8, n_arms_mult=2, h=10, r=10, square_xy=[4,1]) {
  for (level=[0,1]) {
    for (ang=[0:360/n_twist:360]) {
      for (m=[1,1/n_arms_mult,2-1/n_arms_mult]) {
        for (ms=[-1,1]) {
          /* for (ith_arm=[0:1:n_arms]) { */
          translate([0,0,level*h])
            linear_extrude(
                height=h, center=false,
                twist=(360/n_twist )*(level % 2 == 0 ? 1 : -1))
            translate([r*sin(ang*m*ms), r*cos(ang*m*ms), 0])
            rotate([0,0,(360/n_twist*-1)*(level%2)])
            square(square_xy, center=true);
        }
        }
      }
    }
  }

  /* improved: num arms is cleaner. rotation correct */
  module v2(twist_deg, n_arms, n_segments, h_segment, r, square_xy=[1,1], t) {
    h_tip = 7.6;

    for (level=[0:1:n_segments-1])
      for (ang=[0:360/n_arms:360]) {
        si = ((level%2) == 0) ? 1 : -1;
        incr = (level%2)*twist_deg;
        incr2 = (level%2==0?1:0)*twist_deg;
        translate([0,0,level*h_segment+1*level]) {
          linear_extrude(
              height=h_segment - h_tip, center=false,
              twist=twist_deg*si)
            translate([r*sin(ang+incr), r*cos(ang+incr), 0])
            rotate([0,0,360-(ang+incr)])
            square(square_xy, center=true);

          translate([r*sin(ang+incr), r*cos(ang+incr), 0])
            rotate([180,0,360-(ang+incr)])
            tip(square_xy[0], square_xy[1], 3.6/2, h_tip/2, $fn=6);

#translate([r*sin(ang + incr2), r*cos(ang + incr2), h_segment-h_tip])
          rotate([0,0,360-(ang+incr2)])
            tip(square_xy[0], square_xy[1], 3.6/2, h_tip/2, $fn=6);
        }
      }
  }

  module tip(x, y, r_bolt, r_o) {
    translate([0,3/2,0])
      rotate([90,0,0])
      linear_extrude(height=y)
      difference(){
        union(){
          translate([0,r_o,0])circle(r=r_o, center=true);
          polygon([
              [-x/2,0],
              [0,2*r_o-.5],
              [x/2,0]]);
          /* polygon([ */
          /* [-x/2,-y/2], [-x/2,y/2], */
          /* [0,2*r_o], */
          /* [x/2,y/2], [x/2,-y/2]]); */
        }
        translate([0,r_o,0])circle(r=r_bolt);
      }
    /* } */
}

module lego_part(lx, ly, lz, l_ro, l_rbolt, a_r, a_deg) {
  translate([a_r*sin(a_deg),a_r*cos(a_deg),lz])
    rotate([0,0,-a_deg])
    tip(lx, ly, l_rbolt, l_ro, $fn=6);
  translate([a_r*sin(0),a_r*cos(0),0])
    mirror([0,0,1])tip(lx, ly, l_rbolt, l_ro, $fn=6);
  linear_extrude(height=lz, twist=a_deg)
    translate([a_r*sin(0), a_r*cos(0),0])square([lx, ly], center=true);
}
module v2_trellis() {
  // lego part dimensions
  lx = 8;
  ly = 3;
  lz = 20;
  l_ro = 7.6/2;
  l_rbolt = 3.6/2;
  // arm dimensions
  a_r = 15;
  a_deg = 90;

  module lego_1() {
    translate([0,0,l_ro])
      lego_part(lx, ly, lz, l_ro, l_rbolt, a_r, a_deg);
  }
  module lego_2() {
    translate([0,0,l_ro])
      lego_part(lx, ly, lz, l_ro, l_rbolt, a_r+ly, a_deg);
  }

  module segment(angle) {
    rotate(a=angle, v=[sin(0),cos(0),0])
      lego_1();
    /* rotate([0,90,0])lego_1(); */

    /* mirror([0,1,0])lego_2(); */
    translate([0,0,(lz+2*l_ro)]) {
      /* hull(){cube([1,1,1],center=true);translate([30*sin(a_deg), 30*cos(a_deg),0])cube([1,1,1],center=true);} */
      rotate(a=-angle, v=[sin(a_deg),cos(a_deg),0])
        translate([0,0,(lz+2*l_ro)])
          mirror([0,0,1])
            lego_2();
      }
  }
  segment(50);
  rotate([0,0,0])cube([1,1,lz+l_ro],center=false);
  /* translate([0,0,2*(lz+2*l_ro)])segment(); */
  /* { */
  /* lego_2(); */
  /* mirror([1,0,0])lego_1(); */
  /* } */
}
v2_trellis();


/* lego_part(lx, ly, lz, l_ro, l_rbolt, a_r, a_deg); */


/* v1(); */
/* v2( */
/* twist_deg=360/8, */
/* n_arms=10, */
/* h=10, */
/* r=10, */
/* square_xy=[4,1]); */

/* v2( */
/* twist_deg=45, */
/* n_arms=2, */
/* n_segments=6, */
/* h_segment=20, */
/* r=10, */
/* square_xy=[8,3], t=$t/100); */


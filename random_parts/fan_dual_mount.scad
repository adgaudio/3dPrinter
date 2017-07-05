module fan_mount(fan1_len, fan2_len, fan_bolt_d, bolt_hole_inset, arm_bolt_d, th, part_attachment_width) {
  l = fan1_len + fan2_len + part_attachment_width;
  fan_attachment_len = arm_bolt_d+2*th;
  fan_attachment_offset = bolt_hole_inset - th - arm_bolt_d/2;

  mid = l/2 - (fan2_len-fan1_len)/2;

  translate([-mid,0,0])cube([l, th, th]);
  // fan separator
  translate([-part_attachment_width/2,0,0])cube([part_attachment_width, max(fan1_len, fan2_len)/2, 3*th]);
  //arm connector piece
  _part_attachment(part_attachment_width, th, arm_bolt_d, (fan1_len > 0 && fan2_len > 0));
  //fan attachments
  if (fan2_len > 0) {
    translate([l-mid-fan_attachment_len-fan_attachment_offset,0,0])
      _fan_attachment(fan_attachment_len, fan_bolt_d, th);
    translate([part_attachment_width/2+fan_attachment_offset,0,0])
      _fan_attachment(fan_attachment_len, fan_bolt_d, th);
  // support piece
  cube([fan_attachment_offset+part_attachment_width/2, fan_attachment_len, th]);
  }
  if (fan1_len > 0) {
    translate([-mid+fan_attachment_offset,0,0])
      _fan_attachment(fan_attachment_len, fan_bolt_d, th);
    translate([-part_attachment_width/2-fan_attachment_len-fan_attachment_offset,0,0])
      _fan_attachment(fan_attachment_len, fan_bolt_d, th);
  // support piece
  translate([-fan_attachment_offset-part_attachment_width/2,0,0])
    cube([fan_attachment_offset+part_attachment_width/2, fan_attachment_len, th]);
  }

}
module _fan_attachment(fan_attachment_len, fan_bolt_d, th) {
  difference(){
    cube([fan_attachment_len, fan_attachment_len, th]);
    translate([fan_attachment_len/2, fan_attachment_len/2, -.1])
      cylinder(r=fan_bolt_d/2, h=th+1);
  }
}
module _part_attachment(width, th, arm_bolt_d, support=true) {
  x = width;
  z = arm_bolt_d+2*th;
  y = z+th;
  translate([-x/2,-y+th,0])
    difference(){
      union(){
        cube([x, y, z]);
        translate([0,0,z/2])rotate([0,90,0])cylinder(r=z/2,h=x, $fn=20);
      }
      translate([-.1, 0,z/2])rotate([0,90,0])cylinder(r=arm_bolt_d/2, h=x+1);
    }
  if (support)
    linear_extrude(th)polygon(points=[[-2*width,0],[2*width,0],[0,-y/2]]);
}


module arm(l, arm_bolt_d, th, part_attachment_width) {
  _part_attachment(part_attachment_width, th, arm_bolt_d, false);
  translate([part_attachment_width/-2,0,0])cube([part_attachment_width, l, arm_bolt_d+2*th]);
  translate([0,l,0])rotate([0,0,180])_part_attachment(part_attachment_width, th, arm_bolt_d, false);

}

module base(mount_bolt_d, arm_bolt_d, th, part_attachment_width) {
  x = mount_bolt_d+part_attachment_width+th*2;
  y = mount_bolt_d+th*2;
  _part_attachment(part_attachment_width, th, arm_bolt_d);
  difference(){
    translate([-x/2,0,0])cube([x, y+th, th]);
    translate([0,y/2+th,-.1])cylinder(r=mount_bolt_d/2, h=th+1);
  }
}

module print_all_parts(fan1_len, fan2_len, bolt_hole_inset) {
  arm_len=30;
  arm_bolt_d=3.6;
  fan_bolt_d=3.6;
  m5_bolt_hole_loose=5.8;
  th = 2;
  part_attachment_width = 2;

  fan_mount(fan1_len, fan2_len, fan_bolt_d, bolt_hole_inset, arm_bolt_d, th, part_attachment_width);
  translate([0,max(fan1_len, fan2_len)/2+th+1, 0]) rotate([0,0,90])
    arm(arm_len, arm_bolt_d, th, part_attachment_width);
  translate([fan1_len+m5_bolt_hole_loose+th+1,0,0])
    base(m5_bolt_hole_loose, arm_bolt_d, th, part_attachment_width);
}


module fan_mount_40() { // make me
  fan_mount(40, 0, 3.6, 4, 3.6, 2, 2);
}
module fan_mount_4040() { // make me
  fan_mount(40, 40, 3.6, 4, 3.6, 2, 2);
}
module fan_mount_6060() { // make me
  fan_mount(60, 60, 5.3, 5, 3.6, 2, 2);
}
module fan_mount_60() { // make me
  fan_mount(60, 0, 5.3, 5, 3.6, 2, 2);
}
module arm_30() {  // make me
  arm(30,3.6,2,2);
}
module arm_20() {  // make me
  arm(20,3.6,2,2);
}
module arm_40() {  // make me
  arm(40,3.6,2,2);
}
module base_m5() {  // make me
  base(5.8, 3.6, 2, 2);
}
module base_m3() {  // make me
  base(3.6, 3.6, 2, 2);
}

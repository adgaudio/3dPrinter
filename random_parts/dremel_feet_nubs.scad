// Dremel 220-01 Rotary Tool Workstation Drill Press Work Station with Wrench
// A small "foot" to support the dremel drill press.
//
// The base plate of the press scratches my floor and furniture
// This little plastic piece protects the floor/workbench from the metal plate
// of the drill press.
// Put a felt pad over the nut hole.
// Use M3 nut and 10mm bolt
// Don't forget to print 4 of them!


module dremel_foot_nub() {  // make me
  difference() {
    union(){
      cylinder(r=8/2, h=11);
      cylinder(r=10, h=5);
    }
    translate([0,0,-.1])cylinder(r=3.5/2, h=20.2, $fn=30);
    translate([0,0,-.1])cylinder(
      r=5.4/2 * tan(360/6/2) / sin(360/6/2), h=3, $fn=6);
    %cube([1, 5.4, 50], center=true);  // debug the nut hole
  }
}

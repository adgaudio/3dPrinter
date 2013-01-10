
difference() {
  linear_extrude(height=.4, center=true)square([50,10], center=true);
  #scale([.1,.1,.1])translate([-190,-185,0])linear_extrude(height=5, center=true)import("sailthru_logo.dxf");
}

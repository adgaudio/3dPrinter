module sailthru() {
  difference() {
    cube([191,36, 5], center=true);
    #scale([.4,.4,1])translate([-190,-185,0])linear_extrude(height=10, center=true)import("sailthru_logo.dxf");
  }
}
sailthru();

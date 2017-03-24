// mount
m_w = 15;
m_l = 27;
m_th = 6.1;

// cylinder section
c_do = 10;
c_di = 3.2;
c_h = 25;

// m3 bolt cutout
bolt_m3_r = 3/2;


translate([0,c_do/2,0])
difference() {
cylinder(r=c_do / 2, h=c_h, center=true, $fn=50);
cylinder(r=c_di / 2, h=c_h+.1, center=true, $fn=7);
}

translate([(m_l-c_do)/2,0,0])
difference(){
cube([m_l, m_th, m_w], center=true);
rotate([90,0,0])cylinder(r=bolt_m3_r, h=m_th+1, center=true, $fn=6);
translate([m_l/3,0,0]) rotate([90,0,0])cylinder(r=bolt_m3_r, h=m_th+1, center=true, $fn=5);
}

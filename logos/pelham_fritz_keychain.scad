font=6;

union(){
translate([font*.4, .8, 0])
linear_extrude(height = 2)
text("PELHAM FRITZ", font, "Lato Black", spacing=1);
translate([0,-1,0])
cube([font*10.5, 2, 2]);
translate([0, -font-.8, 0])
linear_extrude(height = 2)
text("3D EXPERIENCE", font, "Lato Black", spacing=1);

translate([-4.9,0,0])difference(){
cylinder(r=5, h=2);
translate([0,0,-.5])cylinder(r=3, h=3);
}
}

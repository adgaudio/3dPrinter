include <BOSL2/std.scad>

module flower_pot_container_large() {  // make me
    r=150/2;
    h=140;
    path = circle(r=r);
    linear_sweep(
        path, texture="diamonds", tex_size=[20,40],
        h=h, style="concave");
}

module flower_pot_container_medium() {  // make me
    r=100/2;
    h=100;
path = circle(r=r);
linear_sweep(
    path, texture="trunc_pyramids", tex_size=[20,40], tex_depth=4,
    h=h, style="concave");
}

// pot_large();
// pot_medium();


module _insert_mainbody(r, h, th, h_max_water_level, w_watering_arm, is_inside) {
    // fn to get the heights of the bottom portion.  (note: it's zflipped)
    function h_z(x,y) =  5+h_max_water_level/2+h_max_water_level/2*1.5*pow(cos(360*x*.25 * 2.75),1)*pow(cos(360*y*.25 * 2.75 +0), 1);
    // inner cylinder
    bot_of_insert = up(h_max_water_level, p=path3d(circle(r=r-(is_inside?th:0))));
    top_of_insert = up(h, p=path3d(circle(r=r-(is_inside?th:0))));
    skin(
        [bot_of_insert, top_of_insert],
        method="distance", slices=10, refine=10);
        // the "funnel" shapped bottom - more like sine waves
        intersection() {
            up(h_max_water_level)zflip()heightfield(size=[2*r, 2*r], data=function(x,y) h_z(x,y), bottom=0);
            cylinder(h=h_max_water_level,r=r-(is_inside?th:0));
        }
}

module _insert(r,h,th,h_max_water_level, w_watering_arm, is_inside=false) {
    d_hole = 4;
    // ... compute the region where the holes can exist.  has knowledge of hole
    // size and of watering arm location
    c = circle(r=r-th-d_hole);
    s = zrot(0, p=move([r,0,0], p=square([(w_watering_arm+2*th+d_hole*2)*2,2*th+d_hole*2+w_watering_arm], center=true)));
    holes_region = difference(c, s);

    // make the insert object
    diff("watering_arm_hole holes") {
        _insert_mainbody(r,h,th,h_max_water_level, w_watering_arm, is_inside);
        // grid_copies(n=6, r=r/2 + r/4) down(1)cylinder(r=2, h=h+1+1);
    
        // watering arm coming up side
        zrot(0)
        right(r) {
            tag("watering_arm_hole")
            down(1)cuboid([(w_watering_arm+(is_inside?th:0))*2, w_watering_arm+2*(is_inside?th:0), h+2], anchor=BOT, rounding=5, except=[TOP,BOT]);
        }
        if (!is_inside) {
        // holes
        tag("holes")
        grid_copies(spacing=15, stagger=true, inside=holes_region) {
           down(1)cylinder(d=d_hole, h=h, $fn=6);
       }
        }
    }
}
// module _inner(r, h) {
// }
module flower_pot_insert_large() {  // make me
    r = 142/2;
    h = 140;
    th=2;
    h_max_water_level = 50;
    w_watering_arm = 40;
    difference(){
    _insert(r,h,th,h_max_water_level, w_watering_arm, false);
    up(th+2)_insert(r,h,th,h_max_water_level, w_watering_arm, true);
    }
}
module flower_pot_insert_medium() {  // make me
    r=(100-8)/2;
    h=100;
    th=2;
    h_max_water_level = 40;
    w_watering_arm = 20;
    difference(){
    _insert(r,h,th,h_max_water_level, w_watering_arm, false);
    up(th+2)_insert(r,h,th,h_max_water_level, w_watering_arm, true);
    }
}


flower_pot_insert_large();
// flower_pot_insert_medium();

include <BOSL2/std.scad>

fa=$preview?1:.5;
fs=$preview?1:.5;

module flower_pot_container_large() {  // make me
    r=150/2;
    h=140;
    path = circle(r=r, $fa=fa, $fs=fs);
    linear_sweep(
        path, texture="diamonds", tex_size=[20,40],
        h=h, style="concave");
}

module flower_pot_container_medium() {  // make me
    r=100/2;
    // r=100/2 - 3/2; // TODO: temp hack to get 1st attempt original to fit snugly work.
    h=100;
path = circle(r=r, $fa=fa, $fs=fs);
// texture="trunc_pyramids", tex_size=[20,40]
// texture="trunc_pyramids", tex_size=[5,5]
// cubes dots hex_grid
// tri_grid
// // the R+K grid:   texture=tex,  tex_size=[40,20], tex_depth=1,
// tex = [
//     [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
//     [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
//     [0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
//     [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
//     [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
// ];
tex = texture("dimples");
linear_sweep(
    path,
    // texture="trunc_pyramids", tex_size=[5,5], tex_depth=2,
    // texture="cubes", tex_size=[30,50], tex_depth=8,
    texture=tex,  tex_size=[20,20], tex_depth=2, tex_inset=-1,
    h=h, style="concave");
}

// pot_large();
// pot_medium();


module _insert_mainbody(r, h, th, h_max_water_level, w_watering_arm, is_inside) {
    // fn to get the heights of the bottom portion.  (note: it's zflipped)
    function h_z(x,y) =  5+h_max_water_level/2+h_max_water_level/2*1.5*pow(cos(360*x*.25 * 2.75),1)*pow(cos(360*y*.25 * 2.75 +0), 1);
    // inner cylinder
    bot_of_insert = up(h_max_water_level, p=path3d(circle(r=r-(is_inside?th:0), $fa=fa, $fs=fs)));
    top_of_insert = up(h, p=path3d(circle(r=r-(is_inside?th:0), $fa=fa, $fs=fs)));
    skin(
        [bot_of_insert, top_of_insert], slices=10
        );
        // method="distance", slices=10, refine=10);
        // the "funnel" shapped bottom - more like sine waves
        intersection() {
            up(h_max_water_level)zflip()heightfield(size=[2*r, 2*r], data=function(x,y) h_z(x,y), bottom=0);
            cylinder(h=h_max_water_level,r=r-(is_inside?th:0), $fa=fa, $fs=fs);
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
    r = (150-6)/2;
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
    r=(100-5)/2;
    tex_depth = 8;
    h=100-tex_depth/2;
    th=2;
    h_max_water_level = 40;
    w_watering_arm = 20;
    diff("remove"){
    _insert(r,h,th,h_max_water_level, w_watering_arm, false);

    // add rim on top based on tex_depth;
    up(h)tube(or=r+tex_depth-2, ir=r-th, h=tex_depth, ochamfer1=tex_depth-2, orounding2=2, $fa=fa, $fs=fs, anchor=BOT);

    tag("remove")up(th+2)_insert(r,h,th,h_max_water_level, w_watering_arm, true);
    }
}


// ECHO: "ribs", "texture_is_2d", 0, 1
// ECHO: "trunc_ribs", "texture_is_2d", 0, 1
// ECHO: 0.25, 0.5, 0.75, 1.25  // (...noise caused by trunc_ribs_vnf)
// ECHO: 0.25, 0.5, 0.75, 1.25  // (...noise caused by trunc_ribs_vnf)
// ECHO: 0.25, 0.5, 0.75, 1.25  // (...noise caused by trunc_ribs_vnf)
// ECHO: "trunc_ribs_vnf", "texture_is_3d", 0, 1
// ECHO: "wave_ribs", "texture_is_2d", 0, 1
// ECHO: "diamonds", "texture_is_2d", 0, 1
// ECHO: "diamonds_vnf", "texture_is_3d", 0, 1
// ECHO: "pyramids", "texture_is_2d", 0, 1
// ECHO: "pyramids_vnf", "texture_is_3d", 0, 1
// ECHO: "trunc_pyramids", "texture_is_2d", 0, 1
// ECHO: "trunc_pyramids_vnf", "texture_is_3d", 0, 1
// ECHO: "hills", "texture_is_2d", 0, 1
// ECHO: "bricks", "texture_is_2d", -0.0241379, 0.524828
// ECHO: "bricks_vnf", "texture_is_3d", 0, 1
// ECHO: "checkers", "texture_is_3d", 0, 1
// ECHO: "cones", "texture_is_3d", 0, 1
// ECHO: "cubes", "texture_is_3d", 0, 1
// ECHO: "trunc_diamonds", "texture_is_3d", 0, 1
// ECHO: "dimples", "texture_is_3d", -1, 1
// ECHO: "dots", "texture_is_3d", 0, 1
// ECHO: "tri_grid", "texture_is_3d", 0, 1
// ECHO: "hex_grid", "texture_is_3d", 0, 1
// ECHO: "rough", "texture_is_2d", 0.000396749, 0.199996


flower_pot_container_medium();
// flower_pot_container_large();
// flower_pot_insert_large();
// flower_pot_insert_medium();

include <BOSL2/nurbs.scad>
include <BOSL2/std.scad>

$fa=1;
$fs=1;
// %up(1)up(12.35)import("Garmin_to_Quadlock.stl");
// down(16.5)import("QuadLockMag.stl");

magnet_h = 1.6;
r_ring = 59.5/2;
module pieSlice(a, r1, r2, h){
    // probably more complicated than necessary, but it's all curved and it
    // prints nicely and works well too.
  // a:angle, r:radius, h:height
  // square([r,h]);
  // rotate_extrude(angle=a) 
  // rect([r,h], rounding=rounding, anchor=FRONT+LEFT);
  bias = .33;
  shapes = [for(ij=[[.5+bias,0], [1+bias,.2], [1+bias, .8], [.25+bias, 1]])
      path3d(nurbs_curve([
          [0,0], [r2*(ij[0]*.1+.9),0], [r1*(ij[0]*.1+.9),1],
          [r1*(ij[0]*.1+.9)*cos(a), r1*(ij[0]*.1+.9)*sin(a)],
          [r2*(ij[0]*.1+.9)*cos(a), r2*(ij[0]*.1+.9)*sin(a)] ],
          2, type="closed", splinesteps=6), ij[1]*h)];

  skin(shapes, slices=0);
}

module part1() {
down(1.5+1.5){
cylinder(r=15.75, h=1.5+1.5);
zrot_copies(n=4, sa=-asin(12/2/17.5)) {
// pieSlice(r1=17.5, r2=15.75, h=1.5, a=2*asin(12/2/17.5));
pieSlice(r1=17.5, r2=15.75, h=3, a=2*asin(12/2/17.5)*.2);
hull(){
pieSlice(r1=17.5, r2=15.75, h=2, a=2*asin(12/2/17.5)*.2);
zrot(2*asin(12/2/17.5)*.8)pieSlice(r1=17.5, r2=15.75, h=1.5, a=2*asin(12/2/17.5)*.2);
}
}
// pie_slice(r1=16.5, r2=17.5, h=h/2, ang=2*asin(12/2/17.5), rounding=1);
}
}

module _quadlock_wallet_sleeve() {
    x=3.375*2.54 * 10;
    y=2.125*2.54 * 10 + 1;
    _z=0.76;
    z = 3.9 *_z + 1.8 + 1;  // must be a bug, because 3*_z only fits 2 cards
    r=z/2;
    left(x/2-27 - 3)up(z/2) {
    diff("credit_cards thumb_slot recess_for_connectors"){
        hull(){
        // right(x/2)xrot(90)cyl(r=r, h=y);
        left(x/2)xrot(90)cyl(r=r, h=y);
        fwd(y/2)yrot(90)cyl(r=r, h=x);
        back(y/2)yrot(90)cyl(r=r, h=x);
        }

        tag("credit_cards")
        up(1.8)down(_z*3.2/2)left(x/2)yrot(90)zrot(90)prismoid(
        size1=[y, _z*2.5], size2=[y,_z*3.2], h=x, anchor=BOT, rounding2=1);

        tag("thumb_slot")
        left(x/2+r)hull(){
            cyl(r=10, h=z, rounding=-1.5);
            right(10)cyl(r=10, h=z, rounding=-1.5);
        }

    }
    }
}
module wallet_head(optional_magnet=false) {  // make me
part1();

cylinder(r=15.75, h=1.8 * (2/3));

angles = optional_magnet? [

    -45*19/3,
    -45*20/3,
    -45*21/3,
    -45*22/3,
    -45*18/3,
    -45*17/3,
    -45*16/3,-45*15/3,
    -45*14/3,-45*13/3,
    -45*12/3,-45*11/3,
    -45*10/3,-45*9/3,-45*8/3,-45*7/3,
    -45*6/3, -45*5/3, -45*4/3,-45,-45/3*2,-45/3,0,45/3] : [-45/3,0,45/3];
// insert goes inside the wall of the sleeve
up(1.8/3) {
    cylinder(r=20, h=1.8/3);
    for (ang = angles) {
    zrot(ang) {
        hull(){
            left(20)cylinder(r=3, h=1.8 * (1/3));
            if (optional_magnet) {
            left(53/2)down(1.8/3/2)cylinder(r=4.4/2, h=1.555);
            } else {
            left(53/2-4.4)down(1.8/3/2 - 1.8/3)cube([4.4,4.4,1.8/3], center=true);
            }
        }
        // tag("optional_magnet")left(53/2)down(.025 + 1.8/3/2)cylinder(r=4/2, h=1.55+.05);
    }
    }
}
}

module wallet_sleeve() {  // make me
    difference() {
        _quadlock_wallet_sleeve();
        wallet_part1(optional_magnet=true);
    }
}



// debugging 
// part1();
// wallet_head1(false);
// wallet_head1(true);


// wallet_head();
// wallet_sleeve();

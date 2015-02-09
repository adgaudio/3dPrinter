r_i = 6.5 /2;
r_o = 9.9 /2;
lense_width = 6/2;
h=6;

module laser_module_insert() {  // make me
  // this retrofits cheap-o 5mw laser modules to fit inside
  // standard 12mm laser module blanks from AixiZ

  // I stick a spring in the compartment to push the anode towards an
  // end of the blank

  // blanks:  http://amazon.com/AixiZ-30mm-laser-module-blanks/dp/B004LZHA0I/ref=sr_1_1?ie=UTF8&qid=1423438907&sr=8-1&keywords=laser+module+blank
  // laser module: http://www.nyplatform.com/index.php?route=product/product&filter_name=laser&product_id=545

  // DISCLAIMER: Plastic melts.  Lasers can get hot.  Lasers blind you.
  // I take NO RESPONSIBILITY for anything that
  // happens if you use this laser module insert.  Know what you're doing!

  difference() {
    cylinder(r=r_o, h=h, center=true, $fn=40);
    translate([0, 0, -h/2 + .5])
      cylinder(r=lense_width, h=1+1, center=true, $fn=40);
    translate([0, 0, .5 + .5])
    cylinder(r=r_i, h=h, center=true, $fn=40);
  }
}

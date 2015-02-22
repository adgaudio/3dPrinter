3dPrinter - The software side to building and using your own 3d printer!
---

This repo contains a collection of openscad parts I've designed.  Some
of them are posted on Thingiverse.


`lib` Openscad modules that I use to facilitate designing prints.
`external` Other people's libraries that I also depend on.
`gears` A small collection of gears and an enclosure box for them.
`dive_lights` Inserts and experiments with scuba lights. I proposed with these!
`random_parts` An unorganized collection of one-off projects and small parts.


Check out gettingStarted.sh for install notes I follow to install the
software that I use on my reprap.


To convert a .scad file to .STL, you can use this handy python script:

```
$ ./openscad_maker.py my_file.scad
```

You can also export one stl file for each selected function in your scad file:

```
$ ./openscad_maker my_file.scad --modules function1 function2

```

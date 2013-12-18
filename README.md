3dPrinter - The software side to building and using your own 3d printer!
---

This repo contains a collection of openscad parts I've designed.  Some
of them are posted on Thingiverse.


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

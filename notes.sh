echo "get arduino and start it"
git clone git://github.com/arduino/Arduino.git
(cd Arduino ; git checkout 1.0.1 ; cd build ; ant ; ant run)

echo "get marlin firmware"
git clone git@github.com:ErikZalm/Marlin.git
(cd Marlin ; git checkout Marlin_v1 ) echo see github for readme

echo "get slic3r"
(mkdir slic3r ; cd slic3r ;
 wget http://dl.slic3r.org/linux/slic3r-linux-x86_64-0-9-3.tar.gz ;
 tar xvzf slic3r-linux-x86_64-0-9-3.tar.gz)

#echo "get skeinforge"
#(mkdir skeinforge ; cd skeinforge ;
 #wget $(curl http://fabmetheus.crsndoo.com/rss.xml | tr -s '<>' "\n"|grep http|grep files|head -n 1)
 #unzip *.zip
#)

# to get replicatorg software (not complete)
#(wget URL ; tar xvzf FILE ################################################3
#git init ; git add * ; git commit -am "initial commit.")
# -- edit machines/Ultimachine.xml
# -- set baudrate to 250000o

echo "get printrun (and link it with skeinforge)"
git clone https://github.com/kliment/Printrun.git
(cd Printrun ; ln -s ../skeinforge . )

echo "FIRST, You will need to customize your firmare by tweaking Configuration.h for your reprap."
echo "Be sure to calibrate motors, make sure temperature and pid settings work, etc"
echo "After configuration, upload marlin firmware using arduino software"
echo "-- in arduino IDE, open Marlin/Marlin/Marlin.pde"
echo "-- upload to arduino board"
echo ""
echo "SECOND, After the firmware is calibrated, you will need to spend a lot of time"
echo "adjusting Slic3r/Skeinforge settings.  Both Slic3r and Skeinforge do the "
echo "same thing, so you must choose one of them to generate gcode from an stl file"
echo "I recommend Slic3r over Skeinforge."
echo ""
echo "THIRD, You may want to learn how to use 3d modeling software like blender."
echo ""
echo "Have fun!"
python Printrun/pronterface.py
./slic3r/bin/slic3r


#echo "3D modeling with opencascade. You will have to install dependencies and resolve problems. But this is the general way to do it."
#echo git clone https://github.com/tpaviot/oce.git
#echo (cd oce && git checkout OCE-0.9.1 && cmake . && make && sudo make install/strip)
#echo git clone https://github.com/tpaviot/pythonocc.git
#echo (cd pythonocc/src/contrib/geom-* && cmake . && make && make install)
#echo (cd pythonocc/src/contrib/smesh-* && cmake . && make && make install)
#echo (cd pythonocc/src && python setup.py build && python setup.py install)
#echo " OR "
#echo sudo apt-get install blender




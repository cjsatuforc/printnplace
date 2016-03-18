use <extrusions.scad>
use <ymotor.scad>

module ecylinder(r,h,$fn,ext){
cylinder(r=r,h=h,$fn=$fn);
if(ext[0]!=0){
	translate([ext[0],0,0])cylinder(r=r,h=h,$fn=$fn);
	translate([ext[0]/2,0,h/2])cube([abs(ext[0])-2*r,2*r,h],true);
}
if(ext[1]!=0){
	translate([0,ext[1],0])cylinder(r=r,h=h,$fn=$fn);
	translate([0,ext[1]/2,h/2])cube([2*r,abs(ext[1]),h],true);
}
if(ext[2]!=0){
	translate([0,0,-abs(ext[2])])cylinder(r=r,h=h+abs(ext[2]),$fn=$fn);
}
}

module advpin(){mirror([0,1,0]){
	cube([4,42,5],true);
	translate([0,20.9,0])rotate([-90,0,0])cylinder(r=1,h=44.1);}
	
}

module ycarriage(){
difference(){translate([0,-5,0])union(){
cube([110,100,5],true);
translate([0,0,3.5])cube([67,100,4],true);
translate([0,-30.1,3.5])cube([100,10,4],true);
translate([0,-45,6])cube([100,10,8],true);
translate([0,0,7.5])cube([61.5,100,7],true);
translate([4,-32.5,15])cube([16,35,20],true);

}

translate([7,-36.7,24.0])cube([36,24,20],true);
translate([0.5,-37.1,24.0])cube([3,36,20],true);

translate([10,70,4.5])rotate([90,0,0])cylinder(r=5.2,h=150);
translate([10-5.2,-80,4.7])cube([10.4,150,5.2]);
translate([-7,0,4.7])cube([4.2,150,10],true);
#translate([-14.30,0,9.7])cube([4.2,150,5.2],true);
translate([0,-10,0])cylinder(r=2.5,h=30,$fn=20);
for(i=[-28,28])for(j=[-22.5,22.5])translate([i,j,-.5])rotate([0,0,0]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}

translate([10,-40,15])rotate([0,0,360/16])cylinder(r=1.7,h=30,center=true,$fn=8);
translate([10,-35,15])rotate([0,0,360/16])cylinder(r=1.7,h=30,center=true,$fn=8);
translate([-44.5,10,-20])cylinder(r=2.5,h=30);
translate([44.5,10,-20])cylinder(r=2.5,h=30);
for(i=[-20,20])translate([i,0,5]){
rotate([90,0,0])rotate([0,0,22.5])cylinder(r=2.3,h=115,center=true,$fn=8);
translate([0,26,0])cube([7.3,4.3,20],true);
}
translate([0,-5,0])difference(){cube(120,center=true);
cylinder(r=60,h=130,center=true);
}
}
}

translate([40,0,14.5])ycarriage();

module lservox(ext=[0,0,0]){
translate(ext/2)translate([-2.25,0.7,0])cube([23+abs(ext[0]),23.7+abs(ext[1]),12.7+abs(ext[2])],true);
translate([4.6-16.9+4.6,0,0])cube([2.87,34.3,12.7],true);
translate([-23.7/2-4.95,-23.7/2+6.5,0])rotate([0,90,0])ecylinder(r=12/2,h=10,ext=ext);
translate([-23.7/2-12.95+4,-23.7/2+6.5,0])rotate([0,90,0])ecylinder(r=8.5/2,h=8.8,ext=ext);
#translate([-23.7/2-13.95-6+3.5,-23.7/2+6.5,0])rotate([0,90,0])ecylinder(r=8/2,h=4.45,ext=ext);
translate([-23.7/2-15.5+3.5,-23.7/2+6.5,0])rotate([0,90,0])ecylinder(r=21/2,h=3.5,ext=ext);
translate([-23.7/2-4.95,1,0])rotate([0,90,0])ecylinder(r=6.5/2,h=10,ext=ext);
}

module zmotor(){
	difference(){
	union(){
		translate([40,71,24])cube([32,52,4],true);
		translate([40,47,19])cube([60,4,14],true);
		translate([40,49,-21])cube([20,4,90],true);
		translate([40,52,-21])cube([4,10,90],true);
		translate([40,52+5.5,16])cube([4,10,20],true);
	}
	translate([50,47.5,17])rotate([-90,0,0])cylinder(r=5,h=30,center=true);
	translate([52,47.5,13])rotate([-90,0,0])cylinder(r=5,h=30,center=true);
	translate([30,47.5,17])rotate([-90,0,0])cylinder(r=5,h=30,center=true);
	translate([28,47.5,13])rotate([-90,0,0])cylinder(r=5,h=30,center=true);
	translate([40,80,22])nema14(true);
	for(i=[60,20])translate([i,47.5,20])rotate([-90,0,0])rotate([0,0,22.5]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}
	for(i=[-6,6])for(j=[-1,0,1])translate([40+i,47.5,12-25-j*10])rotate([-90,0,0])rotate([0,0,22.5]){cylinder(r=1.8,h=30,center=true,$fn=8);

}
#translate([40+6,47.5,12-54])rotate([-90,0,0])rotate([0,0,22.5]){cylinder(r=1.8,h=30,center=true,$fn=8);

}
#translate([40+6,47.5,12-54-22])rotate([-90,0,0])rotate([0,0,22.5]){cylinder(r=1.8,h=30,center=true,$fn=8);

}


	}
}

*zmotor();


%translate([0,43.8,0])cube(7.5,center=true);
translate(){
*translate([0,-108,-1])cube([10,68,1]);
*translate([10,-108,-1])cube([10,28,1]);
%translate([40,80,26]){translate([0,-90,0])cylinder(r=8,h=18);
hull(){
cylinder(r=7,h=18);
translate([0,-90,0])cylinder(r=7,h=18);

}
translate([0,0,-4])nema14(false);
}
%*translate([0,-50,52])cube([100,100,5]);
%translate([48.3,-36,35])rotate([0,180,180])lservox();
*translate([30+13-17.4,-14,36+2.5-14.5])advpin();
*#translate([30+13-17.4,-14-31,16])advpin();


%translate([-1.5,0,4]){translate([9.5,-58,33]){rotate([90,0,180])hsnema8(true);
translate([0,-2,0])rotate([90,0,0])cylinder(r=19/2,h=48);
}
translate([-3,-30,13]){rotate([0,0,90])drylinn27(80);
%translate([0,40,-20])cylinder(r=2.5,h=30);
}
}


*translate([80.5,0,4])mirror([1,0,0]){
translate([9.5,-58+60,33]){rotate([90,0,180])hsnema8(false);
translate([0,-2,0])rotate([90,0,0])cylinder(r=19/2,h=48);
}
translate([-4,-30,13])rotate([0,0,90])drylinn27(80);
}

}



module zcarriage(){translate([0,30,0])difference(){
union(){
translate([-3,-28,26.5])cube([21,7,21]);
translate([-10,-28,26.5])cube([10,30,5]);
translate([-10,-8,26.5])cube([40,12,5]);
translate([2,-8,26.5])cube([12,3,20]);
translate([27,-2,26.5])cube([12,6,20]);
translate([10,0,26.5])cube([8,38,5]);

}

for(i=[-3,-23])#translate([-5,i,24.5]){
cylinder(r=3.3,h=10);
translate([0,0,7.1])cylinder(r=4.4,h=18);
}

translate([33.5,-10,31])cube([1.66,100,16]);
translate([23,0.5,40])rotate([0,90,0])cylinder(r=1.7,h=12,$fn=16);

translate([-1.5,0,4])translate([9.5,-58,33])rotate([90,0,180]){hsnema8(true);
translate([0,0,45])cylinder(r=4.5,h=10);
}
}

}



*%drylinn80(160);
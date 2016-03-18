use <extrusions.scad>
use <echain.scad>


*%translate([40,-5,24])rotate([0,0,90])color("grey",0.2)profile4020(115);
*%drylinn80(100,0);

module gt2lock(){difference(){cube([22,6,2],true);
for(i=[-13.5/2,13.5/2])translate([i,0,0])rotate([0,0,360/16])cylinder(r=2.1,h=30,center=true,$fn=8);
#for(i=[0:4])translate([0,-5+i*2,2-0.8])cube([8,1.2,3],true);
}
}
*translate(){
gt2lock();
translate([10,10,0])gt2lock();
translate([-0,20,0])gt2lock();
translate([10,30,0])gt2lock();
}
translate([40,0,15])xcarriage();

module xcarriage(){difference(){
union(){color("yellow",0.5)translate([0,0,-2.5/2])cube([68,55,2.5],true);
translate([0,8,7.45])cube([48,40,15],true);
translate([-13,-12,10])cube([8.2,4,25],true);
translate([13,-12,10])cube([8.2,4,25],true);
translate([0,-22.5,10])cube([28,3,25],true);
}

#for(i=[5.5,19])for(j=[13,-13])translate([j,0,i])rotate([90,0,0])rotate([0,0,360/16])cylinder(r=1.8,h=30,center=true,$fn=8);


translate([0,20,9])cube([40.5,50,20.1],true);
translate([0,22.5,9])cube([34,65,20.1],true);
translate([0,20,9])cube([18,75,20.1],true);
for(i=[-28,28])for(j=[-22.5,22.5])translate([i,j,-.5])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}


for(i=[0,20])for(j=[0,1])mirror([j,0,0])translate([22,i,9])rotate([0,90,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}

}
}
%translate([50,0,35])echain(37.4,15,20,18,16,0);
%translate([0,-22.5,27]){

translate([0,-13/2,0])cube([200,2,10],true);
translate([0,13/2,0])cube([200,2,10],true);

}



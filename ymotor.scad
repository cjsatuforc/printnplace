use <extrusions.scad>
xpos=0;
ypos=0;

module ymotor(){mirror([0,0,1])difference(){translate([0,-20,0])cube([42,75,5]);
translate([-20,20,-1])cube([42,75,8]);
#translate([21,1,0])nema17(true);
%translate([32,22,-40])rotate([90,0,90])profile8020(160);
for(j=[0,20])translate([32,30+j,2])mirror([0,0,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}
}
}
rotate([0,180,0])ymotor();

*translate([21.5,90,6])rotate([0,0,-90])yidler();

module yidler(){
translate([0,2.5,-16])difference(){
union(){translate([0,2,-2])cube([15,32,24],true);
translate([0,-2,5])cube([38,20,5]);
#translate([0,8,11.5])rotate([90,0,0])difference(){cube([15,5,19],true);
translate([0,-19.51,0]){translate([0,18.5,12.5])cube([31,3,21],true);
translate([0,20,15.5])cube([31,3,21],true);
translate([0,18.5,-12.5])cube([31,3,21],true);
translate([0,20,-15.5])cube([31,3,21],true);
translate([0,22.5,0])cube([31,3,21],true);
}
}

}
translate([0,-3,-4])cube([17,18,11],true);
#translate([0,-3,-1])mirror([0,0,1]){rotate([0,0,22.5])cylinder(r=2.5,h=20,center=true,$fn=8);
translate([0,0,11.6])rotate([0,0,22.5])cylinder(r=4.5,h=4,center=true,$fn=8);}

for(i=[15,30])#translate([i,10.5,18])mirror([0,0,1]){translate([0,-2.5,0])rotate([0,0,22.5])cylinder(r=2.5,h=20,center=true,$fn=8);
translate([0,-2.5,11.6])rotate([0,0,22.5])cylinder(r=4.5,h=4,center=true,$fn=8);}
}
}

module yidleranchor(){
translate([6,0,-16])difference(){
cube([30,39,19],true);
translate([7,-3,0])cube([30,39,10],true);
translate([14,-10,0])rotate([0,0,-35])cube([30,49,22],true);
for(i=[0,10])translate([i,23.7,0])rotate([90,0,0]){
translate([0,0,0])rotate([0,0,22.5])cylinder(r=2.5,h=20,center=true,$fn=8);
translate([0,0,7.6])rotate([0,0,22.5])cylinder(r=4.5,h=4,center=true,$fn=8);
}
for(i=[14,-14])translate([-17.4,i-2,-1])rotate([0,90,0]){
translate([0,0,0])rotate([0,0,22.5])cylinder(r=2.5,h=20,center=true,$fn=8);
translate([0,0,7.6])rotate([0,0,22.5])cylinder(r=4.5,h=4,center=true,$fn=8);
}

}

}



translate([0,0,7.5])rotate([0,-90,0])yidler();

*translate([120,0,3])rotate([0,-90,0])yidleranchor();
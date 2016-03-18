use <extrusions.scad>

%translate([31,11+4.5,40])rotate([0,90,0])profile2020();
%translate([31,111+4.5,40])rotate([0,90,0])profile2020();

module xidlerblock(){
translate([-20,0,0])mirror([0,1,0])rotate([0,0,-90])difference(){
translate([0,3,0])cube([12,37,21],true);
translate([0,-14.5+17,0])cube([16,18,11],true);
*translate([-10,-21.5,0])rotate([0,0,35])cube([16,18,11],true);
for(i=[-14.5+17,20-2.5])translate([0,i,0]){translate([0,0,0])rotate([0,0,22.5])cylinder(r=2.5,h=22,center=true,$fn=8);
translate([0,0,9.6])rotate([0,0,22.5])cylinder(r=4.5,h=4,center=true,$fn=8);
}
#translate([1.5,-8,0])rotate([0,-90,0]){
translate([0,-2.5,-10])rotate([0,0,22.5])cylinder(r=2.5,h=40,center=true,$fn=8);
translate([0,-2.5,7.6])rotate([0,0,0])cylinder(r=8.3/2,h=4,center=true,$fn=6);
}

}

}



module xidler(){
%translate([33.5,-8,16])rotate([0,0,20])xidlerblock();
%translate([33.5,-8,16])rotate([0,0,-3])xidlerblock();
difference(){
translate([-11.1,-21,0])cube([52,42,32]);
translate([31,11+4.5,40])rotate([0,90,0])cube([100,20,20],true);
translate([-15,-42,5])cube([60,44,40]);
translate([-35,-42,-5])cube([60,44,40]);
translate([-34,6,-5.5])cube([50,44,40]);
translate([-34,1,22.5])cube([50,44,40]);
translate([-4.5,1,13.5])cube([18,10,5]);



#translate([31,-8,8])rotate([0,0,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
*cylinder(r=4.5,h=30,$fn=8);
}
for(i=[0,20])translate([17,11+4.5,26-i])rotate([0,-90,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}
}
}



module xmotormount(){difference(){
translate([-21.1,-21,0])cube([62,42,32]);
translate([-35,-22,4.5])cube([50,44,40]);
translate([-5,-42,4.5])cube([50,44,40]);
translate([22,-42,-5.5])cube([50,44,40]);
translate([31,11+4.5,40])rotate([0,90,0])cube([100,20,20],true);

translate([-0.5,0,-7])nema17();

translate([31,2.5,5])rotate([90,0,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}
translate([31,2.5,25])rotate([90,0,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}
translate([17,11+4.5,25])rotate([0,-90,0])rotate([0,0,360/16]){cylinder(r=2.5,h=30,center=true,$fn=8);
cylinder(r=4.5,h=30,$fn=8);
}
}
}
//idlers
*translate(100,0,0){
translate([0,100,0])xidler();
translate([10.5,85.5,6])rotate([-90,0,0])xidlerblock();

translate([0,50,0])mirror([1,0,0]){
translate([0,100,0])xidler();
translate([10.5,85.5,6])rotate([-90,0,0])xidlerblock();
}
}

//motors
translate(){
xmotormount();
translate([0,-50,0])mirror([0,1,0]) xmotormount();
}
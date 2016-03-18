use <extrusions.scad>

*cylinder(r=2.5,h=10,$fn=30);
difference(){
cylinder(r=6,h=28,$fn=50);
translate([0,0,4-.2])ring(9.5,13,9.1);
translate([0,0,-.2])ring(5,13,5.1);
translate([0,0,6+9])ring(7.5,13,5);
translate([0,0,6+16])ring(3,13,6.1);
translate([0,0,-.1])cylinder(r=2/2,h=25.1,$fn=20);
translate([0,0,6+19-.1])cylinder(r=1/2,h=3.2,$fn=10);

translate([0,-20,-1])cube([40,40,30]);
}
%translate([0,0,-42])hsnema8();
translate([0,0,4.5])oring(id=5,od=7);
translate([0,0,-.5])oring(id=3,od=5);
translate([0,0,-4.5])oring(id=3,od=5);
color("silver",.5)ring(10,16,1);


translate([0,0,-9])difference(){
ring(3,12,13);
translate([0,0,-.1])cylinder(r=5/2,h=5,$fn=20);
translate([0,0,-.1])ring(od=13,id=10,h=10);
translate([0,0,8])cylinder(r=5/2,h=5,$fn=20);
translate([0,-20,-1])cube([40,40,30]);

}

translate([0,0,-.5])oring(id=3,od=5);
translate([0,0,-4.5])oring(id=3,od=5);
translate([0,0,6.5])magnet();




module oring(id=15,od=17){
color("black")rotate_extrude($fn=20)translate([(od+id)/4,0,0])circle(r=(od-id)/4);
}
module magnet(){
color("silver",.5)difference(){
cylinder(r=19.1/2,h=6.5,$fn=50);
translate([0,0,-.1])cylinder(r=9.5/2,h=6.7,$fn=30);
}
}
module ring(id,od,h){
difference(){
cylinder(r=od/2,h=h,$fn=50);
translate([0,0,-.1])cylinder(r=id/2,h=h+.2,$fn=30);
}
}

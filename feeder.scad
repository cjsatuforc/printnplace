PI=3.141592653589793;
*rotate([0,0,24])translate([-45+.5,0,1.25]) takeupwheel(8);
*rotate([0,0,24])translate([-18+.25,0,1.25]) frictionwheel();

d=0;
extrangle=360*-d/(19.1*PI);
*translate([0,0,0.25])rotate([0,0,12+extrangle]) sprocket();

*%translate([-140+2.1+d,19.1/2+1,2])rotate([90,0,0])mirror([0,1,0])tape(200);
rotate([180,0,0])feeder(8);

module feeder(w){
difference(){
union(){
translate([-55,-25,3.9])cube([60,40,2]);
translate([-50,7.5,-8.1])cube([165,22,14]);
%translate([95,29.5,-10])cube(20);
%translate([-45,29.5,-10])cube(20);
translate([-50,29.5,-8.1])cube([4.7,20.2,14]);
translate([-40+4.7/2,29.5,-8.1])cube([4.7,3.2,14]);
translate([-20+4.7/2,29.5,-8.1])cube([4.7,3.2,14]);

}
//mounting holes
translate([-50,39.5,0])rotate([0,90,0])rotate([0,0,360/16])cylinder(r=2.5,h=30,center=true,$fn=8);
translate([105,20,0])rotate([90,0,0])rotate([0,0,360/16])cylinder(r=2.5,h=30,center=true,$fn=8);
translate([105,10,0])rotate([90,0,0])rotate([0,0,360/16])cylinder(r=4.5,h=30,center=true,$fn=8);
translate([-10,0,0]){
translate([-60,-62,3.8])cube([70,40,3]);
translate([-30,-62,3.8])rotate([0,0,25])cube([70,40,3]);
rotate([0,0,24])translate([-45+.5,0,1.25]){
cylinder(r=1.7,h=30,$fn=30);
%takeupwheel(w);
}
rotate([0,0,24])translate([-18+.25,0,1.25]){cylinder(r=1.7,h=30,$fn=30);
%frictionwheel();
}
cylinder(r=1.7,h=30,$fn=30);
%rotate([0,0,12]) sprocket();
translate([0,0,1.])cylinder(r=23.4/2,h=5.5,center=true,$fn=30);
}
#translate([-139.9+4,19.8/2+1-.3,2.5])rotate([90,0,0])mirror([0,1,0])cube([200,9,1.7]);
#translate([56,8,-2])cube([15,3,9],true);
#translate([37,8,0])cube([20,3,4],true);
#translate([64,19.8/2+28.15-.3,-2])semicirclechannel(9,1.7,28);
#translate([49,7.3,-6])rotate([0,0,180+14.3+14])cube([98,0.1,6]);
}
}

module semicirclechannel(w,h,r){
translate([-r/2-1,0,0])difference(){
translate([r/2+1,0,0])rotate_extrude($fn=120)translate([r,0,0])square([h,w],true);
cube([r+2,2*r+h+1,w+1],true);
}
}


module tape(l=100){
	difference(){
		cube([l,8,1]);
		for(i=[0:l/4-1]){
			translate([2+i*4,1.8,-.1])cylinder(r=0.8,$fn=20,h=2);
			translate([4+i*4,5.08,0.81])cube([1.6,3.8,0.4],true);
		}
	}
}

module takeupwheel(w=8){

difference(){
union(){
translate([0,0,-2])cylinder(r=18.5,h=4.1,$fn=220);
translate([0,0,-w-1])cylinder(r=19.1,h=w+.05-1,$fn=220);
}
cylinder(r=1.9,h=20,center=true,$fn=30);
translate([0,0,0.75])rotate_extrude()translate([18.7,0,0])rotate([90,0,0])circle(r=1,$fn=50,center=true);

}
}
module frictionwheel(){
difference(){
translate([0,0,-.25])cylinder(r=15.2/2,h=2.35,$fn=220);
cylinder(r=1.9,h=10,center=true,$fn=30);
#translate([0,0,0.75])rotate_extrude()translate([8,0,0])rotate([90,0,0])circle(r=1,$fn=50,center=true);

}
}

module sprocket(){difference(){
union(){
for(i=[0:15])rotate([0,0,24*i])translate([0,-18.2/2,0])rotate([-90,0,0])cylinder(r1=0.55,r2=0.7,h=3.2,center=true,$fn=10);
cylinder(r=18.4/2,h=1.5,center=true,$fn=30);
translate([0,0,1.5])cylinder(r=18.7/2,h=3.2,center=true,$fn=30);

}
cylinder(r=1.9,h=10,center=true,$fn=30);
translate([0,0,-1.3])cylinder(r=39.0/2,h=2,center=true,$fn=30);
translate([0,0,2-.3])rotate_extrude()translate([10.2,0,0])rotate([90,0,0])circle(r=1,$fn=50,center=true);
}
}


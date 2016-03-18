module Islot5(l=100){
translate([l/2,0,0]){cube([l,5,6.6],center=true);
translate([0,0,1])hull(){
cube([l,5,4.5],center=true);
translate([0,0,-1.5])cube([l,11,1.5],center=true);
}
}
}

module rcorner(r,l){
translate([l/2,0,0])difference(){
cube([l,r*2,r*2],center=true);
for(i=[-1,1])for(j=[-1,1])translate([0,i*r,j*r])rotate([0,90,0])cylinder(r=r,h=l+1,$fn=20,center=true);
}
}


module profilex020(l=100,x=4){
xwidth=x*10;
color("beige")difference(){
translate([0,-xwidth,-10])cube([l,2*xwidth,20]);
if(x>1)for(i=[1:x-1])translate([-.5,-xwidth+i*20,0])rotate([0,90,0])cylinder(r=12.5/2,$fn=20,h=l+1);

for(i=[0:x-1])translate([-.5,-xwidth+10+i*20,0]){
rotate([0,90,0])cylinder(r=4.3/2,$fn=20,h=l+1);
translate([0,0,-6.9])Islot5(l+1);
mirror([0,0,1])translate([0,0,-6.9])Islot5(l+1);
}
for(i=[0,1])mirror([0,i,0])translate([-.5,-xwidth+3.1,0])rotate([-90,0,0])Islot5(l+1);
for(i=[-xwidth,xwidth])for(j=[-10,10])translate([-.5,i,j])rcorner(2,l+1);
}
}

module profile8020(l=100){
echo(str("profile 8020 L:",l,"mm weight:",(l*.00189),"kg"));
profilex020(l=l,x=4);
}
module profile4020(l=100){
echo(str("profile 4020 L:",l,"mm weight:",(l*.00089),"kg"));
profilex020(l=l,x=2);
}
module profile6020(l=100){
echo(str("profile 6020 L:",l,"mm weight:",(l*.00128),"kg"));
profilex020(l=l,x=3);
}
module profile2020(l=100){
echo(str("profile 2020 L:",l,"mm weight:",(l*.00049),"kg"));
profilex020(l=l,x=1);
}


module drylinn80(len=100,pos=0){
echo(str("drylin NS-01-80 L:",len,"mm weight:",(len*.00114+0.1),"kg"));
xpos=max(0,min(pos,len-80));
color("gray")difference(){
translate([0,-40,0])cube([len,80,12]);
for(i=[0:round(len/150)]){
translate([25+150*i,0,-1]){
	translate([0,20,0])cylinder(r=2,$fn=20,h=30);
	translate([0,-20,0])cylinder(r=2,$fn=20,h=30);
	translate([0,20,4.5])cylinder(r=4,$fn=20,h=30);
	translate([0,-20,4.5])cylinder(r=4,$fn=20,h=30);
	
}
}
translate([-.5,-57/2,6.5])cube([len+1,57,6]);
}
color("beige")difference(){union(){
translate([xpos,-56/2,6.1])cube([80,56,3]);
translate([xpos+6,-56/2,5.9])cube([68,56,6.1]);
}for(i=[0,56])for(j=[-22.5,22.5])translate([xpos+12+i,j,0])cylinder(r=2,$fn=20,h=15);
}

}


module drylinn27(len=80,pos=0){
//echo(str("drylin NS-01-80 L:",len,"mm weight:",(len*.00114+0.1),"kg"));
xpos=max(0,min(pos,len-20));
color("gray")difference(){
translate([0,-27/2,0])cube([len,27,9]);
translate([-.5,-27/2-.1,-.1])cube([len+1,2.76,3.3]);
translate([-.5,27/2-2.75,-.1])cube([len+1,2.76,3.3]);
for(i=[0:round(len/150)]){
translate([25+150*i,0,-1]){
	translate([0,20,0])cylinder(r=2,$fn=20,h=30);
	translate([0,-20,0])cylinder(r=2,$fn=20,h=30);
	translate([0,20,4.5])cylinder(r=4,$fn=20,h=30);
	translate([0,-20,4.5])cylinder(r=4,$fn=20,h=30);
	
}
}
translate([-.5,-16/2,6.5])cube([len+1,16,6]);
}
color("beige")difference(){union(){
translate([xpos,-16/2,6.1])cube([34,16,3]);
translate([xpos+2,-16/2+1,6.6])cube([30,14,3]);
for(i=[0,20])translate([xpos+7	+i,0,9])cylinder(r=3.2,$fn=20,h=5.5);
}
for(i=[0,20])translate([xpos+7	+i,0,2])cylinder(r=2,$fn=20,h=15.5);
}
}


drylinn27(80);

module nema17(cutout=true){
difference(){union(){translate([0,0,-48/2])cube([42,42,48],true);
translate([0,0,-1])cylinder(r=11,h=3.5);

translate([0,0,-1])cylinder(r=2.5,h=25,$fn=30);
if(cutout==true){
translate([0,0,-1])cylinder(r=12.5,h=25);
for(i=[-31/2,31/2])for(j=[-31/2,31/2]){
translate([i,j,-1])cylinder(r=2,h=12,$fn=10);
translate([i,j,10])cylinder(r=4,h=31,$fn=10);
}
}
}
if(cutout!=true){for(i=[-31/2,31/2])for(j=[-31/2,31/2]){
translate([i,j,-4])cylinder(r=2,h=11,$fn=10);
}
}
}
}


module hsnema8(cutout=true){
difference(){
union(){
translate([0,0,30.1/2])cube([20,20,30.1],center=true);
translate([0,0,30.0])cylinder(r=7.5,h=1.4);
translate([0,0,-7])cylinder(r=2.5,h=7.1,$fn=30);
translate([0,0,30.0])cylinder(r=2.5,h=7.1,$fn=30);
if(cutout==true){
translate([0,0,30.0])cylinder(r=7.7,h=11.4);
translate([0,0,-10.0])cylinder(r=7.7,h=11.4);
for(i=[-15.7/2,15.7/2])for(j=[-15.7/2,15.7/2])translate([i,j,28.2+1]){
cylinder(r=2.5/2,h=10.1,$fn=10);
translate([0,0,8])cylinder(r=5/2,h=10,$fn=10);
}
}

}
for(i=[-15.7/2,15.7/2])for(j=[-15.7/2,15.7/2])translate([i,j,28.2])if(cutout!=true){
cylinder(r=2.5/2,h=2,$fn=10);
}
if(cutout!=true){
cylinder(r=2.5/2,h=80,center=true,$fn=20);
}
}
}

hsnema8();

module nema14(cutout=true){
difference(){union(){translate([0,0,-36/2])cube([35,35,36],true);
translate([0,0,-1])cylinder(r=11,h=3.5);

translate([0,0,-1])cylinder(r=2.5,h=25,$fn=30);
if(cutout==true){
translate([0,0,-1])cylinder(r=11.5,h=25);
for(i=[-26/2,26/2])for(j=[-26/2,26/2]){
translate([i,j,-1])cylinder(r=2,h=12,$fn=10);
translate([i,j,10])cylinder(r=4,h=31,$fn=10);
}
}
}
if(cutout!=true){for(i=[-26/2,26/2])for(j=[-26/2,26/2]){
translate([i,j,-4])cylinder(r=2,h=11,$fn=10);
}
}
}
}




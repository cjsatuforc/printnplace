use <extrusions.scad>;
use <feeder.scad>;
xpos=80;
ypos=480;
cover=1;

//for assembly only
echo("assembly aids");
*%profile4020(300);
echo("end assembly aids");

//fasteners 
echo("20x automatic fastener"); //5x at each corner
echo("4x automatic fastener"); //gantry mount
echo("8x automatic fastener"); //xaxis-frame
echo("16x automatic fastener"); //pcbholders



//sides
translate([0,290,10])rotate([90,0,0])profile2020(450);
translate([0,-290,10])rotate([90,0,0])profile2020(450);
translate([0,280,70])rotate([0,0,0])profile4020(450);
translate([0,-280,70])rotate([0,0,0])profile4020(450);

if(cover==0){
//corners
translate([-10,290,0])rotate([90,-90,0])profile2020(100);
translate([-10,-290,0])rotate([90,-90,0])profile2020(100);
translate([460,290,0])rotate([90,-90,0])profile2020(100);
translate([460,-290,0])rotate([90,-90,0])profile2020(100);
}else{
//optional taller corners and cover
translate([-10,290,0])rotate([90,-90,0])profile2020(260);
translate([-10,-290,0])rotate([90,-90,0])profile2020(260);
translate([460,290,0])rotate([90,-90,0])profile2020(260);
translate([460,-290,0])rotate([90,-90,0])profile2020(260);
translate([-10,-560/2,250])rotate([90,0,90])profile2020(560);
translate([460,-560/2,250])rotate([90,0,90])profile2020(560);
translate([0,290,250])rotate([90,0,0])profile2020(450);
translate([0,-290,250])rotate([90,0,0])profile2020(450);
echo("8x automatic fastener");
}

//front
translate([-10,-560/2,10])rotate([90,0,90])profile2020(560);
translate([-10,-560/2,80])rotate([90,0,90])profile4020(560);
//back
translate([460,-560/2,10])rotate([90,0,90])profile2020(560);
translate([460,-560/2,80])rotate([90,0,90])profile4020(560);

//PCB holder and stuff

translate([0,80,70])profile4020(450);
translate([0,-80,70])profile4020(450);
translate([0,90,90])profile2020(450);
translate([0,-90,90])profile2020(450);
translate([70,-80,90])rotate([0,0,90])profile8020(160);
translate([70+80,-80,90])rotate([0,0,90])profile8020(160);
translate([70+160,-80,90])rotate([0,0,90])profile8020(160);
translate([70+240,-80,90])rotate([0,0,90])profile8020(160);
*translate([70,-300,90])rotate([0,0,90])profile8020(160);

*%translate([254/2+30,0,70])cube([254,200,100],true);
%translate([100,250,50])cube([80,60,100],true);
*%translate([100,-240,50])cube([80,60,100],true);

//feeder
translate([95,255,110])rotate([-90,0,-90])feeder(8);

//linear axes
translate([30+xpos,-560/2,175+10]){
rotate([-90,0,90]){profile8020(560);
translate([0,-10,10])drylinn80(560,480-ypos);
}
}
for(i=[0,1])mirror([0,i,0])translate([0,150,0]){
translate([0,-10,50])rotate([90,0,0])drylinn80(450,xpos);
translate([0,0,40])rotate([90,0,0])profile8020(450);
translate([40+xpos,-36,35])rotate([90,-90,0])profile4020(110);
}
echo("12x M4 channel nuts");
echo("12x M4x6mm DIN 7984");



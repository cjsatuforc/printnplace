module picam(){difference(){
    cube([25,24,1],center=true);
    for(i=[2,14.5])
        for(j=[21/2,-21/2])
            translate([j,-25/2+i,-5])
                cylinder(r=1,$fn=20,h=10);
}
translate([25/2-4-8.5,24/2-4-5.5,3])cube([8,8,5],center=true);

}


module pyramid(dims, zstep=0.5){
    for(i=[1:len(dims)]){
        translate([0,0,-len(dims)*zstep+i*zstep+0.01])cube([dims[i-1]+.5,dims[i-1]+.5,zstep+0.01],true);
    }
}

*pyramid([3,5,7,10,12,14]);

*difference(){
    render()union(){
        cube([160,50,20],true);
        translate([0,23.8,10.9])           rotate([60,0,0])            cube([160,6,3],true);
    }
    
    translate([0,-17,0])rotate(45)cylinder(r=4,h=60,center=true,$fn=4);
    translate([0,0,-5])rotate([0,0,22.5])cylinder(r1=8,r2=14,h=10.5,center=true,$fn=8);
    translate([0,15,0])cylinder(r=1.5,h=30,center=true);
    for(i=[-1,1])for(j=[-1,1])translate([i*14,j*18,0])cylinder(r=1.5,h=30,center=true);
    translate([-32.5,-9,0])cube(28.5,true);
    for(i=[1,0,-1])rotate([0,0,180-i*180])translate([i*55,7,0])rotate([90,0,0])rotate([0,0,22.5]){cylinder(r=8/2,$fn=8,h=60,center=true);
    cylinder(r=5/2,$fn=8,h=70);
    }
    translate([0,0,5])cylinder(r=17,h=10.1,center=true);
    for(k=[0,1])translate([k*-95,0,0]){for(i=[0:3])translate([24+i*15.5,25-10,9.9])pyramid([3,5,7,10,12,14]);
    for(i=[2,1])translate([2.5+i*1.5*20,25-34,9.9]){pyramid([20,24,28]);
        for(j=[0,1]){translate([-5+j*10,-5+j*10,-1.49])pyramid([3.5,5,7,9]);
            translate([j*10-5,-j*10+5,-1.49])pyramid([2,4,6,8]);
        }
            
    }
    }
}

rotate([0,180,0])difference(){
union(){
    translate([3,0,0])cube([25,25,20],true);
    translate([0,0,9])cube([35,42,2],true);

}
translate([0,-18,0])rotate(45)cylinder(r=5,h=60,center=true);
translate([0,15,0])cylinder(r=2,h=30,center=true);
rotate(90){
%translate([0,-2.5,-10.5])picam();
for(i=[-1,1])for(j=[-1,1])translate([i*10.5,-6.75+j*6.25,0])cylinder(r=1.2,h=40,center=true);
translate([0,0,-7.1])cube([9,40,6],true);
translate([7,-12,-9.1])rotate(-25)cube([3,10,2],true);
cylinder(r1=6,r2=8,h=21,center=true);
}
for(i=[-1,1])for(j=[-1,1])translate([i*14,j*18,0])cylinder(r=2,h=30,center=true);

}

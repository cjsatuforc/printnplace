PI=3.141592653589793;

module e_lement(elwidth,elheight,ellength){
translate([2.5,0,0])cube([ellength-5,elwidth,elheight]);
translate([0,0,elheight/8])cube([ellength,elwidth,elheight/4]);
}

module echain(elwidth,elheight,ellength,radius,numelems,pos){
	L=ellength*(numelems-2);
	travel=2*(L-radius*PI);
	echo(str(numelems,"pcs echain W",elwidth," H",elheight," pitch ", ellength," R",radius, " travel range:",travel,"mm"));
	H=radius*2+elheight;
	clamppos=max(0,min(pos,travel));
	els_in_curve=(radius*PI/ellength);
	angular_pitch=180/(els_in_curve+1);
	extrangle=(-2*ellength-clamppos)*angular_pitch/ellength/2;
	for(i=[1:numelems]){
		translate([-clamppos/2-1*ellength,0,0]){
			if(i*angular_pitch+extrangle<=180 && i*angular_pitch+extrangle>=0)
				translate([ellength/2,0,radius+elheight/2])
					rotate([0,i*angular_pitch+extrangle,0])
						translate([-ellength/2,0,-radius-elheight/2])
							e_lement(elwidth,elheight,ellength);
			if(i*angular_pitch+extrangle>180)
				translate(
				[ellength/2-(180-extrangle-i*angular_pitch)*ellength/(angular_pitch),
				0,radius+elheight/2])
					rotate([0,180,0])
						translate([-ellength/2,0,-radius-elheight/2])
							e_lement(elwidth,elheight,ellength);
			if(i*angular_pitch+extrangle<0)
				translate(
				[ellength/2+(-extrangle-i*angular_pitch)*ellength/(angular_pitch),
				0,radius+elheight/2])
					translate([-ellength/2,0,-radius-elheight/2])
						e_lement(elwidth,elheight,ellength);
		}
	}

}

echain(37.4,15,20,18,16,20);
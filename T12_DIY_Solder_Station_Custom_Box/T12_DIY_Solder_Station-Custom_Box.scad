/*
License: Creative Commons - Attribution
Original by "alex_at": https://www.thingiverse.com/thing:2821134
Modifications by Chris @ https://pcburn.com
*/

$fn=100;
nozzle=0.4;
wall=nozzle*4;
clearance=0;
h=28;
ht=3;
hf=29.5;
sm=20;
x=77;
y=80; // Depth; 160 in original
s=2;
powersupply_y=19;
power_socket_d=11.5;
onoff_d=21;

reduce_rearpanel_w=0.5; // Fudge factor for rear panel width

/* added in option for printing parts */

// Print Base
bottom_on=1;
// Print Top
top_on=0;
// Print Back
back_on=0;
// PSU Mounts
psu_mounts_on=0;



module border_support(h) {
    cube([wall*2,wall*2,h]);
}

module frontpanel() {
	x=x-clearance*2;
	h=hf-wall*2-clearance*2;
    
	difference() {
        translate([0,0,-wall]) cube([x,20,wall*2]);
        translate([(x+s)/2-23.5/2,h/2-7.2,-wall-0.5]) cube([23.5,14.4,(wall*2)+1]);
        translate([(x+s)/2-22.5/2-16.75,h/2,-wall-0.5]) cylinder(d=13, h=wall*2+1);
        translate([(x+s)/2-22.5/2-23.25,h/2,-wall-0.5]) cube([13,10,wall*2+1]);
            
        translate([(x+s)/2-22.5/2-16.75+11,h/2,-wall-0.5]) cylinder(d=3.6, h=wall*2+1);
        translate([(x+s)/2-22.5/2-16.75+11,h/2-7.29,-wall-0.5]) cylinder(d=3.6, h=wall*2+1);
        translate([(x+s)/2+22.5/2+16.05,h/2,-wall-0.5]) cylinder(d=8, h=wall*2+1);
        translate([(x+s)/2+22.5/2+12.05,h/2,-wall-0.5]) cube([8,10,wall*2+1]);
	}
}
module frontpanel2() {
	x=x-wall*2-clearance*2;
	h=hf-wall*2-clearance*2;
    
    // Static adjustment for non-parametric breakage
    translate([0,3,0])
	union() {        
        translate([wall,17,-wall]) cube([x,10,wall*2]);        
        difference() {  
            translate([(x+s)/2-22.5/2-23.25+wall+clearance,10,-wall]) cube([13-clearance*2,7,wall*2]);  
            translate([(x+s)/2-22.5/2-16.75+wall,h/2-3,-wall-1]) cylinder(d=13, h=(wall+1)*2);
        }        
        difference() {  
            translate([(x+s)/2+22.5/2+12.05+wall+clearance,10,-wall]) cube([8-clearance*2,7,wall*2]);    
            translate([(x+s)/2+22.5/2+16.05+wall,h/2-3,-wall-1]) cylinder(d=8, h=(wall+1)*2);
        }
    }
}
module rearpanel() {
    width_cube=(x-wall*2)-reduce_rearpanel_w;
    depth_cube=hf-wall*2;
        difference() {
            color([1,0,1,1]) translate([reduce_rearpanel_w/2,0,0]) cube([width_cube,depth_cube,wall]);
            translate([20-(reduce_rearpanel_w/2),15-wall,0]) cylinder(h=wall,d=onoff_d,center=false);
            translate([50-(reduce_rearpanel_w/2),15-wall,0]) cylinder(h=wall,d=power_socket_d,center=false);
            translate([20-(reduce_rearpanel_w/2)-(onoff_d/2)-0.9,15-wall,1]) cube(2,true);
        }
}

module bottom() {
    rotate([90,0,0]) translate([0,0,-wall]) frontpanel();
    difference() {
        union() {
            difference() {
                cube([x,y,h]);
                translate([wall,wall*3+clearance*2,wall]) cube([x-wall*2,y-wall*6-clearance*4,h+wall]);
            }
//support for power supply
            if (psu_mounts_on) {
                translate([x/2+4,y-powersupply_y,0]) cylinder(d=6, h=4+wall);
                translate([x/2-23,y-powersupply_y-30,0]) cylinder(d=6, h=4+wall);
                translate([x/2+2,y-powersupply_y-120,0]) cylinder(d=6, h=4+wall);
            }
//top support screw
            hull() {
                translate([wall+8/2,y-wall*3-8/2,0]) cylinder(d=8, h=h);
                translate([0,y-wall*3-8,0]) cube([wall,8,h]);
                translate([wall,y-wall*3,0]) cube([8,wall,h]);
            }
            hull() {
                translate([x-wall-8/2,y-wall*3-8/2,0]) cylinder(d=8, h=h);
                translate([x-wall,y-wall*3-8,0]) cube([wall,8,h]);
                translate([x-wall-8,y-wall*3,0]) cube([8,wall,h]);
            }
            hull() {
                translate([wall+8/2,sm+wall*3+8/2,0]) cylinder(d=8, h=h);
                translate([0,sm+wall*3,0]) cube([wall,8,h]);
            }
            hull() {
                translate([x-wall-8/2,sm+wall*3+8/2,0]) cylinder(d=8, h=h);
                translate([x-wall,sm+wall*3,0]) cube([wall,8,h]);
            }
        }
        //front
        translate([wall,-wall,wall]) cube([x-wall*2,wall*5,h]);
        //rear
        translate([wall*2,y-wall*2,wall*2]) cube([x-wall*4,wall*3,h]);
        translate([wall+8,y-wall*4,wall*2]) cube([x-wall*2-16,wall*5,h]);
        translate([wall,y-wall*2-clearance*2,wall]) cube([x-wall*2,wall+clearance*2,h+wall]);
        //screw support for power supply
        if (psu_mounts_on) {
            translate([x/2+4,y-powersupply_y,1]) cylinder(d=2.8, h=4+wall);
            translate([x/2-23,y-powersupply_y-30,1]) cylinder(d=2.8, h=4+wall);
            translate([x/2+2,y-powersupply_y-120,1]) cylinder(d=2.8, h=4+wall);
        }
        //top screw
        translate([wall+8/2,y-wall*3-8/2,10]) cylinder(d=3, h=h);
        translate([x-wall-8/2,y-wall*3-8/2,10]) cylinder(d=3, h=h);
        translate([wall+8/2,sm+wall*3+8/2,10]) cylinder(d=3, h=h);
        translate([x-wall-8/2,sm+wall*3+8/2,10]) cylinder(d=3, h=h);
        //top screw head
        //  translate([wall+8/2,y-wall*3-8/2,-2]) cylinder(d=6, h=h/2);
        //	translate([x-wall-8/2,y-wall*3-8/2,-2]) cylinder(d=6, h=h/2);
        //	translate([wall+8/2,15+wall*3+8/2,-2]) cylinder(d=6, h=h/2);
        //	translate([x-wall-8/2,15+wall*3+8/2,-2]) cylinder(d=6, h=h/2);
    }
}

module support_bottom() {
    //support with top
    translate([wall,y/4-wall*3,0]) rotate([0,0,0]) border_support(h);
    translate([wall,y/4*2-wall*3,0]) rotate([0,0,0]) border_support(h);
    translate([wall,y/4*3-wall*3,0]) rotate([0,0,0]) border_support(h);
    translate([x-wall,y/4+wall*3,0]) rotate([0,0,180]) border_support(h);
    translate([x-wall,y/4*2+wall*3,0]) rotate([0,0,180]) border_support(h);
    translate([x-wall,y/4*3+wall*3,0]) rotate([0,0,180]) border_support(h);
    
    translate([51,wall-1,0]) rotate([0,0,0]) border_support(h/2+6);
    translate([26,wall-1,0]) rotate([0,0,0]) cube([wall,wall*2,h/2+6]);
}

module top() {
    rotate([90,180,0]) translate([-x,-31,-wall]) frontpanel2();
    difference() {
        union() {
            difference() {
                cube([x,y,ht]);
                translate([wall,0+clearance*2,wall]) cube([x-wall*2,y-wall*3-clearance*4,ht+wall]);
            }
            //top support screw
            hull() {
                translate([wall+8/2,y-wall*3-8/2,0]) cylinder(d=8, h=ht);
                translate([0,y-wall*3-8,0]) cube([wall,8,ht]);
                translate([wall,y-wall*3,0]) cube([8,wall,ht]);
            }
            hull() {
                translate([x-wall-8/2,y-wall*3-8/2,0]) cylinder(d=8, h=ht);
                translate([x-wall,y-wall*3-8,0]) cube([wall,8,ht]);
                translate([x-wall-8,y-wall*3,0]) cube([8,wall,ht]);
            }
            hull() {
                translate([wall+8/2,sm+wall*3+8/2,0]) cylinder(d=8, h=ht);
                translate([0,sm+wall*3,0]) cube([wall,8,ht]);
            }
            hull() {
                translate([x-wall-8/2,sm+wall*3+8/2,0]) cylinder(d=8, h=ht);
                translate([x-wall,sm+wall*3,0]) cube([wall,8,ht]);
            }
        }
    
        //rear
        translate([wall*2,y-wall*2,wall*2]) cube([x-wall*4,wall*3,ht]);
        translate([wall+8,y-wall*4,wall*2]) cube([x-wall*2-16,wall*5,ht]);
        translate([wall,y-wall*2-clearance*2,wall]) cube([x-wall*2,wall+clearance*2,ht+wall]);
        //top screw
        translate([wall+8/2,y-wall*3-8/2,-0.1]) cylinder(d=2.7, h=ht+1);
        translate([x-wall-8/2,y-wall*3-8/2,-0.1]) cylinder(d=2.7, h=ht+1);
        translate([wall+8/2,sm+wall*3+8/2,-0.1]) cylinder(d=2.7, h=ht+1);
        translate([x-wall-8/2,sm+wall*3+8/2,-0.1]) cylinder(d=2.7, h=ht+1);
    }
}

if (back_on) {
    render() {
        rotate([90,180,0]) translate([wall-x,-hf,+wall-y]) rearpanel();
    }
}
if (top_on) {
    render() {
        rotate([0,180,0]) translate([-x,0,-45]) top();
    }
}
if (bottom_on) {
    render() {
        bottom();
    }
}

Nullsoft AVS Preset 0.2   �  �    _________                                           
 (        _____)                                                 
  \     ( inal                  __                               Seismogrid
    \    ����\     _      /    )                         
      \   |�\    \_/  \_/    /                           
        \/    \                 /                            by Steven Wittens
                 \__/^\__/ hack                        aka UnConeD
______________________________________________________
  ����������������������������������������������������
This preset started out as an attempt at faking a water surface. The last 5 ripple sources and times are kept, and the surface is calculated from that. As soon as a ripple has faded, a new one is generated.

To make it more appealing, I started experimenting with shading. At first I used a regular linescope, but after making Texer II I used that instead. It looks a lot smoother...
Aside from the shading, there's also some special colorcoding. Occasionally, a ripple will also contain a change of color that spreads out with the ripple until it fills the area. Until the next color change...
Because there are already subtle color variations in the grid, a color-matrix is used and then rendered in a particular hue.
Very holographic.

Unfortunately there's not much else to do with this preset, because extras would slow it down.
 ____________________________________________________
������������������������������������������������������
(c) Steven Wittens / UnConeD
steven @ acko dot net - www.acko.net

If you wish to use any part (or the whole) of this preset in your own presets, packs or in another medium, you must include my name as a clear credit reference. Including my contact information/website address is not required, but appreciated.
Exception to the above: you may display these presets as a projection at parties, raves or clubs without credit reference on-screen. $   �  	   x=0;y=0;   ti=ti*.9;t=t-.010-ti*.02;
ox=cos(t)*cos(t*.379+1+md)*cos(sin(t*.141+md));
oy=-sin(t*.517+3)*cos(-t*.21+md)*.7+.5;
oz=-(sin(t)*cos(-t*.41)*sin(cos(1+t*.631)));
ot=.3+1.9/sqrt(sqr(ox)+sqr(oy)+sqr(oz));
ox=ox*ot;oy=oy*ot-.2;oz=oz*ot;
oy=sqrt(abs(oy))*sign(oy);
oy=sqrt(abs(oy))*sign(oy);
ry=atan2(-ox,oz);
rx=-atan2(oy,sqrt(sqr(ox)+sqr(oz)));

cx=cos(rx);sx=sin(rx);
cy=cos(ry);sy=sin(ry);

reg30=ox;
reg31=oy;
reg32=oz;

reg40=cx;
reg41=sx;
reg42=cy;
reg43=sy;

reg50=w/h;
reg51=h/w;

reg99=reg99+sin(rt-reg99)*.1;
    ti=1;rt=rt+rand(628)*.01;
 8   /* Camera code */
n=0;md=rand(200)*.01-1;t=-rand(200);       ���     $   �      ,  reg02=reg02*decay;reg03=reg03+expand;
reg06=reg06*decay;reg07=reg07+expand;
reg10=reg10*decay;reg11=reg11+expand;
reg14=reg14*decay;reg15=reg15+expand;
reg18=reg18*decay*decay;reg19=reg19+expand;

reg55=glow;
reg97=reg97*.8+reg00*.2;
reg98=reg98*.8+reg01*.2;
reg70=spd;

reg60=hcx;reg61=hcy;
reg64=sin(hu)*.5+.65;reg63=sin(hu+2.09)*.5+.5;reg62=sin(hu+4.18)*.5+.65;
reg68=sin(lhu)*.5+.65;reg67=sin(lhu+2.09)*.5+.5;reg66=sin(lhu+4.18)*.5+.65;
reg65=reg65+.035;

rpt=(rpt+1)%10;
ft=below(reg18,.01);ft=if(rpt,0,ft);x=ft;
reg16=if(x,reg12,reg16);reg17=if(x,reg13,reg17);reg18=if(x,reg14,reg18);reg19=if(x,reg15,reg19);
reg12=if(x,reg08,reg12);reg13=if(x,reg09,reg13);reg14=if(x,reg10,reg14);reg15=if(x,reg11,reg15);
reg08=if(x,reg04,reg08);reg09=if(x,reg05,reg09);reg10=if(x,reg06,reg10);reg11=if(x,reg07,reg11);
reg04=if(x,reg00,reg04);reg05=if(x,reg01,reg05);reg06=if(x,reg02,reg06);reg07=if(x,reg03,reg07);
reg00=if(x,rand(160)*.01-.8,reg00);reg01=if(x,rand(160)*.01-.8,reg01);reg02=if(x,(getspec(0,.125,0)*6+.25)*.2,reg02);reg03=if(x,0,reg03);
 �  y=ft;ft=below(reg18,.01);ft=if(y,ft,ft);x=ft;tc=0;bc=(bc+1)%8;
reg16=if(x,reg12,reg16);reg17=if(x,reg13,reg17);reg18=if(x,reg14,reg18);reg19=if(x,reg15,reg19);
reg12=if(x,reg08,reg12);reg13=if(x,reg09,reg13);reg14=if(x,reg10,reg14);reg15=if(x,reg11,reg15);
reg08=if(x,reg04,reg08);reg09=if(x,reg05,reg09);reg10=if(x,reg06,reg10);reg11=if(x,reg07,reg11);
reg04=if(x,reg00,reg04);reg05=if(x,reg01,reg05);reg06=if(x,reg02,reg06);reg07=if(x,reg03,reg07);
reg00=if(x,rand(160)*.01-.8,reg00);reg01=if(x,rand(160)*.01-.8,reg01);reg02=if(x,(getspec(0,.125,0)*6+.5)*.4,reg02);reg03=if(x,0,reg03);
reg02=min(1.7,reg02);

x=bor(bc,below(reg65,1.5));
hcx=if(x,hcx,reg00);hcy=if(bc,hcy,reg01);
lhu=if(x,lhu,hu);
hu=if(x,hu,rand(628)*.01);
reg65=if(x,reg65,0);
reg64=sin(hu)*.5+.65;reg63=sin(hu+2.09)*.5+.5;reg62=sin(hu+4.18)*.5+.65;
reg68=sin(lhu)*.5+.65;reg67=sin(lhu+2.09)*.5+.5;reg66=sin(lhu+4.18)*.5+.65;
 �   n=0;/* ripple code */
decay=.92;expand=.045;glow=.3;spd=6.5;
lhu=rand(628)*.01;hu=rand(628)*.01;

reg02=0;reg03=0;
reg06=0;reg07=0;
reg10=0;reg11=0;
reg14=0;reg15=0;
reg18=0;reg19=0;
ltm=gettime(0)-.1;       ���     (       ���)Acko.net: Texer II              `                                                                                                                                                                                                                                                                                           g=16;n=g*g;ig=1/(g-1);�  gx=0;gy=0;
af=reg50;ly=0;
glow=reg55;
li=glow;
v00=reg00;v01=reg01;v02=reg02;v03=reg03;
v04=reg04;v05=reg05;v06=reg06;v07=reg07;
v08=reg08;v09=reg09;v10=reg10;v11=reg11;
v12=reg12;v13=reg13;v14=reg14;v15=reg15;
v16=reg16;v17=reg17;v18=reg18;v19=reg19;

ox=reg30;oy=reg31;oz=reg32;
cx=reg40;sx=reg41;cy=reg42;sy=reg43;
spd=reg70;

hcx=reg60;hcy=reg61;
hur=reg62;hug=reg63;hub=reg64;
hip=reg65;
hvr=reg66;hvg=reg67;hvb=reg68;

sz=w/320*2.8;    Y  hy=gx*ig*2-1;hx=gy*ig*2-1;

py=.2;
d=.75*(sqr(hx-v00)+sqr(hy-v01));py=py-sin(d*10-v03*spd)*v02*min(1,max(0,v03-d));
d=.75*(sqr(hx-v04)+sqr(hy-v05));py=py-sin(d*10-v07*spd)*v06*min(1,max(0,v07-d));
d=.75*(sqr(hx-v08)+sqr(hy-v09));py=py-sin(d*10-v11*spd)*v10*min(1,max(0,v11-d));
d=.75*(sqr(hx-v12)+sqr(hy-v13));py=py-sin(d*10-v15*spd)*v14*min(1,max(0,v15-d));
d=.75*(sqr(hx-v16)+sqr(hy-v17));py=py-sin(d*10-v19*spd)*v18*min(1,max(0,v19-d));
red=if(gx,atan(ly-py)*li,0);
ly=py;
px=hx+ox;py=py+oy;pz=hy+oz;
x1=px*cy+pz*sy;z1=-px*sy+pz*cy;
y2=py*cx+z1*sx;z2=-py*sx+z1*cx;
z2=z2*.5+.5;
dt=if(above(z2,.01),1/z2,0);
x=if(dt,x1*dt,x);y=if(dt,y2*dt*af-.1,y);
sizex=dt*sz;sizey=sizex;

� colorcode;
dy=(py-oy);
k=max(0,.03-dy*.3);l=max(0,dy*.1+.03);
vg=(red*2+.08);vb=(red*1.5+k*2);vr=(red*2.5+l*2);
d=min(1,max(0,((sqr(hx-hcx)+sqr(hy-hcy))-hip*2.7+1)));
vvr=hur+d*(hvr-hur);
vvg=hug+d*(hvg-hug);
vvb=hub+d*(hvb-hub);
red=vr*vvr+vg*vvg+vb*vvb;
green=vr*vvb+vg*vvr+vb*vvg;
blue=vr*vvg+vg*vvb+vb*vvr;

gx=if(below(gx,g-1),gx+1,0);
gy=if(equal(gx,0),gy+1,gy);

skip=below(red+green+blue,0);
(       �$   �    hx=gx*ig*2-1;hy=gy*ig*2-1;

py=.2;
d=.75*(sqr(hx-v00)+sqr(hy-v01));py=py-sin(d*10-v03*spd)*v02*min(1,max(0,v03-d));
d=.75*(sqr(hx-v04)+sqr(hy-v05));py=py-sin(d*10-v07*spd)*v06*min(1,max(0,v07-d));
d=.75*(sqr(hx-v08)+sqr(hy-v09));py=py-sin(d*10-v11*spd)*v10*min(1,max(0,v11-d));
d=.75*(sqr(hx-v12)+sqr(hy-v13));py=py-sin(d*10-v15*spd)*v14*min(1,max(0,v15-d));
d=.75*(sqr(hx-v16)+sqr(hy-v17));py=py-sin(d*10-v19*spd)*v18*min(1,max(0,v19-d));
px=hx+ox;py=py+oy;pz=hy+oz;
x1=px*cy+pz*sy;z1=-px*sy+pz*cy;
y2=py*cx+z1*sx;z2=-py*sx+z1*cx;
z2=z2*.5+.5;
ldt=dt;
dt=if(above(z2,.01),1/z2,0);
x=if(dt,x1*dt,x);y=if(dt,y2*dt*af-.1,y);


red=if(band(ldt,above(gx,0)),if(bor(equal(gy,0),equal(gy,g-1)),.75,.25),0);green=red;blue=red;
gx=if(below(gx,g-1),gx+1,0);
gy=if(equal(gx,0),gy+1,gy);
 ;  gx=0;gy=0;
af=reg50;

v00=reg00;v01=reg01;v02=reg02;v03=reg03;
v04=reg04;v05=reg05;v06=reg06;v07=reg07;
v08=reg08;v09=reg09;v10=reg10;v11=reg11;
v12=reg12;v13=reg13;v14=reg14;v15=reg15;
v16=reg16;v17=reg17;v18=reg18;v19=reg19;

ox=reg30;oy=reg31;oz=reg32;
cx=reg40;sx=reg41;cy=reg42;sy=reg43;
spd=reg70;        g=22;n=g*g;ig=1/(g-1);       ���    $   �    hx=gy*ig*2-1;hy=gx*ig*2-1;

py=.2;
d=.75*(sqr(hx-v00)+sqr(hy-v01));py=py-sin(d*10-v03*spd)*v02*min(1,max(0,v03-d));
d=.75*(sqr(hx-v04)+sqr(hy-v05));py=py-sin(d*10-v07*spd)*v06*min(1,max(0,v07-d));
d=.75*(sqr(hx-v08)+sqr(hy-v09));py=py-sin(d*10-v11*spd)*v10*min(1,max(0,v11-d));
d=.75*(sqr(hx-v12)+sqr(hy-v13));py=py-sin(d*10-v15*spd)*v14*min(1,max(0,v15-d));
d=.75*(sqr(hx-v16)+sqr(hy-v17));py=py-sin(d*10-v19*spd)*v18*min(1,max(0,v19-d));
px=hx+ox;py=py+oy;pz=hy+oz;
x1=px*cy+pz*sy;z1=-px*sy+pz*cy;
y2=py*cx+z1*sx;z2=-py*sx+z1*cx;
z2=z2*.5+.5;
ldt=dt;
dt=if(above(z2,.01),1/z2,0);
x=if(dt,x1*dt,x);y=if(dt,y2*dt*af-.1,y);


red=if(band(ldt,above(gx,0)),if(bor(equal(gy,0),equal(gy,g-1)),.75,.25),0);green=red;blue=red;
gx=if(below(gx,g-1),gx+1,0);
gy=if(equal(gx,0),gy+1,gy);
 ;  gx=0;gy=0;
af=reg50;

v00=reg00;v01=reg01;v02=reg02;v03=reg03;
v04=reg04;v05=reg05;v06=reg06;v07=reg07;
v08=reg08;v09=reg09;v10=reg10;v11=reg11;
v12=reg12;v13=reg13;v14=reg14;v15=reg15;
v16=reg16;v17=reg17;v18=reg18;v19=reg19;

ox=reg30;oy=reg31;oz=reg32;
cx=reg40;sx=reg41;cy=reg42;sy=reg43;
spd=reg70;        g=22;n=g*g;ig=1/(g-1);       ���             %3            
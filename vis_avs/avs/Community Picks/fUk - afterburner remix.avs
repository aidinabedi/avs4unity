Nullsoft AVS Preset 0.2   ÷  ó  there i did it:)

only made one because of lack of time. even this one isnt really finished:D. But it will have to do because time's up. Anyway El i hope you like it :).

i did this from geround zero but i kept the basic concept. I rewrote all the code so i could manipulate it better, but its basicaly the same effect.the ship movement code is as simple as it gets, but it still fucks up sometime:D(cant figure out what the problem is).the pilot is all guts & no brain :).

el-vis - afterburner002  (cyberpunx)
fsk - flatmix 


©fsk 20.12.2003, ljubljana, slovenija<<------------------------------------------------











hi im the obstacle if you are wondering how i work heres my story:)   (im just gonna tell you about the fun part that happens every frame)

if(band(above(reg78,20),band(below(mz,0),b)),                       // if 20 frames have passed since my predecesor started                                                                                                          and i have reached the end 
                                                                       and theres a beat, then i:
assign( reg11, (reg11+3)%18                                  )+     // move the buffer index one place up
assign( index,reg11                                          )+     // i remember my index
assign( hw,rand(2)                                           )+     // i decide if im horizontal or vertical
assign( gmegabuf(index),(rand(8)-4)*.2+.125                  )+     // i write my pos to gmegabuf
assign( gmegabuf(index+1),hw                                 )+     // i write my orientation to gmegabuf
assign( gmegabuf(index+2),min(reg78,100)                     )+     // i write the time difference between me my predecesor (max diference =100 frames)
assign( reg78,0                                              )+     // i reset the timer
assign( mz,100                                               )+     // i go to the start
assign( start,1                                              )+     // i pick a random width 
                                                                       (reg98 is some crapy ratio fixer fsk gave me. fsk you lazy bastard:P)
assign( wid,(rand(35)+15)*reg98*.7                           ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                              )      // i make one step down the road
);                                     

if(band(below(mz,reg83),start),                                     // if i have passed the ship and havent done so before
assign(reg12,(index+3)%18)+assign(start,0)                          // i tell the ship to stop worrying about me,i rat on my friend whos comeing next                                                                                and remember i've done this already
,0);
 
n=above(mz,-1)*2;                                                   //  i tell avs that if im waiting he doesnt need to draw me 

blue=1-mz*.015;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;      


and then your classic triangle space ship a.k.a. me, comes in and 

t=gettime(0);                                                         // i look at the time
c=0;                                                                  // i reset the counter for the triangle fill
d=.25;                                                                // i move my pen to the start 
pix=2/h;                                                              // i mesure up one pixle
n=d/pix*3;                                                            // i calculate how many points il need to draw myself
                      
if(below(abs(if(gmegabuf(reg12+1),newx,newy)-gmegabuf(reg12)),.7),    // if im in the way of the next obstacle                  
assign(if(gmegabuf(reg12+1),newx,newy),gmegabuf(reg12)-.7*sign(gmegabuf(reg12)))+       //i move for .7 away from it on the apropriate side and axis 
assign(speed,(1.5/(gmegabuf(reg12+2)+.02)))                           // i calculate the aproximate speed ill need to move away in time 
                                                                         (from the time the obstacle sends me and some parameters fsk gave me)
,0);                                                         
mx=mx+(newx-mx)*speed;                                                // i move one step closer to safety if i need to
my=my+(newy-my)*speed;                                                // 

mx2=mx+sin(t*7)*.03;                                                  // i pretend im interesting and ghoing real fast by wobeling a bit:)
my2=my+sin(t*5)*.03;                                                  //
reg83=sin(t)+1;                                                       // i move forward and backward a bit to make myself even more interesting:D                                                                                      i also tell the obstacles about this
reg84=1/(1+reg83*.5);                                                 // i use projection to calculate my line width 
linesize=4*reg98*reg84;                                               // i calculate my linevidth with the factor from the previous line 
                                                                         and the crappy aspect fix                            

and thats it. thats preety much all we can do :( were stupid and we have a boring 'life' and its all fsk's fault - get a life dumbass:P instead of tourchuring us with your borring script kiddie tasks. huh just imagine i could have been an algorithm for some medical equipment or a space craft guidence sistem or some other leet shit like that instead of this ;(. oh well lifes a bitch and then the windows freeze. 
                   

 $   c    skip=1;
low=abs(getosc(i,.8,0));
oneL=max(low,oneL);
twoL=max(low,twoL);
curML=max(low,curML);
threeL=max(low,threeL);

mid=abs(getosc(i,.04,0)-getosc(i,.4,0));
oneM=max(mid,oneM);
twoM=max(mid,twoM);
curMM=max(mid,curMM);
threeM=max(mid,threeM);

hi=abs(getosc(i,.0,0)-getosc(i,.004,0));
oneH=max(hi,oneH);
twoH=max(hi,twoH);
curMH=max(hi,curMH);
threeH=max(hi,threeH); Ł  t=gettime(0);
reg46=(sin(t*.02)*cos(t*.05)*cos(t*.07)+1)*.4+.2;
ss=w+h;
if(equal(ss,buf),0,assign(reg00,1));
buf=ss;
reg78=reg78+1;
reg99=w/h;
reg98=(ss)*.003;
avgL=(oneL+twoL+threeL)/3;
avgL=max(avgL,.01);
reactL=(curML/avgL);
reactL=min(above(reactL,.7)*reactL,1);
curML=0;
oneL=oneL-.0001;
twoL=twoL-.001;
threeL=threeL-.01;

avgM=(oneM+twoM+threeM)/3;
avgM=max(avgM,.01);
reactM=(curMM/avgM);
reactM=above(reactM,0)*reactM;
curMM=0;
oneM=oneM-.0001;
twoM=twoM-.001;
threeM=threeM-.01;

avgH=(oneH+twoH+threeH)/3;
avgH=max(avgH,.01);
reactH=(curMH/avgH);
reactH=above(reactH,.2)*reactH;
curMH=0;
oneH=oneH-.0001;
twoH=twoH-.001;
threeH=threeH-.01;
reg30=reactL;
reg31=reactM;
reg32=reactH;     å   // calculates some weird wave averages;) + a litle global shit
n=50;
avgH=.1;
avgL=.1;
avgM=.1;
reg00=1;
loop(6,assign(gmegabuf(index),.7)+assign(gmegabuf(index+1),1)+assign(gmegabuf(index+2),100)+assign(index,(index+3)));       ’’’     ž’’’,   $                              @  AVS 2.8+ Effect List Config     .         //alpha gradient
    enabled=reg00; $   [       x=0;
y=i*2-1;
red=pow(i,1);
    t=t-0.05;
reg00=0;        n=80;                 "   ’     x=0;                   %                               ž’’’f     $                              @  AVS 2.8+ Effect List Config            
   //texture     (       $   Ž   J   y=.9;
x=i*.5-.5;
skip=bnot(bor(equal(c,sw1),equal(c,sw2)));
c=c+1;

 O   c=0;

sw1=rand(6);
sw2=rand(6);

red=reg30*bri;
blue=red;
green=red*.9;    
 !   n=6;bri=.7;//low
rs=n-1;mini=1;              $   H  t   d=c%2;
y=.9;
x=i*2-1;
skip=bnot(bor(below(c,sw1+2)*above(c,sw1-2),below(c,sw2+2)*above(c,sw2-2))*d);
c=c+1;

    c=0;
sw=(reg32);
sw1=if(sw,rand(40)+81,sw1);
sw2=if(sw,rand(40),sw2);

blue=reg32*bri+above(reg32,.95)*.1;
red=blue*.9;
green=blue;    

 #   n=160;bri=.05;//hi
rs=n-1;mini=1;              (      ė$     .   y=.9;
x=i*.5;
skip=above(i,v1);
c=c+1;

 S   c=0;
v1=max(v1-.05,getosc(0,0,2));
blue=bri+v1*.5;
red=blue*.8;
green=blue*.9; O   sw=bnot(reg32)+1;
sw1=if(sw,rand(40)+81,sw1);
sw2=if(sw,rand(40),sw2);


    n=20;bri=.1;//hi
rs=n-1;              $     2   y=.9;
x=-i*.5-.5;
skip=above(i,v1);
c=c+1;

 S   c=0;
v1=max(v1-.05,getosc(0,0,1));
blue=br1+v1*.5;
red=blue*.8;
green=blue*.9; O   sw=bnot(reg32)+1;
sw1=if(sw,rand(40)+81,sw1);
sw2=if(sw,rand(40),sw2);


 !   n=20;bri=.1;//hi
rs=n-1;mini=1;              $   5  6   y=.9;
//x=(sI)*.2+i*.01+.25;
x=-i*.5;

c=c+1;

 n   c=0;
si=(sin(gettime(0)*3));

v1=max(v1-.05,getosc(0,0,1));
blue=bri+v1*.5;
red=blue*.7;
green=blue*.7; O   sw=bnot(reg32)+1;
sw1=if(sw,rand(40)+81,sw1);
sw2=if(sw,rand(40),sw2);


 !   n=20;bri=.2;//hi
rs=n-1;mini=1;                 ?   ’  "   reg55=2/sh;
y=y+(reg55)*2;
x=x;                       2  ’    //raytrace tunel
dx1=if(x,x,.00001);
dy1=if(y,y,.00001)/reg99;
ky=abs(1/(dy1));
kx=abs(1/(dx1));
k=min(kx,ky);
dx=dx1*k;
dy=dy1*k;
kx=equal(k,kx);
ky=equal(k,ky);
x=if(kx,if(above(dx1,0),dy*.25-.75,-dy*.25+.25),if(above(dy1,0),-dx*.25-.25,dx*.24+.75));
y=k*2*.01;
                  (       $   \     
line=i*2-1; 
x1=if(hw,gmegabuf(index),line); 
y1=if(hw,line,gmegabuf(index)); 
z1=mz;
z=1/(1+z1/2);
x=x1*z;
y=y1*z*reg99;
c=c+1; ”  if(band(above(reg78,20),band(below(mz,0),b)),            
 assign( index,reg11                                             )+    
assign( hw,rand(2)                                               )+     
assign( gmegabuf(index+1),hw                            )+     
assign( gmegabuf(index),(rand(8)-4)*.2+.125        )+  
assign( gmegabuf(index+2),min(reg78,100)          )+     
assign( reg78,0                                                   )+     
assign( mz,100                                                    )+    
assign( start,1                                                     )+     
assign( reg11, (reg11+3)%18                               )+      
assign( wid,(rand(35)+15)*reg98*.7                      ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                       )    
);                                     
if(band(below(mz,reg83),start),                                     
assign(reg12,(index+3)%18)+assign(start,0)                          
,0);
n=above(mz,-1)*2;                                                 
blue=1-mz*.01;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;        // vv obstacles            $   ]     
line=i*2-1; 
x1=if(hw,gmegabuf(index),line); 
y1=if(hw,line,gmegabuf(index)); 
z1=mz;
z=1/(1+z1/2);
x=x1*z;
y=y1*z*reg99;
c=c+1; ¢  if(band(above(reg78,20),band(below(mz,0),b)),            
 assign( index,reg11                                             )+    
assign( hw,rand(2)                                               )+     
assign( gmegabuf(index+1),hw                            )+     
assign( gmegabuf(index),if(hw,reg80,reg81)       )+     
assign( gmegabuf(index+2),min(reg78,100)          )+     
assign( reg78,0                                                   )+     
assign( mz,100                                                    )+    
assign( start,1                                                     )+     
assign( reg11, (reg11+3)%18                               )+      
assign( wid,(rand(35)+15)*reg98*.7                      ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                       )    
);                                     
if(band(below(mz,reg83),start),                                     
assign(reg12,(index+3)%18)+assign(start,0)                          
,0);
n=above(mz,-1)*2;                                                 
blue=1-mz*.01;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;        // vv obstacles            $   \     
line=i*2-1; 
x1=if(hw,gmegabuf(index),line); 
y1=if(hw,line,gmegabuf(index)); 
z1=mz;
z=1/(1+z1/2);
x=x1*z;
y=y1*z*reg99;
c=c+1; ”  if(band(above(reg78,20),band(below(mz,0),b)),            
 assign( index,reg11                                             )+    
assign( hw,rand(2)                                               )+     
assign( gmegabuf(index+1),hw                            )+     
assign( gmegabuf(index),(rand(8)-4)*.2+.125        )+  
assign( gmegabuf(index+2),min(reg78,100)          )+     
assign( reg78,0                                                   )+     
assign( mz,100                                                    )+    
assign( start,1                                                     )+     
assign( reg11, (reg11+3)%18                               )+      
assign( wid,(rand(35)+15)*reg98*.7                      ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                       )    
);                                     
if(band(below(mz,reg83),start),                                     
assign(reg12,(index+3)%18)+assign(start,0)                          
,0);
n=above(mz,-1)*2;                                                 
blue=1-mz*.01;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;        // vv obstacles            $   ]     
line=i*2-1; 
x1=if(hw,gmegabuf(index),line); 
y1=if(hw,line,gmegabuf(index)); 
z1=mz;
z=1/(1+z1/2);
x=x1*z;
y=y1*z*reg99;
c=c+1; ¢  if(band(above(reg78,20),band(below(mz,0),b)),            
 assign( index,reg11                                             )+    
assign( hw,rand(2)                                               )+     
assign( gmegabuf(index+1),hw                            )+     
assign( gmegabuf(index),if(hw,reg80,reg81)       )+     
assign( gmegabuf(index+2),min(reg78,100)          )+     
assign( reg78,0                                                   )+     
assign( mz,100                                                    )+    
assign( start,1                                                     )+     
assign( reg11, (reg11+3)%18                               )+      
assign( wid,(rand(35)+15)*reg98*.7                      ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                       )    
);                                     
if(band(below(mz,reg83),start),                                     
assign(reg12,(index+3)%18)+assign(start,0)                          
,0);
n=above(mz,-1)*2;                                                 
blue=1-mz*.01;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;        // vv obstacles            $   ]     
line=i*2-1; 
x1=if(hw,gmegabuf(index),line); 
y1=if(hw,line,gmegabuf(index)); 
z1=mz;
z=1/(1+z1/2);
x=x1*z;
y=y1*z*reg99;
c=c+1; ¢  if(band(above(reg78,20),band(below(mz,0),b)),            
 assign( index,reg11                                             )+    
assign( hw,rand(2)                                               )+     
assign( gmegabuf(index+1),hw                            )+     
assign( gmegabuf(index),if(hw,reg80,reg81)       )+     
assign( gmegabuf(index+2),min(reg78,100)          )+     
assign( reg78,0                                                   )+     
assign( mz,100                                                    )+    
assign( start,1                                                     )+     
assign( reg11, (reg11+3)%18                               )+      
assign( wid,(rand(35)+15)*reg98*.7                      ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                       )    
);                                     
if(band(below(mz,reg83),start),                                     
assign(reg12,(index+3)%18)+assign(start,0)                          
,0);
n=above(mz,-1)*2;                                                 
blue=1-mz*.01;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;        // vv obstacles            $   ]     
line=i*2-1; 
x1=if(hw,gmegabuf(index),line); 
y1=if(hw,line,gmegabuf(index)); 
z1=mz;
z=1/(1+z1/2);
x=x1*z;
y=y1*z*reg99;
c=c+1; ¢  if(band(above(reg78,20),band(below(mz,0),b)),            
 assign( index,reg11                                             )+    
assign( hw,rand(2)                                               )+     
assign( gmegabuf(index+1),hw                            )+     
assign( gmegabuf(index),if(hw,reg80,reg81)       )+     
assign( gmegabuf(index+2),min(reg78,100)          )+     
assign( reg78,0                                                   )+     
assign( mz,100                                                    )+    
assign( start,1                                                     )+     
assign( reg11, (reg11+3)%18                               )+      
assign( wid,(rand(35)+15)*reg98*.7                      ),     
//else: 
assign( mz,max(-3,mz-reg55*200)                       )    
);                                     
if(band(below(mz,reg83),start),                                     
assign(reg12,(index+3)%18)+assign(start,0)                          
,0);
n=above(mz,-1)*2;                                                 
blue=1-mz*.01;                                                     
green=blue; 
red=blue*.7;
linesize=wid*z;        // vv obstacles            (       $   @  Į   st=c%2; 
d=if(bnot(st),d-pix,d);
x1=(st*.45-.225)*i*ys+mx2; 
y1=1;
z1=d+reg83-.15;
z=1/(1+z1*.5);
x=x1*z;
y=y1*z*reg99;
reg97=min(z1,reg97);
red=z*.013;
green=red;
blue=red;
c=c+1; ś  tb=t;
t=gettime(0);
fr=tb-t;
c=0;
ys=(reg81+1)*.5+.2;
d=.45*ys;
pix=2/h;
n=d/pix;
if(below(abs(if(gmegabuf(reg12+1),newx,newy)-gmegabuf(reg12)),.7),
assign(if(gmegabuf(reg12+1),newx,newy),gmegabuf(reg12)-.7*sign(gmegabuf(reg12)))+
assign(speed,(1.5/(gmegabuf(reg12+2)+.02)))
,0);
reg14=(newx-mx)*speed;
reg15=(newy-my)*speed;
mx=mx+reg14;
my=my+reg15;

mx2=mx+sin(t*7)*.03;
my2=my+sin(t*5)*.03;
t1=t1+get;
reg83=sin(t)*2+2;
reg84=1/(1+reg83*.5);
linesize=1;
reg80=mx2;
reg81=my2;
 ,   get=getosc(0,0,0)*tb*.000001;
reg99=w/h;
 8   //ship;

speed=.2
mx=.5;
my=.3;
newx=.2;
newy=.7;           ž’’’}   $’   #                           @  AVS 2.8+ Effect List Config     (         //atmosfhere    alphaout=reg46                    qk
Color Map                       Č                    p	                                                      H	                                                       	                                                      Čå                                                       å                                                       pX                                                      xå                                                       vy                                                     (   ’   ¤Į’        /     ’   Żī’                 ’   ’’’        ’      ’   ’’Ż        S )     ’   Õ’Õ t      Ęc      »   ’ęĢ    ’   Łģ’ ¬@      ’     ’   ’×ś           
_     ’      ō   ’³f žB  ž’’’ū   $                             @  AVS 2.8+ Effect List Config     "          // render&blend  ship     (       $   ß    st=c%3; 
d=if(bnot(st),d-pix,d);
r=st*.3333333333333333*$pi*2+$pi*.5;// heres avs pretending he can read long numbers
x1=cos(r)*d+reg80; 
y1=reg81;
z1=sin(r)*d+reg83;
z=1/(1+z1*.5);
x=x1*z;
y=y1*z*reg99;
reg97=min(z1,reg97);
red=min(i*3,1);
green=red;
blue=red;
c=c+1; @   c=0;
d=.25;
pix=2/h;
n=d/pix*3;
linesize=4*reg98*reg84;

 ,   get=getosc(0,0,0)*tb*.000001;
reg99=w/h;
 8   //ship;

speed=.2
mx=.5;
my=.3;
newx=.2;
newy=.7;              Pm
Acko.net: Texer II              ®      avsres_texer_circle_sharp_19x19.bmp bmp                                                                                                                                                                                                                                              n=2;//exterior rings$   sizex=reg98*.48*reg84;
sizey=sizex;    N   z1=-.15+reg83;
z=1/(1+z1/2);
x1=(i-.5)*.16+reg80;
x=x1*z;
y=reg81*z*reg99;(       Pm
Acko.net: Texer II              l      avsres_texer_circle_heavyblur_21x21.bmp                                                                                                                                                                                                                                           o   row=10; clm=2;ef=3;
n=row*clm;
ofx=1/clm;
ofy=1/row;
mox=2*ofx;
moy=2*ofy;
startx=-1+ofx;
starty=-1-ofy;)   lig=max(0,min(1,lig+b-.03));
c=0;
z1=0;    ¬  gx=c%clm; 
x1=gx*.16-.08;  
z1=if(bnot(gx),min(z1-.01,z1-.07+.3*thrust),z1);  
thr=getosc(-z1,.1,2)*z1*2;
thr2=getosc(-z1,.1,1)*z1*2;   
thrust=if(gx,thr,thr2); 
c=c+1;
z2=z1-.15+reg83;
if(below(z2,-1.99),assign(z2,-1.99),0);
z=1/(1+z2/2);
x=(x1+reg80-z1*-reg14*ef)*z;
y=(y1+reg81-z1*-reg15*ef)*z*reg99;
sizex=min(2,abs((1.4+z1)*reg98*.3+thrust*-z1*3))*z;
sizey=sizex;
red=.1+lig*.9*-z1;
green=red;  
blue=red;
                              ’’’             %          (       Pm
Acko.net: Texer II              Ģ      avsres_texer_circle_edgeonly_19x19.bmp                                                                                                                                                                                                                                               n=2;//exterior ringsB   sizex=reg98*.4*reg84;
sizey=sizex;
red=.1;
green=.5;
blue=.5
    N   z1=-.15+reg83;
z=1/(1+z1/2);
x1=(i-.5)*.16+reg80;
x=x1*z;
y=reg81*z*reg99;Pm
Acko.net: Texer II              ÷      avsres_texer_circle_heavyblur_19x19.bmp                                                                                                                                                                                                                                              n=2;//exterior ringsm   sizex=reg98*.3*reg84;
sizey=sizex;
lig=max(0,min(.5,lig+b-.015));
red=.1+lig;
green=.5+lig*.5;
blue=.5
    N   z1=-.13+reg83;
z=1/(1+z1/2);
x1=(i-.5)*.16+reg80;
x=x1*z;
y=reg81*z*reg99;Pm
Acko.net: Texer II                    avsres_texer_circle_heavyblur_21x21.bmp                                                                                                                                                                                                                                           o   row=10; clm=2;ef=3;
n=row*clm;
ofx=1/clm;
ofy=1/row;
mox=2*ofx;
moy=2*ofy;
startx=-1+ofx;
starty=-1-ofy;-   
lig=max(0,min(.5,lig+b-.015));
c=0;
z1=0;    Ų  gx=c%clm;
x1=gx*.16-.08;
z1=if(bnot(gx),min(z1-.01,z1-.07+.3*thrust),z1);  
thr=getosc(-z1,.1,2)*z1*2;
thr2=getosc(-z1,.1,1)*z1*2;
thrust=if(gx,thr,thr2);   
c=c+1;
z2=z1-.15+reg83;
if(below(z2,-1.99),assign(z2,-1.99)+assign(skip,1),0);
z=1/(1+z2/2);
x=(x1+reg80-z1*-reg14*ef)*z;
y=(y1+reg81-z1*-reg15*ef)*z*reg99;
sizex=min(2,abs((1.4+z1)*reg98*.3+thrust*-z1*5))*z;
sizey=sizex;
red=.2-lig*z1+z2*.5*.1; 
green=.2-lig*z1*.2+z2*.5*.1;
blue=.3-lig*-z1+z2*.1;%         
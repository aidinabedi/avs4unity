Nullsoft AVS Preset 0.2    s   o   >> alien device [ gallery rmx ]

:: zamuz | gonzalo muсoz
>> strifer27@tutopia.com
>> zamuz.deviantart.com    н  й      _               /                                                                                /
   |  | 10       /                             Alien Device                               /
   |  |          /                                                                                /
 /_/        /________________________________________/
______/


Back-face culling. Its not perfect because I had to hack around the perspective projection but its good enough for me. Back-face culling in an orthographic projection is much easier. The way it works is by checking which direction the face normals are pointing, if they are pointing away into the screen then the superscope for that face is not drawn. The normals are also used to add some basic lighting and a bump is placed rougly where the specular highlight should be. The dodecahedron itself is the same one that I've used before with solid pentagons instead of wireframes and a simple cycling texture placed on top, the color code is pretty simple, the bump does most of the work in making the object look particularly solid. Increase the numpoints variable in the first superscope's init box to increase the detail level for faster computers.


-- Jheriko

jheriko@ntlworld.com $   °      y  // Rotation
rx=rx+drx*dt;
ry=ry+dry*dt;
rz=rz+drz*dt;
drx=drx*.9+.1*tdrx;dry=dry*.9+.1*tdry;drz=drz*.9+.1*tdrz;
crz=cos(rz);srz=sin(rz);
cry=cos(ry);sry=sin(ry);
crx=cos(rx);srx=sin(rx);

// Aspect ratio
asp=h/w;

// Dump to global registers
reg00=asp;
reg01=crz;reg02=srz;
reg03=cry;reg04=sry;
reg05=crx;reg06=srx;

dt=gettime(lasttime);lasttime=gettime(0); }   tdrx=if(rand(10),tdrx,(rand(11)-5)*.25);
tdry=if(rand(10),tdry,(rand(11)-5)*.25);
tdrz=if(rand(10),tdrz,(rand(11)-5)*.25); К   // Global variables innit
n=0;
numpoints=360;
reg99=numpoints;
tdrx=(rand(11)-5)*.25;
tdry=(rand(11)-5)*.25;
tdrz=(rand(11)-5)*.25;       €€€     ю€€€дJ  Б  $А   А                           @  AVS 2.8+ Effect List Config                    (       А$   $  %  x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
blue=.7*red;red=1.2*green;green=1.2*green;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     Ћ   // Back Face Culled Pentagon 1
n=reg99;

// Coordinates
kx0=1;ky0=1;kz0=1;
kx1=$PHI;ky1=0;kz1=$PHI-1;
kx2=1;ky2=-1;kz2=1;
kx3=0;ky3=1-$PHI;kz3=$PHI;
kx4=0;ky4=$PHI-1;kz4=$PHI;
scaleinc=1/(n/6);       €€€    $       x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
red=0.8*red;blue=0.8*red;
   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ѕ   // Back Face Culled Pentagon 2
n=reg99;

// Coordinates
kx0=1-$PHI;ky0=-$PHI;kz0=0;
kx1=-1;ky1=-1;kz1=1;
kx2=0;ky2=1-$PHI;kz2=$PHI;
kx3=1;ky3=-1;kz3=1;
kx4=$PHI-1;ky4=-$PHI;kz4=0;
scaleinc=1/(n/6);       €€€    $   $  "  x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
green=.8*red;red=.7*blue;blue=.8*green;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ќ   // Back Face Culled Pentagon 3
n=reg99;

// Coordinates
kx0=1;ky0=-1;kz0=1;
kx1=$PHI;ky1=0;kz1=$PHI-1;
kx2=$PHI;ky2=0;kz2=1-$PHI;
kx3=1;ky3=-1;kz3=-1;
kx4=$PHI-1;ky4=-$PHI;kz4=0;
scaleinc=1/(n/6);       €€€    $        x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
green=.8*red;red=.35*blue;blue=red;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ќ   // Back Face Culled Pentagon 4
n=reg99;

// Coordinates
kx0=-1;ky0=1;kz0=1;
kx1=0;ky1=$PHI-1;kz1=$PHI;
kx2=0;ky2=1-$PHI;kz2=$PHI;
kx3=-1;ky3=-1;kz3=1;
kx4=-$PHI;ky4=0;kz4=$PHI-1;
scaleinc=1/(n/6);       €€€    $       x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
red=0.8*red;green=0.7*red;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     Ћ   // Back Face Culled Pentagon 5
n=reg99;

// Coordinates
kx0=1;ky0=1;kz0=1;
kx1=$PHI-1;ky1=$PHI;kz1=0;
kx2=1;ky2=1;kz2=-1;
kx3=$PHI;ky3=0;kz3=1-$PHI;
kx4=$PHI;ky4=0;kz4=$PHI-1;
scaleinc=1/(n/6);       €€€    $     ы  x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     “   // Back Face Culled Pentagon 6
n=reg99;

// Coordinates
kx0=$PHI-1;ky0=-$PHI;kz0=0;
kx1=1;ky1=-1;kz1=-1;
kx2=0;ky2=1-$PHI;kz2=-$PHI;
kx3=-1;ky3=-1;kz3=-1;
kx4=1-$PHI;ky4=-$PHI;kz4=0;
scaleinc=1/(n/6);       €€€    $   %  "  x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
green=.8*red;red=.7*blue;blue=.8*green;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ѕ   // Back Face Culled Pentagon 7
n=reg99;

// Coordinates
kx0=-1;ky0=1;kz0=1;
kx1=1-$PHI;ky1=$PHI;kz1=0;
kx2=-1;ky2=1;kz2=-1;
kx3=-$PHI;ky3=0;kz3=1-$PHI;
kx4=-$PHI;ky4=0;kz4=$PHI-1;
scaleinc=1/(n/6);       €€€    $   ,  %  x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
blue=.7*red;red=1.2*green;green=1.2*green;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ”   // Back Face Culled Pentagon 8
n=reg99;

// Coordinates
kx0=-$PHI;ky0=0;kz0=1-$PHI;
kx1=-1;ky1=1;kz1=-1;
kx2=-0;ky2=$PHI-1;kz2=-$PHI;
kx3=0;ky3=1-$PHI;kz3=-$PHI;
kx4=-1;ky4=-1;kz4=-1;
scaleinc=1/(n/6);       €€€    $       x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
red=0.8*red;blue=0.8*red;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ќ   // Back Face Culled Pentagon 9
n=reg99;

// Coordinates
kx0=-1;ky0=1;kz0=-1;
kx1=1-$PHI;ky1=$PHI;kz1=0;
kx2=$PHI-1;ky2=$PHI;kz2=0;
kx3=1;ky3=1;kz3=-1;
kx4=0;ky4=$PHI-1;kz4=-$PHI;
scaleinc=1/(n/6);       €€€    $       x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
red=0.8*red;green=0.7*red;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ‘   // Back Face Culled Pentagon 10
n=reg99;

// Coordinates
kx0=-$PHI;ky0=0;kz0=$PHI-1;
kx1=-$PHI;ky1=0;kz1=1-$PHI;
kx2=-1;ky2=-1;kz2=-1;
kx3=1-$PHI;ky3=-$PHI;kz3=-0;
kx4=-1;ky4=-1;kz4=1;
scaleinc=1/(n/6);       €€€    $   ы  ы  x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     ћ   // Back Face Culled Pentagon 11
n=reg99;

// Coordinates
kx0=-1;ky0=1;kz0=1;
kx1=0;ky1=$PHI-1;kz1=$PHI;
kx2=1;ky2=1;kz2=1;
kx3=$PHI-1;ky3=$PHI;kz3=0;
kx4=1-$PHI;ky4=$PHI;kz4=0;
scaleinc=1/(n/6);       €€€    $   "    x1=((equal(pnum,0)*kx0+equal(pnum,1)*kx1+equal(pnum,2)*kx2+equal(pnum,3)*kx3+equal(pnum,4)*kx4+equal(pnum,5)*kx0)-nx0)*scale+nx0;
y1=((equal(pnum,0)*ky0+equal(pnum,1)*ky1+equal(pnum,2)*ky2+equal(pnum,3)*ky3+equal(pnum,4)*ky4+equal(pnum,5)*ky0)-ny0)*scale+ny0;
z1=((equal(pnum,0)*kz0+equal(pnum,1)*kz1+equal(pnum,2)*kz2+equal(pnum,3)*kz3+equal(pnum,4)*kz4+equal(pnum,5)*kz0)-nz0)*scale+nz0;

x2=x1*crz-y1*srz;
y2=x1*srz+y1*crz;
x1=x2*cry+z1*sry;
z2=-x2*sry+z1*cry;
y1=y2*crx-z2*srx;
z1=y2*srx+z2*crx;
z1=1/(2+.25*z1);
x=x1*z1;
y=y1*z1;
x=x*asp;
pnum=(pnum+1)%6;
red=max(.1,bnot(equal(pnum,1))*light*sin(15*scale)*sin(21*scale+t))+equal(scale,1)*light+.5*light+.1;
green=max(.1,.4*red);
blue=max(.1,.4*red);
scale=if(pnum,scale,scale-scaleinc);
green=.8*red;red=.35*blue;blue=red;   t=t+getspec(0.5,1,0);
// Calculate normal
nx=(kx0+kx1+kx2+kx3+kx4)*0.2;
ny=(ky0+ky1+ky2+ky3+ky4)*0.2;
nz=(kz0+kz1+kz2+kz3+kz4)*0.2;
nx0=nx;ny0=ny;nz0=nz;

// Load stuff from global registers
asp=reg00;
crz=reg01;srz=reg02;
cry=reg03;sry=reg04;
crx=reg05;srx=reg06;
pnum=0;

// Rotate normal
mx=nx*crz-ny*srz;
my=nx*srz+ny*crz;
nx=mx*cry+nz*sry;
mz=-mx*sry+nz*cry;
ny=my*crx-mz*srx;
nz=my*srx+mz*crx;

n=bnot(above(nz,-.1*(sqr(nx)+sqr(ny))))*reg99;

scale=1;

light=.1+6/(sqr(nx-1)+sqr(ny+1)+sqr(nz-1.5));     –   // Back Face Culled Pentagon 12
n=reg99;

// Coordinates
kx0=0;ky0=$PHI-1;kz0=-$PHI;
kx1=1;ky1=1;kz1=-1;
kx2=$PHI;ky2=0;kz2=1-$PHI;
kx3=1;ky3=-1;kz3=-1;
kx4=0;ky4=1-$PHI;kz4=-$PHI;
scaleinc=1/(n/6);       €€€    +   а   9   x=(x*1.5/(sin(sz)-1.2))+sx;
y=(y*1.5/(sin(sz)-1.2))+sy; 2   sx=ax+(sx/1.1);
sy=ay+(sy/1.1);
sz=az+(sz/1.2); D   ax=rand(10)/100-.1/2;
ay=rand(10)/100-.1/2;
az=rand(10)/100-.1/2;                                                   А   ю€€€#  А  $А   :                          @  AVS 2.8+ Effect List Config                    ю€€€q   В $А   А                          @  AVS 2.8+ Effect List Config                                     А   +   q      d=d/1.02;r=r+(sr/10);    sr=ar+(sr/1.1);
    ar=rand(10)/100-.1/2;
                                    Иq≤Color Map                       ∞                      :ш                                                        4ш                                                       Є3ш                                                       P3ш                                                       »fA                                                       `bц                                                       HCш                                                       8ор                                                            €   €€€                €   €€€                €   €€€                €   €€€                €   €€€                €   €€€                €   €€€                €   €€€       (                                  +   У       x=x*2+sx;
y=y*2+sy;
alpha=0.1    sx=ax+sx;
sy=ay+sy; -   ax=rand(10)/100-.1/2;
ay=rand(10)/100-.1/2;                                  %         +   Ц   #   x=-x*5+sx;
y=-y*5+sy;
alpha=0.06    sx=ax+sx;
sy=ay+sy; -   ax=rand(10)/100-.1/2;
ay=rand(10)/100-.1/2;                                  
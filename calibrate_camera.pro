read_jpeg,'~/cotton_pictures/WP_20170730_10_22_19_Pro.jpg',c

;Use red channel for now
cr=reform(c[0,*,*])
s=size(cr,/dim)

;Check calibration every 100 pixels along first dimension, starting at 10th pixel
calx=fltarr(s[0]/10)
c=0
FOR i=10,s[0]-1,10 DO BEGIN
   f=fft(cr[i,*],-1)
   y=real_part(abs(f)/f[0])
   pk=peaks(y, 8)
   pk1=(pk[where(pk gt 5)])[0]  ;Choose first peak at a value > 5 to avoid mean
   ;print,float(s[1])/pk1
   calx[c]=float(s[1])/pk1
   c=c+1
ENDFOR

print,''

;Again along other dimension
caly=fltarr(s[1]/10)
c=0
FOR i=10,s[1]-1,10 DO BEGIN
   f=fft(cr[*,i],-1)
   y=real_part(abs(f)/f[0])
   pk=peaks(y, 8)
   pk1=(pk[where(pk gt 5)])[0]
   ;print,float(s[0])/pk1
   caly[c]=float(s[0])/pk1
   c=c+1
ENDFOR

print,'Pix per division:', median(calx), median(caly)   ;pixels per 2mm

;For this graph paper every cal1 or cal2 pixels equals 2mm.
;The camera was 157mm away
;Ignoring pincushion etc for now
zdist=157.0
offsetx=(findgen(s[0]) - s[0]/2)  ;Pixels from center of picture
offsety=(findgen(s[1]) - s[1]/2)

mmppx=2.0/median(calx)  ;mm per pixel
mmppy=2.0/median(caly)

thetax=atan(offsetx * mmppx / zdist) * 180/!pi
thetay=atan(offsety * mmppy / zdist) * 180/!pi

print,'FOV_x',max(thetax)-min(thetax)
print,'FOV_y',max(thetay)-min(thetay)
plot,offsety,thetay
oplot,[min(offsety),max(offsety)],[min(thetay), max(thetay)]
stop
END
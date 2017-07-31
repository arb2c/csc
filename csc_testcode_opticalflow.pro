;A 14 minute sequence I took with phone on Jul 27 2017, images every 10 seconds
spawn,'''ls'' /sysdisk1/bansemer/citizen_sky_camera/cloud_pictures/*jpg', fn
s=sort(fn)
fn=fn[s]
n=n_elements(fn)

downsize=800   ;Max dimension of downsized photo
;
window,0,xsize=downsize*2+10, ysize=1000
FOR i=0,n-1 DO BEGIN
   read_jpeg,fn[i],img
   s=float(size(img,/dim))
   simg=float(congrid(reform(img[0,*,*]), downsize, s[2]/s[1]*downsize))
   simg_rbr=simg/(float(congrid(reform(img[2,*,*]), downsize, s[2]/s[1]*downsize)))
   tv,simg
   tv,sobel(simg),810,0
   tv,simg_rbr*200,0,500
   tv,sobel(simg_rbr)*200,810,500
ENDFOR











END
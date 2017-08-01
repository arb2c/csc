;Testing 4 pictures taken of cotton balls at home

;Position relative to the bottom-right corner of the board I was using, centimeters
xpos=[-20.4, -0.7, -0.7, -20.4]
ypos=[0.4, 0.4, 38.0, 38.0]

dirname='~/cotton_pictures/'
fn=['WP_20170730_10_10_38_Pro2.jpg',$
   'WP_20170730_10_10_54_Pro2.jpg',$
   'WP_20170730_10_11_06_Pro2.jpg',$
   'WP_20170730_10_11_14_Pro2.jpg']

;Position to center(roughly) of each cloud
cx=[-17.0, 1.0]
cy=[22.0, 34.0]
diam=[6.5, 7.5]  ;Very rough

;Will need to check EXIF dat for orientation on different cameras.
;On Lumia all here are set to 'Top-left' (EXIF: Image Data / Orientation)
;Pixel 0,0 in IDL convention is northeast
;Maybe use sun/sky brightness as a check?


FOR i=0,n_elements(fn)-1 DO BEGIN
   read_jpeg,dirname+fn[i],img
   r=reform(img[0,*,*])
   rbr=float(r)/(reform(img[2,*,*]))   ;This tends to take out darker area (like paper clips here)
   edges=roberts(rbr)  ;GDL supported, when in IDL can also try sobel, laplacian, edge_dog, shift_diff, and prewitt 
   
   ;Just some vis stuff, summing all images
   IF i eq 0 THEN BEGIN
      sumimg=float(img)
      sumedges=float(img)*0
      sumedges[i,*,*]=edges  ;Add to red channel, other colors come next
   ENDIF ELSE BEGIN
      sumimg=sumimg+img
      sumedges[i<2,*,*]=sumedges[i<2,*,*]+edges
      IF i eq 3 THEN sumedges[0,*,*]=sumedges[0,*,*]+edges
   ENDELSE

   
ENDFOR
s=size(r,/dim)
window,0,xsize=s[0],ysize=s[1]
tv,sumimg/4,/true

window,1,xsize=s[0],ysize=s[1]
tv,sumedges*400,/true

END

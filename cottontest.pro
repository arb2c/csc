;Testing 4 pictures taken of cotton balls at home

;Position relative to the bottom-right corner of the board I was using, centimeters
xpos=[-20.4, -0.7, -0.7, -20.4]
ypos=[0.4, 0.4, 38.0, 38.0]

dirname='~/cotton_pictures/'
IF float(!version.release) gt 8 THEN dirname='/sysdisk1/bansemer/citizen_sky_camera/cotton_pictures/'
fn=['WP_20170730_10_10_38_Pro2.jpg',$
   'WP_20170730_10_10_54_Pro2.jpg',$
   'WP_20170730_10_11_06_Pro2.jpg',$
   'WP_20170730_10_11_14_Pro2.jpg']

;Position to center(roughly) of each cloud
cx=[-17.0, 1.0]
cy=[22.0, 34.0]
cz=[]
diam=[6.5, 7.5]  ;Very rough
pix2ang=csc_pixelmap(camera='Lumia 640 Forward')

;Will need to check EXIF dat for orientation on different cameras.
;On Lumia all here are set to 'Top-left' (EXIF: Image Data / Orientation)
;Pixel 0,0 in IDL convention is northeast
;Maybe use sun/sky brightness as a check?

nfeatures=10  ;Max number of features per image
base={xcg:fltarr(nfeatures), ycg:fltarr(nfeatures), area:fltarr(nfeatures), roi:fltarr(nfeatures), $
      theta:fltarr(nfeatures), phi:fltarr(nfeatures), n:0}
features=replicate(base, n_elements(fn))

FOR i=0,n_elements(fn)-1 DO BEGIN
   read_jpeg,dirname+fn[i],img
   r=reform(img[0,*,*])
   rbr=float(r)/(reform(img[2,*,*]))   ;This tends to take out darker area (like paper clips here)
   edges=roberts(rbr)  ;GDL supported, when in IDL can also try sobel, laplacian, edge_dog, shift_diff, and prewitt 
   ;edges=prewitt(rbr)

   ;Use rbr to get fore/back values
   rbr_scaled=rbr/max(rbr) * 255.0 
   fb=csc_foreback(rbr_scaled)

   ;Threshold the image
   thresh=(fb.fore+fb.back)/2.0
   rbr_thresh=rbr*0
   rbr_thresh[where(rbr_scaled gt thresh)]=1

   ;Get blobs and properties
   blobs=label_blobs(rbr_thresh)
   nblobs=max(blobs)
   barea=fltarr(nblobs)
   bx=fltarr(nblobs)
   by=fltarr(nblobs)
   FOR j=0,nblobs-1 DO BEGIN
      thisblob=blobs*0
      thisblob[where(blobs eq (j+1))]=1
      iv=invariant_moments(thisblob, /norotate)
      features[i].area[j]=iv.area
      features[i].xcg[j]=iv.xcg
      features[i].ycg[j]=iv.ycg
      features[i].roi[j]=iv.roi
      features[i].theta[j]=pix2ang.theta[round(iv.xcg)]
      features[i].phi[j]=pix2ang.phi[round(iv.ycg)]
      features[i].n=features[i].n+1
   ENDFOR
   
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

;Do some triangulation
;Cheesy feature matching for now... this is going be tough
FOR i=0,features[0].n-1 DO BEGIN   ;Assume all features are in all pictures, eventually need to change this
   roi=features[0].roi[i]
   roidiff=abs(features.roi-roi)/roi
   w=where(roidiff lt 0.1, nw)   ;Index to each matching feature
   
   perm1=intarr(factorial(nw-1))
   perm2=intarr(factorial(nw-1))
   c=0
   for j=0,nw-2 do begin
      for k=j+1,nw-1 do begin
         perm1[c]=w[j]   ;Get each permutation of indexes, picture 0 with 1,2,and 3; picture 1 with 2 and 3, etc.
         perm2[c]=w[k]
         
         c=c+1
         
      endfor
   endfor
    ;Now compute position of each feature from all combinations of w
   ;perm1=[]
ENDFOR

;Just link by hand for now.
ilink=[[0,0,0,0],[1,1,1,1]]  ;Linked features have the same index in all frames.  Won't always be so lucky.

END

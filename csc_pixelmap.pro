FUNCTION csc_pixelmap, fov, npix, camera=camera
   ;Return the angles (theta and phi) for each pixel in the x and y direction
   ;based on field of view and number of pixels
   ;Use csc_cameraspecs to get these values.
   ;fov is 2-element array in degrees for the x and y dimensions
   ;npix is a 2-element array in pixels for x and y dimensions

   ;camera is the cameraname in csc_cameraspecs, and overrides fov and npix
   
   ;Note: this assumes that there is no appreciable distortions in the camera, i.e. it gives a planar view.
   
   IF n_elements(camera) ne 0 THEN BEGIN
      c=csc_cameraspecs(name=camera)
      fov=[c.xfov, c.yfov]
      npix=[c.xres, c.yres]      
   ENDIF
   
   maxxdist=tan(fov[0]/2 * !pi/180)   ;Assume height of 1, find distance from center of picture to edge based on FOV  
   maxydist=tan(fov[1]/2 * !pi/180)
   
   theta=fltarr(npix[0])  ;Angle represented by each pixel, 0 degrees is zenith
   phi=fltarr(npix[1])
   
   xdist=maxxdist * (findgen(npix[0])-npix[0]/2)/(npix[0]/2)
   ydist=maxydist * (findgen(npix[1])-npix[1]/2)/(npix[1]/2)
   
   theta=atan(xdist)  ;*180/!pi
   phi=atan(ydist)    ;*180/!pi

   ;A full matrix for elevation
   ;Probably a better way to do this
   dist=fltarr(npix)
   FOR i=0,npix[0]-1 DO dist[i,*]=xdist[i]^2
   FOR i=0,npix[1]-1 DO dist[*,i]=dist[*,i]+ydist[i]^2
   dist=sqrt(dist)
   elevation=(!pi/2 - atan(dist)) ; * 180/!pi

   ;For azimuth, using the atan (2-term) function gets the signs right, acos and asin don't.
   xdist2d=fltarr(npix)
   ydist2d=fltarr(npix)
   FOR i=0,npix[1]-1 DO xdist2d[*,i]=xdist
   FOR i=0,npix[0]-1 DO ydist2d[i,*]=ydist
   ;Flipping signs and order here will change the orientation of the zero azimuth, currently set 
   ;zero is aligned with the x-axis (right side in IDL TV orientation), with the -pi/pi seam on the left.
   azimuth=atan(ydist2d,-xdist2d) 
   
   ;All in radians for now
   return,{theta:theta, phi:phi, elevation:elevation, azimuth:azimuth}
END
   
   
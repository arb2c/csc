FUNCTION csc_cameraspecs, name=name, id=id
   ;PRO to return settings for all supported cameras in a structure

        
   base={cameraname:'', shortname:'', format:'', focallength:'', xfov:0.0, yfov:0.0,$
         xres:0L, yres:0L, equiv35:0.0}

   x=base
   
   ;First addition
   x.cameraname='iPhone4'
   x.shortname='ip4'
   x.format='apple'
   x.focallength=3.85   ;mm
   x.xfov=60.8
   x.yfov=47.5
   x.xres=2592
   x.yres=1936
   x.equiv35=30  
   all=x   

   ;Add more probes to the list starting here:
   x.cameraname='iPhone4s'
   x.shortname='ip4s'
   x.format='apple'
   x.focallength=4.28   ;mm
   x.xfov=56.423
   x.yfov=43.83
   x.xres=3264
   x.yres=2448
   x.equiv35=30  
   all=[all,x]   

   x.cameraname='iPhone5'
   x.shortname='ip5'
   x.format='apple'
   x.focallength=4.1   ;mm
   x.xfov=58.498
   x.yfov=45.56
   x.xres=3264
   x.yres=2448
   x.equiv35=30  
   all=[all,x] 
   
   x.cameraname='iPhone5s'
   x.shortname='ip5'
   x.format='apple'
   x.focallength=4.12   ;mm
   x.xfov=61.4
   x.yfov=48.0
   x.xres=3264
   x.yres=2448
   x.equiv35=30  
   all=[all,x] 

   x.cameraname='iPad2'
   x.shortname='ipad2'
   x.format='apple'
   x.focallength=4.28   ;mm
   x.xfov=56.423
   x.yfov=43.83
   x.xres=3264
   x.yres=2448
   x.equiv35=30  
   all=[all,x]   
   

   ;Sources
   ; ;Field of view measurements found online (degrees):
   ; older iPhone : 37mm
   ; iPhone4:   60.8 x 47.5  (30mm)
   ; iPhone4S:  55.7 x 43.2
   ; iPhone5S:  61.4 x 48.0
   ; 
   ; from http://caramba-apps.com/blog/files/field-of-view-angles-ipad-iphone.html
   ;     iPhone 4:  61.048 x 47.53 degrees (based upon a resolution of 2592x1936 pixels, a focal length of 3.85mm and a vertical chip size of 4.54mm, ref)
   ;     iPhone 4s: 56.423 x 43.83 degrees (based upon a resolution of 3264x2448 pixels, a focal length of 4.28mm and a vertical chip size of 4.592mm, ref)
   ;     iPhone 5:  58.498 x 45.56 degrees (based upon a resolution of 3264x2448 pixels, a focal length of 4.1mm and a vertical chip size of 4.592mm)
   ; 
   ;     New iPad:  56.423 x 43.83 degrees (same as iPhone 4s)
   ; 
   ;More at http://www.anandtech.com/show/7329/some-thoughts-about-the-iphone-5s-camera-improvements
 
   IF n_elements(name) ne 0 THEN BEGIN
      w=where(name eq all.cameraname,nw)
      IF nw gt 0 THEN return, all[w] ELSE return,base
   ENDIF
   IF n_elements(id) ne 0 THEN BEGIN
      IF id lt n_elements(all) THEN return, all[id] ELSE return,base
   ENDIF

   ;Return everything if no probe specified
   return,all
END

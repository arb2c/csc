FUNCTION csc_foreback,img,binsize=binsize
   ;FUNCTION to find the background and foreground levels of an image
   ;requires a gray level cloud image ranging from 0 to 255
   ;Assumed mean image value is between the foreground and background... should
   ;be valid for most in-focus particles.
   ;AB 8/17
   ;Adapted from CPI code
   
   IF n_elements(binsize) eq 0 THEN binsize=3 ;to ignore some noise
   z=smooth(histogram(img,binsize=binsize,max=255,min=0),5,/edge_truncate)
   
   ;Fore/back peaks show up better in log space
   lz=alog10(z)
   
   ;Find the mean in log space
   logmean=total(lz*findgen(n_elements(lz)),/nan) / total(lz,/nan)
   i=fix(logmean)
   
   ;i=fix(mean(img)/binsize)   ;This is the old way from the CPI version
   dummy=max(lz[0:i-1],idark)
   dummy=max(lz[i:*],ibright)
   ibright=ibright+i

   ;Remember that for cloud images the background is dark and the foreground is bright
   return,{back:idark*binsize,fore:ibright*binsize}
END
   
   
   
   

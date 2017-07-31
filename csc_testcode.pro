;Test code for stitching cloud photos

;Two images with some overlap from my phone
read_jpeg,'/sysdisk1/bansemer/citizen_sky_camera/cirrus_cloud_pictures/WP_20170719_09_10_18_Pro.jpg',a
read_jpeg,'/sysdisk1/bansemer/citizen_sky_camera/cirrus_cloud_pictures/WP_20170719_09_10_23_Pro.jpg',b

;Find channel with most contrast, will have lowest peak in histogram
ah0=histogram(a[0,*,*])
ah1=histogram(a[1,*,*])
ah2=histogram(a[2,*,*])
bh0=histogram(b[0,*,*])
bh1=histogram(b[1,*,*])
bh2=histogram(b[2,*,*])

;Plot up the histograms, channel 0 (red) should have broadest signal
window,0
cgplot,ah0,yr=[0,max([ah0,ah1,ah2,bh0,bh1,bh2])],color='red'
cgoplot,ah1,color='green'
cgoplot,ah2,color='blue'
cgoplot,bh0,thick=2,color='red'
cgoplot,bh1,thick=2,color='green'
cgoplot,bh2,thick=2,color='blue'

;Make smaller versions and display
;**Note, this may be a good way to 'stitch' photos, start with very small versions for initial link, then refine with hi-res images
loadct,0
downsize=1000
window,1,xsize=downsize,ysize=downsize*1.5
s=float(size(a,/dim))
as=float(congrid(reform(a[0,*,*]), downsize, s[2]/s[1]*downsize))
bs=float(congrid(reform(b[0,*,*]), downsize, s[2]/s[1]*downsize))
tv,as
tv,bs, 0,600

;Check red-blue ratio (RBR), which is used in some publications, e.g. Chow et al 2011 (see my citizenskycamera folder)
as_rbr=as / float(congrid(reform(a[2,*,*]), downsize, s[2]/s[1]*downsize))
bs_rbr=bs / float(congrid(reform(b[2,*,*]), downsize, s[2]/s[1]*downsize))
window,2,xsize=downsize,ysize=downsize*1.5
tv,as
tv,as_rbr*250,0,600
xyouts,10,610,'Red-blue ratio, picture A',/device,charsize=1.5
xyouts,10,10,'Red channel',/device,charsize=1.5
window,3,xsize=downsize,ysize=downsize*1.5
tv,bs
tv,bs_rbr*250,0,600
xyouts,10,610,'Red-blue ratio, picture B',/device,charsize=1.5
xyouts,10,10,'Red channel',/device,charsize=1.5

loadct,39
END
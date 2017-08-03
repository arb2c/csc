FUNCTION standardline, x, y, azimuth
   ;Convert line in form of a point plus azimuth to standard form Ax+By+C=0
   ;Azimuth is in radians relative to 'north', i.e. positive y-axis

   a=-cos(azimuth)
   b=sin(azimuth)
   c=x*cos(azimuth) - y*sin(azimuth)

   return, {a:a, b:b, c:c}
END
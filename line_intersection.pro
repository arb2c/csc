FUNCTION line_intersection, one, two
   ;Find intersecion of two lines in standard form ax+by+c=0
   ;https://www.topcoder.com/community/data-science/data-science-tutorials/geometry-concepts-line-intersection-and-its-applications/
   ;one and two are structures with tags 'a', 'b', and 'c'
   ;test code verified: help,line_intersection(standardline(2.5,3.0,-135*!pi/180), standardline(8.0,5.0,-82*!pi/180)),/st
   
   det = one.a*two.b - two.a*one.b

   IF det ne 0 THEN BEGIN
      x = (one.b*two.c - two.b*one.c)/det
      y = (two.a*one.c - one.a*two.c)/det
   ENDIF ELSE return, !values.f_nan  ;Parallel lines

   return, {x:x, y:y}
END
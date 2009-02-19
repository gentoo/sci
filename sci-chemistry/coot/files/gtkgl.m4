dnl
dnl AM_PATH_GTKGL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
dnl
AC_DEFUN([AM_PATH_GTKGL],
  [
    AC_REQUIRE([AM_PATH_GTK])
    
    AC_ARG_WITH(gtkgl-prefix, [  --with-gtkgl-prefix=DIR prefix where GtkGLArea is installed ])
    if test -n "${with_gtkgl_pefix}"; then
      gtkgl__Idir="-I${with_gtkgl_prefix}/include"
      gtkgl__Ldir="-L${with_gtkgl_prefix}/lib"
    fi
    
    GTKGL_CFLAGS=""
    GTKGL_LIBS=""
    
    AC_LANG_SAVE
    AC_LANG_C
    AC_CHECK_LIB(gtkgl, gdk_gl_query,
      [
        ac_save_CPPFLAGS="${CPPFLAGS}"
        CPPFLAGS="${CPPFLAGS} ${GTK_CFLAGS} ${gtkgl__Idir}"
        AC_CHECK_HEADER(gtkgl/gtkglarea.h,
          [
            have_gtkgl=yes
            GTKGL_CFLAGS="${GTK_CFLAGS} ${gtkgl__Idir}"
            GTKGL_LIBS="${gtkgl__Ldir} -lgtkgl"
          ],
          have_gtkgl=no
        )
        CPPGLAGS="${ac_save_CPPFLAGS}"
      ],
      have_gtkgl=no,
      ${gtkgl__Ldir}
    )
    AC_LANG_RESTORE
    
    if test "X${have_gtkgl}" = Xyes; then
      ifelse([$1], , :, [$1])
    else
      ifelse([$2], , :, [$2])
    fi
    
    AC_SUBST(GTKGL_CFLAGS)
    AC_SUBST(GTKGL_LIBS)
  ]
)

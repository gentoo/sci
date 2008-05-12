# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $ Header: $

inherit eutils toolchain-funcs versionator flag-o-matic multilib

MY_P="ngs$(delete_version_separator 1)"

DESCRIPTION="NETGEN is an automatic 3d tetrahedral mesh generator"
HOMEPAGE="http://www.hpfem.jku.at/netgen/"
SRC_URI="http://www.hpfem.jku.at/cgi/download.cgi?ID=${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="opencascade lapack gmp"
SLOT="0"

RDEPEND="opencascade? ( sci-libs/opencascade )
	gmp? ( dev-libs/gmp )
	virtual/opengl
	>=dev-lang/tk-8.0
	>=dev-lang/tcl-8.0
	>=dev-tcltk/tix-8.1
	x11-libs/libXmu "

DEPEND="${RDEPEND}
	lapack? ( dev-util/pkgconfig )"

S="${WORKDIR}/netgen"

src_unpack() {
	ln -s "${DISTDIR}"/"download.cgi?ID=${MY_P}.tar.gz" ${MY_P}.tar.gz
	unpack ./${MY_P}.tar.gz
	cd "${WORKDIR}"
	mv ${MY_P} netgen
	cd "${S}"
	epatch "${FILESDIR}"/togl_tk.patch
	epatch "${FILESDIR}"/meshtype.patch
	epatch "${FILESDIR}"/densemat.patch
	epatch "${FILESDIR}"/debian-inspired-netgen_4.4-9.patch
	epatch "${FILESDIR}"/debian-inspired-netgen_4.4-9.2.patch
}

src_compile() {
	cd "${S}"
	local LAPACK="-lg2c"
	export MACHINE="LINUX"
	# gcc>=4.0 does not have libg2c anymore
	if version_is_at_least "4.0" $(gcc-version) ; then
		 LAPACK=""
	fi

	# Fix the Makefiles
	local tk_version
	tk_version=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
	local tk_release_serial
	tk_release_serial=$(grep TK_RELEASE_SERIAL /usr/include/tk.h | awk '{print $3}')
	local tix_version
	tix_version=$(grep TIX_VER /usr/include/tix.h | sed 's/^.*"\(.*\)".*/\1/')

	# The install location of libtix has changed from 8.2* to 8.4
	if version_is_at_least "8.4" ${tix_version} ; then
		tix_patch_level=$(sed -n '/TIX_PATCH_LEVEL/p' /usr/include/tix.h | sed -n '1p' | sed 's/^.*"\(.*\)".*/\1/')
		sed -i -e "s:-ltix8.1.8.4:-L/usr/$(get_libdir)/Tix${tix_patch_level} -lTix${tix_patch_level}:g" ./Makefile
	else
		sed -i -e 's:tix8.1.8.4:tix:g' ./Makefile
	fi

	sed -i \
	    -e 's:tcl8.4:tcl:g' \
	    -e 's:tk8.4:tk:g' \
	    -e "s:CPP_DIR=.:CPP_DIR=${S}:g" ./Makefile \
	|| die "Correction of the tcl/tk flags and CPP_DIR value in Makefile failed"

	sed -i \
	    -e "s:-O2:${CXXFLAGS}:g" \
	    -e 's:/usr/include/GL3.5:/usr/include/GL:g' \
	    -e "s:-L/usr/openwin/lib -L/usr/X11R6/lib -L/usr/lib/GL3.5:-L/usr/X11R6/$(get_libdir) -L/usr/$(get_libdir)/GL:g" ./libsrc/makefile.mach.LINUX \
	|| die "Correction of the GL patch in libsrc/makefile.mach.LINUX failed"

	if use opencascade ; then
		sed -i \
		    -e "s:/opt/OpenCASCADE5.2:$CASROOT/../:g" \
		    -e "s:/ros/lin/lib:/ros/lin/$(get_libdir):g" ./Makefile ./libsrc/makefile.mach.LINUX \
		|| die "Correction of the OpenCascade location in Makefile and libsrc/makefile.mach.LINUX failed"
	else
		sed -i \
		    -e 's:OCC_DIR=/opt/OpenCASCADE5.2:# OCC_DIR=/opt/OpenCASCADE5.2:g' \
		    -e "s:OCCINC_DIR=\$(OCC_DIR)/ros/inc:# OCCINC_DIR=\$(OCC_DIR)/ros/inc:g" \
		    -e "s:OCCLIB_DIR=\$(OCC_DIR)/ros/lin/lib:# OCCLIB_DIR=\$(OCC_DIR)/ros/lin/lib:g" ./Makefile ./libsrc/makefile.mach.LINUX \
		|| die "Commenting out of OpenCascade in Makefile and libsrc/makefile.mach.LINUX failed"
		sed -i \
		    -e 's:CPLUSPLUSFLAGS2 += -DOCCGEOMETRY -DOCC52 -DUSE_STL_STREAM -DHAVE_IOSTREAM -DHAVE_LIMITS -I\$(OCCINC_DIR):# CPLUSPLUSFLAGS2 += -DOCCGEOMETRY -DOCC52 -DUSE_STL_STREAM -DHAVE_IOSTREAM -DHAVE_LIMITS -I\$(OCCINC_DIR):g' \
		    -e 's:LINKFLAGS2 += -L\$(OCCLIB_DIR) -lTKIGES -lTKBRep -lTKSTEP -lTKSTL -lTKTopAlgo -lTKG3d -lTKG2d -lTKXSBase -lTKOffset -lTKFillet -lTKGeomBase -lTKGeomAlgo -lTKShHealing -lTKBO -lTKPrim -lTKernel -lTKMath -lTKBool:# LINKFLAGS2 += -L\$(OCCLIB_DIR) -lTKIGES -lTKBRep -lTKSTEP -lTKSTL -lTKTopAlgo -lTKG3d -lTKG2d -lTKXSBase -lTKOffset -lTKFillet -lTKGeomBase -lTKGeomAlgo -lTKShHealing -lTKBO -lTKPrim -lTKernel -lTKMath -lTKBool:g' ./libsrc/makefile.mach.LINUX \
		|| die "Commenting out of OpenCascade C++ and Link flags in libsrc/makefile.mach.LINUX failed"
		sed -i \
		    -e 's:-locc::g' \
		    -e 's:occlib:# occlib:g' ./Makefile \
		|| die "Commenting out of OpenCascade in Makefile failed"
	fi

	use lapack && LAPACK="${LAPACK} $(pkg-config --libs lapack)"
	use gmp    && LAPACK="${LAPACK} -lgmp"

	sed -i \
	    -e "s:# lapack =  -llapack  -lblas -lgmp -lg2c:lapack = ${LAPACK}:g" ./Makefile ./libsrc/makefile.mach.LINUX \
	|| die "Lapack setup failed"

	# Copy tkInt.h from the system to the source to correct the issue with togl.cpp
	cp -p /usr/$(get_libdir)/tk${tk_version}/include/generic/tkInt.h ./togl/tkInt${tk_version}p${tk_release_serial}.h
	cp -p /usr/$(get_libdir)/tk${tk_version}/include/generic/tkIntDecls.h ./togl/tkIntDecls${tk_version}p${tk_release_serial}.h
	sed -i \
	    -e "s:tkIntDecls.h:./tkIntDecls${tk_version}p${tk_release_serial}.h:g" ./togl/tkInt${tk_version}p${tk_release_serial}.h \
	|| dies "togl.cpp vs. tkInt.h issue correction failed"

	# Build 2 extra demo applications
	#sed -i \
	#    -e "s:# appdemo:appdemo:g" \
	#    -e "s:# appaddon:appaddon:g" \
	#    -e "s:# appngs:appngs:g" \
	#    -e "s:#	cd demoapp:	cd demoapp:g" \
	#    -e "s:#	cd ngsolve:	cd ngsolve:g" ./Makefile \
	#|| die "Extra demo applications. 'sed' failed"

	make || die "make failed"
}

src_install() {
	cd "${S}"
	# The binaries
	dobin ng
	# The libraries
	dolib ./lib/LINUX/*.a ./lib/LINUX/*.so*
	# The docs
	dodoc ./doc/ng4.pdf VERSION
	# The headers
	dodir /usr/include/${PN}
	insinto /usr/include/${PN}
	doins ./libsrc/include/*.hpp
	# Ngsolve headers
	dodir /usr/include/${PN}/ngsolve
	insinto /usr/include/${PN}/ngsolve
	doins ./ngsolve/*.hpp

	for headers_dir in \
	csg general geom2d gprim interface linalg \
	meshing opti stlgeom visualization; do
		dodir /usr/include/${PN}/${headers_dir}
		insinto /usr/include/${PN}/${headers_dir}
		doins ./libsrc/${headers_dir}/*.hpp
	done
	if use opencascade; then
		dodir /usr/include/${PN}/occ
		insinto /usr/include/${PN}/occ
		doins ./libsrc/occ/*.hpp
	fi
	# The shared files
	dodir /usr/share/doc/${PF}
	insinto /usr/share/doc/${PF}
	find . -name "*.tcl" -exec doins {} \;
	dodir /usr/share/doc/${PF}/tutorials
	insinto /usr/share/doc/${PF}/tutorials
	doins ./tutorials/*
	# Install icon and .desktop for menu entry
	doicon "${FILESDIR}"/icon/${PN}-icon.png
	domenu "${FILESDIR}"/icon/${PN}.desktop
}

pkg_postinst() {
	einfo "Netgen ebuild needs further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=155424"
}


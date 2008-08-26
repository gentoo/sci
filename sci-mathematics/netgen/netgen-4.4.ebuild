# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils toolchain-funcs versionator flag-o-matic

MY_P="ngs$(delete_version_separator 1)"

DESCRIPTION="NETGEN is an automatic 3d tetrahedral mesh generator"
HOMEPAGE="http://www.hpfem.jku.at/netgen/"
SRC_URI="http://www.hpfem.jku.at/cgi/download.cgi?ID=${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="opencascade blas lapack gmp"
SLOT=0

RDEPEND="opencascade? ( sci-libs/opencascade )
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )
	gmp? ( dev-libs/gmp ) "

DEPEND="${RDEPEND}
	virtual/opengl
	x11-base/xorg-x11
	>=dev-lang/tk-8.0
	>=dev-lang/tcl-8.0
	>=dev-tcltk/tix-8.1"

src_unpack() {
	ln -s "${DISTDIR}"/"download.cgi?ID=${MY_P}.tar.gz" ${MY_P}.tar.gz
	unpack ./${MY_P}.tar.gz
	MY_S="${WORKDIR}"/"${MY_P}"
	cd "${MY_S}"
	epatch "${FILESDIR}"/togl_tk.patch
	epatch "${FILESDIR}"/meshtype.patch
	epatch "${FILESDIR}"/densemat.patch
	epatch "${FILESDIR}"/debian-netgen_4.4-7.patch
}

src_compile() {
	cd "${MY_S}"
	local LAPACK="-lg2c"
	export MACHINE="LINUX"
	# gcc>=4.0 does not have libg2c anymore
	if version_is_at_least "4.0" $(gcc-version) ; then
		 LAPACK=""
	fi

	# Fix the Makefiles
	local tk_version
	tk_version=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
	tk_release_serial=$(grep TK_RELEASE_SERIAL /usr/include/tk.h | awk '{print $3}')
	sed -i "s:tk8.4:tk${tk_version}:g" ./Makefile
	sed -i "s:tk8.4:tk${tk_version}:g" ./libsrc/makefile.mach.LINUX

	# The install location of libtix has changed from 8.2* to 8.4
	tix_version=$(grep TIX_VER /usr/include/tix.h | sed 's/^.*"\(.*\)".*/\1/')
	if version_is_at_least "8.4" ${tix_version} ; then
		tix_patch_level=$(sed -n '/TIX_PATCH_LEVEL/p' /usr/include/tix.h | sed -n '1p' | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:-ltix8.1.8.4:-L/usr/$(get_libdir)/Tix${tix_patch_level} -lTix${tix_patch_level}:g" ./Makefile
	else
		sed -i "s:tix8.1.8.4:tix${tix_version}:g" ./Makefile
	fi

	local tcl_version
	tcl_version=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
	sed -i "s:tcl8.4:tcl${tcl_version}:g" ./Makefile
	sed -i "s:tcl8.4:tcl${tcl_version}:g" ./libsrc/makefile.mach.LINUX

	sed -i "s:CPP_DIR=.:CPP_DIR=${MY_S}:g" ./Makefile
	sed -i "s:-L/usr/openwin/lib -L/usr/X11R6/lib -L/usr/lib/GL3.5:-L/usr/X11R6/$(get_libdir) -L/usr/$(get_libdir)/GL:g" ./libsrc/makefile.mach.LINUX

	if use opencascade; then
		sed -i "s:/opt/OpenCASCADE5.2:$CASROOT/../:g" ./Makefile
		sed -i "s:/opt/OpenCASCADE5.2:$CASROOT/../:g" ./libsrc/makefile.mach.LINUX
	else
		sed -i "s:OCC_DIR=/opt/OpenCASCADE5.2:# OCC_DIR=/opt/OpenCASCADE5.2:g" ./Makefile
		sed -i "s:OCC_DIR=/opt/OpenCASCADE5.2:# OCC_DIR=/opt/OpenCASCADE5.2:g" ./libsrc/makefile.mach.LINUX
		sed -i "s:OCCINC_DIR=\$(OCC_DIR)/ros/inc:# OCCINC_DIR=\$(OCC_DIR)/ros/inc:g" ./Makefile
		sed -i "s:OCCINC_DIR=\$(OCC_DIR)/ros/inc:# OCCINC_DIR=\$(OCC_DIR)/ros/inc:g" ./libsrc/makefile.mach.LINUX
		sed -i "s:OCCLIB_DIR=\$(OCC_DIR)/ros/lin/lib:# OCCLIB_DIR=\$(OCC_DIR)/ros/lin/lib:g" ./Makefile
		sed -i "s:OCCLIB_DIR=\$(OCC_DIR)/ros/lin/lib:# OCCLIB_DIR=\$(OCC_DIR)/ros/lin/lib:g" ./libsrc/makefile.mach.LINUX
		sed -i "s:CPLUSPLUSFLAGS2 += -DOCCGEOMETRY -DOCC52 -DUSE_STL_STREAM -DHAVE_IOSTREAM -DHAVE_LIMITS -I\$(OCCINC_DIR):# CPLUSPLUSFLAGS2 += -DOCCGEOMETRY -DOCC52 -DUSE_STL_STREAM -DHAVE_IOSTREAM -DHAVE_LIMITS -I\$(OCCINC_DIR):g" ./libsrc/makefile.mach.LINUX
		sed -i "s:LINKFLAGS2 += -L\$(OCCLIB_DIR) -lTKIGES -lTKBRep -lTKSTEP -lTKSTL -lTKTopAlgo -lTKG3d -lTKG2d -lTKXSBase -lTKOffset -lTKFillet -lTKGeomBase -lTKGeomAlgo -lTKShHealing -lTKBO -lTKPrim -lTKernel -lTKMath -lTKBool:# LINKFLAGS2 += -L\$(OCCLIB_DIR) -lTKIGES -lTKBRep -lTKSTEP -lTKSTL -lTKTopAlgo -lTKG3d -lTKG2d -lTKXSBase -lTKOffset -lTKFillet -lTKGeomBase -lTKGeomAlgo -lTKShHealing -lTKBO -lTKPrim -lTKernel -lTKMath -lTKBool:g" ./libsrc/makefile.mach.LINUX
		sed -i "s:-locc::g" ./Makefile
		sed -i "s:occlib:# occlib:g" ./Makefile
	fi

	if use lapack; then
		LAPACK="${LAPACK} -llapack"
	fi

	if use blas; then
		LAPACK="${LAPACK} -lblas"
	fi

	if use gmp; then
		LAPACK="${LAPACK} -lgmp"
	fi

	sed -i "s:# lapack =  -llapack  -lblas -lgmp -lg2c:lapack = $LAPACK:g" ./Makefile
	sed -i "s:# lapack =  -llapack  -lblas -lgmp -lg2c:lapack = $LAPACK:g" ./libsrc/makefile.mach.LINUX

	# Copy tkInt.h from the system to the source to correct the issue with togl.cpp
	cp -p /usr/$(get_libdir)/tk${tk_version}/include/generic/tkInt.h ./togl/tkInt${tk_version}p${tk_release_serial}.h
	cp -p /usr/$(get_libdir)/tk${tk_version}/include/generic/tkIntDecls.h ./togl/tkIntDecls${tk_version}p${tk_release_serial}.h
	sed -i "s:tkIntDecls.h:./tkIntDecls${tk_version}p${tk_release_serial}.h:g" ./togl/tkInt${tk_version}p${tk_release_serial}.h

	# Build 2 extra demo applications
	#sed -i "s:# appdemo:appdemo:g" ./Makefile
	#sed -i "s:# appaddon:appaddon:g" ./Makefile
	#sed -i "s:# appngs:appngs:g" ./Makefile
	#sed -i "s:#	cd demoapp:	cd demoapp:g" ./Makefile
	#sed -i "s:#	cd ngsolve:	cd ngsolve:g" ./Makefile

	emake || die "emake failed"
}

src_install() {
	cd "${MY_S}"
	dobin ng
	dodoc ./doc/ng4.pdf VERSION
	dodir /usr/share/"${PF}"
	insinto /usr/share/"${PF}"
	find . -name "*.tcl" -exec doins --parents {} \;
	dodir /usr/share/"${PF}"/tutorials
	insinto /usr/share/"${PF}"/tutorials
	doins ./tutorials/*
}

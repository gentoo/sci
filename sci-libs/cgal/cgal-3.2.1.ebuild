# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs qt3

DESCRIPTION="The Computational Geometry Algorithms Library is an Open
Source C++ library of geometric algorithms and data structures."
HOMEPAGE="http://www.cgal.org/"
DLPAGE="http://www.cgal.org/download/"
PKN="$(echo ${PN} | tr {a-z} {A-Z})"
PK="$(echo ${P} | tr {a-z} {A-Z})"
SRC_URI="${PK}.tar.gz"
#SRC_URI="ftp://ftp.mpi-sb.mpg.de/pub/outgoing/${PKN}/${PK}.tar.gz"

LICENSE="LGPL-2 QPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="X zlib qt3 examples"
RESTRICT="fetch"

DEPEND="zlib? ( sys-libs/zlib )
	qt3? ( $(qt_min_version 3.0) )
	examples? ( $(qt_min_version 3.0) )
	X? ( virtual/x11 )
	dev-libs/mpfr
	sci-libs/libcore
	dev-libs/gmp
	dev-libs/boost"
RDEPEND="virtual/libc"

S="${WORKDIR}/${PK}"

pkg_nofetch() {
	einfo "Due to license restrictions that may apply to the file in this"
	einfo "package, you must download ${SRC_URI} file manually from"
	einfo "${DLPAGE} and put it in ${DISTDIR}."
}

src_unpack(){
	if use examples; then
		ewarn "Examples actualy require 28M of disk space."
	fi
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${PN}_soname.patch"
	# Patch from redhat bug #199168
	# http://bugzilla.redhat.com/bugzilla/attachment.cgi?id=135376
	# it should be not applied becauseof its textrelaction and issue
	# about undefined symbol: _ZN18QMetaObjectCleanUpC1EPKcPFP11QMetaObjectvE 
	# epatch "${FILESDIR}/${PN}_redhat.patch"
}

src_compile(){
	CGALDIR="${S}/cgal_install_dir"
	myconf="--prefix=${CGALDIR} \
		--with-boost=n \
		--with-boost-param-options=n \
		--with-core=n \
		--with-gmp=n \
		--with-gmpxx=n \
		--with-mpfr=n"

	use X && myconf="${myconf} --with-x11=n"
	use zlib && myconf="${myconf} --with-zlib=n"
	if use qt3 || use examples; then
		myconf="${myconf} --with-qt3mt=n --qt_incl_dir ${QTDIR}/include/ \
			--qt_lib_dir ${QTDIR}/lib"
	fi

	myconf="${myconf} --without-autofind"

	# we use CORE headers provided by libcore
	rm -r "${S}/include/CORE"
	
	./install_cgal ${myconf} -ni $(which $(tc-getCXX)) || \
		die "Unable to compile"
}

src_install(){
	SDIR="$(ls ${CGALDIR}/lib/)"
	LIBNAME="${CGALDIR}/lib/${SDIR}/libCGAL"

	dolib "${LIBNAME}.a" "${LIBNAME}.so" || die "Unable to install ${LIBNAME}"
	if use qt3 || use examples; then 
		dolib "${LIBNAME}Qt.a" ||\
			die "Unable to install ${LIBNAME}Qt.a"
		#"${LIBNAME}Qt.so"
	fi
	dosym "/usr/lib/libCGAL.so" "/usr/lib/libCGAL.so.1" && \
	dosym "/usr/lib/libCGAL.so" "/usr/lib/libCGAL.so.1.0.0" || \
		die "Unable to create symlinks" 

	CGALINC="${CGALDIR}/include/"
	rm -r "${CGALINC}/OpenNL/LICENSE.OPENNL" || \
			die "Unable to remove uneeded headers"
	if ! use qt3 || ! use examples ; then
		rm $(find ${CGALINC}/CGAL/ -name "Qt*") || \
			die "Unable to remove Qt headers"
	fi
	cp -rp "${CGALINC}" "${D}/usr/" || \
		die "Unable to install headers"

	sed "s:${CGALDIR}:/usr:g" -i \
		"${CGALDIR}/make/makefile_${SDIR}" || die "Unable to correct makefle"
	dodir "/usr/share/CGAL" || die "Unable to create share directory"
	cp "${CGALDIR}/make/makefile_${SDIR}" "${D}/usr/share/CGAL/makefile" || \
		die "Unable to install makefile"
	einfo "CGAL_MAKEFILE was installed in : /usr/share/CGAL/makefile"

	if use examples; then
		dodir /usr/share/doc/${P}
		cp -r "${S}/demo" "${D}/usr/share/doc/${P}"
		cp -r "${S}/examples" "${D}/usr/share/doc/${P}"
		einfo "There are 2 directories : demo and examples in"
		einfo "/usr/share/doc/${P}"
		einfo "which contains samples applications. To compile them"
		einfo "use the following command :"
		einfo "CGAL_MAKEFILE=/usr/share/CGAL/makefile make"
	fi
}

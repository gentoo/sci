# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit flag-o-matic fortran-2 toolchain-funcs

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Portable, Extensible Toolkit for Scientific Computation"
HOMEPAGE="http://www.mcs.anl.gov/petsc/petsc-as/"
SRC_URI="http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/${MY_P}.tar.gz"

LICENSE="petsc"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="complex-scalars cxx debug doc fortran hdf5 hypre metis mpi X"

RDEPEND="mpi? ( virtual/mpi[cxx?,fortran?] )
	X? ( x11-libs/libX11 )
	virtual/lapack
	virtual/blas
	hypre? ( sci-libs/hypre )
	metis? ( sci-libs/parmetis )
	hdf5? ( sci-libs/hdf5[!mpi?] )
"

DEPEND="${RDEPEND}
	sys-devel/gcc[-nocxx,fortran?]
	dev-util/cmake
"

REQUIRED_USE="hypre? ( cxx mpi )"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	epatch "${FILESDIR}/${PN}-configure-pic.patch"
	epatch "${FILESDIR}/${PN}-disable-rpath.patch"
}

src_configure(){
	# petsc uses --with-blah=1 and --with-blah=0 to en/disable options
	petsc_enable(){
		use "$1" && echo "--with-${2:-$1}=1" || echo "--with-${2:-$1}=0"
	}
	# select between configure options depending on use flag
	pestc_select() {
		use "$1" && echo "--with-$2=$3" || echo "--with-$2=$4"
	}
	# add info about library include dirs and lib file
	petsc_lib_info(){
		use "$1" && echo "--with-${4:-$1}-include=$2 --with-${4:-$1}-lib=$3"
	}

	local mylang
	local myopt

	use cxx && mylang="cxx" || mylang="c"
	use debug && myopt="debug" || myopt="opt"

	# environmental variables expected by petsc during build
	export PETSC_DIR="${S}"
	export PETSC_ARCH="linux-gnu-${mylang}-${myopt}"

	# flags difficult to pass due to correct quoting of spaces
	local myconf
	myconf[1]="CFLAGS=${CFLAGS}"
	myconf[2]="CXXFLAGS=${CXXFLAGS}"
	myconf[3]="LDFLAGS=${LDFLAGS}"
	myconf[4]="--with-blas-lapack-lib=$(pkg-config --libs lapack)"

	if use debug; then
		strip-flags
		filter-flags -O*
	fi

	# run petsc configure script
	python "${S}/config/configure.py" \
		--prefix="${EPREFIX}/usr" \
		--with-shared-libraries \
		--with-single-library \
		--with-clanguage=${mylang} \
		$(petsc_enable cxx c-support) \
		--with-petsc-arch=${PETSC_ARCH} \
		--with-precision=double \
		--with-gnu-compilers \
		$(petsc_enable debug debugging) \
		$(petsc_enable fortran) \
		$(petsc_enable mpi) \
		$(petsc_select mpi cc /usr/bin/mpicc $(tc-getCC)) \
		$(petsc_select mpi cxx /usr/bin/mpicxx $(tc-getCXX)) \
		$(use fortran && $(pestc_select mpi fc /usr/bin/mpif77 $(tc-getF77))) \
		$(petsc_enable mpi mpi-compilers) \
		$(petsc_enable X) \
		--with-windows-graphics=0 \
		--with-matlab=0 \
		--with-python=0 \
		--with-cmake=/usr/bin/cmake \
		$(petsc_enable hdf5) \
		$(petsc_lib_info hdf5 /usr/include /usr/$(get_libdir)/libhdf5.so) \
		$(petsc_enable hypre) \
		$(petsc_lib_info hypre /usr/include/hypre /usr/$(get_libdir)/libHYPRE.so) \
		$(petsc_enable metis parmetis) \
		$(petsc_lib_info metis /usr/include/parmetis /usr/$(get_libdir)/libparmetis.so parmetis) \
		$(petsc_select complex-scalars scalar-type complex real) \
		--with-scotch=0 \
		"${myconf[@]}"
}

src_install(){
	# petsc install structure is very different from
	# installing headers to /usr/include/petsc and lib to /usr/lib
	# it also installs many unneeded executables and scripts
	# so manual install is easier than cleanup after "emake install"
	insinto /usr/include/"${PN}"
	doins "${S}"/include/*.h "${S}"/include/*.hh
	insinto /usr/include/"${PN}/${PETSC_ARCH}"/include
	doins "${S}/${PETSC_ARCH}"/include/*
	if use fortran; then
		insinto /usr/include/"${PN}"/finclude
		doins "${S}"/include/finclude/*.h
	fi
	insinto /usr/include/"${PN}"/conf
	doins "${S}"/conf/{variables,rules,test}
	insinto /usr/include/"${PN}/${PETSC_ARCH}"/conf
	doins "${S}/${PETSC_ARCH}"/conf/{petscrules,petscvariables,RDict.db}
	insinto /usr/include/"${PN}"/private
	doins "${S}"/include/private/*.h

	# fix configuration files: replace ${S} by installed location
	sed -i "s:${S}:/usr:g" ${D}/usr/include/"${PN}/${PETSC_ARCH}"/include/petscconf.h
	sed -i "s:${PETSC_ARCH}/lib:$(get_libdir):g" ${D}/usr/include/"${PN}/${PETSC_ARCH}"/include/petscconf.h
	sed -i "s:INSTALL_DIR =.*:INSTALL_DIR = /usr:" ${D}/usr/include/"${PN}/${PETSC_ARCH}"/conf/petscvariables

	# add information about installation directory and
	# PETSC_ARCH to environmental variables
	cat >> "${T}"/99petsc <<- EOF
	PETSC_ARCH=${PETSC_ARCH}
	PETSC_DIR=/usr/include/${PN}
	EOF
	doenvd "${T}"/99petsc

	if ! use mpi ; then
		insinto /usr/include/"${PN}"/mpiuni
		doins "${S}"/include/mpiuni/*.h
	fi

	if use doc ; then
		dodoc docs/manual.pdf
		dohtml -r docs/*.html docs/changes docs/manualpages
	fi

	dolib.so "${S}/${PETSC_ARCH}"/lib/*.so
}

pkg_postinst() {
	elog "The petsc ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=53386"
	elog "Note that PETSC_ARCH may be dropped in future since " \
		"upstream now also supports installations without " \
		"different subdirectories."
}

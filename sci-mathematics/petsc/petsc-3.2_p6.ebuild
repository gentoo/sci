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
IUSE="afterimage boost complex-scalars cxx debug doc \
	fortran hdf5 hypre metis mpi sparse threads X"

REQUIRED_USE="
	hypre? ( cxx mpi )
	hdf5? ( mpi )
"

RDEPEND="mpi? ( virtual/mpi[cxx?,fortran?] )
	X? ( x11-libs/libX11 )
	virtual/lapack
	virtual/blas
	hypre? ( sci-libs/hypre )
	metis? ( sci-libs/parmetis )
	hdf5? ( sci-libs/hdf5 )
	boost? ( dev-libs/boost )
	afterimage? ( media-libs/libafterimage )
	sparse? ( sci-libs/cholmod )
"

DEPEND="${RDEPEND}
	sys-devel/gcc[-nocxx,fortran?]
	dev-util/cmake
"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	epatch "${FILESDIR}/${PN}-configure-pic.patch"
	epatch "${FILESDIR}/${PN}-disable-env-warnings.patch"
	epatch "${FILESDIR}/${PN}-disable-rpath.patch"
}

src_configure(){
	# petsc uses --with-blah=1 and --with-blah=0 to en/disable options
	petsc_enable(){
		use "$1" && echo "--with-${2:-$1}=1" || echo "--with-${2:-$1}=0"
	}
	# add external library:
	# petsc_with use_flag libname libdir
	# petsc_with use_flag libname lib include
	petsc_with() {
		local myuse p=${2:-${1}}
		if use ${1}; then
			myuse="--with-${p}=1"
			if [[ $# == 4 ]]; then
				myuse="${myuse} --with-${p}-lib=\"${3}\""
				myuse="${myuse} --with-${p}-include=${4}"
			else
				myuse="${myuse} --with-${p}-dir=${EPREFIX}${3:-/usr}"
			fi
		else
			myuse="--with-${p}=0"
		fi
		echo ${myuse}
	}
	# select between configure options depending on use flag
	petsc_select() {
		use "$1" && echo "--with-$2=$3" || echo "--with-$2=$4"
	}

	local mylang
	local myopt

	use cxx && mylang="cxx" || mylang="c"
	use debug && myopt="debug" || myopt="opt"

	# environmental variables expected by petsc during build
	export PETSC_DIR="${S}"
	export PETSC_ARCH="linux-gnu-${mylang}-${myopt}"

	if use debug; then
		strip-flags
		filter-flags -O*
	fi

	# run petsc configure script
	./configure \
		--prefix="${EPREFIX}/usr" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		--with-shared-libraries \
		--with-single-library \
		--with-clanguage=${mylang} \
		$(petsc_enable cxx c-support) \
		--with-petsc-arch=${PETSC_ARCH} \
		--with-precision=double \
		--with-gnu-compilers \
		--with-blas-lapack-lib="$(pkg-config --libs lapack)" \
		$(petsc_enable debug debugging) \
		$(petsc_enable mpi) \
		$(petsc_select mpi cc /usr/bin/mpicc $(tc-getCC)) \
		$(petsc_select mpi cxx /usr/bin/mpicxx $(tc-getCXX)) \
		$(petsc_enable fortran) \
		$(use fortran && echo "$(petsc_select mpi fc /usr/bin/mpif77 $(tc-getF77))") \
		$(petsc_enable mpi mpi-compilers) \
		$(petsc_enable threads pthread) \
		$(petsc_enable threads pthreadclasses) \
		$(petsc_select complex-scalars scalar-type complex real) \
		--with-windows-graphics=0 \
		--with-matlab=0 \
		--with-python=0 \
		--with-cmake=/usr/bin/cmake \
		$(petsc_with afterimage afterimage \
			/usr/$(get_libdir)/libAfterImage.so /usr/include/libAfterImage) \
		$(petsc_with sparse cholmod) \
		$(petsc_with boost) \
		$(petsc_with hdf5) \
		$(petsc_with hypre hypre /usr/$(get_libdir)/libHYPRE.so /usr/include/hypre) \
		$(petsc_with metis parmetis) \
		$(petsc_with X x11) \
		--with-scotch=0 \
		${EXTRA_ECONF} || die "configuration failed"
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
}

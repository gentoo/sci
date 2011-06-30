# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit flag-o-matic fortran-2 toolchain-funcs

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Portable, Extensible Toolkit for Scientific Computation"
HOMEPAGE="http://www.mcs.anl.gov/petsc/petsc-as/"
SRC_URI="http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/${MY_P}.tar.gz"

LICENSE="petsc"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cxx debug doc fortran hdf5 hypre metis mpi static-libs X"

RDEPEND="mpi? ( virtual/mpi[cxx?,fortran?] )
	X? ( x11-libs/libX11 )
	virtual/lapack
	virtual/blas
	hypre? ( >=sci-mathematics/hypre-2.6.0b[static-libs=] )
	metis? ( sci-libs/parmetis )
	hdf5? ( sci-libs/hdf5[!mpi?] )
"

DEPEND="${RDEPEND}
	sys-devel/gcc[-nocxx,fortran?]"

S="${WORKDIR}/${MY_P}"

if use hypre; then
	use cxx || die "hypre needs cxx, please enable cxx or disable hypre use flag"
	use mpi || die "hypre needs mpi, please enable mpi or disable hypre use flag"
fi

src_prepare(){
	epatch "${FILESDIR}/${PN}-configure-pic.patch"
	epatch "${FILESDIR}/${PN}-disable-rpath.patch"
}

src_configure(){
	local mylang
	local myopt
	local myconf

	use cxx && mylang="cxx" || mylang="c"
	use debug && myopt="debug" || myopt="opt"

	export PETSC_DIR="${S}" || die
	export PETSC_ARCH="linux-gnu-${mylang}-${myopt}" || die

	myconf[10]="--with-blas-lapack-lib=$(pkg-config --libs lapack)"
	myconf[11]="CFLAGS=${CFLAGS}"
	myconf[12]="CXXFLAGS=${CXXFLAGS}"
	myconf[13]="LDFLAGS=${LDFLAGS}"
	myconf[14]="--with-windows-graphics=0"
	myconf[15]="--with-matlab=0"
	myconf[16]="--with-python=0"
	myconf[17]="--with-clanguage=${mylang}"
	myconf[18]="--with-single-library=1"
	myconf[19]="--with-petsc-arch=${PETSC_ARCH}"
	myconf[20]="--with-precision=double"
	myconf[21]="--with-gnu-compilers=1"
	use amd64 \
		&& myconf[22]="--with-64-bit-pointers=1" \
		|| myconf[22]="--with-64-bit-pointers=0"
	use cxx \
		&& myconf[23]="--with-c-support=1"
	use amd64 \
		&& myconf[24]="--with-64-bit-indices=1" \
		|| myconf[24]="--with-64-bit-indices=0"

	if use mpi; then
		myconf[30]="--with-cc=/usr/bin/mpicc"
		myconf[31]="--with-cxx=/usr/bin/mpicxx"
		use fortran && myconf[32]="--with-fc=/usr/bin/mpif77"
		myconf[33]="--with-mpi=1"
		myconf[34]="--with-mpi-compilers=1"
	else
		myconf[30]="--with-cc=$(tc-getCC)"
		myconf[31]="--with-cxx=$(tc-getCXX)"
		use fortran && myconf[32]="--with-fc=$(tc-getF77)"
		myconf[33]="--with-mpi=0"
	fi

	use X \
		&& myconf[40]="--with-X=1" \
		|| myconf[40]="--with-X=0"
	use static-libs \
		&& myconf[41]="--with-shared=0" \
		|| myconf[41]="--with-shared=1"
	use fortran \
		&& myconf[43]="--with-fortran=1" \
		|| myconf[43]="--with-fortran=0"

	if use debug; then
		strip-flags
		filter-flags -O*
		myconf[44]="--with-debugging=1"
	else
		myconf[44]="--with-debugging=0"
	fi

	if use hypre; then
		# hypre cannot handle 64 bit indices, therefore disabled
		myconf[24]="--with-64-bit-indices=0"
		myconf[52]="--with-hypre=1"
		myconf[53]="--with-hypre-include=/usr/include/hypre"
		use static-libs \
			&& myconf[54]="--with-hypre-lib=/usr/$(get_libdir)/libHYPRE.a" \
			|| myconf[54]="--with-hypre-lib=/usr/$(get_libdir)/libHYPRE.so"
	else
		myconf[52]="--with-hypre=0"
	fi

	if use metis; then
		myconf[61]="--with-parmetis=1"
		myconf[62]="--with-parmetis-include=/usr/include/parmetis"
		myconf[63]="--with-parmetis-lib=/usr/$(get_libdir)/libparmetis.so"
	else
		myconf[61]="--with-parmetis=0"
	fi

	if use hdf5; then
		myconf[71]="--with-hdf5=1"
		myconf[72]="--with-hdf5-include=/usr/include"
		myconf[73]="--with-hdf5-lib=/usr/$(get_libdir)/libhdf5.so"
	else
		myconf[71]="--with-hdf5=0"
	fi

	myconf[81]="--with-scotch=0"

	einfo "Configure options: ${myconf[@]}"
	python "${S}/config/configure.py" "${myconf[@]}" \
		|| die "PETSc configuration failed"
}

src_install(){
	insinto /usr/include/"${PN}"
	doins "${S}"/include/*.h "${S}"/include/*.hh
	doins "${S}/${PETSC_ARCH}"/include/*.h

	insinto /usr/include/"${PN}"/private
	doins "${S}"/include/private/*.h

	# fix paths stored in petscconf.h
	dosed "s:${S}:/usr:g" /usr/include/"${PN}"/petscconf.h
	dosed "s:${PETSC_ARCH}/lib:$(get_libdir):g" /usr/include/"${PN}"/petscconf.h \

	if ! use mpi ; then
		insinto /usr/include/"${PN}"/mpiuni
		doins "${S}"/include/mpiuni/*.h
	fi

	if use doc ; then
		dodoc docs/manual.pdf
		dohtml -r docs/*.html docs/changes docs/manualpages
	fi

	use static-libs \
		&& dolib.a  "${S}/${PETSC_ARCH}"/lib/*.a  \
		|| dolib.so "${S}/${PETSC_ARCH}"/lib/*.so
}

pkg_postinst() {
	elog "The petsc ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=53386"
	elog "This ebuild is known to have parallel build issues, "
	elog "hopefully resolved by upstream soon."
	elog "Another problem is that you can break this package by"
	elog "switching your mpi implementation without rebuild petsc."
}

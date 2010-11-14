# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit flag-o-matic toolchain-funcs

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Portable, Extensible Toolkit for Scientific Computation"
HOMEPAGE="http://www.mcs.anl.gov/petsc/petsc-as/"
SRC_URI="http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/${MY_P}.tar.gz"

LICENSE="petsc"
SLOT="0"
KEYWORDS=""
IUSE="mpi hypre X cxx debug static-libs fortran doc"

RDEPEND="mpi? ( virtual/mpi[cxx?,fortran?] )
	X? ( x11-libs/libX11 )
	virtual/lapack
	virtual/blas
	hypre? ( <sci-mathematics/hypre-2.6.0b[mpi=,static-libs=] )"

DEPEND="${RDEPEND}
	sys-devel/gcc[-nocxx,fortran?]"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	epatch "${FILESDIR}/fix-configure-pic.patch"
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
		myconf[51]="--with-64-bit-indices=0"
		myconf[52]="--with-hypre=1"
		myconf[53]="--with-hypre-include=/usr/include/hypre"
		use static-libs \
			&& myconf[54]="--with-hypre-lib=[/usr/$(get_libdir)/libHYPRE_LSI.a,/usr/$(get_libdir)/libHYPRE.a]" \
			|| myconf[54]="--with-hypre-lib=[/usr/$(get_libdir)/libHYPRE_LSI.so,/usr/$(get_libdir)/libHYPRE.so]"
	else
		use amd64 \
			&& myconf[51]="--with-64-bit-indices=1" \
			|| myconf[51]="--with-64-bit-indices=0"
		myconf[52]="--with-hypre=0"
	fi

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

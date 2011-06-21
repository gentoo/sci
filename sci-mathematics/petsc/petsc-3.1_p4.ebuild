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
KEYWORDS="~amd64 ~x86"
IUSE="mpi X cxx debug static-libs fortran doc"

RDEPEND="mpi? ( virtual/mpi[cxx?,fortran?] )
	X? ( x11-libs/libX11 )
	virtual/lapack
	virtual/blas"

DEPEND="${RDEPEND}
	sys-devel/gcc[-nocxx,fortran?]"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	epatch "${FILESDIR}/${PN}-configure-pic.patch"
	# My failed tries on the parallel build QA warnings:
	# sed -i "s/-\?\(@\?\)\${OMAKE}/\1\${MAKE}/g" makefile || die "sed failed"
	# sed -i "s/\ make /\ ${MAKE} /g" makefile || die "sed failed"
}

src_configure(){
	local mylang
	local myopt
	local myconf

	use cxx && mylang="cxx" || mylang="c"
	use debug && myopt="debug" || myopt="opt"

	export PETSC_DIR="${S}" || die
	export PETSC_ARCH="linux-gnu-${mylang}-${myopt}" || die

	if use mpi; then
		## this works independently of the used mpi implementation
		## (openmpi/mpich2)
		myconf="${myconf} --with-cc=/usr/bin/mpicc --with-cxx=/usr/bin/mpicxx"
		myconf="${myconf} --with-fc=/usr/bin/mpif77"
		myconf="${myconf} --with-mpi=1 --with-mpi-compilers=1"

		## of openmpi is used, the following works too, but fails with mpich2
		#myconf="${myconf} --with-mpi-include=/usr/include"
		## adding mpi libraries, -lmpi only is not sufficient if compiling
		## with g++, mpi_f77 needed when using fortran (mpi_f90 caused errors)
		#myconf="${myconf} --with-mpi-lib=[/usr/$(get_libdir)/libmpi.so"
		#use cxx     && myconf="${myconf},/usr/$(get_libdir)/libmpi_cxx.so"
		#use fortran && myconf="${myconf},/usr/$(get_libdir)/libmpi_f77.so"
		#myconf="${myconf}]"
		#myconf="${myconf} --known-mpi-shared=1"
	else
		myconf="${myconf} --with-cc=$(tc-getCC) --with-cxx=$(tc-getCXX)"
		myconf="${myconf} --with-mpi=0"
	fi

	use X \
		&& myconf="${myconf} --with-X=1" \
		|| myconf="${myconf} --with-X=0"
	use static-libs \
		&& myconf="${myconf} --with-shared=0" \
		|| myconf="${myconf} --with-shared=1"
	use amd64 \
		&& myconf="${myconf} --with-64-bit-indices=1" \
		|| myconf="${myconf} --with-64-bit-indices=0"
	use fortran \
		&& myconf="${myconf} --with-fortran=1" \
		|| myconf="${myconf} --with-fortran=0"

	if use debug; then
		strip-flags
		filter-flags -O*
		myconf="${myconf} --with-debugging=1"
	else
		myconf="${myconf} --with-debugging=0"
	fi

	python "${S}"/config/configure.py ${myconf} \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		--with-windows-graphics=0 --with-matlab=0 --with-python=0 \
		--with-clanguage="${mylang}" --with-single-library=1 \
		--with-petsc-arch="${PETSC_ARCH}" --with-precision=double \
		--with-blas-lapack-lib="$(pkg-config --libs lapack)" \
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

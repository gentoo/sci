# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit toolchain-funcs eutils fortran

FORTRAN="g77 gfortran ifc"

DESCRIPTION="A suite of programs for carrying out complete molecular mechanics investigations"
HOMEPAGE="http://ambermd.org/#AmberTools"
SRC_URI="AmberTools-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi openmp lapack X"
RESTRICT="fetch"

RDEPEND="
	virtual/cblas
	virtual/lapack
	sci-libs/cifparse-obj
	sci-chemistry/mopac7
	sci-libs/netcdf
	sci-chemistry/reduce"
DEPEND="${RDEPEND}
	dev-util/byacc
	dev-libs/libf2c
	sys-devel/ucpp"
S="${WORKDIR}/amber11"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "Place it in ${DISTDIR}"
}

pkg_setup() {
	need_fortran "${FORTRAN}"
	if use openmp &&
	[[ $(tc-getCC)$ == *gcc* ]] &&
		( [[ $(gcc-major-version)$(gcc-minor-version) -lt 42 ]] ||
		! has_version sys-devel/gcc[openmp] )
	then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		ewarn "If you want to build ${PN} with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
	fi
	AMBERHOME="${S}"
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-configure.patch"
	epatch "${FILESDIR}/${PV}-configure-fftw.patch"
	epatch "${FILESDIR}/${PV}-Makefile.patch"
	cd AmberTools/src
	rm -r byacc c9x-complex cifparse netcdf reduce ucpp-1.3 || die
}

src_configure() {
	cd AmberTools/src
	sed -e "s:\\\\\$(LIBDIR)/arpack.a:/usr/$(get_libdir)/libarpack.a:g" \
		-e "s:\\\\\$(LIBDIR)/lapack.a:/usr/$(get_libdir)/libclapack.a:g" \
		-e "s:\\\\\$(LIBDIR)/blas.a:/usr/$(get_libdir)/libcblas.a:g" \
		-e "s:CFLAGS=:CFLAGS=${CFLAGS} -DBINTRAJ :g" \
		-e "s:FFLAGS=:FFLAGS=${FFLAGS} :g" \
		-e "s:LDFLAGS=$ldflags:LDFLAGS=${LDFLAGS}:g" \
		-e "s:fc=g77:fc=${FORTRANC}:g" \
		-e "s:NETCDFLIB=\$netcdflib:NETCDFLIB=/usr/$(get_libdir)/libnetcdf.a:g" \
		-e "s:NETCDF=\$netcdf:NETCDF=netcdf.mod:g" \
		-e "s:-O3::g" \
		-i configure
#		-e "s:\\\\\$(LIBDIR)/f2c.a:/usr/$(get_libdir)/libf2c.a:g" \

	local myconf

	use X || myconf="${myconf} -noX11"

	for x in mpi openmp lapack; do
		use ${x} && myconf="${myconf/lapack/scalapack} -${x}"
	done

	./configure \
		${myconf} \
		-nobintraj \
		gnu
#	$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
}

src_compile() {
	cd AmberTools/src
	emake -f Makefile || die
}

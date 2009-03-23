# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs eutils fortran

FORTRAN="g77 gfortran ifc"

DESCRIPTION="A suite of programs for carrying out complete molecular mechanics investigations"
HOMEPAGE="http://ambermd.org/#AmberTools"
SRC_URI="AmberTools-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi openmp scalapack X"
RESTRICT="fetch"

RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}"/amber10

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "Place it in ${DISTDIR}"
}

pkg_setup() {
	need_fortran "${FORTRAN}"
	if use openmp &&
	[[ $(tc-getCC)$ == *gcc* ]] &&
		( [[ $(gcc-major-version)$(gcc-minor-version) -lt 42 ]] ||
		! built_with_use sys-devel/gcc openmp )
	then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		ewarn "If you want to build ${PN} with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-configure_at.patch
	epatch "${FILESDIR}"/${PV}-Makefile_at.patch
}

src_configure() {
	cd src
	sed -e "s:\\\\\$(LIBDIR)/arpack.a:/usr/$(get_libdir)/libarpack.a:g" \
		-e "s:\\\\\$(LIBDIR)/lapack.a:/usr/$(get_libdir)/liblapack.a:g" \
		-e "s:\\\\\$(LIBDIR)/blas.a:/usr/$(get_libdir)/libcblas.a:g" \
		-e "s:\\\\\$(LIBDIR)/f2c.a:/usr/$(get_libdir)/libf2c.a:g" \
		-e "s:CFLAGS=:CFLAGS=${CFLAGS} -DBINTRAJ :g" \
		-e "s:FFLAGS=:FFLAGS=${FFLAGS} :g" \
		-e "s:LDFLAGS=$ldflags:LDFLAGS=${LDFLAGS}:g" \
		-e "s:fc=g77:fc=${FORTRANC}:g" \
		-e "s:NETCDFLIB=\$netcdflib:NETCDFLIB=/usr/$(get_libdir)/libnetcdf.a:g" \
		-e "s:NETCDF=\$netcdf:NETCDF=netcdf.mod:g" \
		-e "s:-O3::g" \
		-i configure_at

	local myconf

	use X || myconf="${myconf} -noX11"

	for x in mpi openmp scalapack; do
		use ${x} && myconf="${myconf} -${x}"
	done

	./configure_at \
		${myconf} \
		-nobintraj \
		$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
}

src_compile() {
	cd src
	emake -f Makefile_at || die
}

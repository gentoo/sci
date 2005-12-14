# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

MY_PV="v${PV}"
MY_PN="`echo \"${PN}\" | tr a-z A-Z`"

DESCRIPTION="Library for unsymmetric sparse linear algebra using the Unsymmetric MultiFrontal method"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/${PN}/"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PV}/${MY_PN}${MY_PV}.tar.gz"
LICENSE="UMFPACK"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="blas doc"
DEPEND="blas? ( virtual/blas )"

S="${WORKDIR}/${MY_PN}${MY_PV}"

src_compile() {
	local MYCONFIG="-DNBLAS"
	local MYLIB="-lm"
	local MYCFLAGS=${CFLAGS}
	if use blas; then 
		MYCFLAGS="${MYCFLAGS} $(blas-config --cflags)"
		MYCONFIG="-DCBLAS" 
		MYLIB="${MYLIB} $(blas-config --clibs)"
	fi

	cd ${MY_PN}
	emake -j1 \
		CC="$(tc-getCC)" \
		CFLAGS="${MYCFLAGS}" \
		LIB="${MYLIB}" \
		CONFIG="${MYCONFIG}" lib || die "emake failed"
}

src_install() {
	dolib.a {AMD,UMFPACK}/Lib/*.a
	insinto /usr/include/umfpack
	doins {AMD,UMFPACK}/Include/*.h
	docinto amd
	dodoc AMD/ChangeLog
	docinto umfpack
	dodoc UMFPACK/ChangeLog
	if use doc; then
		insinto /usr/share/doc/${PF}/amd
		doins AMD/Doc/*.pdf
		insinto /usr/share/doc/${PF}/umfpack
		doins UMFPACK/Doc/*.pdf
	fi
}

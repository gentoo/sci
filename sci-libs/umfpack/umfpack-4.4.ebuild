# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

MY_PV="v${PV}"
MY_PN="`echo \"${PN}\" | tr a-z A-Z`"

DESCRIPTION="Library for unsymmetric sparse linear algebra using the Unsymmetric MultiFrontal method"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/umfpack"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PV}/${MY_PN}${MY_PV}.tar.gz"
# licence in tar file
LICENSE="UMFPACK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="blas doc"
DEPEND="blas? ( virtual/blas )"

S="${WORKDIR}/${MY_PN}${MY_PV}"

src_compile() {

	MYCONFIG="-DNBLAS"
	MYLIB="-lm"
	MYCFLAGS=${CFLAGS}

	if use blas; then 
		MYCFLAGS="${MYCFLAGS} $(blas-config --cflags)"
		MYCONFIG="-DCBLAS"
		MYLIB="${MYLIB} $(blas-config --clibs)"
	fi
	
	# upstream Makefile forbids to use parallell builds.
	# given its simplicity, we reproduce it here

	for udir in {AMD,UMFPACK}/Source; do
		emake \
			CC="$(tc-getCC)" \
			CFLAGS="${MYCFLAGS}" \
			LIB="${MYLIB}" \
			CONFIG="${MYCONFIG}" -C ${udir} || die "emake in compile failed"
	done
}

src_test() {

	for udir in {AMD,UMFPACK}/Demo; do
		emake \
			CC="$(tc-getCC)" \
			CFLAGS="${MYCFLAGS}" \
			LIB="${MYLIB}" \
			CONFIG="${MYCONFIG}" -C ${udir} || die "emake in test failed"
	done
}

src_install() {
	dolib.a {AMD,UMFPACK}/Lib/*.a || die "dolib failed"
	insinto /usr/include/umfpack
	doins {AMD,UMFPACK}/Include/*.h  || die "doins failed"

	dodoc README.txt
	for udir in {AMD,UMFPACK}; do
	 	docinto ${udir}
		dodoc ${udir}/README.txt
		docinto ${udir}/Doc
		dodoc ${udir}/Doc/ChangeLog
		if use doc; then 
			insinto /usr/share/${PF}/${udir}/Doc/ChangeLog
			doins ${udir}/Doc/*.pdf
		fi
	done
}

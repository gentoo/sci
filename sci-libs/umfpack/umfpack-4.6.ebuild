# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

upper() {
	echo ${1} | tr a-z A-Z
}

MY_PV="v${PV}"
MY_PN="$(upper ${PN})"
AMD_VERSION="v1.2"
UFCONFIG_VERSION="v1.0"

DESCRIPTION="Library for unsymmetric sparse linear algebra using the Unsymmetric MultiFrontal method"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/umfpack"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PV}/${MY_PN}.tar.gz
	http://www.cise.ufl.edu/research/sparse/UFconfig/${UFCONFIG_VERSION}/UFconfig.tar.gz
	http://www.cise.ufl.edu/research/sparse/amd/${AMD_VERSION}/AMD.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cblas doc"
DEPEND=">=sys-devel/libtool-1.5
	cblas? ( || ( >=sci-libs/blas-atlas-3.6.0
				>=sci-libs/mkl-8.0
				sci-libs/cblas-reference ) )"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	uplibs="amd umfpack"
	RPATH="${DESTTREE}"/$(get_libdir)

	UPCONFIG="-DNBLAS"
	use amd64 && UPCONFIG="${UPCONFIG} -DLP64"
	if use cblas; then
		UPCONFIG="${UPCONFIG} -DCBLAS $(blas-config --cflags)"
		UPBLAS="$(blas-config --clibs)"
	fi

	# upstream Makefile forbids to use parallell builds.
	# given its simplicity, we bypass it
	for uplib in ${uplibs}; do
		cd ${WORKDIR}/$(upper ${uplib})/Source
		emake \
			CC="libtool --mode=compile --tag=CC $(tc-getCC)" \
			CFLAGS="${CFLAGS}" \
			AR="$(tc-getAR) cr" \
			RANLIB="$(tc-getRANLIB)" \
			LIB="-lm" \
			UMFPACK_CONFIG="${UPCONFIG}" \
			BLAS="${UPBLAS}" \
			|| die "emake for ${uplib} failed"
		libtool --mode=link --tag=CC $(tc-getCC) ${CFLAGS} \
			-o lib${uplib}.la *.lo -rpath ${RPATH} \
			|| die "libtool for ${uplib} failed"
	done
}

src_test() {

	for uplib in ${uplibs}; do
		cd ${WORKDIR}/$(upper ${uplib})/Demo
		emake \
			CC="$(tc-getCC)" \
			CFLAGS="${CFLAGS}" \
			AR="$(tc-getAR) cr" \
			RANLIB="$(tc-getRANLIB)" \
			LIB="-lm" \
			UMFPACK_CONFIG="${UPCONFIG}" \
			BLAS="${UPBLAS}" \
			|| die "emake for ${uplib} failed"
	done
}

src_install() {

	dodir ${RPATH}
	for uplib in ${uplibs}; do
		UPLIB=$(upper ${uplib})
		UPDIR=${WORKDIR}/${UPLIB}
		insinto /usr/include/umfpack
		doins ${UPDIR}/Include/*.h
		cd ${UPDIR}/Source
		libtool --mode=install install -s lib${uplib}.la \
			${D}/${RPATH} || die "libtool for ${uplib} failed"
	 	docinto ${UPLIB}
		dodoc ${UPDIR}/README.txt
		docinto ${UPLIB}/Doc
		dodoc ${UPDIR}/Doc/ChangeLog
		if use doc; then
			insinto /usr/share/${PF}/${UPLIB}/Doc
			doins ${UPDIR}/Doc/*.pdf
		fi
	done
}

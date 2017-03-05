# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for Linear Algebra Package FORTRAN 77 implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc int64"

RDEPEND="
	!app-eselect/eselect-lapack
	|| (
		>=sci-libs/lapack-reference-${PV}-r100[int64?,${MULTILIB_USEDEP}]
		sci-libs/mkl[int64?,${MULTILIB_USEDEP}]
		abi_x86_64? ( !abi_x86_32? ( >=sci-libs/atlas-3.9.34[lapack] ) )
	)
	int64? (
		|| (
			>=sci-libs/lapack-reference-${PV}[int64,${MULTILIB_USEDEP}]
			sci-libs/mkl[int64,${MULTILIB_USEDEP}]
		)
	)
	doc? ( >=app-doc/lapack-docs-3.3 )"
DEPEND=""

pkg_pretend() {
	if [[ -e "${EROOT%/}"/usr/$(get_libdir)/lib${PN}.so ]]; then
		ewarn "You have still the old ${PN} library symlink present"
		ewarn "Please delete"
		ewarn "${EROOT%/}/usr/$(get_libdir)/lib${PN}.so"
		ewarn "to avoid problems with new ${PN} structure"
	fi
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-build multilib

DESCRIPTION="Virtual for FORTRAN 77 BLAS implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc int64"

RDEPEND="
	!app-eselect/eselect-blas
	|| (
		sci-libs/blas-reference[int64?,${MULTILIB_USEDEP}]
		>=sci-libs/openblas-0.2.11[int64?,${MULTILIB_USEDEP}]
		>=dev-cpp/eigen-3.1.4
		sci-libs/atlas[fortran]
		>=sci-libs/acml-4.4
		sci-libs/gotoblas2
		>=sci-libs/mkl-10.3
	)
	doc? ( >=app-doc/blas-docs-3.2 )
	int64? (
		|| (
			sci-libs/blas-reference[int64,${MULTILIB_USEDEP}]
			>=sci-libs/openblas-0.2.11[int64,${MULTILIB_USEDEP}]
		)
	)
"
DEPEND=""

pkg_pretend() {
	if [[ -e "${EROOT%/}"/usr/$(get_libdir)/lib${PN}.so ]]; then
		ewarn "You have still the old ${PN} library symlink present"
		ewarn "Please delete"
		ewarn "${EROOT%/}/usr/$(get_libdir)/lib${PN}.so"
		ewarn "to avoid problems with new ${PN} structure"
		die "Old lib${PN} detected"
	fi
}

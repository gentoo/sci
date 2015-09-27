# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="Virtual for Linear Algebra Package FORTRAN 77 implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

RDEPEND="
	|| (
		>=sci-libs/lapack-reference-${PV}
		>=sci-libs/atlas-3.10.1[lapack]
		>=sci-libs/mkl-11.0
		>=sci-libs/acml-5.3
	)
	doc? ( >=app-doc/lapack-docs-3.3 )"
DEPEND=""

pkg_pretend() {
	if [[ -e "${EPREFIX}"/usr/$(get_libdir)/lib${PN}.so ]]; then
		ewarn "You have still the old ${PN} library symlink present"
		ewarn "Please delete"
		ewarn "${EPREFIX}/usr/$(get_libdir)/lib${PN}.so"
		ewarn "to avoid problems with new ${PN} structure"
	fi
}

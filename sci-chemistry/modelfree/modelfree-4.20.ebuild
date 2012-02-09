# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fortran-2

DESCRIPTION="A program for optimizing Lipari-Szabo model free parameters to heteronuclear relaxation data"
HOMEPAGE="http://www.palmer.hs.columbia.edu/software/modelfree.html"
SRC_URI="http://www.palmer.hs.columbia.edu/software/modelfree4_linux.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="as-is"
IUSE="doc examples"

DEPEND=""
RDEPEND="
	sys-devel/gcc:4.1
	sci-libs/blas-reference
	sci-libs/lapack-reference
"

S="${WORKDIR}"

src_install() {
	dosym ../../usr/$(get_libdir)/librefblas.so /opt/${PN}/libblas.so.3
	dosym ../../usr/$(get_libdir)/libreflapack.so /opt/${PN}/liblapack.so.3

	cat >> "${T}"/${PN} <<- EOF
	#!${EPREFIX}/bin/bash
	LD_LIBRARY_PATH="${EPREFIX}/opt/${PN}" "${EPREFIX}/opt/${PN}/${PN}4" \$@
	EOF

	exeinto /opt/bin
	doexe "${T}"/${PN}

	exeinto /opt/${PN}
	use amd64 && doexe linux_64/${PN}4
	use x86 && doexe linux_32/${PN}4

	use doc && dodoc docs/{modelfree_manual.pdf,VERSIONS.README}
	use examples && insinto /usr/share/${PN} && doins -r testing
}

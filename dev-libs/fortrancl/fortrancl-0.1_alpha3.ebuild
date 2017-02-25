# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils fortran-2

MY_PV=${PV/_}
MY_P=${PN}-${MY_PV}

DESCRIPTION="OpenCL interface for Fortran 90"
HOMEPAGE="http://code.google.com/p/fortrancl/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples static-libs"

DEPEND="virtual/opencl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog README )
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_install() {
	autotools-utils_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{f90,cl}
	fi
}

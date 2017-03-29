# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Collection of finite element programs, libraries, and visualization tools"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	~sci-libs/matc-${PV}
	~sci-misc/elmer-elmergrid-${PV}
	~sci-misc/elmer-meshgen2d-${PV}
	~sci-libs/elmer-eio-${PV}
	~sci-libs/elmer-hutiter-${PV}
	~sci-misc/elmer-fem-${PV}
	~sci-misc/elmer-post-${PV}
	~sci-misc/elmer-front-${PV}"

pkg_postinst() {
	einfo "Elmer ebuilds may need further development."
	einfo "Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=221013"
}

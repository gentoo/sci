# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Elmer is a collection of finite element programs, libraries, and visualization tools"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="=sci-libs/matc-9999*
	=sci-misc/elmer-elmergrid-9999*
	=sci-misc/elmer-meshgen2d-9999*
	=sci-libs/elmer-eio-9999*
	=sci-libs/elmer-hutiter-9999*
	=sci-misc/elmer-fem-9999*
	=sci-misc/elmer-post-9999*
	=sci-misc/elmer-gui-9999*"

pkg_postinst() {
	einfo "Elmer ebuilds may need further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=221013"
}

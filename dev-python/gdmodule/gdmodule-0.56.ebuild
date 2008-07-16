# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="python extensions for gd"
HOMEPAGE="http://newcenturycomputers.net/projects/gdmodule.html"
SRC_URI="http://newcenturycomputers.net/projects/download.cgi/${P}.tar.gz"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

inherit python distutils

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~ppc64"
DEPEND="virtual/python
	media-libs/gd"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="gdmodule"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv Setup.py setup.py
}

pkg_postinst() {
	elog "The gdmodule ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=230459"
}
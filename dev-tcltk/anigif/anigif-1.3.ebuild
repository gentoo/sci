# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Image rotation package"
HOMEPAGE="http://cardtable.sourceforge.net/tcltk/"
#SRC_URI="${HOMEPAGE}/img_rotate.zip"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.zip"

LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="dev-lang/tcl"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/$(get_libdir)/${P}
	doins * || die
}

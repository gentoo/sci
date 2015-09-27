# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils eutils multilib

DESCRIPTION="Compares putatively similar files, ignoring small numeric differences and formats"
HOMEPAGE="http://www.nongnu.org/numdiff/"
SRC_URI="http://savannah.nongnu.org/download/numdiff/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+nls +gmp"

RDEPEND="
	gmp? ( dev-libs/gmp:0 )
	nls? ( sys-devel/gettext )
	!dev-util/ndiff"

DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable gmp)
		$(use_enable nls)
	    --enable-optimization
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# Remove some empty folders:
	rm -r "${ED}"/usr/share/locale || die

	#Fix up some wrong installation pathes:
	mv "${ED}"/usr/share/doc/${P}/{numdiff/numdiff.{html,pdf,txt*},} || die
	rm -r "${ED}"/usr/share/doc/${P}/numdiff || die
}

# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils eutils multilib

DESCRIPTION="program that can be used to compare putatively similar files, ignoring small numeric differences or/and different numeric formats"
HOMEPAGE="http://www.nongnu.org/numdiff/"
SRC_URI="http://savannah.nongnu.org/download/numdiff/${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+nls +gmp"

RDEPEND="
	gmp? ( dev-libs/gmp )
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
	rm -r "${ED}"/usr/share/locale

	#Fix up some wrong installation pathes:
	mv "${ED}"/usr/share/doc/${P}/{numdiff/numdiff.{html,pdf,txt*},} || die
	rm -r "${ED}"/usr/share/doc/${P}/numdiff || die
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Helsinki Finite State Transducer API and tools"
HOMEPAGE="http://hfst.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+openfst sfst foma xml +glib"

RDEPEND="
	foma? ( >sci-misc/foma-0.9.13 )
	glib? ( dev-libs/glib:2 )
	openfst? ( >sci-misc/openfst-1.2 )
	sfst? ( >sci-misc/sfst-1.3 )
	xml? ( dev-libs/libxml2:2= dev-cpp/libxmlpp:3.0= )
"
DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.35
	sys-devel/bison"

src_configure() {
	econf \
		$(use_with openfst) \
		$(use_with sfst) \
		$(use_with foma) \
		$(use_enable xml apertium2fst) \
		$(use_with glib unicodehandler glib) \
		--enable-lexc
}

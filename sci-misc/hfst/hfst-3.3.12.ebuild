# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Helsinki Finite State Transducer API and tools"
HOMEPAGE="http://hfst.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+openfst sfst foma xml +glib"

RDEPEND="
	openfst? ( >sci-misc/openfst-1.2 )
	sfst? ( >sci-misc/sfst-1.3 )
	foma? ( >sci-misc/foma-0.9.13 )
	xml? ( dev-libs/libxml2 dev-cpp/libxmlpp )
	glib? ( dev-libs/glib:2 )"
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

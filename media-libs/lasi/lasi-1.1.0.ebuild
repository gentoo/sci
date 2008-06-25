# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cmake-utils multilib

MY_PN="libLASi"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C++ library for postscript stream output"
HOMEPAGE="http://www.unifont.org/lasi/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS NEWS NOTES README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:\/lib$:\/$(get_libdir):" \
		-i cmake/modules/instdirs.cmake \
		|| die "Failed to fix cmake files for multilib."
}

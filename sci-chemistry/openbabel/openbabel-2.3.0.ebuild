# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel/openbabel-2.2.3.ebuild,v 1.11 2010/07/18 14:53:22 armin76 Exp $

EAPI="3"

inherit cmake-utils eutils

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc gui"

RDEPEND="
	dev-libs/libxml2:2
	>=sci-chemistry/inchi-1.03
	!sci-chemistry/babel
	dev-cpp/eigen:2
	sys-libs/zlib
	gui? ( x11-libs/wxGTK )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8"

src_configure() {
	epatch "${FILESDIR}/${P}-test_lib_path.patch" \
		|| die "Failed to apply ${P}-test_lib_path.patch"
	local mycmakeargs=""
	mycmakeargs="${mycmakearg}
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		$(cmake-utils_use gui BUILD_GUI)
		$(cmake-utils_use_enable test TESTS)"

	cmake-utils_src_configure
}

src_install() {
	dodoc AUTHORS ChangeLog NEWS README THANKS || die
	dodoc doc/{*.inc,README*,*.inc,*.mol2} || die
	dohtml doc/{*.html,*.png} || die
	if use doc ; then
		insinto /usr/share/doc/${PF}/API/html
		doins doc/API/html/* || die
	fi

	cmake-utils_src_install
}

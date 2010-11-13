# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel/openbabel-2.2.3.ebuild,v 1.11 2010/07/18 14:53:22 armin76 Exp $

EAPI="3"

inherit cmake-utils

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	>=dev-libs/libxml2-2.6.5
	!sci-chemistry/babel
	dev-cpp/eigen:2
	sys-libs/zlib"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8"

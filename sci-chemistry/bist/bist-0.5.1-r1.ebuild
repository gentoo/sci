# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils base

DESCRIPTION="Bist, the chemical drawing tool"
HOMEPAGE="http://www.autistici.org/interzona/index.php?mod=03_Bist"
SRC_URI="http://www.autistici.org/interzona/ftrack.php?url=sections/06_Download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/curl
	dev-libs/expat
	>=x11-libs/fltk-1.1.7:1.1
	sci-libs/gsl
	>=sci-chemistry/openbabel-2.2.0
	>=media-libs/plotutils-2.5"

DEPEND="${RDEPEND}"

src_prepare() {
	use amd64 && epatch "${FILESDIR}/${P}-bracket.patch"
	epatch "${FILESDIR}/${P}-install.patch"
}

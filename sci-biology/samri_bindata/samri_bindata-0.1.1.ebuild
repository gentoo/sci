# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Mouse brain atlasses for SAMRI."
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI="http://chymera.eu/pkgdata/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

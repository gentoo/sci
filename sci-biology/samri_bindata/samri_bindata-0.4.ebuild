# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ParaVision Mouse, Rat, and Lemur Testing Data for SAMRI"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI="
	https://zenodo.org/record/3823441/files/${P}.tar.xz
	http://chymera.eu/distfiles/${P}.tar.xz
	"

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

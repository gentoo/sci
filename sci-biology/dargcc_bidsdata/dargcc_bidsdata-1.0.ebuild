# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="BIDS data selection of wildtype animals from DARGCC article"
HOMEPAGE="https://academic.oup.com/cercor/article/28/7/2495/4975475"
SRC_URI="
	https://zenodo.org/record/3885733/files/${P}.tar.xz
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

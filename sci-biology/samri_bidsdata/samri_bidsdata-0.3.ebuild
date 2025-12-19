# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="BIDS-formatted example mouse brain data for SAMRI"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"

SRC_URI="
	https://zenodo.org/record/3831124/files/${P}.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r ./*
}

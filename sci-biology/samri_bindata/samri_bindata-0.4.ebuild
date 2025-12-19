# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ParaVision Mouse, Rat, and Lemur Testing Data for SAMRI"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI="
	https://zenodo.org/record/3823441/files/${P}.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r ./*
}

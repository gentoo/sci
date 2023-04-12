# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utilities Supporting RepSeP-style documents"
HOMEPAGE="https://github.com/TheChymera/repsep_utils"
SRC_URI="https://github.com/TheChymera/repsep_utils/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-tex/pythontex"

src_install() {
	dobin "bin/repsep"

	insinto "/usr/share/repsep"
	doins repsep/*
}

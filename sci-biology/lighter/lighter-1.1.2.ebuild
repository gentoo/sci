# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NGS reads corrector"
HOMEPAGE="https://github.com/mourisl/Lighter"
if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mourisl/Lighter.git"
else
	SRC_URI="https://github.com/mourisl/Lighter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Lighter-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="virtual/zlib:="
RDEPEND="${DEPEND}"

src_install(){
	dobin lighter
	dodoc README.md
}

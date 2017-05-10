# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs python-single-r1

DESCRIPTION="Genome-scale comparison of biological sequences"
HOMEPAGE="http://last.cbrc.jp/"
SRC_URI="http://last.cbrc.jp/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-fix-build-system.patch
	"${FILESDIR}"/${PN}-${PV}-portable-shebangs.patch
)

src_configure() {
	tc-export CC CXX
}

src_install() {
	local DOCS=( doc/*.txt ChangeLog.txt README.txt )
	local HTML_DOCS=( doc/*html )
	einstalldocs

	dobin src/lastdb src/lastal src/last-split src/last-merge-batches \
		src/last-pair-probs src/lastdb8 src/lastal8 src/last-split8

	cd scripts || die
	dobin *
}

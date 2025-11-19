# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-single-r1

DESCRIPTION="De novo de Bruijn genome assembler overcoming uneven coverage"
HOMEPAGE="https://cab.spbu.ru/software/spades"
SRC_URI="
	https://github.com/ablab/spades/releases/download/v${PV}/${P}.tar.gz
	https://cab.spbu.ru/files/release${PV}/manual.html -> ${P}_manual.html
	https://cab.spbu.ru/files/release${PV}/rnaspades_manual.html -> ${P}_rnaspades_manual.html
	https://cab.spbu.ru/files/release${PV}/truspades_manual.html -> ${P}_truspades_manual.html
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	virtual/zlib:=
	app-arch/bzip2
	dev-python/regex
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}"
BDEPEND="dev-build/cmake"

# Remove for next release:
# https://github.com/ablab/spades/issues/1238#issuecomment-1904427831
PATCHES=(
	"${FILESDIR}/${P}-gcc13.patch"
)

src_install(){
	einstalldocs
	# WORKAROUND: This script does both compile and install in one go
	PREFIX="${ED}"/usr ./spades_compile.sh || die
}

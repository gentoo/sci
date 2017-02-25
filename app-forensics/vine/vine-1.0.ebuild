# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="The BitBlaze Static Analysis Component"
HOMEPAGE="http://bitblaze.cs.berkeley.edu/vine.html"
SRC_URI="http://bitblaze.cs.berkeley.edu/release/${P}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/ocaml
	dev-ml/findlib
	dev-ml/camlidl
	>=dev-libs/gmetadom-0.2.6-r1[ocaml]
	dev-ml/extlib
	dev-ml/ocamlgraph"
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

PATCHES=(
	"${FILESDIR}"/${P}-binutils.patch
	"${FILESDIR}"/${P}-gcc46.patch
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-ocamlgraph182.patch
)

src_compile() {
	emake CC=$(tc-getCC) CCFLAGS="${CFLAGS} -fPIC"
}

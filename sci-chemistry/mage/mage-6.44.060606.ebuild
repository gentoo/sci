# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="Mage is a 3D vector display program which shows 'kinemage' graphics"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/mage.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/mage/${MY_P}.src.tgz"

LICENSE="richardson"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-chemistry/prekin"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PV}-Makefile.patch"
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		dynamic
}

src_install() {
	dobin "${S}"/mage
}

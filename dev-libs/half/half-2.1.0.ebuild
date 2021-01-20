# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

DESCRIPTION="Half-precision floating-point library"
HOMEPAGE="http://half.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/half/half/${PV}/half-${PV}.zip"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /usr/include
	doins include/half.hpp
}

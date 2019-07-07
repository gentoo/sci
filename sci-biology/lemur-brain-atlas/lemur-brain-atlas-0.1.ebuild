# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MRI Brain Template and Atlas of the Mouse Lemur"
HOMEPAGE="https://www.nitrc.org/projects/mouselemuratlas"
SRC_URI="https://www.nitrc.org/frs/downloadlink.php/10867 -> ${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/MIRCen-MouseLemurAtlas_V0.01"

src_install() {
	insinto "/usr/share/${PN}"
	doins *
}

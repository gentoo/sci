# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs

DESCRIPTION="A collection of mouse brain atlases in NIfTI format"
HOMEPAGE="https://github.com/IBT-FMI/mouse-brain-atlases"
SRC_URI="http://chymera.eu/distfiles/${P}.zip"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""

CHECKREQS_DISK_BUILD=4G
CHECKREQS_DISK_USR=4G
CHECKREQS_DISK_VAR=8G

src_install() {
	insinto "/usr/share/${PN}"
	doins *
}

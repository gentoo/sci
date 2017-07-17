# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Set of classes for creating statistical genetic programs"
HOMEPAGE="https://github.com/statgen/libStatGen"
SRC_URI="https://github.com/statgen/libStatGen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_install(){
	default
	dolib libStatGen.* # package only makes a static library
}

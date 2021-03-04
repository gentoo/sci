# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs

DESCRIPTION="Set of classes for creating statistical genetic programs"
HOMEPAGE="https://github.com/statgen/libStatGen"
SRC_URI="https://github.com/statgen/libStatGen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_compile() {
	default
	docs_compile
}

src_install(){
	default
	dolib.a libStatGen.a # package only makes a static library
}

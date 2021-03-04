# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DIR="doc/src"
DOCS_DEPEND="media-gfx/graphviz"

inherit cmake docs

DESCRIPTION="A complete OpenCascade - OCAF based CAD framework"
HOMEPAGE="https://sourceforge.net/projects/salomegeometry/"
SRC_URI="mirror://sourceforge/salomegeometry/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

OCC_SLOT="7.4.0"

RDEPEND="sci-libs/opencascade:${OCC_SLOT}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_configure() {
	mycmakeargs=(
		-DOCC_INCLUDE_PATH="/usr/lib64/opencascade-${OCC_SLOT}/ros/include/opencascade/"
	)
	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}

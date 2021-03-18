# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="A free open-source cross-platform bioinformatics software"
HOMEPAGE="http://ugene.unipro.ru"
SRC_URI="https://github.com/ugeneunipro/ugene/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-qt/qtgui-5.4.2
	>=dev-qt/qtsvg-5.4.2
	>=dev-qt/qtscript-5.4.2[scripttools]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# remove Werror
	sed -i -e '/-Werror=/d' CMakeLists.txt || die
	sed -i -e '/-Werror=/d' src/ugene_globals.pri || die
}

src_configure() {
	eqmake5
}

src_install() {
	einstalldocs
	emake INSTALL_ROOT="${ED}" install
}

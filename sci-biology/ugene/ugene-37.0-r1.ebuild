# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="A free open-source cross-platform bioinformatics software"
HOMEPAGE="http://ugene.unipro.ru"
SRC_URI="https://github.com/ugeneunipro/ugene/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cpu_flags_x86_sse2"

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
	local CONFIG_OPTS
	if use amd64; then
		CONFIG_OPTS+=( CONFIG+="x64" )
	elif use ppc; then
		CONFIG_OPTS+=( CONFIG+="ppc" )
	fi

	use cpu_flags_x86_sse2 && CONFIG_OPTS+=( use_sse2 )

	eqmake5 $CONFIG_OPTS || die
}

src_install() {
	einstalldocs
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install
}

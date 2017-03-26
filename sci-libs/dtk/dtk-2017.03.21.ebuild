# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Meta-platform for modular scientific platform development"
HOMEPAGE="https://github.com/d-tk/dtk"
SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-qt/qttest:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
DEPEND="${RDEPEND}
	dev-lang/swig:0"

src_configure() {
	local mycmakeargs=(
		-DDTK_BUILD_SUPPORT_COMPOSER=ON
		-DDTK_BUILD_SUPPORT_CORE=ON
		-DDTK_BUILD_SUPPORT_CONTAINER=ON
		-DDTK_BUILD_SUPPORT_DISTRIBUTED=ON
		-DDTK_BUILD_SUPPORT_GUI=ON
		-DDTK_BUILD_SUPPORT_MATH=ON
	)
	cmake-utils_src_configure
}

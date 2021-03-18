# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A free open-source cross-platform bioinformatics software"
HOMEPAGE="http://ugene.unipro.ru"
SRC_URI="https://github.com/ugeneunipro/ugene/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-qt/qtgui-5.4.2
	>=dev-qt/qtsvg-5.4.2
	>=dev-qt/qtscript-5.4.2[scripttools]
"
RDEPEND="${DEPEND}"

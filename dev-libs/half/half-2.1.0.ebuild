# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Half-precision floating-point library"
HOMEPAGE="http://half.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/half/half/${PV}/${P}.zip"
S="${WORKDIR}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

BDEPEND="app-arch/unzip"

src_install() {
	cd include
	doheader half.hpp
}

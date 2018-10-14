# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="C++ Library for reading and writing CIFTI-2 and CIFTI-1 files"
HOMEPAGE="https://github.com/Washington-University/CiftiLib"
SRC_URI="https://github.com/Washington-University/CiftiLib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-cpp/libxmlpp:2.6
	dev-libs/boost
	sys-libs/zlib
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CiftiLib-${PV}"

src_configure() {
	local mycmakeargs=(
		-DIGNORE_QT=TRUE
	)
	cmake-utils_src_configure
}

src_test(){
	local myctestargs=(
				-j1
		)
	cmake-utils_src_test
}

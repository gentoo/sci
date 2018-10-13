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

RDEPEND="sys-libs/zlib"
DEPEND="
	dev-cpp/libxmlpp
	dev-libs/boost
	"

S="${WORKDIR}/CiftiLib-${PV}"

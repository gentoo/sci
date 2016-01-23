# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
HOMEPAGE="http://www.cs.cmu.edu/~ckingsf/software/sailfish/"
SRC_URI="https://github.com/kingsfordgroup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-0.9.1-no-boost-static.patch )

DEPEND="dev-libs/boost:0
		dev-libs/jemalloc
		dev-cpp/tbb"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	rm -r "${ED}"/usr/tests || die
}

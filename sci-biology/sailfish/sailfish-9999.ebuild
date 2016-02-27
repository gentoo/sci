# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
HOMEPAGE="http://www.cs.cmu.edu/~ckingsf/software/sailfish/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/kingsfordgroup/sailfish.git"

LICENSE="GPL-3"
SLOT="0"
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

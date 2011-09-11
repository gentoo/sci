# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

DESCRIPTION="BamTools provides a fast, flexible C++ API for reading and writing BAM files using modified JsonCPP."
HOMEPAGE="https://github.com/pezmaster31/bamtools"
SRC_URI="https://github.com/downloads/pezmaster31/bamtools/"${P}".tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	dobin bin/bamtools || die
	dolib lib/* || die
	insinto /usr/include/bamtools/api || die
	doins include/api/* || die
	insinto /usr/include/bamtools/shared || die
	doins include/shared/*
	dodoc README || die
}

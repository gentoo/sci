# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git-2

DESCRIPTION="BamTools provides a fast, flexible C++ API for reading and writing BAM files using modified JsonCPP."
HOMEPAGE="https://github.com/pezmaster31/bamtools"
EGIT_REPO_URI="https://github.com/pezmaster31/bamtools.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/src

src_configure() {
	cmake-utils_src_configure # this creates "${WORKDIR}"/bamtools-9999_build/ directory for build process
	#sed -i -e 's/^CXX/#CXX/' Makefile || die "Failed to fix Makefile"
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

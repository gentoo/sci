# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"
SRC_URI=""
EGIT_REPO_URI="https://github.com/pezmaster31/bamtools.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}"/src

src_install() {
	dobin bin/bamtools
	dolib lib/*
	insinto /usr/include/bamtools/api
	doins include/api/*
	insinto /usr/include/bamtools/shared
	doins include/shared/*
	dodoc README
}

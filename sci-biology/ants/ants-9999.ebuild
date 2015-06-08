# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package git-r3

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="http://stnava.github.io/ANTs/"
SRC_URI=""
EGIT_REPO_URI="https://bpaste.net/show/02535651bb27"

SLOT="0"
LICENSE="BSD"
KEYWORDS=""

DEPEND="sci-libs/itk"
RDEPEND="${DEPEND}"

src_compile() {
	pwd
	ls
	ccmake ANTs
	emake -j4
}


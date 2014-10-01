# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3

DESCRIPTION="Windowed adaptive adaptor trimming tool for FASTQ data from Illumina/Solexa"
HOMEPAGE="https://github.com/najoshi/sickle"
EGIT_REPO_URI="https://github.com/najoshi/sickle"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib"

src_install(){
	dobin sickle
	dodoc README.md
}

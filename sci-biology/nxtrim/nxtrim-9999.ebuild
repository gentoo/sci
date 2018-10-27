# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils

DESCRIPTION="Trim Illumina TruSeq adapters and split reads by Nextera MatePair linker"
HOMEPAGE="https://github.com/sequencing/NxTrim"
EGIT_REPO_URI="https://github.com/sequencing/NxTrim.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="" # https://github.com/sequencing/NxTrim/issues/32
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	dobin nxtrim mergeReads
	dodoc README.md
}

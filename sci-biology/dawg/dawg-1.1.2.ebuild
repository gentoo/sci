# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="DNA Assembly With Gaps: Phylogenetic aligner for sequence evolution simulation"
HOMEPAGE="http://scit.us/projects/dawg/"
SRC_URI="http://scit.us/projects/files/dawg/Releases/${P}-release.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/${P}-RELEASE

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

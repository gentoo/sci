# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3

DESCRIPTION="Bayesian 3'-end adapter (only) trimmer for Illumina/Solexa"
HOMEPAGE="https://github.com/vsbuffalo/scythe"
EGIT_REPO_URI="https://github.com/vsbuffalo/scythe"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib"

src_install(){
	dobin scythe
	dodoc README.md
	dodoc illumina_adapters.fa
}

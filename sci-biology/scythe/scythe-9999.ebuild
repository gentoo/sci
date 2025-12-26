# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Bayesian 3'-end adapter (only) trimmer for Illumina/Solexa"
HOMEPAGE="https://github.com/vsbuffalo/scythe"
EGIT_REPO_URI="https://github.com/vsbuffalo/scythe"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RESTRICT="test"

DEPEND="virtual/zlib:="
RDEPEND="${DEPEND}"

src_install(){
	dobin scythe
	dodoc README.md
	dodoc illumina_adapters.fa
}

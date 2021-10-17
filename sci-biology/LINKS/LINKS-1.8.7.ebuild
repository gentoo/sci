# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scaffold genome assemblies by Chromium/PacBio/Nanopore reads"
HOMEPAGE="https://github.com/bcgsc/LINKS"
SRC_URI="https://github.com/bcgsc/LINKS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="
	>=dev-lang/perl-1.6
	dev-lang/swig
	sci-biology/btl_bloomfilter
"

src_install(){
	dobin bin/LINKS *.pl tools/*.pl
	dodoc README.md
}

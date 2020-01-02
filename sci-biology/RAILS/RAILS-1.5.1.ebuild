# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Cobbler and RAILS scaffolding tools acting on SAM streams"
HOMEPAGE="https://github.com/bcgsc/RAILS"
SRC_URI="https://github.com/bcgsc/RAILS/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	sci-biology/samtools
	sci-biology/bwa
"
# bin/runRAILSminimap.sh calls minimap2 but one can stream the SAM data directly
BDEPEND=""

src_prepare(){
	# remove hardcoded PATHs
	# https://github.com/bcgsc/RAILS/issues/8
	sed -e 's@^\.\./@@g' -e 's@^export PATH=/gsc/btl/linuxbrew@#&1@' -i bin/*.sh || die
	default
}

src_install(){
	dobin bin/*
	dodoc readme.md paper/paper.pdf
}

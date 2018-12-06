# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Cobbler and RAILS scaffolding tools"
HOMEPAGE="https://github.com/bcgsc/RAILS"
SRC_URI="https://github.com/bcgsc/RAILS/archive/v1.4.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	sci-biology/samtools"
BDEPEND=""

src_prepare(){
	# remove hardcoded PATHs
	sed -e 's@^\.\./@@g' -e 's@^export PATH=/gsc/btl/linuxbrew@#&1@' -i bin/runRAILS.sh || die
	default
}

src_install(){
	dobin bin/*
	dodoc readme.md paper/paper.pdf
}

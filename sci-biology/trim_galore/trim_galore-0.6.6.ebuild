# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Perl wrapper around Cutadapt and FastQC to adapter and quality trimming"
HOMEPAGE="https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/ https://github.com/FelixKrueger/TrimGalore"
SRC_URI="https://github.com/FelixKrueger/TrimGalore/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
	dev-lang/perl
	sci-biology/cutadapt
	sci-biology/fastqc
	${DEPEND}"

S="${WORKDIR}/TrimGalore-${PV}"

src_install(){
	dobin trim_galore
	dodoc -r Docs
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Perl wrapper around Cutadapt and FastQC to adapter and quality trimming"
HOMEPAGE="http://www.bioinformatics.babraham.ac.uk/projects/trim_galore"
SRC_URI="http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/trim_galore_v${PV}.zip"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	sci-biology/cutadapt
	sci-biology/fastqc
	${DEPEND}"

S="${WORKDIR}"

src_install(){
	dobin trim_galore
	dodoc *.pdf
}

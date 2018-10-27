# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Find closely related subjects using SNP genotype data, validate pedigree file"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/Software.cgi"
SRC_URI="http://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/GetZip.cgi?zip_name=GRAF_files.zip -> ${P}.tar.gz"
# the .zip is indeed .tar.gz

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64" # 64bit exe only
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare(){
	sed -e 's#/usr/local/bin/perl#/usr/bin/env perl#' -i *.pl || die # there is not perl_fix_shebang
}

src_install(){
	dobin graf graf_dups *.pl
	dodoc GRAF_ReadMe_*.docx GRAF-popDocumentation*.docx
	insinto /usr/share/"${PN}"
	doins *.txt *.bed *.bim *.fam
}

pkg_postinst(){
	einfo "Probably you will use this program with sci-biology/plink and"
	einfo "sci-biology/plinkseq outputs"
}

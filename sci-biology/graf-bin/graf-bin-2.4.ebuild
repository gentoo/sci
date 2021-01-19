# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Find closely related subjects using SNP genotype data, validate pedigree file"
HOMEPAGE="https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/Software.cgi"
SRC_URI="https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/GetZip.cgi?zip_name=GRAF_files.zip -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_prepare(){
	default
	sed -e 's#/usr/local/bin/perl#/usr/bin/env perl#' -i *.pl || die # there is not perl_fix_shebang
}

src_install(){
	dobin graf graf_dups
	perl_domodule *.pl
}

pkg_postinst(){
	einfo "Probably you will use this program with sci-biology/plink and"
	einfo "sci-biology/plinkseq outputs"
}

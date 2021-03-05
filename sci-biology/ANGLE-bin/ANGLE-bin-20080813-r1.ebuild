# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="CDS prediction overcoming sequencing errors in unfinished cDNA"
HOMEPAGE="http://bioinformatics.cenargen.embrapa.br/portrait/download"
SRC_URI="http://bioinformatics.cenargen.embrapa.br/portrait/download/angle.tar.gz -> ${P}.tar.gz"

# According to Roberto T Arrial (author of portrait) for the purpose of his
# portrait project the binaries were provided under a BSD license.
# The output from Angle is modified for use with portrait and differs from
# current versions at http://cbrc3.cbrc.jp/~shimizu/index.php
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/angle"

RDEPEND="
	sys-libs/libstdc++-v3
	dev-lang/perl
"

QA_PREBUILT="opt/*"

src_install(){
	perl_domodule *.pl
	use amd64 && dobin ANGLE-linux64 ANGLE-linux64DP
	use x86 && dobin ANGLE-linux32 ANGLE-linux32DP
	dodoc README.txt
	insinto /usr/share/"${PN}"
	doins test.html sample.txt sample2.txt test seq2.noOrf
	doins -r param-human param-plant
}

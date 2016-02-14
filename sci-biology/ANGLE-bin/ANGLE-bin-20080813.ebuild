# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="CDS prediction overcoming sequencing errors in protein coding regions in unfinished cDNA"
HOMEPAGE="http://bioinformatics.cenargen.embrapa.br/portrait/download"
SRC_URI="http://bioinformatics.cenargen.embrapa.br/portrait/download/angle.tar.gz"

RESTRICT="fetch"
# According to Roberto T Arrial (author of portrait) for the purpose of his
# portrait project the binaries were provided under a BSD license.
# The output from Angle is modified for use with portrait and differs from
# current versions at http://cbrc3.cbrc.jp/~shimizu/index.php
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/angle

src_install(){
	dobin *.pl ANGLE-linux64 ANGLE-linux32 ANGLE-linux32DP ANGLE-linux64DP
	dodoc README.txt
	insinto /usr/share/"${PN}"
	doins test.html sample.txt sample2.txt "test" seq2.noOrf
	doins -r param-human
	doins -r param-plant
}

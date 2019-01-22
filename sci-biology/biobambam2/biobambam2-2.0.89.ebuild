# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools for bam file processing (libmaus2)"
HOMEPAGE="https://gitlab.com/german.tischler/biobambam2
	https://github.com/gt1/biobambam2"
SRC_URI="https://github.com/gt1/biobambam2/archive/2.0.89-release-20180518145034.tar.gz"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	!sci-biology/biobambam
	>=sci-libs/libmaus2-2.0.489"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/biobambam2-2.0.89-release-20180518145034

src_configure(){
	econf --with-libmaus2="${EPREFIX}"
}

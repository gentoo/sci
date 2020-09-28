# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools

DESCRIPTION="Tools for bam file processing (using libmaus2)"
HOMEPAGE="https://gitlab.com/german.tischler/biobambam2
	https://github.com/gt1/biobambam2"
EGIT_REPO_URI="https://gitlab.com/german.tischler/biobambam2"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-libs/libmaus2"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure(){
	econf --with-libmaus2="${EPREFIX}"
}

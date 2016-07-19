# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 autotools

DESCRIPTION="Tools for bam file processing (libmaus2)"
HOMEPAGE="https://github.com/gt1/biobambam2"
EGIT_REPO_URI="https://github.com/gt1/biobambam2.git"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	!sci-biology/biobambam
	>=sci-libs/libmaus2-2.0.225"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure(){
	econf --with-libmaus2="${EPREFIX}"
}

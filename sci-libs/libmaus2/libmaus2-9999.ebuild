# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Library for biobambam2"
HOMEPAGE="https://github.com/gt1/libmaus"
EGIT_REPO_URI="https://github.com/gt1/libmaus2.git"

LICENSE="GPL-3" # BUG: a mix of licenses, see AUTHORS
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	!sci-libs/libmaus
	sci-libs/io_lib
	app-arch/snappy
	sci-biology/seqan"

src_prepare() {
	eautoreconf
	eapply_user
}

pkg_postinst(){
	einfo "The io_lib, snappy and seqan dependencies are not strictly needed"
	einfo "but were forced for optimal libmaus2 performance."
}

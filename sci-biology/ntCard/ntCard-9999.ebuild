# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Estimate k-mer coverage histogram of genomics data"
HOMEPAGE="https://github.com/bcgsc/ntCard"
EGIT_REPO_URI="https://github.com/bcgsc/ntCard.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

IUSE="openmp"
# requires network
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sh ./autogen.sh || die
	default
}

src_configure() {
	local myconf=()
	use openmp || myconf+=( --disable-openmp )
	econf ${myconf[@]}
}

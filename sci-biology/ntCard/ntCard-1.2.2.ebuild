# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Estimate k-mer coverage histogram of genomics data"
HOMEPAGE="https://github.com/bcgsc/ntCard"
SRC_URI="https://github.com/bcgsc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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

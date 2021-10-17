# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="BTL C/C common bloom filters"
HOMEPAGE="https://github.com/bcgsc/btl_bloomfilter"
SRC_URI="https://github.com/bcgsc/btl_bloomfilter/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare(){
	sh ./autogen.sh || die
	default
}

src_test(){
	make check || die
}

src_install(){
	default
	insinto /usr/share/"${PN}"
	doins -r swig pythonInterface Examples
}

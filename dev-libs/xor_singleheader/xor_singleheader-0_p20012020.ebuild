# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="single header library for fast XOR filters"
HOMEPAGE="https://github.com/FastFilter/xor_singleheader"

COMMIT=6cea6a4dcf2f18a0e3b9b9e0b94d6012b804ffa1
SRC_URI="https://github.com/FastFilter/xor_singleheader/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}
KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_compile() {
	if use test ; then
		default
	fi
}

src_install() {
	doheader include/{fusefilter,xorfilter}.h
}

src_test() {
	"${S}"/unit || die "failed unittests"
}

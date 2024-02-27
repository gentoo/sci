# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="High-Precision Software"
HOMEPAGE="
	https://www.davidhbailey.com/dhbsoftware/
	https://github.com/APN-Pucky/mpfun90
"
MY_PV=$(ver_rs 1- '-')
SRC_URI="https://github.com/APN-Pucky/mpfun90/archive/refs/tags/${MY_PV}.tar.gz"
S="${WORKDIR}/mpfun90-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	tc-export FC
	emake -j1 dynamic FC=${FC}
}

src_install() {
	doheader *.mod
	dolib.so libmpfun90.so
	dolib.a libmpfun90.a
}

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

DESCRIPTION="High-Precision Software"
HOMEPAGE="
	https://www.davidhbailey.com/dhbsoftware/
	https://github.com/APN-Pucky/mpfun90
"
MY_PV=$(ver_rs 1- '-')
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/APN-Pucky/mpfun90"
else
	SRC_URI="https://github.com/APN-Pucky/mpfun90/archive/refs/tags/${MY_PV}.tar.gz"
	S="${WORKDIR}/mpfun90-${MY_PV}"
	KEYWORDS="~amd64"
fi

LICENSE="DHBBSD"
SLOT="0"

src_compile() {
	emake -j1 dynamic
}

src_install() {
	doheader *.mod
	dolib.so libmpfun90.so
	dolib.a libmpfun90.a
}

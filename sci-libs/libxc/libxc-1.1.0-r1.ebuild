# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils fortran-2 multilib

MY_P=${P//_/-}

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
SRC_URI="http://www.tddft.org/programs/octopus/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran static-libs"

S="${WORKDIR}"/${MY_P}

MAKEOPTS+=" -j1"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable fortran)
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}} -fPIC"
		CFLAGS="${CFLAGS} -fPIC"
		)
	autotools-utils_src_configure
}

## Upstream recommends not running the test suite because it requires
## human expert interpretation to determine whether output is an error or
## expected under certain circumstances.
# src_test() { :; }

src_install() {
	autotools-utils_src_install

	if use fortran; then
		# argument for this: --with-moduledir from etsf_io/bigdft
		insinto /usr/$(get_libdir)/finclude
		pushd "${AUTOTOOLS_BUILD_DIR}"/src >/dev/null
		doins *.mod || die
		rm -f "${D}"/usr/include/*.mod || die
		popd >/dev/null
	fi
}

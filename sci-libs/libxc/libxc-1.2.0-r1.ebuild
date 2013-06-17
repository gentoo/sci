# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils fortran-2 multilib

MY_P=${P//_/-}

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
SRC_URI="http://www.tddft.org/programs/octopus/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="fortran static-libs -test"

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
# The autotools src_test function modified not to die. Runs emake check in build directory.
src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	ewarn "This will fail if any test fails, no matter how dealt with in the ebuild."
	make check || ewarn "Make check failed. See above for details."
	einfo "emake check done"
	popd > /dev/null || die
}

src_install() {
	autotools-utils_src_install

}

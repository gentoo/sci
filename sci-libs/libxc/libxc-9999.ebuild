# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils fortran-2 multilib subversion

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
ESVN_REPO_URI="http://www.tddft.org/svn/octopus/trunk/${PN}/"
ESVN_BOOTSTRAP="eautoreconf -i"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="fortran static-libs -test"

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
## expected under certain circumstances. Nevertheless, experts might want the option.
# The autotools src_test function modified not to die. Runs emake check in build directory.
src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	make check || ewarn "Make check failed. See above for details."
	einfo "emake check done"
	popd > /dev/null || die
}

src_install() {
	autotools-utils_src_install

}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils fortran-2 multilib subversion

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
ESVN_REPO_URI="http://www.tddft.org/svn/octopus/trunk/${PN}/"
ESVN_BOOTSTRAP="eautoreconf -i"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="fortran static-libs"

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

src_install() {
	autotools-utils_src_install

	if use fortran; then
		insinto /usr/$(get_libdir)/finclude
		pushd "${AUTOTOOLS_BUILD_DIR}"/src >/dev/null
		doins *.mod || die
		rm -f "${D}"/usr/include/*.mod || die
		popd >/dev/null
	fi
}

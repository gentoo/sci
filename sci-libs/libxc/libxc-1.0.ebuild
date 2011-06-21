# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit fortran-2 multilib toolchain-funcs

MY_P=${P//_/-}

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="http://www.tddft.org/programs/octopus/wiki/index.php/Libxc/"
SRC_URI="http://www.tddft.org/programs/octopus/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		$(use_enable fortran) \
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}"
}

## Upstream recommends not running the test suite because it requires
## human expert interpretation to determine whether output is an error or
## expected under certain circumstances.
# src_test() { :; }

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc README ChangeLog AUTHORS || die

	if use fortran; then
		# argument for this: --with-moduledir from etsf_io/bigdft
		insinto /usr/$(get_libdir)/finclude
		pushd src >/dev/null
		doins *.mod || die
		rm -f "${D}"/usr/include/*.mod || die
		popd >/dev/null
	fi
}

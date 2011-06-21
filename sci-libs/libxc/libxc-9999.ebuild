# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils fortran-2 multilib toolchain-funcs flag-o-matic autotools subversion

DESCRIPTION="A library of exchange-correlation functionals"
HOMEPAGE="http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
ESVN_REPO_URI="http://www.tddft.org/svn/octopus/trunk/${PN}/"
ESVN_BOOTSTRAP="eautoreconf -i"

LICENSE="LGPL-3"
SLOT="0"
IUSE="fortran debug"
KEYWORDS="~amd64 ~x86"

src_configure() {
	econf \
		$(use_enable fortran) \
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README NEWS ChangeLog AUTHORS || die "dodoc failed"

	if use fortran; then
		insinto /usr/$(get_libdir)/finclude
		cd src
		doins *.mod
	fi
}

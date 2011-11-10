# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel-perl/openbabel-perl-2.3.0.ebuild,v 1.3 2011/03/29 06:00:42 jlec Exp $

EAPI="3"

inherit cmake-utils eutils perl-module

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-lang/perl
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2
	dev-util/cmake"

S="${WORKDIR}/openbabel-${PV}"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-makefile.patch"
}

src_configure() {
	local mycmakeargs="-DPERL_BINDINGS=ON"
	mycmakeargs="${mycmakeargs}
		-DRUN_SWIG=ON"
	cmake-utils_src_configure
}

src_compile() {
	cd "${WORKDIR}/${P}_build/scripts"
	perl-module_src_prep
	perl-module_src_compile
}

src_test() {
	cd "${WORKDIR}/${P}_build/scripts"
	emake test || die "make test failed"
}

src_install() {
	cd "${WORKDIR}/${P}_build/scripts/perl"
	perl-module_src_install
}

pkg_preinst() {
	perl-module_pkg_preinst
}

pkg_postinst() {
	perl-module_pkg_postinst
}

pkg_prerm() {
	perl-module_pkg_prerm
}

pkg_postrm() {
	perl-module_pkg_postrm
}

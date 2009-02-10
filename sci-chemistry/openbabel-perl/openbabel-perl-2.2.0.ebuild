# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils perl-module

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="swig"

RDEPEND="~sci-chemistry/openbabel-2.2.0
	dev-lang/perl"

DEPEND="${RDEPEND}
	swig? ( >=dev-lang/swig-1.3.29 )"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/openbabel-${PV}"
	cd "${S}"

	local myconf=""
	if use swig ; then
		if ! built_with_use dev-lang/swig perl ; then
			echo
			eerror "To be able to build openbabel-perl with swig use"
			eerror "dev-lang/swig has to be merged with perl enabled."
			eerror "Please, re-emerge dev-lang/swig with USE=\"perl\"."
			die "dev-lang/swig has been built without perl support"
		else
			myconf="--enable-maintainer-mode"
		fi
	fi
	econf \
		${myconf} \
		--enable-static \
		|| die "econf failed"
	S="${S}/scripts"
	cd "${S}"
	if use swig ; then
		emake perl/openbabel_perl.cpp || die "Failed to make SWIG perl bindings"
	fi
	S="${S}/perl"
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch" \
		|| die "Failed to apply ${P}-makefile.patch"
}

src_compile() {
	perl-module_src_prep
	perl-module_src_compile
}

src_test() {
	emake test || die "make test failed"
}

src_install() {
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


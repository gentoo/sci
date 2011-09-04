# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils fortran-2 multilib

DESCRIPTION="Calculates maximally localized Wannier functions (MLWFs)"
HOMEPAGE="http://www.wannier.org/"
SRC_URI="http://wannier.org/code/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples perl test"

RDEPEND="
	virtual/blas
	virtual/lapack
	perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
		doc? ( virtual/latex-base
			|| (
				dev-texlive/texlive-latexextra
				app-text/tetex
				app-tex/ptex
			)
		)"

src_prepare() {
	# Patch taken from sci-physics/abinit-5.7.3 bundled version
	epatch \
		"${FILESDIR}"/${PN}-1.1-0001.patch \
		"${FILESDIR}"/${PN}-1.1-0002.patch
}

src_configure() {
	cat <<- EOF >> "${S}"/make.sys
		F90 = $(tc-getFC)
		FCOPTS = ${FCFLAGS:- ${FFLAGS:- -O2}}
		LDOPTS = ${LDFLAGS}
		LIBS = $(pkg-config --libs blas lapack)
	EOF
}

src_compile() {
	emake -j1 wannier || die "make wannier failed"
	emake -j1 lib || die "make lib failed"
	if use doc; then
		emake -j1 doc || die "make doc failed"
	fi
}

src_test() {
	einfo "Compare the 'Standard' and 'Current' outputs of this test."
	pushd tests
	emake test || die
	cat wantest.log
}

src_install() {
	dobin wannier90.x || die "Wannier executable cannot be installed"
	if use perl; then
		( cd utility; dobin kmesh.pl )
	fi
	dolib.a libwannier.a || die "libwannier.a cannot be installed"
	insinto /usr/$(get_libdir)/finclude
	doins src/*.mod || die
	if use examples; then
		mkdir -p "${D}"/usr/share/${PN}
		cp -r examples "${D}"/usr/share/${PN}/;
	fi
	if use doc; then
		(cd doc; dodoc *.pdf )
	fi
	dodoc README README.install CHANGE.log
}

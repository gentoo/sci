# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools elisp-common eutils java-pkg-opt-2

MYP=ThePEG-${PV}

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="http://home.thep.lu.se/ThePEG/"
SRC_URI="http://www.hepforge.org/archive/thepeg/${MYP}.tar.bz2
	test? ( hepmc? (
	http://www.hepforge.org/archive/lhapdf/pdfsets/current/cteq6ll.LHpdf
	http://www.hepforge.org/archive/lhapdf/pdfsets/current/cteq5l.LHgrid
	http://www.hepforge.org/archive/lhapdf/pdfsets/current/GRV98nlo.LHgrid
	http://www.hepforge.org/archive/lhapdf/pdfsets/current/MRST2001nlo.LHgrid ) )"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs hepmc java lhapdf test zlib"

RDEPEND="sci-libs/gsl
	dev-lang/perl
	emacs? ( virtual/emacs )
	hepmc? ( sci-physics/hepmc )
	java? ( >=virtual/jre-1.5 )
	lhapdf? ( sci-physics/lhapdf )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	test? ( sys-process/time )"

S="${WORKDIR}/${MYP}"

pkg_setup() {
	elog "There is an extra option on package Rivet not yet in Gentoo:"
	elog "You can use the env variable EXTRA_ECONF variable for this:"
	elog "EXTRA_ECONF=\"--with-rivet=DIR\""
	elog "where DIR - location of Rivet installation"
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	find -name 'Makefile.am' -exec sed -i '1ipkgdatadir=$(datadir)/thepeg' {} \; \
		|| die "changing pkgdatadir name failed"
	sed -i '/dist_pkgdata_DATA = ThePEG.el/d' lib/Makefile.am \
		|| die "preventing install ThePEG.el in pkgdatadir failed"
	epatch "${FILESDIR}"/${P}-java.patch
	eautoreconf

	java-pkg-opt-2_src_prepare
}

src_configure() {
	econf \
		--disable-silent-rules \
		$(use_with hepmc hepmc "${EPREFIX}"/usr) \
		$(use_with java javagui) \
		$(use_with lhapdf LHAPDF "${EPREFIX}"/usr) \
		$(use_with zlib zlib "${EPREFIX}"/usr)
}

src_compile() {
	emake
	if use emacs; then
		elisp-compile lib/ThePEG.el || die
	fi
}

src_test() {
	emake LHAPATH="${DISTDIR}" check
}

src_install() {
	emake DESTDIR="${D}" install
	if use emacs; then
		elisp-install ${PN} lib/ThePEG.el lib/ThePEG.elc || die
	fi
	use java && java-pkg_newjar java/ThePEG.jar

	cat <<-EOF > "${T}"/50${PN}
	LDPATH="${EPREFIX}/usr/$(get_libdir)/ThePEG"
	EOF
	doenvd "${T}"/50${PN}
}

pkg_postinst() {
	if use emacs; then
		elog "To use installed elisp file you should add"
		elog "(add-to-list 'load-path \"${SITELISP}/${PN}\")"
		elog "(load \"ThePEG\")"
		elog "to your .emacs file"
	fi
}

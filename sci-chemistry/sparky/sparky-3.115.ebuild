# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/sparky/sparky-3.113.ebuild,v 1.4 2009/09/18 14:50:12 betelgeuse Exp $

EAPI="2"

inherit eutils toolchain-funcs multilib python

DESCRIPTION="Graphical NMR assignment and integration program for proteins, nucleic acids, and other polymers"
HOMEPAGE="http://www.cgl.ucsf.edu/home/sparky/"
SRC_URI="http://www.cgl.ucsf.edu/home/sparky/distrib-${PV}/${PN}-source-${PV}.tar.gz"
LICENSE="sparky"
SLOT="0"
# Note: this package will probably require significant work for lib{32,64},
# including parts of the patch.
KEYWORDS="~ppc ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="dev-lang/python:2.4[tk]
	=dev-lang/tk-8.4*
	app-shells/tcsh"
DEPEND="${RDEPEND}
	>=app-shells/bash-3
	net-misc/rsync"
S="${WORKDIR}/${PN}"

pkg_setup() {
	# Install for specific pythons instead of whatever's newest.
	python="/usr/bin/python2.4"
	python_version

	arguments=( SPARKY="${S}" \
		SPARKY_INSTALL_MAC="" \
		SPARKY_INSTALL="${D}/usr" \
		PYTHON_PREFIX="${ROOT}usr" \
		PYTHON_VERSION="${PYVER}" \
		TK_PREFIX="${ROOT}usr" \
		TCLTK_VERSION="8.4" \
		CXX="$(tc-getCXX)" \
		CC="$(tc-getCC)" \
		INSTALL="rsync -avz" \
		INSTALLDIR="rsync -avz" )

	# It would be nice to get the docs versioned, but not critical
	#	DOCDIR="\$(SPARKY_INSTALL)/share/doc/${PN}" \
	# To get libdir working properly, we need to get makefiles respecting this
	#	PYDIR="\$(SPARKY_INSTALL)/$(get_libdir)/python\$(PYTHON_VERSION)/site-packages" \
}

src_prepare() {
	epatch "${FILESDIR}"/fix-install.patch

	sed -i \
		-e "s:^\(set PYTHON[[:space:]]*=\).*:\1 /usr/bin/python${PYVER}:g" \
		-e "s:^\(setenv TCLTK_LIB[[:space:]]*\).*:\1 /usr/$(get_libdir):g" \
		"${S}"/bin/sparky
}

src_compile() {
	emake "${arguments[@]}" || die "make failed"
}

src_install() {
	emake "${arguments[@]}" install || die "install failed"
	# Make internal help work
	dosym ../../share/doc/sparky/manual /usr/lib/sparky/manual
	# It returns a weird threading error message without this
	dosym ../python${PYVER}/site-packages /usr/lib/sparky/python
}

pkg_postinst() {
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/sparky
}

pkg_postrm() {
	python_mod_cleanup /usr/lib/python${PYVER}/site-packages/sparky
}

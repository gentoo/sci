# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Crystallographic Object-Oriented Toolkit for model building, completion and validation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~emsley/coot/"
SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND=">=sci-libs/gsl-1.3
	=dev-libs/glib-1.2*
	=x11-libs/gtkglarea-1.2*
	virtual/glut
	virtual/opengl
	sci-chemistry/ccp4
	dev-lang/python
	x11-libs/gtk-canvas
	dev-lang/python
	x11-libs/guile-gtk
	dev-libs/guile-gui
	dev-libs/goosh
	dev-libs/guile-www
	sci-libs/coot-data"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/add-needed-includes-libs.patch
	epatch ${FILESDIR}/glutinit.patch
	epatch ${FILESDIR}/setupdir.patch
	epatch ${FILESDIR}/use-fftw-single.patch
	cd ${S}
	eautoconf
	eautomake
}

src_compile() {
	# All the --with's are used to activate various parts.
	# Yes, this is broken behavior.
	econf \
		--includedir='${prefix}/include/coot' \
		--with-gtkcanvas-prefix=/usr \
		--with-clipper-prefix=/usr \
		--with-mmdb-prefix=/usr \
		--with-ssmlib-prefix=/usr \
		--with-guile=/usr \
		--with-python=/usr \
		|| die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
}

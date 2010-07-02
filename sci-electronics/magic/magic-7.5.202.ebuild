# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib eutils autotools

DESCRIPTION="The VLSI design CAD tool."
HOMEPAGE="http://www.opencircuitdesign.com/magic/index.html"
SRC_URI="http://www.opencircuitdesign.com/magic/archive/${P}.tgz \
	ftp://ftp.mosis.edu/pub/sondeen/magic/new/beta/2002a.tar.gz"

LICENSE="as-is GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses
	sys-libs/readline
	dev-lang/tcl
	dev-lang/tk
	dev-tcltk/blt"
DEPEND="${RDEPEND}
	app-shells/tcsh"

src_prepare() {
	epatch "${FILESDIR}/${PN}-ldflags.patch"
	cd scripts
	eautoreconf
	cd ..
	sed -i -e "s: -pg : :" tcltk/Makefile || die "tcltk patch failed"
}

src_configure() {
	# Short-circuit top-level configure script to retain CFLAGS
	cd scripts
	CPP="cpp" econf
}

src_compile() {
	emake -j1 || die "Compilation failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die

	dodoc README README.Tcl TODO || die

	# Move docs from libdir to docdir and add symlink.
	mv "${D}/usr/$(get_libdir)/magic/doc"/* "${D}/usr/share/doc/${PF}/" || die
	rmdir "${D}/usr/$(get_libdir)/magic/doc" || die
	dosym "/usr/share/doc/${PF}" "/usr/$(get_libdir)/magic/doc" || die

	# Move tutorial from libdir to datadir and add symlink.
	dodir /usr/share/${PN} || die
	mv "${D}/usr/$(get_libdir)/magic/tutorial" "${D}/usr/share/${PN}/" || die
	dosym "/usr/share/${PN}/tutorial" "/usr/$(get_libdir)/magic/tutorial" || die

	# Install latest MOSIS tech files
	cp -pPR "${WORKDIR}"/2002a "${D}"/usr/$(get_libdir)/magic/sys/current || die
}

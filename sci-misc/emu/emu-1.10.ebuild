# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="EMU Speech Database System"
HOMEPAGE="http://emu.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="as-is" # or EMU?
SLOT="0"
KEYWORDS="~x86"
IUSE="R esps estools nist-sphere nas X"

DEPEND=">=dev-lang/tcl-8.4
	X? ( virtual/x11 )"
RDEPEND=">=dev-lang/tcl-8.3
	>=dev-lang/tk-8.3
	dev-tcltk/bwidget
	dev-tcltk/tcllib
	R? ( dev-lang/R )
	X? ( virtual/x11 )"
#	!R? ( splus )
#	esps? ( esps )
#	estools? ( estools )
#	nist-sphere? ( nist-sphere )

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A}
	# This tcl install script is partially braindamaged
	cd ${S}
	sed -i "s:\$(WISH) ./doinstall.tcl$:\0 --prefix=${D}/usr/ \
	--tcl_prefix=${D}/usr/ --bin=${D}/usr/bin/ --auto:g" Makefile.in
}

src_compile() {
	myconf="--with-tcl=/usr/lib/ --with-tk=/usr/lib/"
	# --without selectors do not work here:
	#	$(use_with esps) $(use_with estools) $(use_with nist-sphere nist) \
	#	$(use_with nas)"
	use esps && myconf="$myconf --with-esps"
	use estools && myconf="$myconf --with-estools"
	use nist-sphere &&	myconf="$myconf --with-nist"
	use nas && myconf="$myconf --with-nas"

	econf $myconf || die "econf failed"
	emake || die "emake failed"
}

src_install() {

	make DESTDIR="${D}" install || die "install failed"
	for f in ${D}/usr/bin/* ; do
		sed -i "s|${D}||g" $f
	done
	dodoc README TODO
	rm ${D}/usr/COPYING
}


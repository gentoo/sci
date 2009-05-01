# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A new GUI for the Mosflm crystallographic data processing tool"
HOMEPAGE="http://www.mrc-lmb.cam.ac.uk/harry/imosflm"
SRC_URI="${HOMEPAGE}/downloads/${P}.tar.gz"
LICENSE="ccp4"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND=">=dev-tcltk/itcl-3.3
	>=dev-tcltk/itk-3.3
	>=dev-tcltk/iwidgets-4
	>=dev-tcltk/tkimg-1.3
	>=dev-tcltk/tdom-0.8
	dev-tcltk/tablelist
	dev-tcltk/anigif
	dev-tcltk/combobox
	>=dev-tcltk/tktreectrl-2.1
	>=sci-chemistry/mosflm-7.0.4
	dev-lang/tcl"
DEPEND=""

src_compile(){ :; }

src_install(){
	insinto /usr/$(get_libdir)/${PN}
	doins -r "${S}"/{src,bitmaps}
	fperms 775 /usr/$(get_libdir)/${PN}/src/imosflm

	make_wrapper imosflm /usr/$(get_libdir)/${PN}/src/imosflm
}

pkg_postinst() {
	einfo "If you have problems running the package with tcl/tk-8.5"
	einfo "please upgrade dev-tcltk/itcl and dev-tcltk/itk to latest"
}

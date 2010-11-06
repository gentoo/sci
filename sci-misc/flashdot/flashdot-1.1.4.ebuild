# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit subversion

DESCRIPTION="Generator for psychophysical experiments"
HOMEPAGE="http://www.flashdot.info/"
ESVN_REPO_URI="https://flashdot.svn.sourceforge.net/svnroot/flashdot/trunk/src@114"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="+ocamlopt"

DEPEND=">=dev-lang/ocaml-3.10[ocamlopt?]
	dev-ml/ocamlsdl
	dev-ml/ocamlgsl
	x11-apps/xdpyinfo"
RDEPEND="${DEPEND}"

MAKEOPTS="-j1 VERSION=${PV}"
use ocamlopt || MAKEOPTS="${MAKEOPTS} TARGETS=flashdot_bytecode BYTECODENAME=flashdot"

src_compile() {
	econf
	emake ${MAKEOPTS} || die "emake failed"
}

src_install() {
	emake ${MAKEOPTS} DESTDIR="${D}" CALLMODE=script install || die "install failed"
}

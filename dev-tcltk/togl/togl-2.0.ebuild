# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# inherit

MY_P="Togl${PV}"

DESCRIPTION="A Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz"

LICENSE="Togl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

RDEPEND="dev-lang/tk"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_compile() {

	econf \
		$(use_enable amd64 64bit) \
		$(use_enable threads)

	emake || die "compilation error"
}

src_install() {
	emake DESTDIR="${D}" install || die "failed to install"
	dohtml doc/* || die "no html"
	dodoc README* || die "no README"
}

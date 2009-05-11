# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib autotools

MY_PN="dxsamples"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Samples for IBM Data Explorer"
HOMEPAGE="http://www.opendx.org/"
SRC_URI="http://opendx.sdsc.edu/source/${MY_P}.tar.gz"
LICENSE="IPL-1"
SLOT="0"

S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=sci-visualization/opendx-4.4.4-r2"
DEPEND="${RDEPEND}"

src_prepare() {

	epatch "${FILESDIR}/${P}-nojava.patch"
#	absolutely no javadx for now
	epatch "${FILESDIR}/${P}-install.patch"

	eautoreconf
}

src_configure() {
	econf "--libdir=/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	elog "This version of the opendx-samples ebuild is still under development."
	elog "suggestions, comments and offer of help welcome"
	elog "post a message in gentoo-science or pop up on irc on #gentoo-science"
}

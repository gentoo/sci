# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base toolchain-funcs

DESCRIPTION="With this form you can predict 1H, 13C and 15N chemical shifts for your favorite protein"
HOMEPAGE="http://redpoll.pharmacy.ualberta.ca/shiftx/"
SRC_URI="http://redpoll.pharmacy.ualberta.ca/download/${PN}/${PN}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.patch
)

DOCS="README FEATURES *.pdb *.out"

src_compile() {
	emake \
		CC="$(tc-getCC)" || \
		die "compilation failed"
}

src_install() {
	dobin ${PN} || die "installationof ${PN} failed"
	dodoc ${DOCS} || die
}

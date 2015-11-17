# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="The crystallographic computing system"
HOMEPAGE="http://jana.fzu.cz/"
SRC_URI="http://www-xray.fzu.cz/jana/download/final2000/${PN}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	virtual/fortran"
DEPEND="${RDEPEND}
	x11-proto/xproto
	sys-apps/gawk"

S="${WORKDIR}/${PN}"

src_prepare() {
	einfo "setting up the Makefile for $(tc-getFC)"

	if [[ $(tc-getFC) =~ gfortran ]]; then
		epatch "${FILESDIR}/${PV}-gfortran.diff"
	elif [[ $(tc-getFC) =~ g77 ]]; then
		epatch "${FILESDIR}/${PV}-g77.diff"
	fi
}

src_compile() {
	emake -j1 CCOM="$(tc-getCC)"
}

src_install() {
	dobin jana2000
	dodoc README.TXT

	insinto /usr/share/${PN}/source
	doins -r source/{fg,data}

	echo "JANADIR=/usr/share/${PN}" >"${T}/jana2000env"
	newenvd "${T}/jana2000env" 99jana2000env
}

pkg_postinst() {
	elog "The Development of Jana2000 is stopped."
	elog "The successor Jana2006 is not yet available for unix/linux platforms"
	elog "check at http://www-xray.fzu.cz/jana/jana.html for news"
	elog "please cite Jana2000 as follows:"
	elog "  Petricek, V., Dusek, M. and Palatinus, L. (2000):"
	elog "  Jana2006. The crystallographic computing system."
	elog "  Institute of Physics, Praha, Czech Republic."
}

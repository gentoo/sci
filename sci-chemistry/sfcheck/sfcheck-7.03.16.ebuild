# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Program for assessing the agreement between the atomic model and X-ray data or EM map"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/sfcheck.html"
#SRC_URI="http://www.ysbl.york.ac.uk/~alexei/downloads/sfcheck.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="ccp4"
IUSE=""

RDEPEND="sci-libs/ccp4-libs"
DEPEND="${RDEPEND}
	!!<sci-chmistry/ccp4-apps-6.1.3"

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch

	emake \
		-C src \
		clean || die
}

src_compile() {
	MR_FORT="$(tc-getFC) ${FFLAGS}" \
	MR_LIBRARY="-lccp4f" \
	emake \
		-C src \
		all
}

src_install() {
	dobin bin/${PN} || die
	dodoc readme ${PN}.com.gz doc/${PN}* || die
}

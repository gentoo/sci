# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="TwinScan, N-SCAN, and Pairagon: A gene structure prediction pipeline"
HOMEPAGE="http://mblab.wustl.edu/software/twinscan"
SRC_URI="http://mblab.wustl.edu/software/download/iscan-${PV}.tar_.gz"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/N-SCAN"

src_unpack() {
	unpack ${A}
	tar -C "${WORKDIR}" -xf iscan-${PV}.tar_
}

src_prepare() {
	sed -i "1 a use lib '/usr/share/${PN}/lib/perl5';" "${S}"/bin/*.pl || die
	sed -i '/my $blast_param/ s/#//' "${S}/bin/runTwinscan2.pl"
}

src_install() {
	dobin "${S}/bin/iscan" "${S}"/bin/*.pl || die
	insinto /usr/share/${PN}
	doins -r "${S}/parameters" || die
	doins -r "${S}/lib" || die
	echo "TWINSCAN=/usr" > "${S}"/99${PN}
	doenvd "${S}"/99${PN} || die
	dodoc examples/* README*
}

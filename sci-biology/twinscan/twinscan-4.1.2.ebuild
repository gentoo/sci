# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="TwinScan, N-SCAN, and Pairagon: A gene structure prediction pipeline"
HOMEPAGE="http://mblab.wustl.edu/software/twinscan"
SRC_URI="http://mblab.wustl.edu/software/download/iscan-${PV}.tar_.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/N-SCAN"

src_prepare() {
	sed -i "1 a use lib '/usr/share/${PN}/lib/perl5';" "${S}"/bin/*.pl || die
	sed -i '/my $blast_param/ s/#//' "${S}/bin/runTwinscan2.pl" || die
	tc-export CC AR RANLIB

	sed \
		-e 's:ar :$(AR) :g' \
		-e 's:ranlib :$(RANLIB) :g' \
		-e 's: -o : $(LDFLAGS) -o :g' \
		-i Makefile || die

	sed \
		-e "/^GLIB_CFLAGS/s:=.*:=$($(tc-getPKG_CONFIG) --cflags glib-2.0) -DHAS_GLIB:g" \
		-e "/^GLIB_LFLAGS/s:=.*:=$($(tc-getPKG_CONFIG) --libs glib-2.0)-DHAS_GLIB:g" \
		-i Makefile.include || die
}

src_install() {
	dobin "${S}/bin/iscan" "${S}"/bin/*.pl || die
	insinto /usr/share/${PN}
	doins -r "${S}/parameters" || die
	doins -r "${S}/lib" || die
	echo "TWINSCAN=/usr" > "${S}"/99${PN}
	doenvd "${S}"/99${PN} || die
	rm -rf examples/tmp
	dodoc examples/* README*
}

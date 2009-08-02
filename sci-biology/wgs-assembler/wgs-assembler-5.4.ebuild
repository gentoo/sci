# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/wgs-assembler/wgs-assembler-5.3.ebuild,v 1.1 2009/06/05 15:16:05 weaver Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Whole-genome shotgun assembler based on the Celera Assembler"
HOMEPAGE="http://sourceforge.net/projects/wgs-assembler/"
SRC_URI="mirror://sourceforge/${PN}/wgs-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

DEPEND="x11-libs/libXt"
RDEPEND="${DEPEND}
	app-shells/tcsh
	dev-perl/Log-Log4perl"

S="${WORKDIR}/wgs-${PV}"

src_configure() {
	cd "${S}/kmer"
	./configure.sh || die
}

src_compile() {
	# not really an install target
	# WARNING: untracked failure compiling the second target
	emake -C kmer -j1 install || die
	emake -C src -j1 SITE_NAME=LOCAL || die
}

src_install() {
	OSTYPE=$(uname)
	MACHTYPE=$(uname -m)
	MACHTYPE=${MACHTYPE/x86_64/amd64}
	MY_S="${OSTYPE}-${MACHTYPE}"
	sed -i 's|#!/usr/local/bin/|#!/usr/bin/env |' $(find $MY_S -type f) || die

	sed -i '/sub getBinDirectory/ a return "/usr/bin";' ${MY_S}/bin/runCA* || die
	sed -i '1 a use lib "/usr/share/'${PN}'/lib";' $(find $MY_S -name '*.p*') || die

	dobin kmer/${MY_S}/bin/* || die
	dolib.a kmer/${MY_S}/lib/* || die

	insinto /usr/share/${PN}
	doins -r ${MY_S}/bin/spec
	insinto /usr/share/${PN}/lib
	doins -r ${MY_S}/bin/TIGR || die
	rm -rf ${MY_S}/bin/{TIGR,spec}
	dobin ${MY_S}/bin/* || die
	dolib.a ${MY_S}/lib/* || die
	dodoc README
}

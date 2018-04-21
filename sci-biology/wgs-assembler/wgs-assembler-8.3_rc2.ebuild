# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 toolchain-funcs

MY_PV="${PV/_}" # convert from _rc2 to rc2

DESCRIPTION="De novo whole-genome shotgun DNA sequence OLC assembler"
HOMEPAGE="http://sourceforge.net/projects/wgs-assembler/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${PN}/wgs-8.3/wgs-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	x11-libs/libXt
	!x11-terms/terminator"
RDEPEND="${DEPEND}
	app-shells/tcsh
	dev-perl/Log-Log4perl
	sci-biology/jellyfish:2"

S="${WORKDIR}/wgs-${MY_PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-rename-jellyfish.patch
	tc-export CC CXX
}

src_configure() {
	cd "${S}/kmer" || die
	./configure.sh || die
}

src_compile() {
	# not really an install target
	emake -C kmer -j1 install
	emake -C src -j1 SITE_NAME=LOCAL
}

src_install() {
	OSTYPE=$(uname)
	MACHTYPE=$(uname -m)
	MACHTYPE=${MACHTYPE/x86_64/amd64}
	MY_S="${OSTYPE}-${MACHTYPE}"
	sed -i 's|#!/usr/local/bin/|#!/usr/bin/env |' $(find $MY_S -type f) || die

	sed -i '/sub getBinDirectory ()/ a return "/usr/bin";' ${MY_S}/bin/runCA* || die
	sed -i '/sub getBinDirectoryShellCode ()/ a return "bin=/usr/bin\n";' ${MY_S}/bin/runCA* || die
	sed -i '1 a use lib "/usr/share/'${PN}'/lib";' $(find $MY_S -name '*.p*') || die

	dobin kmer/"${MY_S}"/bin/*
	insinto /usr/$(get_libdir)/"${PN}"
	use static-libs && doins kmer/"${MY_S}"/lib/*

	insinto /usr/include/"${PN}"
	doins kmer/"${MY_S}"/include/*

	insinto /usr/share/${PN}/lib
	doins -r "${MY_S}"/bin/TIGR
	rm -rf "${MY_S}"/bin/TIGR || die
	dobin "${MY_S}"/bin/*
	use static-libs && dolib.a ${MY_S}/lib/*
	dodoc README

	# drop bundled jellyfish-2.0.0
	rm "${ED}"/usr/bin/jellyfish || die
}

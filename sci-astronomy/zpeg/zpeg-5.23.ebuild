# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit fortran-2

MYP=${PN}_${PV}

DESCRIPTION="Galaxy photometric redshifts from evolutionary synthesis"
HOMEPAGE="http://imacdlb.iap.fr:8080/cgi-bin/zpeg/zpeg.pl"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/leborgne/${PN}/${MYP}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="gdl"

RDEPEND="gdl? ( dev-lang/gdl )"
DEPEND=""

S="${WORKDIR}/${MYP}"

FORTRAN_STANDARD="90"

src_prepare() {
	# save configure for tests
	cp configure{,.orig} || die
	# install data in FHS
	sed -i \
		-e "s:ZPEG_ROOT=.*:ZPEG_ROOT=${EPREFIX}/usr/share/${PN}:" \
		configure || die
}

src_compile() {
	# not worth debugging parallel build failures which is due to
	# fortran modules missing dependencies)
	emake -j1 -C src
}

src_test() {
	# test only works with hardcoded path, so reconfigure and recompile
	mv bin/zpeg{,.orig} || die
	mv configure{.orig,} || die
	emake -C src clean && econf && emake -j1 -C src
	cd test
	../bin/zpeg -V ZPEG1_cata.cat -o hdf.zpeg -p hdf.par -t hdf.par.tmp || die
	mv bin/zpeg{.orig,} || die
}

src_install() {
	dobin bin/zpeg
	insinto /usr/share/${PN}
	doins -r data VERSION
	dodoc HISTORY
	echo > 99zpeg "ZPEG_ROOT=${EROOT}/usr/share/${PN}"
	doenvd 99zpeg
	if use gdl; then
		insinto /usr/share/gnudatalanguage/${PN}
		doins idl/*.pro
	fi
}

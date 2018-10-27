# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# inherit eutils

DESCRIPTION="software package for algebraic number theory"
HOMEPAGE="http://page.math.tu-berlin.de/~kant/kash.html"
SRC_URI="
	ftp://ftp.math.tu-berlin.de/pub/algebra/Kant/Kash_3/KASH3-Linux-i686-2008-07-31.tar.bz2
	ftp://ftp.math.tu-berlin.de/pub/algebra/Kant/Kash_3/KASH3-lib-archindep-2008-07-31.tar.bz2"

LICENSE="kash"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

MY_P="kash3"
S="${WORKDIR}/${MY_P}"

# This is a binary package:
QA_PREBUILT="opt/${MY_P}/kash3"

src_unpack() {
	default
	mkdir "${S}" && cd "${S}" || die
	mv KASH3-Linux*/* "${S}" || die
	mv KASH3-lib*/lib/* "${S}/lib/" || die
}

# Binary package
# src_configure() { : }
#
# src_compile() { : }
#
src_install() {
	cat > kash3.sh <<- EOF
	#!"${EPREFIX}/bin/sh"
	/opt/${MY_P}/kash3 -l "${EROOT}opt/${MY_P}/lib"
	EOF
	chmod 755 kash3.sh
	dodir /opt/${MY_P}
	cp -R "${S}/" "${ED}"opt/ || die
	dosym ../${MY_P}/kash3.sh /opt/bin/kash3
}

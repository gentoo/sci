# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# inherit eutils

DESCRIPTION="software package for algebraic number theory"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://page.math.tu-berlin.de/~kant/kash.html"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="ftp://ftp.math.tu-berlin.de/pub/algebra/Kant/Kash_3/KASH3-Linux-i686-2008-07-31.tar.bz2
ftp://ftp.math.tu-berlin.de/pub/algebra/Kant/Kash_3/KASH3-lib-archindep-2008-07-31.tar.bz2"

LICENSE="kash"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux"
IUSE=""

DEPEND=""
RDEPEND=""

MY_P="kash3"
S="${WORKDIR}/${MY_P}"

# This is a binary package:
QA_PREBUILT="opt/${MY_P}/kash3"

src_unpack() {
	unpack ${A}
	mkdir "${S}"
	mv KASH3-Linux*/* "${S}" || die
	mv KASH3-lib*/lib/* "${S}/lib/" || die
}

# Binary package
# src_configure() { : }
#
# src_compile() { : }
#
src_install() {
	cat > kash3.sh <<EOF
#/bin/sh
/opt/${MY_P}/kash3 -l ${EROOT}opt/${MY_P}/lib
EOF
	chmod 755 kash3.sh
	dodir /opt/${MY_P}
	cp -R "${S}/" "${D}"opt/ || die
	dosym ../${MY_P}/kash3.sh /opt/bin/kash3
}

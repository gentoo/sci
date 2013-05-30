# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# inherit eutils
DESCRIPTION="Software for Numerical Algebraic Geometry"
HOMEPAGE="http://www.nd.edu/~sommese/bertini/"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="x86? ( http://www.nd.edu/~sommese/bertini/BertiniLinux32_v1.3.1.tar.gz )
		 amd64? ( http://www.nd.edu/~sommese/bertini/BertiniLinux64_v1.3.1.tar.gz )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
# Mirroring the tarballs is not allowed for now.
RESTRICT="mirror"
DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mkdir "${S}"
	mv Bertini*/* "${S}" || die
}

src_install() {
	dodir /opt/${P}
	cp -R "${S}/" "${D}"opt/ || die
	dosym ../${P}/bertini /opt/bin/bertini
}

# As part of the licence we display information about Bertini
# This procedure was agreed upon with Jon Hauenstein
pkg_postinst(){
	elog "You just installed"
	elog "Bertini: Software for Numerical Algebraic Geometry"
	elog "Authors: Daniel J. Bates, Jonathan D. Hauenstein, Andrew J. Sommese, and"
	elog "Charles W. Wampler"
	elog ""
	elog "For additional information about Bertini, please visit"
	elog "http://www.nd.edu/~sommese/bertini."
	elog ""
	elog "Bertini is distributed free of charge on an ``as is'' basis with no"
	elog "warranties, implied or otherwise, that it is suitable for any purpose. Its"
	elog "intended usage is for educational and for research purposes, so that the"
	elog "user may gain a greater understanding of numerical homotopy continuation"
	elog "for solving systems of polynomial equations. Any other use is strictly the"
	elog "user's responsibility."
}

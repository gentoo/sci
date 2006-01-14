# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Provides an interface to FITS formatted files under python"
SRC_URI="ftp://ra.stsci.edu/pub/${PN}/${PN}_v${PV}.tar.gz"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/pyfits"

DEPEND=">=dev-lang/python-2.3
	dev-python/numarray"
IUSE="doc"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# license to get from http://projects.scipy.org/astropy/pyfits/file/trunk/lib/LICENSE.txt
LICENSE="AURA"

S=${WORKDIR}/${PN}

src_install() {
	distutils_src_install
	
	if use doc; then
		dodir /usr/share/doc/${PF}
		insinto /usr/share/doc/${PF}
		doins docs/Users_Manual.pdf
	fi
}

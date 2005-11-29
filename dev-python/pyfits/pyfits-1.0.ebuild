# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Provides an interface to FITS formatted files under python"
SRC_URI="ftp://ra.stsci.edu/pub/pyfits/${PN}_v${PV}.tar.gz"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/pyfits"

DEPEND=">=dev-lang/python-2.3
	dev-python/numarray"
IUSE="doc"
SLOT="0"
KEYWORDS="~x86 ~amd64"

# the license has to be checked.
# Nothing on the web site, so copy it from numarray, 
# which are from the same guys
LICENSE="BSD"

S=${WORKDIR}/${PN}

src_install() {

	distutils_src_install

	if use doc; then	
	        dodir /usr/share/doc/${PF}
        	insinto /usr/share/doc/${PF}
		doins docs/Users_Manual.pdf
	fi
}

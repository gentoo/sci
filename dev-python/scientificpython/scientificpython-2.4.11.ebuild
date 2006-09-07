# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/scientificpython/ScientificPython}
S=${WORKDIR}/${MY_P}
DV=686 # hardcoded download version
inherit distutils

IUSE=""
DESCRIPTION="Scientific Module for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${DV}/${MY_P}.tar.gz"
HOMEPAGE="http://dirac.cnrs-orleans.fr/ScientificPython/"
SLOT="0"
LICENSE="CeCILL"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc x86"

DEPEND="virtual/python
	>=dev-python/numeric-19.0
	>=sci-libs/netcdf-3.0"

src_install() {
	distutils_src_install

	dodoc MANIFEST.in COPYRIGHT README*
	cd Doc
	dodoc CHANGELOG
	dohtml HTML/*
	insinto /usr/share/doc/${PF}/pdf
	doins PDF/*
	cd ../Examples
	insinto /usr/share/doc/${PF}/
	doins -r Examples
}

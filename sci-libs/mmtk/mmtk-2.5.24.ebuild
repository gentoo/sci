# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/mmtk/MMTK}
S=${WORKDIR}/${MY_P}

inherit distutils

# This number identifies each release on the CRU website.
# Can't figure out how to avoid hardcoding it.
NUMBER="2259"
IUSE=""
DESCRIPTION="Molecular Modeling ToolKit for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${NUMBER}/${MY_P}.tar.gz"
HOMEPAGE="http://dirac.cnrs-orleans.fr/MMTK/"
SLOT="0"
LICENSE="CeCILL-C"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/scientificpython"
DEPEND="${RDEPEND}"

src_install() {
	distutils_src_install

	dodoc MANIFEST.in COPYRIGHT README*
	cd Doc
	dodoc CHANGELOG
	dohtml HTML/*

	dodir /usr/share/doc/${PF}/pdf
	insinto /usr/share/doc/${PF}/pdf
	doins PDF/*
}

# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mmtk/mmtk-2.4.6.ebuild,v 1.2 2006/10/17 03:49:02 dberkholz Exp $

MY_P=${P/mmtk/MMTK}
S=${WORKDIR}/${MY_P}

inherit distutils

# This number identifies each release on the CRU website.
# Can't figure out how to avoid hardcoding it.
NUMBER="2077"
IUSE=""
DESCRIPTION="Molecular Modeling ToolKit for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${NUMBER}/${MY_P}.tar.gz"
HOMEPAGE="http://dirac.cnrs-orleans.fr/MMTK/"
SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~x86"

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

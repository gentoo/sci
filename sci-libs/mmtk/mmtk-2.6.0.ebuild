# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MY_PN=${PN/mmtk/MMTK}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
PYTHON_MODNAME=${MY_PN}

inherit distutils

# This number identifies each release on the CRU website.
# Can't figure out how to avoid hardcoding it.
NUMBER="2469"
IUSE=""
DESCRIPTION="Molecular Modeling ToolKit for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${NUMBER}/${MY_P}.tar.gz"
HOMEPAGE="http://dirac.cnrs-orleans.fr/MMTK/"
SLOT="0"
LICENSE="CeCILL-C"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/scientificpython-2.6"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "/ext_package/d" \
		"${S}"/setup.py \
		|| die
}

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

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="Graphical tool to construct chemical compound definitions for NMR"
HOMEPAGE="http://www.ccpn.ac.uk/software/chembuild"
SRC_URI="http://www2.ccpn.ac.uk/download/ccpnmr/${PN}${PV}_WithApi.tar.gz"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-python/pyside[webkit,${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}"/ccpnmr/ccpnmr3.0/

#TODO:
#install in sane place
#unbundle data model
#unbundle inchi
#parallel build

src_install() {
	local in_path=$(python_get_sitedir)/${PN}
	local _file

	find . -name "*.pyc" -type f -delete
	dodir /usr/bin
	sed \
	-e "s|gentoo_sitedir|${EPREFIX}$(python_get_sitedir)|g" \
	-e "s|gentoolibdir|${EPREFIX}/usr/${libdir}|g" \
	-e "s|gentootk|${EPREFIX}/usr/${libdir}/tk${tkver}|g" \
	-e "s|gentootcl|${EPREFIX}/usr/${libdir}/tclk${tkver}|g" \
	-e "s|gentoopython|${PYTHON}|g" \
	-e "s|gentoousr|${EPREFIX}/usr|g" \
	-e "s|//|/|g" \
		"${FILESDIR}"/${PN} > "${ED}"/usr/bin/${PN} || die
	fperms 755 /usr/bin/${PN}

	rm -rf cNg license || die

	ebegin "Installing main files"
	python_moduleinto ${PN}
	python_domodule *
	python_optimize
	eend
}

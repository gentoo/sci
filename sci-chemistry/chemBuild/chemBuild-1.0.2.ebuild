# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit python toolchain-funcs

DESCRIPTION="Graphical tool to construct chemical compound definitions for NMR"
HOMEPAGE="http://www.ccpn.ac.uk/software/chembuild"
SRC_URI="http://www2.ccpn.ac.uk/download/ccpnmr/${PN}${PV}_WithApi.tar.gz"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/pyside"
DEPEND=""

S="${WORKDIR}"/ccpnmr/ccpnmr3.0/

#TODO:
#install in sane place
#unbundle data model
#unbundle inchi
#parallel build

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

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
	-e "s|gentoopython|$(PYTHON -a)|g" \
	-e "s|gentoousr|${EPREFIX}/usr|g" \
	-e "s|//|/|g" \
		"${FILESDIR}"/${PN} > "${ED}"/usr/bin/${PN} || die
	fperms 755 /usr/bin/${PN}

	insinto ${in_path}

	rm -rf cNg license || die

	ebegin "Installing main files"
		doins -r *
	eend
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}

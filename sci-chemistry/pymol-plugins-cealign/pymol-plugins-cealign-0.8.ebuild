# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils
PYTHON_MODNAME="cealign"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 ~amd64"
DESCRIPTION="The CE algorithm is a fast and accurate protein structure alignment algorithm."
SRC_URI="http://www.pymolwiki.org/images/5/58/Cealign-${PV}-RBS.tar.bz2"
HOMEPAGE="http://www.pymolwiki.org/index.php/Cealign"
IUSE=""
RESTRICT="mirror"
DEPEND="dev-python/numpy
		>sci-chemistry/pymol-0.99"
RDEPEND="${DEPEND}"

S=${WORKDIR}/cealign-${PV}-RBS

src_install(){
	mtype=$(uname -m)

	distutils_src_install

	insinto $(python_get_sitedir)/cealign
	doins qkabsch.py cealign.py

	cat >> "${T}"/pymolrc <<- EOF
	run $(python_get_sitedir)/cealign/qkabsch.py
	run $(python_get_sitedir)/cealign/cealign.py
	EOF

	insinto ${PYMOL_PATH}
	doins "${T}"/pymolrc

	dodoc CHANGES doc/cealign.pdf
}

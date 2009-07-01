# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_MODNAME="cealign"

inherit distutils

DESCRIPTION="The CE algorithm is a fast and accurate protein structure alignment algorithm."
HOMEPAGE="http://www.pymolwiki.org/index.php/Cealign"
SRC_URI="http://www.pymolwiki.org/images/0/03/Cealign-0.9.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/numpy
		>sci-chemistry/pymol-0.99"
RDEPEND=""

RESTRICT="mirror"
S=${WORKDIR}/cealign-0.9

src_install(){
	mtype=$(uname -m)

	distutils_src_install

	insinto $(python_get_sitedir)/cealign
	doins qkabsch.py cealign.py || die

	cat >> "${T}"/pymolrc <<- EOF
	run $(python_get_sitedir)/cealign/qkabsch.py
	run $(python_get_sitedir)/cealign/cealign.py
	EOF

	insinto ${PYMOL_PATH}
	doins "${T}"/pymolrc || die

	dodoc CHANGES doc/cealign.pdf
}

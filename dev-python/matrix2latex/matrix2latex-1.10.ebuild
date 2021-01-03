# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A tool to create LaTeX tables from python lists and arrays"
HOMEPAGE="https://github.com/TheChymera/matrix2latex"
SRC_URI="https://github.com/TheChymera/matrix2latex/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-${COMMIT}"

distutils_enable_sphinx doc_sphinx
distutils_enable_tests pytest

python_prepare_all() {
	# this has been renamed in newer versions of sphinx
	sed -i -e 's/sphinx.ext.pngmath/sphinx.ext.imgmath/g' doc_sphinx/conf.py

	distutils-r1_python_prepare_all
}

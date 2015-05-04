# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2} )

inherit distutils-r1

DESCRIPTION="Pure-python graphics and GUI library built on PyQt4/PySide and numpy."
HOMEPAGE="http://www.pyqtgraph.org/"
SRC_URI="http://www.pyqtgraph.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl example"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	|| ( >=dev-python/PyQt4-4.7.0[${PYTHON_USEDEP}] dev-python/pyside[${PYTHON_USEDEP}] )"

src_prepare() {
	use opengl || rm -r pyqtgraph/opengl
	if ! use example; then
		 sed -i -e '/package_dir/d' setup.py || die "Unable to remove example"
		 sed -i -e "s/+ \['pyqtgraph\.examples'\]//" setup.py || die "Unable to remove example"
	fi
}

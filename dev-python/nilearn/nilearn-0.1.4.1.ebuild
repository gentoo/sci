# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="http://nilearn.github.io/"
SRC_URI="mirror://pypi/n/${PN}/${PN}-0.1.4.post1.tar.gz -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scikits_learn
	sci-libs/scipy[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.1.0[${PYTHON_USEDEP}]"

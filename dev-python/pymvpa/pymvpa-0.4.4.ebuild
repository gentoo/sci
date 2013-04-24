# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pywavelets/pywavelets-0.2.0.ebuild,v 1.1 2010/04/22 20:14:30 bicatali Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Multivariate pattern analysis with Python"
HOMEPAGE="http://www.pymvpa.org/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples minimal test"

DEPEND="
	dev-lang/swig
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sys-apps/help2man
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
		)
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	!minimal? (
		dev-python/hcluster
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pynifti
		dev-python/rpy[${PYTHON_USEDEP}]
		sci-libs/afni
		sci-libs/fsl
		sci-libs/libsvm
		sci-libs/scipy
		sci-libs/shogun[python] )"

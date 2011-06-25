# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pywavelets/pywavelets-0.2.0.ebuild,v 1.1 2010/04/22 20:14:30 bicatali Exp $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Multivariate pattern analysis with Python"
HOMEPAGE="http://www.pymvpa.org/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples minimal test"

DEPEND="
	dev-lang/swig
	dev-python/lxml
	dev-python/numpy
	sys-apps/help2man
	doc? ( dev-python/sphinx media-gfx/graphviz )
	test? ( dev-python/nose )"

RDEPEND="dev-python/numpy
	!minimal? (
		dev-python/hcluster
		dev-python/ipython
		dev-python/matplotlib
		dev-python/pynifti
		dev-python/rpy
		sci-libs/afni
		sci-libs/fsl
		sci-libs/libsvm
		sci-libs/scipy
		sci-libs/shogun[python] )"

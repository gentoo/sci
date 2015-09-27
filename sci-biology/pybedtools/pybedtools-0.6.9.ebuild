# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Wrapper for Aaron Quinlan's BEDtools, plus other useful methods for working"
HOMEPAGE="http://pythonhosted.org/pybedtools/"
SRC_URI="https://github.com/daler/pybedtools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-biology/bedtools"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

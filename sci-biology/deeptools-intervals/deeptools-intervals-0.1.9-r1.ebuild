# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Constructing interval trees with associated exon/annotation information"
HOMEPAGE="https://github.com/deeptools/deeptools_intervals"
SRC_URI="https://github.com/deeptools/deeptools_intervals/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN//-/_}-${PV}"

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="*:2.6"
PYTHON_USE_WITH="threads"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Fast matching of large sets of points in 3D space, in O(N log N) time"
HOMEPAGE="http://pschella.github.com/k3match/"
SRC_URI="http://www.astro.ru.nl/~pschella/files/software/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" "

DEPEND=">=dev-python/numpy-1.4.0"
RDEPEND="${DEPEND}"

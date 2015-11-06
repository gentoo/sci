# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python Bindings for the NVIDIA Management Library"
HOMEPAGE="https://developer.nvidia.com/ganglia-monitoring-system"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"

RDEPEND="=dev-util/nvidia-cuda-gdk-352.39[nvml]"
DEPEND="${RDEPEND}"

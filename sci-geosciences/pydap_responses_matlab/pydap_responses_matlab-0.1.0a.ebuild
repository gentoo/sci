# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils versionator

MY_PN=${PN//_/.}
LETTER_PV="$(get_version_component_range 4)"
MAJMIN_PV="$(get_version_component_range 1-3)"
MY_P=${MY_PN}-${MAJMIN_PV}.${LETTER_PV}

DESCRIPTION="NetCDF response for Pydap Data Access Protocol server."
HOMEPAGE="http://pydap.org"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND=">=sci-geosciences/pydap-3.0_rc10
	>=sci-libs/scipy-0.7.2-r1"

S="$WORKDIR/$MY_P"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg-utils

MYPV=${PV/_/}
S=${WORKDIR}/${PN}-${MYPV}

DESCRIPTION="Helpers for Astropy and Affiliated packages"
HOMEPAGE="https://github.com/astropy/astropy-helpers"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MYPV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_prepare_all() {
	sed -e '/import ah_bootstrap/d' \
		-i setup.py || die "Removing ah_bootstrap failed"
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

# master file /var/tmp/portage/dev-python/astropy-helpers-4.0.1/work/astropy-helpers-4.0.1/astropy_helpers/sphinx/index.rst not found
#distutils_enable_sphinx astropy_helpers/sphinx dev-python/sphinx-astropy

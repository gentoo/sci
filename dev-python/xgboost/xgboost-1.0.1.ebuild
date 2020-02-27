# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz"
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="XGBoost Python Package"

HOMEPAGE="https://xgboost.readthedocs.io"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -e "/ADD_CFLAGS/s:=:=${CFLAGS/-O?/}:" \
		-e "/ADD_LDFLAGS/s:=:=${LDFLAGS}:" \
		-i ${PN}/make/config.mk || die

	distutils-r1_python_prepare_all
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 eutils multilib flag-o-matic

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="http://nipy.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/prov[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# nipy uses the horrible numpy.distutils automagic
}

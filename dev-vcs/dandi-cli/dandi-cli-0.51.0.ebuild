# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..10} )

inherit distutils-r1

MY_PN="dandi"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="DANDI command line client to facilitate common operations"
HOMEPAGE="https://github.com/dandi/dandi-cli"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test etelemetry"

RDEPEND="
	=dev-python/dandi-schema-0.8*[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.9.0[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/click-didyoumean[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	dev-python/fscacher[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/interleave[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/keyrings-alt[${PYTHON_USEDEP}]
	dev-python/nwbinspector[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/pynwb[${PYTHON_USEDEP}]
	dev-python/pyout[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/semantic_version[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/zarr[${PYTHON_USEDEP}]
	dev-python/zarr_checksum[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/anys[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		media-libs/opencv[ffmpeg,${PYTHON_USEDEP}]
	)
"
# Upstream might be amenable to dropping opencv:
# https://github.com/dandi/dandi-cli/issues/944

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

src_prepare() {
	if use etelemetry; then
		default
	else
		eapply "${FILESDIR}/${PN}-0.28.0-no-etelemetry.patch"
		default
		sed -i "/etelemetry/d" setup.cfg
	fi
}

python_test() {
	export DANDI_TESTS_NONETWORK=1
	epytest
}

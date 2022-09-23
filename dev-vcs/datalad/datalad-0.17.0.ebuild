# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Keep code, data, containers under control with git and git-annex"
HOMEPAGE="https://github.com/datalad/datalad"
SRC_URI="https://github.com/datalad/datalad/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +downloaders +metadata +publish misc"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/p7zip
	app-arch/patool[${PYTHON_USEDEP}]
	dev-python/annexremote[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/iso8601[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wraps[${PYTHON_USEDEP}]
	downloaders? (
		dev-python/boto[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/keyrings-alt[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
	metadata? (
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/whoosh[${PYTHON_USEDEP}]
	)
	misc? (
		dev-python/argcomplete[${PYTHON_USEDEP}]
		dev-python/pyperclip[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)
	publish? (
		dev-vcs/python-gitlab[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/httpretty[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"

# Noticed by upstream:
# https://github.com/datalad/datalad/issues/6623
PATCHES=( "${FILESDIR}/${PN}-0.17.0-skip.patch" )

distutils_enable_tests pytest

python_test() {
	local -x DATALAD_TESTS_NONETWORK=1
	#export DATALAD_TESTS_NONETWORK=1
	epytest -k "not turtle and not slow and not usecase"
	#epytest -k "not turtle"
	#${EPYTHON} -m nose -s -v -A "not(integration or usecase or slow or network or turtle)" datalad || die
	# Full test suite takes for ever:
	# ${EPYTHON} -m nose -s -v datalad || die
}

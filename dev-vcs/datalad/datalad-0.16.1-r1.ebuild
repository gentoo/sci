# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )
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
	dev-python/annexremote[${PYTHON_USEDEP}]
	dev-vcs/git-annex
	dev-python/appdirs[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/iso8601[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	app-arch/patool[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
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
		dev-python/PyGithub[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/httpretty[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"

# Noticed by upstream:
# https://github.com/datalad/datalad/issues/6623
PATCHES=( "${FILESDIR}/${P}-input.patch" )

distutils_enable_tests nose

python_test() {
	export DATALAD_TESTS_NONETWORK=1
	${EPYTHON} -m nose -s -v -A "not(integration or usecase or slow or network or turtle)" datalad || die
	# Full test suite takes for ever:
	# ${EPYTHON} -m nose -s -v datalad || die
}

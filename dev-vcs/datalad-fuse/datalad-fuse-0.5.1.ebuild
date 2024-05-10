# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Keep code, data, containers under control with git and git-annex"
HOMEPAGE="https://github.com/datalad/datalad"
SRC_URI="https://github.com/datalad/datalad-fuse/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/aiohttp-retry[${PYTHON_USEDEP}]
	dev-python/fsspec[${PYTHON_USEDEP}]
	dev-python/methodtools[${PYTHON_USEDEP}]
	dev-python/linesep[${PYTHON_USEDEP}]
	dev-vcs/datalad[${PYTHON_USEDEP}]
	sys-fs/fuse
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${P}-git_config.patch"
)

python_test() {
	#git init -q || die
	#git config --global user.email "placeholder@gentoo.org" || die
	#git config --global user.name "Place Holder" || die
	#git add . || die
	#git commit -m "init" || die
	##GIT_AUTHOR_NAME="Place Holder" GIT_AUTHOR_EMAIL="placeholder@gentoo.org" epytest
	##export GIT_AUTHOR_NAME="Place Holder"
	##export GIT_AUTHOR_EMAIL="placeholder@gentoo.org"
	epytest
}

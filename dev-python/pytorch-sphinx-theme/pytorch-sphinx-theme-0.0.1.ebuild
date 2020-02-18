# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Sphinx theme for PyTorch Docs and PyTorch Tutorials"
HOMEPAGE="https://github.com/pytorch/pytorch_sphinx_theme"
COMMIT="77e5f4c6a11538b996aac8aa989ee8ad45d66919"
SRC_URI="https://github.com/pytorch/pytorch_sphinx_theme/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="dev-python/sphinx"
DEPEND="${RDEPEND} dev-python/setuptools"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PN//-/_}-${COMMIT}" "${S}"
}

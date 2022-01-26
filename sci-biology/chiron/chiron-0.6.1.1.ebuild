# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A deep neural network basecaller for nanopore sequencing"
HOMEPAGE="https://github.com/haotianteng/chiron
	https://www.biorxiv.org/content/early/2017/09/12/179531"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	sci-biology/mappy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	sci-libs/tensorflow[${PYTHON_USEDEP}]
"

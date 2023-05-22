# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )
DISTUTILS_SINGLE_IMPL=1  # because "sci-libs/vtk" inherits "python-single-r1"
inherit distutils-r1 pypi

DESCRIPTION="Easier Pythonic interface to VTK"
HOMEPAGE="https://docs.pyvista.org"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	sci-libs/vtk[python,imaging,rendering,views,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/imageio[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		>=dev-python/scooby-0.5.1[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

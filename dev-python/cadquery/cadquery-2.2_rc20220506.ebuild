# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Python parametric CAD scripting framework based on OCCT"
HOMEPAGE="https://cadquery.readthedocs.io"

# The official CadQuery 2.1 tarball requires the obsolete OCCT 7.4.0, but
# CadQuery 2.2 has yet to be officially released. We instead package a commit
# known to work as expected with OCCT 7.5.2.
MY_COMMIT="803a05e78c233fdb537a8604c3f2b56a52179bbe"

#FIXME: Uncomment on bumping to the next stable release.
# SRC_URI="https://github.com/CadQuery/cadquery/archive/refs/tags/${PV}.tar.gz"
SRC_URI="https://github.com/CadQuery/cadquery/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Dependencies are intentionally listed in "conda/meta.yml" order. Due to its
# Anaconda focus, "setup.py" currently fails to list dependencies.
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/path[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="
	>=dev-python/cadquery-ocp-7.5.0[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/pyparsing-2.0.0[${PYTHON_USEDEP}]
		dev-python/ezdxf[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/nptyping[${PYTHON_USEDEP}]
		sci-libs/nlopt[python,${PYTHON_USEDEP}]
		dev-python/multimethod[${PYTHON_USEDEP}]
		dev-python/typish[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

distutils_enable_tests pytest

#FIXME: Uncomment after packaging "dev-python/sphinx-autodoc-typehints".
# distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinx-autodoc-typehints

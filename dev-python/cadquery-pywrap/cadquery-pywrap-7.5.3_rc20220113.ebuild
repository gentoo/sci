# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit llvm distutils-r1

DESCRIPTION="C++ binding generator based on libclang and pybind11"
HOMEPAGE="https://github.com/CadQuery/pywrap"

#FIXME: Uncomment on bumping to the next stable release.
# MY_PN=occt
# MY_PV=$(ver_cut 1-2)
# MY_P="${MY_PN}${MY_PV}"
# SRC_URI="https://github.com/CadQuery/pywrap/archive/refs/tags/${MY_P}.tar.gz"

# The official pywrap 7.4.0 tarball is broken, but pywrap 7.5.3 has yet to be
# officially released. We instead package a commit known to work as expected.
MY_COMMIT="66e7376d3a27444393fc99acbdbef40bbc7031ae"
SRC_URI="https://github.com/CadQuery/pywrap/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# Dependencies are intentionally listed in "setup.py" order.
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/logzero[${PYTHON_USEDEP}]
	dev-python/path[${PYTHON_USEDEP}]
	dev-python/clang-python[${PYTHON_USEDEP}]
	dev-python/cymbal[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	>=dev-python/joblib-1.0.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/toposort[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/schema[${PYTHON_USEDEP}]
	sci-libs/vtk
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/pywrap-${MY_COMMIT}"

src_prepare() {
	#FIXME: Submit an upstream issue. This violates PEP 440 standards.
	# Sanitize the "bindgen" version to avoid Gentoo QA notices.
	sed -i -e 's~\(version=\)"0.1dev"~\1"'$(ver_rs 3 '')'"~' setup.py || die

	# Replace conda- with Gentoo-specific prefix dirnames.
	sed -i -e "s~\\bgetenv('CONDA_PREFIX')~'${EPREFIX}/usr'~" bindgen/*.py ||
		die

	# Reduce all hardcoded header includes to noops.
	sed -i -e 's~rv\.append(Path(prefix).*~True~' bindgen/utils.py || die

	distutils-r1_src_prepare
}

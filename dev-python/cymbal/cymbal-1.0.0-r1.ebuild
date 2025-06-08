# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_13 )
inherit distutils-r1 pypi

DESCRIPTION="Add functionality missing from the python libclang bindings"
HOMEPAGE="https://pypi.org/project/cymbal/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/clang[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

# Prevent "setup.py" from installing the "tests" package.
src_prepare() {
	sed -i -e 's~\(packages     = \)find_packages(),~\1["cymbal"],~' \
		setup.py || die

	default_src_prepare
}

# Omit "test_class_template_arg", failing due to outdated clang assumptions.
python_test() {
	pytest -k 'not test_class_template_arg' || die
}

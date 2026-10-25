# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="Efficient pythonic random access to fasta subsequences"
HOMEPAGE="
	https://github.com/mdshw5/pyfaidx
	https://pypi.org/project/pyfaidx/
"
SRC_URI="https://github.com/mdshw5/pyfaidx/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# The remaining tests require genome data downloaded separately by upstream
	epytest -o addopts= \
		tests/test_bed_non_data.py \
		tests/test_bgzfblock.py \
		'tests/test_faidx.py::test_faidx_cli_transform_chromsizes[False]' \
		tests/test_feature_comments.py \
		tests/test_feature_spliced_seq.py \
		tests/test_long_fasta_entry.py \
		tests/test_sequence_class.py \
		tests/test_wrap_sequence_newline.py
}

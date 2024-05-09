# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )
inherit distutils-r1 pypi

DESCRIPTION="W3C provenance data dodel library"
HOMEPAGE="https://pypi.org/project/prov/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.10[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# Reported upstream:
# https://github.com/trungdong/prov/issues/156
EPYTEST_DESELECT=(
	src/prov/tests/test_model.py::TestAttributesBase
	src/prov/tests/test_rdf.py::TestStatementsBase
	src/prov/tests/test_rdf.py::TestAttributesBase2
	src/prov/tests/test_rdf.py::TestQualifiedNamesBase
	src/prov/tests/test_rdf.py::TestAttributesBase
	src/prov/tests/test_model.py::TestStatementsBase
	src/prov/tests/test_model.py::TestExamplesBase::test_all_examples
	src/prov/tests/test_model.py::TestQualifiedNamesBase
	src/prov/tests/test_rdf.py::RoundTripRDFTests::test_namespace_inheritance
	src/prov/tests/test_rdf.py::RoundTripRDFTests::test_default_namespace_inheritance
	src/prov/tests/test_rdf.py::TestRDFSerializer::test_json_to_ttl_match
	src/prov/tests/test_rdf.py::TestJSONExamplesBase::test_all_examples
	src/prov/tests/test_rdf.py::TestExamplesBase::test_all_examples
)

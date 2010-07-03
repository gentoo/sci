# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="A package for managing hierarchical datasets built on top of the HDF5 library."
HOMEPAGE="http://www.pytables.org/"
SRC_URI="http://www.pytables.org/download/stable/tables-${PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
IUSE="doc examples"

DEPEND="
	>=sci-libs/hdf5-1.6.5
	>=dev-python/numpy-1.2.1
	>=dev-python/numexpr-1.3
	>=dev-python/cython-0.12.1
	dev-libs/lzo:2
	app-arch/bzip2"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/tables-${PV}

DOCS="ANNOUNCE.txt MIGRATING_TO_2.x.txt RELEASE_NOTES.txt THANKS"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi

	if use doc; then
		cd doc

		dohtml -r html/* || die

		docinto text
		dodoc text/* || die

		insinto /usr/share/doc/${PF}
		doins -r usersguide.pdf scripts || die
	fi
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" tables/tests/test_all.py
	}
	python_execute_function testing
}

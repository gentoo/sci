# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3*"

inherit python

DESCRIPTION="Bayesian Photometric Redshifts"
HOMEPAGE="http://www.its.caltech.edu/~coe/BPZ/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/numpy
	|| ( dev-python/matplotlib dev-python/python-biggles )"
DEPEND="test? ( ${RDEPEND} )"

src_prepare() {
	sed -i -e 's/TkAgg/Agg/g' bpz.py plots/probplot.py plots/coeplot.py
}

src_test() {
	cd test
	testing() {
		export BPZPATH="${S}" PYTHONPATH="${S}"
		"$(PYTHON)" ../bpz.py UDFtest.cat -INTERP 2
		"$(PYTHON)" ../bpzfinalize.py UDFtest
		"$(PYTHON)" ../plots/webpage.py UDFtest
	}
	python_execute_function testing
}

src_install() {
	insinto /usr/share/bpz
	doins -r FILTER SED AB
	installation() {
		insinto $(python_get_sitedir)/bpz
		doins -r *.py plots
	}
	python_execute_function installation
	cat <<-EOF > bpz
		#!$(type -P sh)
		sitedir=\$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')
		BPZPATH=${EPREFIX}/usr/share/bpz python \${sitedir}/bpz/bpz.py \$@
	EOF
	exeinto /usr/bin
	doexe bpz
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Bayesian Photometric Redshifts"
HOMEPAGE="http://www.its.caltech.edu/~coe/BPZ/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	|| (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/python-biggles[${PYTHON_USEDEP}]
		)"
DEPEND="${PYTHON_DEPS}
	test? ( ${RDEPEND} )"

src_prepare() {
	sed \
		-e 's/TkAgg/Agg/g' \
		-i bpz.py plots/probplot.py plots/coeplot.py || die
}

src_test() {
	cd test
	export BPZPATH="${S}" PYTHONPATH="${S}"
	${EPYTHON} ../bpz.py UDFtest.cat -INTERP 2 || die
	${EPYTHON} ../bpzfinalize.py UDFtest || die
	${EPYTHON} ../plots/webpage.py UDFtest || die
}

src_install() {
	insinto /usr/share/bpz
	doins -r FILTER SED AB
	python_moduleinto ${PN}
	python_domodule *.py plots

	cat <<-EOF > bpz
		#!$(type -P sh)
		sitedir=$(python_get_sitedir)
		BPZPATH="${EPREFIX}"/usr/share/bpz ${EPYTHON} \${sitedir}/bpz/bpz.py \$@
	EOF

	dobin bpz
}

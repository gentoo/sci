# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON=2.3
PYTHON_USE_WITH="tk"

inherit base python eutils versionator

MY_P="${PN}$(get_version_component_range 1-2 ${PV})"

DESCRIPTION="Software for automated NOE assignment and NMR structure calculation."
HOMEPAGE="http://aria.pasteur.fr/"
SRC_URI="http://aria.pasteur.fr/archives/${MY_P}.tar.gz"

SLOT="0"
LICENSE="cns"
KEYWORDS="~amd64 ~x86"
IUSE="examples +numpy"

RDEPEND="sci-chemistry/cns[aria,openmp]
	numpy? ( dev-python/numpy )
	!numpy? ( dev-python/numeric )
	>=dev-python/scientificpython-2.7.3
	>=dev-lang/tk-8.3
	>=dev-tcltk/tix-8.1.4
	>=sci-chemistry/ccpn-2.0.5
	dev-python/matplotlib[tk]"
DEPEND=""

RESTRICT="fetch"

S="${WORKDIR}/${PN}2.2"

PATCHES=(
	"${FILESDIR}"/sa_ls_cool2.patch
	)

pkg_nofetch(){
	einfo "Go to ${HOMEPAGE}, download ${A}"
	einfo "and place it in ${DISTDIR}"
}

src_prepare() {
	base_src_prepare
	use numpy && epatch "${FILESDIR}"/${PV}-numpy.patch
}

src_test(){
	export CCPNMR_TOP_DIR=$(python_get_sitedir)
	export PYTHONPATH=.:${CCPNMR_TOP_DIR}/ccpn/python
	${python} check.py || die
}

src_install(){
	insinto "$(python_get_sitedir)/${PN}"
	doins -r src aria2.py || die "failed to install ${PN}"
	insinto "$(python_get_sitedir)/${PN}"/cns
	doins -r cns/{protocols,toppar,src/helplib} || die "failed to install cns part"

	if use examples; then
		insinto /usr/share/${P}/
		doins -r examples
	fi

# ENV
	cat >> "${T}"/20aria <<- EOF
	ARIA2="$(python_get_sitedir)/${PN}"
	EOF

	doenvd "${T}"/20aria

# Launch Wrapper
	cat >> "${T}"/aria <<- EOF
	#!/bin/sh
	export CCPNMR_TOP_DIR=$(python_get_sitedir)
	export PYTHONPATH=.:${CCPNMR_TOP_DIR}/ccpn/python
	exec "${python}" -O "\${ARIA2}"/aria2.py \$@
	EOF

	dobin "${T}"/aria || die "failed to install wrapper"
	dosym aria /usr/bin/aria2

	dodoc COPYRIGHT README
}

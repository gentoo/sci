# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="threads(+)"

inherit python-single-r1

DESCRIPTION="Piece of software used to help building software projects"
HOMEPAGE="https://waf.io/"
SRC_URI="https://waf.io/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="doc? ( $(python_gen_cond_dep \
	'dev-python/sphinx[${PYTHON_USEDEP}]' )
)"
DEPEND="${PYTHON_DEPS}"

src_prepare() {
	rm waf || die

	default
}

src_configure() {
	${EPYTHON} ./waf-light configure || die "waf configure failed"
}

src_compile() {
	${EPYTHON} ./waf-light build || die "waf build failed"
	use doc && build_sphinx docs/sphinx
}

src_install() {
	default

	# Set INSTALL to EPREFIX
	# Set REVISION to PR
	# set dirname to empty because python_get_sitedir
	# installs directly to a dir with the correct name
	# Set location of waflib to location of Gentoo
	# Python sitedir
	sed -e "/INSTALL=/s:=.*:='${EPREFIX}':" \
		-e "/REVISION=/s:=.*:='${PR}':" \
		-e "/dirname =/s:=.*:= '':" \
		-e "s:/lib/:$(python_get_sitedir)/:" \
		-e "/^#\(==>\|BZ\|<==\)/d" \
		-i waf || die
	python_doscript waf

	python_domodule waflib

	if use examples ; then
		dodoc -r demos
	fi
}

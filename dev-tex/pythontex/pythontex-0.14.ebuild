# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit latex-package python-r1

DESCRIPTION="Fast Access to Python from within LaTeX"
HOMEPAGE="https://github.com/gpoore/pythontex"
SRC_URI="https://github.com/gpoore/pythontex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LPPL-1.3 BSD"
KEYWORDS="~amd64"
IUSE="highlighting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-texlive/texlive-latex"
RDEPEND="${DEPEND}
	dev-texlive/texlive-xetex
	>=dev-python/matplotlib-1.2.0[${PYTHON_USEDEP}]
	highlighting? ( dev-python/pygments[${PYTHON_USEDEP}] )"

TEXMF=/usr/share/texmf-site

src_compile() {
	cd ${PN} || die
	latex-package_src_compile
}

src_install() {
	dodoc ${PN}/README "${S}"/*rst ${PN}_quickstart/*

	cd ${PN} || die
	latex-package_src_install

	installation() {
		if python_is_python3; then
			python_domodule {de,}${PN}3.py
		else
			python_domodule {de,}${PN}2.py
		fi
		python_domodule ${PN}_{engines,utils}.py
		python_doscript {de,}${PN}.py syncpdb.py
		python_optimize
	}
	python_foreach_impl installation
}

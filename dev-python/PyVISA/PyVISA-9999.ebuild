# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Python VISA bindings for GPIB, RS232, and USB instruments"
HOMEPAGE="https://github.com/hgrecco/pyvisa-py"
EGIT_REPO_URI="https://github.com/hgrecco/${PN}.git git://github.com/${PN}/${PN}.git"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	"
DEPEND="${RDEPEND}"

python_test() {
	esetup.py test
}
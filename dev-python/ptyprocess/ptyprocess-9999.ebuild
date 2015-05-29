# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="pyFFTW"

DESCRIPTION="Launch a subprocess in a pseudo terminal (pty), and interact with both the process and its pty"
HOMEPAGE="https://github.com/pexpect/ptyprocess"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pexpect/${PN}.git git://github.com/pexpect/${MY_PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="ISC"
SLOT="0"

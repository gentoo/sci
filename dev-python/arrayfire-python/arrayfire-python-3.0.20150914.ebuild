# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Python bindings for ArrayFire"
HOMEPAGE="http://www.arrayfire.com"

MY_PN="arrayfire"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/arrayfire/${PN}.git git://github.com/arrayfire/${PN}.git"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=sci-libs/arrayfire-3.0.0
	"
DEPEND="${RDEPEND}"

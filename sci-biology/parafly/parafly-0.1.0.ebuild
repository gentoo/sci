# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Parallel cmd processing utility"
HOMEPAGE="https://github.com/ParaFly/ParaFly"
SRC_URI="https://github.com/ParaFly/ParaFly/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/ParaFly-${PV}"

src_configure(){
	./configure --prefix="${EPREFIX}"/usr
}

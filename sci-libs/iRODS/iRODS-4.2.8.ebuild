# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Integrated Rule Oriented Data System, a data management software"
HOMEPAGE="https://irods.org"
SRC_URI="https://github.com/irods/irods/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/clang"

S="${WORKDIR}/irods-${PV}"

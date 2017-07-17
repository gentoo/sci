# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Integrated Rule Oriented Data System, a data management software"
HOMEPAGE="https://irods.org"
SRC_URI="https://github.com/irods/irods/archive/4.2.0.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="sys-devel/clang"
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/irods-"${PV}"

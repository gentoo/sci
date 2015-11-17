# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils

DESCRIPTION="Tool for statistical analysis of large data sets"
HOMEPAGE="http://ovis.ca.sandia.gov/"
SRC_URI="http://ovis.ca.sandia.gov/mediawiki/downloads/OVIS-${PV}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="avahi"

RDEPEND="
	>=dev-db/mysql-5.0.77
	>=dev-libs/boost-1.44
	dev-libs/libevent
	>=dev-libs/qjson-0.7.1
	sys-libs/readline:0=
	>=dev-qt/qthelp-4.7.4:4=[compat]
	>=dev-qt/qtgui-4.7.4:4=
	avahi? ( >=net-dns/avahi-0.6.27 )"
DEPEND="${RDEPEND}
	avahi? ( >=net-dns/avahi-0.6.27 )"

S="${WORKDIR}/OVIS-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-directories.patch
}

src_configure() {
	CMAKE_BUILD_TYPE="Release"
	mycmakeargs=(
	    -D OVIS_USE_MYSQL=ON
	    $(cmake-utils_use avahi OVIS_USE_AVAHI)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	echo "LDPATH=\"/usr/$(get_libdir)/vtk\"" > "${T}/91ovis"
	doenvd  "${T}/91ovis"
}

pkg_postinst() {
	elog "Ovis requires a MySQL database and all privileges on it"
	elog "in order to work. To do so, start the mysql client with:"
	elog "  mysql -u root -p"
	echo ""
	elog "and perform the following operations:"
	elog "  CREATE DATABASE OVIS_Cluster;"
	elog "  GRANT ALL PRIVILEGES ON OVIS_Cluster.* TO ovis@localhost;"
	elog "  flush-privileges;"
	echo ""
	einfo "Remember to start the mysql server before using Ovis!"
}

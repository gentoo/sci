# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit cmake-utils

DESCRIPTION="Tool for statistical analysis of large data sets"
HOMEPAGE="http://ovis.ca.sandia.gov"
SRC_URI="http://ovis.ca.sandia.gov/mediawiki/downloads/OVIS-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"

IUSE="avahi"

RDEPEND=">=x11-libs/qt-gui-4.7.4
    >=x11-libs/qt-assistant-4.7.4[compat]
	>=dev-libs/qjson-0.7.1
	>=dev-libs/boost-1.44
    avahi? ( >=net-dns/avahi-0.6.27 )
    >=dev-db/mysql-5.0.77
    dev-libs/libevent
    sys-libs/readline"
    
DEPEND="${RDEPEND}
	>=net-dns/avahi-0.6.27"

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
	
	echo "LDPATH=\"/usr/$(get_libdir)/vtk\"" > "${DISTDIR}/etc/env.d/91ovis"
}

pkg_postinst() {
	elog "Ovis requires a MySQL database and all privileges on it"
	elog "in order to work. To do so, start the mysql client with:"
	elog "  mysql -u root -p"
	elog " "
	elog "and perform the following operations:"
	elog "  CREATE DATABASE OVIS_Cluster;"
	elog "  GRANT ALL PRIVILEGES ON OVIS_Cluster.* TO ovis@localhost;"
	elog "  flush-privileges;"
	elog " "
	einfo "Remember to start the mysql server before using Ovis!"
}

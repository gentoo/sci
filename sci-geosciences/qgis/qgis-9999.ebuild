# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="python? 2"

inherit cmake-utils python subversion eutils

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
ESVN_REPO_URI="http://svn.osgeo.org/qgis/trunk/qgis"
SRC_URI="examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples gps grass gsl postgres python sqlite"

RDEPEND=">=sci-libs/gdal-1.6.1[geos,postgres?,python?,sqlite?]
	dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	sci-libs/geos
	gps? (
		dev-libs/expat
		sci-geosciences/gpsbabel
		x11-libs/qwt
	)
	grass? ( >=sci-geosciences/grass-6.4.0_rc6[postgres?,python?,sqlite?] )
	gsl? ( sci-libs/gsl )
	postgres? (
		|| (
			>=dev-db/postgresql-base-8.4
			>=dev-db/postgresql-server-8.4
		)
	)
	python? ( dev-python/PyQt4[sql,svg] )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	local mycmakeargs
	mycmakeargs+=(
		"-DQGIS_MANUAL_SUBDIR=/share/man/"
		"-DBUILD_SHARED_LIBS=ON"
		"-DBINDINGS_GLOBAL_INSTALL=ON"
		"-DQGIS_LIB_SUBDIR=$(get_libdir)"
		"-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis"
		"-DWITH_INTERNAL_SPATIALITE:BOOL=OFF"
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with grass)
		$(cmake-utils_use_with gps EXPAT)
		$(cmake-utils_use_with gps QWT)
		$(cmake-utils_use_with gsl)
		$(cmake-utils_use_with python BINDINGS)
		$(cmake-utils_use_with sqlite SPATIALITE)
	)
	use grass && mycmakeargs+=( "-DGRASS_PREFIX=/usr/" )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS BUGS ChangeLog README SPONSORS CONTRIBUTORS || die

	newicon images/icons/qgis-icon.png qgis.png || die
	make_desktop_entry qgis "Quantum GIS " qgis

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/qgis_sample_data/* || die "Unable to install examples"
	fi
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	fi
}

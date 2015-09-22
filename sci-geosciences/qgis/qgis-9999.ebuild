# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit cmake-utils gnome2-utils multilib python-single-r1 subversion eutils

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
ESVN_REPO_URI="http://svn.osgeo.org/qgis/trunk/qgis"
SRC_URI="examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples gps grass gsl postgres python sqlite"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=sci-libs/gdal-1.6.1[geos,postgres?,python?,sqlite?]
	dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	sci-libs/geos
	gps? (
		dev-libs/expat
		sci-geosciences/gpsbabel
		x11-libs/qwt:6=
	)
	grass? ( >=sci-geosciences/grass-6.4.0_rc6[postgres?,python?,sqlite?] )
	gsl? ( sci-libs/gsl )
	postgres? ( dev-db/postgresql:* )
	python? (
		${PYTHON_DEPS}
		dev-python/PyQt4[sql,svg,${PYTHON_USEDEP}]
		dev-python/sip[${PYTHON_USEDEP}] )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	python-single-r1_pkg_setup
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
		$(cmake-utils_use python BINDINGS_GLOBAL_INSTALL)
		$(cmake-utils_use_with spatialite SPATIALITE)
		$(cmake-utils_use_enable test TESTS)
		$(usex grass "-DGRASS_PREFIX=/usr/" "")
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc BUGS ChangeLog CODING README

	newicon -s 128 images/icons/qgis-icon.png qgis.png
	make_desktop_entry qgis "Quantum GIS " qgis

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/qgis_sample_data/*
	fi
	python_fix_shebang "${D}"/usr/share/qgis/grass/scripts
	python_optimize "${D}"/usr/share/qgis/python/plugins \
		"${D}"/$(python_get_sitedir)/qgis \
		"${D}"/usr/share/qgis/grass/scripts
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	fi
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

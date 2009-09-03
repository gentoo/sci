# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils qt4

DESCRIPTION="Quantum GIS (QGIS) is a Geographic Information System (GIS)"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="http://download.osgeo.org/qgis/src/${PN}_${PV}.tar.gz
	samples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug gps grass gsl postgres python sqlite samples"

RDEPEND=">=sci-libs/gdal-1.6.1
		x11-libs/qt-core:4[qt3support]
		x11-libs/qt-gui:4
		x11-libs/qt-svg:4
		x11-libs/qt-sql:4
		>=sci-libs/geos-3.0.0
		sci-libs/proj
		sqlite? ( dev-db/sqlite:3 )
		postgres? ( virtual/postgresql-base	)
		grass? ( >=sci-geosciences/grass-6.0.1
			   sci-libs/gdal-grass )
		gps? ( dev-libs/expat
			sci-geosciences/gpsbabel )
		gsl? ( sci-libs/gsl )
		python? ( dev-lang/python
			dev-python/PyQt4
			dev-python/sip )
		gps? ( sci-geosciences/gpsbabel )"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs
	mycmakeargs="${mycmakeargs} -DBUILD_SHARED_LIBS:BOOL=ON \
		$(cmake-utils_use_with postgres POSTGRESQL) \
		$(cmake-utils_use_with grass GRASS) \
		$(cmake-utils_use_with gps EXPAT) \
		$(cmake-utils_use_with gsl GSL) \
		$(cmake-utils_use_with python BINDINGS) \
		$(cmake-utils_use_with sqlite SPATIALITE)"

	if use grass; then
		GRASS_ENVD="/etc/env.d/99grass /etc/env.d/99grass-6 /etc/env.d/99grass-cvs";
		for file in ${GRASS_ENVD}; do
			if test -r ${file}; then
				GRASSPATH=$(sed -n 's/LDPATH="\(.*\)\/lib"$/\1/p' ${file});
			fi
		done
		mycmakeargs="${mycmakeargs} -DGRASS_PREFIX=${GRASSPATH}"
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon images/icons/qgis-icon.png qgis.png
	make_desktop_entry qgis Qgis qgis.png 'Science;Geoscience'

	if use samples; then
		cd "${WORKDIR}"
		insinto /usr/share/doc/${PF}/sample_data
		doins qgis_sample_data/* || die "Unable to install sample data"
	fi
}

pkg_postinst() {
	if use samples; then
		einfo "You can find sample data to use with qgis in"
		einfo "/usr/share/doc/${PF}/sample_data/"
	fi
}

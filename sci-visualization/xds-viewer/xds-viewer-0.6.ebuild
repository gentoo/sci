# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils

DESCRIPTION="Viewing X-ray diffraction and control images in the context of data processing by the XDS"
HOMEPAGE="http://xds-viewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="x11-libs/qt-gui
	dev-libs/glib:2
	media-libs/libpng"
DEPEND=">=dev-util/cmake-2.6"
PDEPEND="sci-chemistry/xds-bin"

DOCS="README"
HTML_DOCS="src/doc/*"

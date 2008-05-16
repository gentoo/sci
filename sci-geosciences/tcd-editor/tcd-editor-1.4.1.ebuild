# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PN=${PN/tcd-editor/tideEditor}
MY_PV=${PV/_p/-r}
MY_SPV=$(get_version_component_range 1-3)
S=${WORKDIR}/${MY_PN}-${MY_SPV}

DESCRIPTION="Tide editor is a graphical editor for Tidal Constituent Databases."
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_PN}-${MY_PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=sci-geosciences/libtcd-2.2.3
	=x11-libs/qt-3*"
RDEPEND="${DEPEND}"


src_compile() {
	sed -i \
		"s;\(#include <qlistbox.h>\);&1\n#include <qmetaobject.h>;" map.h
	MOC="/usr/qt/3/bin/moc" econf || die "econf failed"
	emake || die "emake failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

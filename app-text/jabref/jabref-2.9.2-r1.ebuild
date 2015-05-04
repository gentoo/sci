# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EANT_BUILD_TARGET="jars"

inherit eutils java-pkg-2 java-ant-2 java-utils-2

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://jabref.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/JabRef-${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

src_install() {
	java-pkg_newjar build/lib/JabRef-${PV}.jar
	java-pkg_dolauncher ${PN} --main net.sf.jabref.JabRef
	newicon src/images/JabRef-icon-48.png JabRef-icon.png
	make_desktop_entry ${PN} JabRef JabRef-icon Office
}

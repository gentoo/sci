# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EANT_DOC_TARGET=javadocs
inherit java-pkg-2 java-ant-2

SFVERSION="2.10b"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://jabref.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/JabRef-${SFVERSION}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

EANT_BUILD_TARGET="jars"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${PN}-${SFVERSION}"

src_install() {
	java-pkg_newjar build/lib/JabRef-${SFVERSION}.jar
	use doc && java-pkg_dojavadoc build/docs/API
	dodoc src/txt/README
	java-pkg_dolauncher ${PN} --main net.sf.jabref.JabRef
	newicon src/images/JabRef-icon-48.png JabRef-icon.png
	make_desktop_entry ${PN} JabRef JabRef-icon Office
}

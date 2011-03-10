# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Java-based command-line utilities manipulating SAM/BAM files with Java API (SAM-JDK)"
HOMEPAGE="http://picard.sourceforge.net/index.shtml"
SRC_URI="http://sourceforge.net/projects/picard/files/picard-tools/1.40/picard-tools-1.40.zip"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

# TODO: maybe better set set CLASSPATH=/whatever/av.jar:/whatever/sam-1.09.jar
src_install(){
	insinto "${DESTDIR}"/usr/share/"${PN}"/lib
	doins *.jar || die "dobin failed"
}

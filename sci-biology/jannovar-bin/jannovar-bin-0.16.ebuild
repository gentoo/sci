# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool"
HOMEPAGE="http://compbio.charite.de
	https://github.com/charite/jannovar"
SRC_URI="https://github.com/charite/jannovar/releases/download/v0.16/jannovar-cli-0.16.jar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}"

src_install(){
	cp "${DISTDIR}"/jannovar-cli-0.16.jar jannovar-bin.jar
	java-pkg_newjar jannovar-bin.jar
	java-pkg_dolauncher jannovar-bin --jar jannovar-bin.jar
}

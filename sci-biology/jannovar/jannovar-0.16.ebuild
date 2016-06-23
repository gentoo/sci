# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool"
HOMEPAGE="http://compbio.charite.de/contao/index.php/jannovar.html"
SRC_URI="https://github.com/charite/jannovar/archive/v0.16.tar.gz -> ${P}.tar.gz"

# https://github.com/charite/jannovar
LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.6
	dev-java/maven-bin:*"
RDEPEND=">=virtual/jre-1.6"

# TODO: set a proxy because it downloads data during compile step
# http://jannovar.readthedocs.io/en/master/install.html
# see https://github.com/charite/jannovar/issues/218
src_compile(){
	mvn package -Dmaven.test.skip.exec=true -DskipTests=true || die
}

src_install(){
	mvn install -Dmaven.test.skip.exec=true || die
	dojar *.jar
	java-pkg_newjar jannovar-bin.jar
	java-pkg_dolauncher jannovar-bin --jar jannovar-bin.jar
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool"
HOMEPAGE="http://compbio.charite.de/contao/index.php/jannovar.html"
SRC_URI="http://compbio.charite.de/contao/index.php/jannovar.html?file=tl_files/Jannovar/Jannovar.jar -> Jannovar-bin-20150503.jar
	http://compbio.charite.de/contao/index.php/jannovar.html?file=tl_files/Jannovar/JannovarTutorial.pdf -> JannovarTutorial.pdf
	http://compbio.charite.de/contao/index.php/jannovar.html?file=tl_files/Jannovar/tutorial.tgz -> Jannovar_tutorial.tgz"

# https://github.com/charite/jannovar
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}"

src_install(){
	cp "${DISTDIR}"/Jannovar-bin-20150503.jar Jannovar-bin.jar
	java-pkg_newjar Jannovar-bin.jar
	java-pkg_dolauncher Jannovar-bin --jar Jannovar-bin.jar
}

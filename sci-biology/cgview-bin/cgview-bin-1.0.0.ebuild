# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 perl-module eutils toolchain-funcs

DESCRIPTION="CGView Comparison Tool to compare genome sequences graphically (aka CCT)"
HOMEPAGE="https://paulstothard.github.io/cgview_comparison_tool/"
SRC_URI="https://github.com/paulstothard/cgview_comparison_tool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-lang/perl-5.8.8
	>=sci-biology/ncbi-tools-2.2.15
	>=virtual/jre-1.4.2:*
	dev-java/xerces:2
	dev-java/batik
	dev-java/commons-lang:2.1
	>=media-gfx/imagemagick-6
	>=sci-biology/bioperl-1.4.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/cgview_comparison_tool-${PV}"

src_install() {
	insinto /usr/share/${PN}/scripts
	chmod a+x scripts/* # BUG: this does not work
	doins -r scripts/*
	insinto /usr/share/${PN}/lib/scripts
	doins -r lib/scripts/*
	echo 'CCT_HOME='${EPREFIX}'/usr/share/cgview' > "${S}/99cgview"
	echo 'PATH="$PATH":"'${CCT_HOME}'/scripts"' >> "${S}/99cgview"
	doenvd "${S}/99cgview"
	perl_set_version
	perl_domodule lib/perl_modules/Util/*.pm
	#
	# Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/batik/svggen/SVGGraphics2DIOException
	java-pkg_dojar bin/cgview/cgview.jar
}

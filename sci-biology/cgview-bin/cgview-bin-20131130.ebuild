# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="CGView Comparison Tool to compare genome sequences graphically (aka CCT)"
HOMEPAGE="http://stothard.afns.ualberta.ca/downloads/CCT"
SRC_URI="http://www.ualberta.ca/~stothard/downloads/cgview_comparison_tool.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

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

S="${WORKDIR}"/cgview_comparison_tool

src_test(){
	./update_cogs.sh || die
	./test.sh || die
}

src_install() {
	insinto /usr/share/${PN}/scripts
	chmod a+x scripts/* # BUG: this does not work
	doins scripts/*
	echo 'CCT_HOME='${EPREFIX}'/usr/share/cgview' > "${S}/99cgview"
	echo 'PATH="$PATH":"'${CCT_HOME}'/scripts"' >> "${S}/99cgview"
	doenvd "${S}/99cgview"
	perl_set_version
	insinto ${VENDOR_LIB}/cgview
	doins lib/perl_modules/Util/*.pm
	#
	# Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/batik/svggen/SVGGraphics2DIOException
	java-pkg_dojar bin/cgview.jar
}

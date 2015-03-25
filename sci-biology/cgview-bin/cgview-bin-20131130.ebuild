# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2

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
	echo 'CCT_HOME='${EPREFIX}'/usr/share/cgview_comparison_tool' > "${S}/99cgview"
	echo 'PATH="$PATH":"'${CCT_HOME}'/scripts"' >> "${S}/99cgview"
	doenvd "${S}/99cgview"
	#export PATH="$PATH":"${CCT_HOME}/scripts":/path/to/blast-2.2.25/bin
	#export PERL5LIB="${CCT_HOME}"/lib/bioperl-1.2.3:"${CCT_HOME}"/lib/perl_modules:"$PERL5LIB"

	dobin bin/cgview.jar
}

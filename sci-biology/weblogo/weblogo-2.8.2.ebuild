# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils perl-module

DESCRIPTION="generate consensus sequence logo figures"
HOMEPAGE="http://weblogo.berkeley.edu/"
SRC_URI="http://weblogo.berkeley.edu/release/weblogo.2.8.2.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	media-gfx/imagemagick"

S="${WORKDIR}/${PN}"

src_install(){
	perl_set_version
	dobin seqlogo
	insinto /usr/share/"${PN}"
	doins logo.css logo.xml template.eps logo.conf.init clustal.dat globin.fasta test.html logo.cgi info.html README
	doins -r img
	insinto ${VENDOR_LIB}
	doins *.pm
	HTML_DOCS=( examples.html )
	DOCS=( Crooks-2004-GR-WebLogo.pdf )
	einstalldocs
}

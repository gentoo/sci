# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker

DESCRIPTION="Construction and assessment tool for spatially extended statistical processes used to test hypotheses about functional imaging data"
HOMEPAGE="http://www.fil.ion.ucl.ac.uk/spm/"
URI_BASE="http://www.fil.ion.ucl.ac.uk/spm/download/restricted/idyll/"
SRC_URI="" # SRC_URI is left blank on live ebuild

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

DEPEND="${RDEPEND}
	"

RDEPEND=">=sci-mathematics/octave-3.6.4
	"

S=${WORKDIR}/${PN}

src_unpack() {
	# We have to do this inside of here, since it's a live ebuild. :-(
	wget "${URI_BASE}${PN}.zip" || die
	unpack "./${PN}.zip"
	}

src_prepare() {
	cd "${S}"/src
	emake distclean PLATFORM=octave
	emake toolbox-distclean PLATFORM=octave
}

src_compile() {
	cd "${S}"/src
	emake -j1 PLATFORM=octave
	emake toolbox PLATFORM=octave
}

src_install() {
	cd "${S}"/src
        emake -j1 install PLATFORM=octave
        emake -j1 toolbox-install PLATFORM=octave
	dodir /opt/${PN}
	mv "${S}"/* "${ED}"/opt/${PN}
ewarn "SPM8 has _not_ been added to the octave path. If you wish to be able to
run it directly from the octave shell please run the following from your
octave shell:

	addpath('/opt/${PN}/')

You may make the path change persistent for your user by subsequently running:

	savepath()
 
"
}
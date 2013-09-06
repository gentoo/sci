# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker

DESCRIPTION="Construction and assessment tool for spatially extended statistical processes used to test hypotheses about functional imaging data"
HOMEPAGE="http://www.fil.ion.ucl.ac.uk/spm/"
URI_BASE="http://www.fil.ion.ucl.ac.uk/spm/download/restricted/idyll/"
URI_BASE_NAME="spm8"
SRC_URI="" # SRC_URI is left blank on live ebuild

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

DEPEND="net-misc/wget
	${RDEPEND}"

RDEPEND=">=sci-mathematics/octave-3.6.4
	"

S=${WORKDIR}/${URI_BASE_NAME}

src_unpack() {
	# We have to do this inside of here, since it's a live ebuild. :-(
	wget "${URI_BASE}${URI_BASE_NAME}.zip"
	unpack "./${URI_BASE_NAME}.zip"
	}

src_install() {
	cd src
	emake DESTDIR="${D}" distclean PLATFORM=octave
	emake DESTDIR="${D}" PLATFORM=octave && emake DESTDIR="${D}" install PLATFORM=octave
	emake DESTDIR="${D}" toolbox-distclean PLATFORM=octave
	emake DESTDIR="${D}" toolbox PLATFORM=octave && emake DESTDIR="${D}" toolbox-install PLATFORM=octave
	}
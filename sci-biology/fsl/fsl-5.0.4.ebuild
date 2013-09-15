# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Software library containing image analysis and statistical tools for functional, structural and diffusion MRI brain imaging data"
HOMEPAGE="http://www.fmrib.ox.ac.uk/fsl"
SRC_URI="http://fsl.fmrib.ox.ac.uk/fsldownloads/${P}-sources.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""

DEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack "${P}-sources.tar.gz"
	}

src_configure() {
	LDCONFIG="true" econf
	}

src_compile() {
	export FSLDIR=`pwd`
	. etc/fslconf/fsl.sh
	#cd ${FSLDIR}
	./build	
	}
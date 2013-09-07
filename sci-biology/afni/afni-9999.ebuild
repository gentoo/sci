# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI="http://afni.nimh.nih.gov/pub/dist/tgz/afni_src.tgz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	"

DEPEND="
	x11-libs/motif[static-libs]
	"

S=${WORKDIR}/afni_src

src_compile() {
	sed -e 's/-V 32//g' -i Makefile.linux_xorg7_64 # they provide somewhat problematic makefiles :(
	emake -j1 -f Makefile.linux_xorg7_64 totality suma XLIBS="-lXm -lXt" LGIFTI=-lexpat
	}

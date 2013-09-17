# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
URI_BASE="http://afni.nimh.nih.gov/pub/dist/tgz/"
URI_BASE_NAME="afni_src"
SRC_URI="" # SRC_URI is left blank on live ebuild

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	"

DEPEND="
	x11-libs/motif[-static-libs]
	app-shells/tcsh
	dev-libs/expat
	x11-libs/libXpm
	"

S=${WORKDIR}/${URI_BASE_NAME}

src_unpack() {
	wget "${URI_BASE}${URI_BASE_NAME}.tgz"
	unpack "./${URI_BASE_NAME}.tgz"
	}

src_prepare() {
	sed -e 's/-V 32//g' -i other_builds/Makefile.linux_fedora_19_64 # they provide somewhat problematic makefiles :(
	# sed -i 's/..\/MakeFile/.\/MakeFile/g' ./afni_src/ptaylor # they provide somewhat problematic makefiles :(
	cp other_builds/Makefile.linux_fedora_19_64 Makefile # some Makefile under ptaylor looks 	# for the parent makefile at "Makefile".	
	}

src_compile() {
	emake -j1 totality # suma XLIBS="-lXm -lXt" LGIFTI=-lexpat
	}

src_install() {
	insinto /opt/${PN}
	doins -r "${S}"/*
	}
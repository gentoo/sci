# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="Metaproject uniting all the available MINC tools"
HOMEPAGE="https://github.com/BIC-MNI/minc-toolkit"
SRC_URI=""
EGIT_REPO_URI="git://github.com/BIC-MNI/minc-toolkit.git"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS=""

COMMON_DEP="media-libs/freeglut
	x11-libs/libXmu
	x11-libs/libXi"

DEPEND="dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	${COMMON_DEP}"

RDEPEND="sci-libs/hdf5
	sci-libs/netcdf
	${COMMON_DEP}"

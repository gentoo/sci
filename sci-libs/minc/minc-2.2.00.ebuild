# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Medical Imaging file format and Toolbox"
HOMEPAGE="http://en.wikibooks.org/wiki/MINC"
SRC_URI="http://packages.bic.mni.mcgill.ca/tgz/${P}.tar.gz"
IUSE=""
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD"

COMMON_DEP="x11-libs/libXmu
	x11-libs/libXi"

DEPEND="sys-devel/flex
	sys-devel/autoconf
	sci-libs/netcdf
	sys-libs/zlib
	dev-perl/Text-Format
	dev-util/byacc
	${COMMON_DEP}"

RDEPEND="sci-libs/hdf5
	media-libs/netpbm
	${COMMON_DEP}"

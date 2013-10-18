# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Analysis of functional, structural, and diffusion MRI brain imaging data"
HOMEPAGE="http://www.fmrib.ox.ac.uk/fsl"
SRC_URI="http://fsl.fmrib.ox.ac.uk/fsldownloads/${P}-sources.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="media-libs/glu
	media-libs/libpng
	media-libs/gd
	sys-libs/zlib
	dev-libs/boost
	"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-lang/tcl
	dev-lang/tk
	"

S=${WORKDIR}/${PN}

TARGET_PATH="/usr/lib64/fsl"

src_prepare(){
	epatch "${FILESDIR}/${P}"-setup.patch
	epatch "${FILESDIR}/${P}"-headers.patch

	sed -i \
		-e "s:@@GENTOO_RANLIB@@:$(tc-getRANLIB):" \
		-e "s:@@GENTOO_CC@@:$(tc-getCC):" \
		-e "s:@@GENTOO_CXX@@:$(tc-getCXX):" \
		config/generic/systemvars.mk

	makefilelist=$(find src/ -name Makefile)

	sed -i \
		-e "s:-I\${INC_BOOST}::" \
		-e "s:-I\${INC_ZLIB}::" \
		-e "s:-I\${INC_GD}::" \
		-e "s:-I\${INC_PNG}::" \
		-e "s:-L\${LIB_GD}::" \
		-e "s:-L\${LIB_PNG}::" \
		-e "s:-L\${LIB_ZLIB}::" \
		${makefilelist}
}

src_compile() {
	export FSLDIR=${WORKDIR}/${PN}
	export FSLCONDIR=${WORKDIR}/${PN}/config
	export FSLMACHTYPE=generic

	export USERLDFLAGS="${LDFLAGS}"
	export USERCFLAGS="${CFLAGS}"
	export USERCXXFLAGS="${CXXFLAGS}"

	./build || die
}

src_install() {
	dodir "${TARGET_PATH}"

	# install files 
	COPY_DIRECTORIES="bin doc etc extras include lib refdoc tcl"
	for DIR in ${COPY_DIRECTORIES}; do
		cp -R "${S}/${DIR}" "${D}/${TARGET_PATH}/" || die "Install failed!"
	done

	# set up shell environment for all users
	insinto /etc/profile.d
	doins "${FILESDIR}"/fsl.sh || die
	insinto /etc/env.d
	doins "${FILESDIR}"/99fsl || die
}

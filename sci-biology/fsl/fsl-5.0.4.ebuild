# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Analysis of functional, structural, and diffusion MRI brain imaging data"
HOMEPAGE="http://www.fmrib.ox.ac.uk/fsl"
SRC_URI="http://fsl.fmrib.ox.ac.uk/fsldownloads/${P}-sources.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="media-libs/glu"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}/${PN}

TARGET_PATH="/usr/lib64/fsl"

src_compile() {

	export FSLDIR=${WORKDIR}/${PN}
	source etc/fslconf/fsl.sh
	addpredict /etc/ld.so.conf
	addpredict /etc/ld.so.cache

	# setting symbolic links for build configuration for gcc 4.6 and 4.7
	cd config && 
		ln -sfn linux_64-gcc4.4 linux_64-gcc4.6 && 
		ln -sfn linux_64-gcc4.4 linux_64-gcc4.7 && 
		cd .. || die 

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

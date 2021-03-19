# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Correction of electron beam-induced sample motion"
HOMEPAGE="https://emcore.ucsf.edu/ucsf-motioncor2"
SRC_URI="${PN}_${PV}.zip"
S="${WORKDIR}"/${PN}_${PV}

LICENSE="UCSF-Motioncor2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda92 +cuda102"
REQUIRED_USE="^^ ( cuda92 cuda102 )"
RESTRICT="fetch"

RDEPEND="
	cuda92? ( =dev-util/nvidia-cuda-toolkit-9.2* )
	cuda102? ( =dev-util/nvidia-cuda-toolkit-10.2* )
	media-libs/tiff
	app-arch/xz-utils
	media-libs/libjpeg-turbo
"
BDEPEND="app-arch/unzip"

pkg_nofetch() {
	elog "Please download ${PN}_${PV}.zip from:"
	elog "\t ${HOMEPAGE}"
	elog "and place it into your DISTDIR folder"
}

src_install() {
	dodoc MotionCor2-UserManual-10-08-2020.pdf \
	      MotionCor2_1.4.0_ReleaseIntro-10-14-2020.docx
	docompress -x /usr/share/doc/${PF}

	# package also has 10.0 10.1 11.0 versions
	# but these cuda versions are not in ::gentoo
	local mcbin
	if use cuda92; then
		mcbin="${PN}_${PV}_Cuda92"
	elif use cuda102; then
		mcbin="${PN}_${PV}_Cuda102"
	fi
	dobin "${mcbin}"
	dosym "${mcbin}" /usr/bin/MotionCor2
}

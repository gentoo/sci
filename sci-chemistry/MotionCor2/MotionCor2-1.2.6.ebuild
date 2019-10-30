# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Correction of electron beam-induced sample motion"
HOMEPAGE="https://emcore.ucsf.edu/ucsf-motioncor2"
SRC_URI="${PN}_${PV}.zip"

LICENSE="UCSF-Motioncor2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda92 +cuda101"

DEPEND="
	cuda92? ( =dev-util/nvidia-cuda-toolkit-9.2* )
	cuda101? ( =dev-util/nvidia-cuda-toolkit-10.1* )
	media-libs/tiff
	app-arch/xz-utils
	|| ( media-libs/jpeg:62 media-libs/libjpeg-turbo )
"
RDEPEND="${DEPEND}"
BDEPEND=""

REQUIRED_USE="^^ ( cuda92 cuda101 )"

RESTRICT="fetch"
VERSION="MotionCor2 v1.2.6 (05-22.2019, Linux) now Cuda v8.0,9.2,10.1"

S="${WORKDIR}"

pkg_nofetch() {
		echo
		elog "Please download ${PN}_${PV}.zip from"
		elog "${HOMEPAGE}."
		elog "Be sure to select the version ${VERSION} tarball!!"
		elog "Then move the tarball to"
		elog "${DISTDIR}/${PN}_${PV}.zip"
		echo
}

src_install() {
	dodoc MotionCor2-UserManual-09-13-2018.pdf
	if use cuda92; then
		newbin MotionCor2_1.2.6-Cuda92 ${PN}
	elif use cuda101; then
		newbin MotionCor2_1.2.6-Cuda101 ${PN}
	fi
}

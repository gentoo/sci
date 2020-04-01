# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="DICOM to NIfTI converter"
HOMEPAGE="https://github.com/rordenlab/dcm2niix"
SRC_URI="https://github.com/rordenlab/dcm2niix/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

pkg_postinst() {
	optfeature "parallel gzip support" app-arch/pigz
}

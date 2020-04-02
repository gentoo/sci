# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Converts Bruker ParaVision MRI data to the NIfTI file format"
HOMEPAGE="https://github.com/neurolabusc/Bru2Nii"
SRC_URI="https://github.com/neurolabusc/Bru2Nii/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui"

RDEPEND=""
DEPEND="dev-lang/fpc
	gui? ( dev-lang/lazarus )"

S="${WORKDIR}/Bru2Nii-${PV}"

src_compile() {
	fpc -Tlinux Bru2.lpr || die
	if use gui ; then
		lazbuild -B --lazarusdir="/usr/share/lazarus/" Bru2Nii.lpr || die
	fi
}

src_install() {
	dobin Bru2
	use gui && dobin Bru2Nii
	dodoc README.md
}

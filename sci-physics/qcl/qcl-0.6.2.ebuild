# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Quantum Computation Language with an emulator of a quantum computer"
HOMEPAGE="http://tph.tuwien.ac.at/~oemer/qcl.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="doc"
RESTRICT="nomirror"
SRC_URI="http://tph.tuwien.ac.at/~oemer/tgz/qcl-0.6.2.tgz
	doc? ( http://tph.tuwien.ac.at/~oemer/doc/structquprog.pdf
		http://tph.tuwien.ac.at/~oemer/doc/qcldoc.pdf
		http://tph.tuwien.ac.at/~oemer/doc/quprog.pdf )"
DEPENDS="media-libs/plotutils"

src_compile() {
	emake QCLDIR="/usr/share/${PN}" || die "emake failed"
}

src_install() {
	make QCLDIR="${D}/usr/share/${PN}" QCLBIN="${D}/usr/bin" install \
		|| die "install failed"
	dodoc README CHANGES
	if use doc ; then
		insinto "/usr/share/doc/${PF}"
		cd "${DISTDIR}"
		doins structquprog.pdf qcldoc.pdf quprog.pdf
	fi
}

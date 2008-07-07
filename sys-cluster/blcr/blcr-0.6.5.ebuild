# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Berkeley Lab Checkpoint/Restart for Linux"
HOMEPAGE="http://ftg.lbl.gov/CheckpointRestart/CheckpointRestart.shtml"
SRC_URI="http://ftg.lbl.gov/CheckpointRestart/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup() {
	# Kbuild.include:try_run appears to cause problems with
	# the sandbox for this package
	ewarn
	ewarn "This package is known to have issues with the sandbox"
	ewarn "If you experience problems, please re-emerge with:"
	ewarn "FEATURES=\"-sandbox -usersandbox\""
	ewarn

	linux-mod_pkg_setup
	MODULE_NAMES="blcr(blcr::${S}/cr_module/kbuild)
		blcr_imports(blcr::${S}/blcr_imports/kbuild)
		blcr_vmadump(blcr::${S}/vmadump4/kbuild)"
	BUILD_TARGETS="clean all"
	ECONF_PARAMS="--with-kernel=${KV_DIR}"
}


src_compile() {
	linux-mod_src_compile
	emake util || die "emake failed"
}

src_install() {
	linux-mod_src_install
	dodoc README NEWS
	cd "${S}"/util
	emake DESTDIR="${D}" install || die "binaries install failed"
	cd "${S}"/libcr
	emake DESTDIR="${D}" install || die "libcr install failed"
	cd "${S}"/man
	emake DESTDIR="${D}" install || die "man install failed"
	cd "${S}"/include
	emake DESTDIR="${D}" install || die "headers install failed"
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "Be sure to add blcr to your modules.autoload.d to"
	einfo "ensure that the modules get loaded on your next boot"
}

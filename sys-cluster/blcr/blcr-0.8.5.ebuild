# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-mod

DESCRIPTION="Berkeley Lab Checkpoint/Restart for Linux"
HOMEPAGE="https://ftg.lbl.gov/projects/CheckpointRestart"
SRC_URI="https://crd.lbl.gov/assets/Uploads/FTG/Projects/CheckpointRestart/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# up to kernel 2.6.38

pkg_setup() {
	local msg
	linux-info_pkg_setup

	# kernel version check
	if kernel_is gt 3 8; then
		eerror "${PN} is being developed and tested up to linux-3.7.x."
		eerror "It is known not to work with 3.8.x kernels"
		eerror "Make sure you have a proper kernel version and point"
		eerror "  /usr/src/linux symlink or env variable KERNEL_DIR to it!"
		die "Wrong kernel version ${KV_FULL}"
	fi

	linux-mod_pkg_setup
	MODULE_NAMES="blcr(blcr::${S}/cr_module/kbuild)
		blcr_imports(blcr::${S}/blcr_imports/kbuild)"
	BUILD_TARGETS="clean all"
	ECONF_PARAMS="--with-kernel=${KV_DIR}"

	MAKEOPTS+=" -j1"
}

src_install() {
	dodoc README NEWS
	cd "${S}"/util || die
	default
	cd "${S}"/libcr || die
	default
	cd "${S}"/man || die
	default
	cd "${S}"/include || die
	default
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "Be sure to add blcr to your modules.autoload.d to"
	einfo "ensure that the modules get loaded on your next boot"
}

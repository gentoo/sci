# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="Connectivity data from the Allen Mouse Brain data portal"
HOMEPAGE="https://github.com/IBT-FMI/ABI-connectivity-data"
SRC_URI="http://chymera.eu/distfiles/${P}.tar.xz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND=""

pkg_pretend() {
	CHECKREQS_DISK_BUILD="3G"
	CHECKREQS_DISK_USR="3G"
	CHECKREQS_DISK_VAR="3G"
	check-reqs_pkg_pretend
}

# We disable this phase to not check requirements twice.
pkg_setup() { :; }

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

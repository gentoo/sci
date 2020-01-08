# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="BIDS data files released with the IRSABI publication"
HOMEPAGE="http://www.aic-fmi.ethz.ch/"
SRC_URI="
	http://chymera.eu/distfiles/${P}.tar.xz
	https://zenodo.org/record/3601531/files/${P}.tar.xz
"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND=""

pkg_pretend() {
	CHECKREQS_DISK_BUILD="10G"
	check-reqs_pkg_pretend
}

# We disable this phase to not check requirements twice.
pkg_setup() { :; }

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

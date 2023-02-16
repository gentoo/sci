# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs

DESCRIPTION="BIDS data files released with the DRLFOM publication"
HOMEPAGE="http://chymera.eu/docs/focus/open-science/"
SRC_URI="
	https://zenodo.org/record/3598424/files/${P}.tar.xz
"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND=""

pkg_pretend() {
	CHECKREQS_DISK_BUILD="21G"
	check-reqs_pkg_pretend
}

# We disable this phase to not check requirements twice.
pkg_setup() { :; }

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

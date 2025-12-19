# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="A collection of rat brain templates in NIfTI format"
HOMEPAGE="https://gitlab.com/FOS-FMI/rat-brain-templates_generator"
SRC_URI="https://resources.chymera.eu/distfiles/${P}.tar.xz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_pretend() {
	CHECKREQS_DISK_BUILD="16G"
	check-reqs_pkg_pretend
}

# We disable this phase to not check requirements twice.
pkg_setup() { :; }

src_install() {
	insinto "/usr/share/${PN}"
	doins *
}

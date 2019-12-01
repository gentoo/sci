# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Portable, simple and extensible C++ logging library"
HOMEPAGE="https://github.com/SergiusTheBest/plog"

EGIT_REPO_URI="https://github.com/simoncblyth/plog.git"
EGIT_COMMIT="04c2389fac6def5471d2c8ff87d16a67c9e4045d"
KEYWORDS="~amd64"

LICENSE="MPL-2.0"
SLOT="0"

src_install() {
	doheader -r include/${PN}
	dodoc README.md
}

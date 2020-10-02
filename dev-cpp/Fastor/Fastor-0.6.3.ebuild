# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="light-weight high performance tensor algebra framework"
HOMEPAGE="https://github.com/romeric/Fastor"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/romeric/Fastor"
else
	SRC_URI="https://github.com/romeric/Fastor/archive/V${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

src_install() {
	doheader -r Fastor
}

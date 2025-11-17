# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

DESCRIPTION="compare unformatted text files with numerical content"
HOMEPAGE="https://github.com/quinoacomputing/ndiff"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	COMMIT="3154ade48853851bd82251f3e98dded92c9998f0"
	SRC_URI="https://github.com/quinoacomputing/ndiff/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

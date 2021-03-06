# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Bayesian gen. variant detector to find short polymorphisms"
HOMEPAGE="https://github.com/ekg/freebayes"
SRC_URI="https://github.com/freebayes/freebayes/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests not included in release tarball?
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}
	sci-libs/htslib
	sci-biology/bamtools
	sci-biology/samtools:*"

S="${WORKDIR}/${PN}"

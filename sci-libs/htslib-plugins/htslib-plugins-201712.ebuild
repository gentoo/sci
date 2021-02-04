# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="iRODs plugins for >=htslib-1.4"
HOMEPAGE="https://github.com/samtools/htslib-plugins"
SRC_URI="https://github.com/samtools/htslib-plugins/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND=">=sci-libs/iRODS-3"
RDEPEND="${DEPEND}"

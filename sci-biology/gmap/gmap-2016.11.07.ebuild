# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MY_BASE_PV="$(replace_all_version_separators '-' $(get_version_component_range 1-3))"
MY_PV="${MY_BASE_PV}"

DESCRIPTION="DNA and splice-aware RNA/cDNA read aligners/mappers (gmap and gsnap)"
HOMEPAGE="http://research-pub.gene.com/gmap/"
SRC_URI="http://research-pub.gene.com/gmap/src/gmap-gsnap-${MY_PV}.tar.gz"

LICENSE="gmap"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/gmap-${MY_BASE_PV}"

# TODO: respect avx2

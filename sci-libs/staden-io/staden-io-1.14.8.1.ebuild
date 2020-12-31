# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="File reading and writing code to provide a general purpose trace file interface"
HOMEPAGE="https://github.com/COMBINE-lab/staden-io_lib"
SRC_URI="https://github.com/COMBINE-lab/staden-io_lib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}_lib-${PV}"

# TODO: why doesn't this work?
RESTRICT="test"

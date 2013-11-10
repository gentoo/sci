# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python based program for visualization of data from Freesurfer"
HOMEPAGE="http://pysurfer.github.com"
SRC_URI="https://github.com/nipy/PySurfer/archive/${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-visualization/mayavi"
DEPEND=""

S="${WORKDIR}/PySurfer-${PV}"

src_unpack() {
    unpack ${A}
    cd "${S}"
    epatch "${FILESDIR}/${PV}-headless_build.patch"
}

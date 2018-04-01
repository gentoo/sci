# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Filter, split and trim NGS sequence data"
HOMEPAGE="https://github.com/JoseBlanca/seq_crumbs"
SRC_URI="https://github.com/JoseBlanca/"${PN}"/archive/v"${PV}".tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=sci-biology/biopython-1.60
	>=sci-biology/pysam-0.8
	>=dev-python/rpy-2
	dev-python/matplotlib
	dev-python/configobj
	dev-python/toolz"
RDEPEND="${DEPEND}"

# TODO fix file collisions
#  * Detected file collision(s):
#  * 
#  * 	/usr/share/man/man1/index.1.bz2
#  * 	/usr/share/man/man1/install.1.bz2
#  * 
#  * Searching all installed packages for file collisions...
#  * 
#  * Press Ctrl-C to Stop
#  * 
#  * sys-apps/coreutils-8.29:0::gentoo
#  * 	/usr/share/man/man1/install.1.bz2
#  * 
#  * media-libs/netpbm-10.76.00:0::gentoo
#  * 	/usr/share/man/man1/index.1.bz2
src_prepare(){
	sed -e "s#sys.prefix#os.getenv('ED')+'/usr/'#" -i setup.py || die
	default
}

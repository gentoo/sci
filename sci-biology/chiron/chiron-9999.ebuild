# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 eutils git-r3

DESCRIPTION="Basecaller for OxfordNanopore data using deep learning"
HOMEPAGE="https://github.com/haotianteng/chiron
	https://www.biorxiv.org/content/early/2017/09/12/179531"
EGIT_REPO_URI="https://github.com/haotianteng/chiron"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="=sci-libs/tensorflow-1.0.1"
RDEPEND="${DEPEND}
	dev-python/h5py"

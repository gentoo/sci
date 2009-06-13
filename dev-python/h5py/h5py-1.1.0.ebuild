# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A simple Python interface to HDF5 files."
HOMEPAGE="http://h5py.alfven.org/"
SRC_URI="http://h5py.googlecode.com/files/${P}-1.6.tar.gz"

LICENSE="h5py hdf5 pytables"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-libs/hdf5-1.6.7
	>=dev-lang/python-2.4"
RDEPEND="${DEPEND}"



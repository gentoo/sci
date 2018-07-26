# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 git-r3

DESCRIPTION="A pure python package for parsing DICOM files"
HOMEPAGE="http://www.pydicom.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/darcymason/pydicom"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${S}/source"

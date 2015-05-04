# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2

inherit eutils

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation"
HOMEPAGE="http://www.salome-platform.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug mpi"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sci-misc/salome-kernel-5.1.3*[debug?,mpi?]
		 =sci-misc/salome-gui-5.1.3*[debug?]
		 =sci-misc/salome-med-5.1.3*[debug?,mpi?]
		 =sci-misc/salome-geom-5.1.3*[debug?]
		 =sci-misc/salome-smesh-5.1.3*[debug?]
		 =sci-misc/salome-visu-5.1.3*[debug?]
		 =sci-misc/salome-component-5.1.3*[debug?,mpi?]
		 =sci-misc/salome-yacs-5.1.3*[debug?]
		 =sci-misc/salome-pycalculator-5.1.3*[debug?]"

DEPEND="${RDEPEND}"

pkg_postinst() {
	einfo "Salome ebuild needs further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=155974"
}

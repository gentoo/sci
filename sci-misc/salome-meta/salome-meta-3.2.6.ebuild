# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation"
HOMEPAGE="http://www.salome-platform.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="=sci-misc/salome-kernel-${PV}*
	=sci-misc/salome-gui-${PV}*
	=sci-misc/salome-med-${PV}*
	=sci-misc/salome-geom-${PV}*
	=sci-misc/salome-smesh-${PV}*
	=sci-misc/salome-visu-${PV}*
	=sci-misc/salome-superv-${PV}*
	=sci-misc/salome-component-${PV}*
	=sci-misc/salome-pycalculator-${PV}*"

pkg_postinst() {
	einfo "Salome ebuild needs further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=155974"
}


# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="=sci-misc/salome-kernel-3.2.6*
	=sci-misc/salome-gui-3.2.6*
	=sci-misc/salome-med-3.2.6*
	=sci-misc/salome-geom-3.2.6*
	=sci-misc/salome-smesh-3.2.6*
	=sci-misc/salome-visu-3.2.6*
	=sci-misc/salome-superv-3.2.6*
	=sci-misc/salome-component-3.2.6*
	=sci-misc/salome-pycalculator-3.2.6*"

pkg_postinst() {
	einfo "Salome ebuild needs further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=155974"
}

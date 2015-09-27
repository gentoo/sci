# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for Message Passing Interface (MPI) v2.0 implementation"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cxx fortran romio threads"

RDEPEND="|| (
	>=sys-cluster/openmpi-1.8.4-r3[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	>=sys-cluster/mpich-3.1.3-r1[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	abi_x86_64? ( !abi_x86_32? ( sys-cluster/mvapich2[fortran?,romio?,threads?] ) )
	x86? ( sys-cluster/mvapich2[fortran?,romio?,threads?] )
	prefix? ( sys-cluster/native-mpi )
)"

DEPEND=""

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils git-r3

DESCRIPTION="MPI substitute library"
HOMEPAGE="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/olenz/NullMPI.git"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="
	!sys-cluster/lam-mpi
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/mpiexec"
DEPEND="${RDEPEND}"

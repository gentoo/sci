# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/olenz/NullMPI.git"
EGIT_BRANCH="master"

inherit autotools-utils git-2

DESCRIPTION="MPI substitute library"
HOMEPAGE="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/"
SRC_URI=""

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs"

RDEPEND="
	!sys-cluster/lam-mpi
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/mpiexec"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog README TODO )

S="${WORKDIR}/${EGIT_REPO_URI##*/}"

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

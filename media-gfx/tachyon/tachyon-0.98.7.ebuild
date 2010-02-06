# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A portable, high performance parallel ray tracing system"
HOMEPAGE="http://jedi.ks.uiuc.edu/~johns/raytracer/"
SRC_URI="http://jedi.ks.uiuc.edu/~johns/raytracer/files/${PV}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples jpeg mpi opengl png threads"

RESTRICT="mirror"

DEPEND="jpeg? ( media-libs/jpeg )
	mpi? ( virtual/mpi )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}/unix"

# TODO: Test on alpha, ia64, ppc
# TODO: MPI: Depend on lam or virtual ? Test MPI
# TODO: Check for threads dependencies
# TODO: add other architectures
# TODO: X, Motif, MBOX, Open Media Framework, Spaceball I/O, MGF ?

TACHYON_MAKE_TARGET=

pkg_setup() {
	if use threads ; then
		if use opengl ; then
			TACHYON_MAKE_TARGET=linux-thr-ogl
			if use mpi ; then
				eerror "tachyon does not support MPI with OpenGL and threads"
				die
			fi
		elif use mpi ; then
			TACHYON_MAKE_TARGET=linux-mpi-thr
		else
			TACHYON_MAKE_TARGET=linux-thr
		fi

		# TODO: Support for linux-athlon-thr ?
	else
		if use opengl ; then
			# TODO: Support target: linux-lam-64-ogl

			eerror "OpenGL is only available with USE=threads!"
		elif use mpi ; then
				TACHYON_MAKE_TARGET=linux-mpi
		else
			TACHYON_MAKE_TARGET=linux
		fi

		# TODO: Support for linux-p4, linux-athlon, linux-ps2 ?
	fi

	if [[ -z "${TACHYON_MAKE_TARGET}" ]]; then
		eerror "No target found, check use flags" && die
	else
		einfo "Using target: ${TACHYON_MAKE_TARGET}"
	fi
}

src_prepare() {
	if use jpeg ; then
		sed -i \
			-e "s:USEJPEG=:USEJPEG=-DUSEJPEG:g" \
			-e "s:JPEGLIB=:JPEGLIB=-ljpeg:g" Make-config \
			|| die "sed failed"
	fi

	if use png ; then
		sed -i \
			-e "s:USEPNG=:USEPNG=-DUSEPNG:g" \
			-e "s:PNGINC=:PNGINC=$(libpng-config --cflags):g" \
			-e "s:PNGLIB=:PNGLIB=$(libpng-config --ldflags):g" Make-config \
			|| die "sed failed"
	fi

	if use mpi ; then
		sed -i "s:MPIDIR=:MPIDIR=/usr:g" Make-config || die "sed failed"
		sed -i "s:linux-lam:linux-mpi:g" Make-config || die "sed failed"
	fi
	sed -i \
		-e "s:-O3::g;s:-g::g;s:-pg::g" \
		-e "s:-m32:${CFLAGS}:g" \
		-e "s:-m64:${CFLAGS}:g" \
		-e "s:-ffast-math::g" \
		-e "s:-fomit-frame-pointer::g" Make-arch || die "sed failed"
}

src_compile() {
	emake "${TACHYON_MAKE_TARGET}" || die "emake failed"
}

src_install() {
	cd ..
	dodoc Changes README

	if use doc ; then
		dohtml docs/tachyon/*
	fi

	cd "compile/${TACHYON_MAKE_TARGET}"

	dobin tachyon
	dolib libtachyon.a

	if use examples; then
		cd "${S}/../scenes"
		insinto "/usr/share/${PN}/examples"
		doins *
	fi
}

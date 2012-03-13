# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs versionator flag-o-matic

# use esmumps version to allow linking with mumps
MYP="${PN}_${PV}_esmumps"
# download id on gforge changes every goddamn release
DID=28978

DESCRIPTION="Software for graph, mesh and hypergraph partitioning"
HOMEPAGE="http://www.labri.u-bordeaux.fr/perso/pelegrin/scotch/"
SRC_URI="http://gforge.inria.fr/frs/download.php/${DID}/${MYP}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples int64 mpi static-libs tools"

DEPEND="sys-libs/zlib
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MYP/b}"

LIBVER=$(get_major_version)
make_shared_lib() {
	local libstatic=${1}
	if [[ ${CHOST} == *-darwin* ]] ; then
		local dylibname=$(basename "${1%.a}").dylib
		shift
		einfo "Making ${dylibname}"
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${dylibname}" \
			-Wl,-all_load -Wl,"${libstatic}" \
			"$@" -o $(dirname "${libstatic}")/"${dylibname}" || die
	else
		local soname=$(basename "${1%.a}").so.${LIBVER}
		shift
		einfo "Making ${soname}"
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname="${soname}" \
			-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
			"$@" -o $(dirname "${libstatic}")/"${soname}" || die "${soname} failed"
		ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	sed -e "s/-O3/${CFLAGS}/" \
		-e "s/gcc/$(tc-getCC)/" \
		-e "s/ ar/ $(tc-getAR)/" \
		-e "s/ranlib/$(tc-getRANLIB)/" \
		src/Make.inc/Makefile.inc.i686_pc_linux2 > src/Makefile.inc || die
	use int64 && append-cflags -DIDXSIZE64
}

src_compile() {
	emake -C src CLIBFLAGS=-fPIC
	make_shared_lib lib/libscotcherr.a
	make_shared_lib lib/libscotcherrexit.a
	make_shared_lib lib/libscotch.a -Llib -lz -lm -lrt -lscotcherr
	make_shared_lib lib/libesmumps.a -Llib -lscotch
	make_shared_lib lib/libscotchmetis.a -Llib -lscotch

	if use mpi; then
		emake -C src CLIBFLAGS=-fPIC ptscotch
		export LINK=mpicc
		make_shared_lib lib/libptscotcherr.a
		make_shared_lib lib/libptscotcherrexit.a
		make_shared_lib lib/libptscotch.a -Llib -lptscotcherr -lz -lm -lrt
		make_shared_lib lib/libptesmumps.a -Llib -lptscotch
		make_shared_lib lib/libptscotchparmetis.a -Llib -lptscotch
	fi
	if use static-libs; then
		emake -C src clean
		emake -C src
		use mpi && emake -C src ptscotch
	fi
}

src_install() {
	dolib.so lib/*.so*
	use static-libs && dolib.a lib/*.a

	insinto /usr/include/scotch
	doins include/*

	cat <<-EOF > scotchmetis.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: scotchmetis
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lscotchmetis -lscotcherr -lscotch
		Private: -lm -lz -lrt
		Cflags: -I\${includedir}/scotch
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins scotchmetis.pc

	# not sure it is actually a full replacement of metis
	#alternatives_for metis scotch 0 \
	#	/usr/$(get_libdir)/pkgconfig/metis.pc scotchmetis.pc

	if use mpi; then
		cat <<-EOF > ptscotchparmetis.pc
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include
			Name: ptscotchparmetis
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -lptscotchparmetis -lptscotcherr -lptscotch
			Private: -lm -lz -lrt
			Cflags: -I\${includedir}/scotch
			Requires: scotchmetis
		EOF
			insinto /usr/$(get_libdir)/pkgconfig
			doins ptscotchparmetis.pc
			# not sure it is actually a full replacement of parmetis
			#alternatives_for metis-mpi ptscotch 0 \
			#	/usr/$(get_libdir)/pkgconfig/metis-mpi.pc ptscotchparmetis.pc
	fi

	dodoc README.txt

	if use tools; then
		local b m
		pushd bin > /dev/null
		for b in *; do
			newbin ${b} scotch_${b}
		done
		popd > /dev/null

		pushd man/man1 > /dev/null
		for m in *; do
			newman ${m} scotch_${m}
		done
		popd > /dev/null
	fi

	use doc && dodoc doc/*.pdf

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* tgt grf
	fi
}

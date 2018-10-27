# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic fortran-2 multilib python-single-r1 toolchain-funcs

DATE="2015-10-20"

DESCRIPTION="Delivering High-Performance Computational Chemistry to Science"
HOMEPAGE="http://www.nwchem-sw.org/index.php/Main_Page"
PATCH_REPO="http://www.nwchem-sw.org/images"
PATCH_LIST="Tddft_mxvec20 Tools_lib64 Config_libs66 Cosmo_meminit Sym_abelian
Xccvs98 Dplot_tolrho Driver_smalleig Ga_argv Raman_displ Ga_defs Zgesvd Cosmo_dftprint"
SRC_URI="http://www.nwchem-sw.org/images/Nwchem-${PV%_p*}.revision${PV#*_p}-src.${DATE}.tar.bz2
	$(for p in ${PATCH_LIST[@]}; do echo ${PATCH_REPO}/${p}.patch.gz; done)"

LICENSE="ECL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="blas cuda doc examples infiniband int64 lapack mrcc nwchem-tests openmp python scalapack"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	scalapack? ( !int64 )
	lapack? ( blas )
	scalapack? ( blas )"

RDEPEND="
	sys-fs/sysfsutils
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )
	scalapack? ( virtual/scalapack )
	cuda? ( dev-util/nvidia-cuda-sdk )
	int64? (
		blas? ( virtual/blas[int64] )
		lapack? ( virtual/lapack[int64] )
	)
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-shells/tcsh
	virtual/mpi[fortran]
	infiniband? ( || (
		sys-cluster/openmpi[fortran,openmpi_fabrics_ofed]
		sys-cluster/mvapich2[fortran]
	) )
	doc? (
		dev-texlive/texlive-latex
		dev-tex/latex2html )"

LONG_S="${WORKDIR}/Nwchem-${PV%_p*}.revision${PV#*_p}-src.${DATE}"
S="${WORKDIR}/${PN}-${PV%_p*}"

pkg_setup() {
	# fortran-2.eclass does not handle mpi wrappers
	export FC="mpif90"
	export F77="mpif77"
	export CC="mpicc"
	export CXX="mpic++"

	use openmp && FORTRAN_NEED_OPENMP=1

	fortran-2_pkg_setup

	if use openmp; then
		# based on _fortran-has-openmp() of fortran-2.eclass
		local openmp=""
		local fcode=ebuild-openmp-flags.f
		local _fc=$(tc-getFC)

		pushd "${T}"
		cat <<- EOF > "${fcode}"
		1     call omp_get_num_threads
		2     end
		EOF

		for openmp in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
			"${_fc}" "${openmp}" "${fcode}" -o "${fcode}.x" && break
		done

		rm -f "${fcode}.*"
		popd

		export FC="${FC} ${openmp}"
		export F77="${F77} ${openmp}"
		export CC="${CC} ${openmp}"
		export CXX="${CXX} ${openmp}"
	fi

	use python && python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
	mv "${LONG_S}" "${S}"
}

src_prepare() {
	for p in ${PATCH_LIST[@]}
		do epatch "${WORKDIR}"/"${p}.patch"
	done
	epatch "${FILESDIR}"/nwchem-6.1.1-nwchemrc.patch
	epatch "${FILESDIR}"/nwchem-6.5-icosahedron_zcoord.patch
	epatch "${FILESDIR}"/nwchem-6.6-unique_tags.patch
	use python && epatch "${FILESDIR}"/nwchem-6.5-python_makefile.patch
	use doc && epatch "${FILESDIR}"/nwchem-6.3-r1-html_doc.patch

	sed \
		-e "s:DBASIS_LIBRARY=\"'\$(SRCDIR)'\":DBASIS_LIBRARY=\"'${EPREFIX}/usr/share/NWChem'\":g" \
		-i src/basis/MakeFile src/basis/GNUmakefile || die
	sed \
		-e "s:DNWPW_LIBRARY=\"'\$(SRCDIR)'\":DNWPW_LIBRARY=\"'${EPREFIX}/usr/share/NWChem'\":g" \
		-i src/nwpw/libraryps/GNUmakefile || die
	sed \
		-e "s:-DCOMPILATION_DIR=\"'\$(TOPDIR)'\":-DCOMPILATION_DIR=\"''\":g" \
		-i src/GNUmakefile src/MakeFile || die

	if [[ $(tc-getFC) == *-*-*-*-gfortran ]]; then
		sed \
			-e "s:ifneq (\$(FC),gfortran):ifneq (\$(FC),$(tc-getFC)):g" \
			-e "s:ifeq (\$(FC),gfortran):ifeq (\$(FC),$(tc-getFC)):g" \
			-i src/config/makefile.h || die
	fi
}

src_compile() {
	export NWCHEM_LONG_PATHS=Y
	use openmp && export USE_OPENMP=1
	export USE_MPI=y
	export USE_MPIF=y
	export USE_MPIF4=y
	export MPI_LOC="${EPREFIX}"/usr
	export MPI_INCLUDE=$MPI_LOC/include
	export MPI_LIB=$MPI_LOC/$(get_libdir)
	export LIBMPI="$(mpif90 -showme:link)"
	if use infiniband; then
		export ARMCI_NETWORK=OPENIB
		export MSG_COMMS=MPI
		export IB_INCLUDE="-I${MPI_INCLUDE}"
		export IB_LIB="-L${MPI_LIB}"
	else
		unset ARMCI_NETWORK
	fi
	if [ "$ARCH" = "amd64" ]; then
		export NWCHEM_TARGET=LINUX64
	elif [ "$ARCH" = "ia64" ]; then
		export NWCHEM_TARGET=LINUX64
	elif [ "$ARCH" = "x86" ]; then
		export NWCHEM_TARGET=LINUX
	elif [ "$ARCH" = "ppc" ]; then
		export NWCHEM_TARGET=LINUX
	else
		die "Unknown architecture"
	fi
	if use python ; then
		if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "ia64" ]; then
			export USE_PYTHON64=yes
		fi
		export PYTHONHOME=/usr
		export PYTHONVERSION=$(eselect python show --python2 |awk -Fpython '{ print $2 }')
		export PYTHONPATH="./:${S}/contrib/python/"
		export NWCHEM_MODULES="all python"
	else
		export NWCHEM_MODULES="all"
	fi
	use mrcc && export MRCC_METHODS="TRUE" # Multi Reference Coupled Clusters
	export CCSDTQ="TRUE"                   # Coupled Clusters Singlets + Dublets + Triplets + Quadruplets
	export CCSDTLR="TRUE"                  # CCSDT (and CCSDTQ?) Linear Response
	export EACCSD="TRUE"                   # Electron Affinities at the CCSD level
	export IPCCSD="TRUE"                   # Ionisation Potentials at the CCSD level
	unset BLASOPT
	local blaspkg="blas"
	local lapackpkg="lapack"
	if use int64; then
		blaspkg="blas-int64"
		lapackpkg="lapack-int64"
	fi
	use blas && export BLASOPT="$($(tc-getPKG_CONFIG) --libs ${blaspkg})"
	use lapack && export BLASOPT+=" $($(tc-getPKG_CONFIG) --libs ${lapackpkg})"
	use scalapack && export BLASOPT+=" $($(tc-getPKG_CONFIG) --libs scalapack)"
	if use cuda; then
		export TCE_CUDA=Y
		export CUDA_PATH=/opt/cuda
		export CUDA=${CUDA_PATH}/bin/nvcc
		export CUDA_FLAGS="-arch=compute_20 -code=sm_20,compute_20"
		export CUDA_INCLUDE="-I${CUDA_PATH}/include"
		export CUDA_LIBS="-L${CUDA_PATH}/$(get_libdir) -lcublas -lcufft -lcudart -lcuda -lstdc++"
	fi
	export LARGE_FILES="TRUE"

	cd src
	if use blas && [ "$NWCHEM_TARGET" = "LINUX64" ]; then
		if use int64; then
			export BLAS_SIZE=8
			export LAPACK_SIZE=8
			export SCALAPACK_SIZE=8
		else
			emake \
				DIAG=PAR \
				FC="$(tc-getFC)" \
				CC="$(tc-getCC)" \
				CXX="$(tc-getCXX)" \
				NWCHEM_TOP="${S}" \
				clean
			emake \
				DIAG=PAR \
				FC="$(tc-getFC)" \
				CC="$(tc-getCC)" \
				CXX="$(tc-getCXX)" \
				NWCHEM_TOP="${S}" \
				64_to_32
			export BLAS_SIZE=4
			export LAPACK_SIZE=4
			export SCALAPACK_SIZE=4
			export USE_64TO32=y
		fi
	fi
	emake \
		DIAG=PAR \
		FC="$(tc-getFC)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		NWCHEM_TOP="${S}" \
		NWCHEM_EXECUTABLE="${S}/bin/${NWCHEM_TARGET}/nwchem" \
		nwchem_config
	emake \
		DIAG=PAR \
		FC="$(tc-getFC)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		NWCHEM_TOP="${S}" \
		NWCHEM_EXECUTABLE="${S}/bin/${NWCHEM_TARGET}/nwchem"

	if use doc; then
		cd "${S}"/doc
		export VARTEXFONTS="${T}/fonts"
		emake \
			DIAG=PAR \
			NWCHEM_TOP="${S}" \
			pdf html
	fi
}

src_install() {
	dobin bin/${NWCHEM_TARGET}/nwchem

	insinto /usr/share/NWChem/basis/
	doins -r src/basis/libraries src/data
	insinto /usr/share/NWChem/nwpw
	doins -r src/nwpw/libraryps

	insinto /etc
	doins nwchemrc

	use examples && \
		insinto /usr/share/NWChem/ && \
		doins -r examples

	use nwchem-tests && \
		insinto /usr/share/NWChem && \
		doins -r QA/tests

	use doc && \
		insinto /usr/share/doc/"${P}" && \
		doins -r doc/nwahtml && \
		doins -r web

}

pkg_postinst() {
	echo
	elog "The user will need to link \$HOME/.nwchemrc to /etc/nwchemrc"
	elog "or copy it in order to tell NWChem the right position of the"
	elog "basis library and other necessary data."
	echo
}

# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit eutils toolchain-funcs cmake-utils python-single-r1

MYP=InsightToolkit-${PV}

DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="http://www.itk.org"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

RESTRICT="primaryuri"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples fftw itkv3compat python review sse2 test"

RDEPEND="
	sci-libs/hdf5[cxx]
	virtual/jpeg
	media-libs/libpng
	media-libs/tiff:0
	sys-libs/zlib
	fftw? ( sci-libs/fftw:3.0 )
"
DEPEND="${RDEPEND}
	python? ( ${PYTHON_DEPS}
			  >=dev-lang/swig-2.0
			  >=dev-cpp/gccxml-0.9.0_pre20120309 )
"

S="${WORKDIR}/${MYP}"

pkg_pretend() {
	if [[ -z ${ITK_COMPUTER_MEMORY_SIZE} ]]; then
		elog "To tune ITK to make the best use ouf working memory you can set"
		elog "    ITK_COMPUTER_MEMORY_SIZE=XX"
		elog "in make.conf, default is 1 (unit is GB)"
	fi
	if use python && [[ -z ${ITK_WRAP_DIMS} ]]; then
		elog "For Python language bindings, you can define the dimensions"
		elog "you want to create bindings for by setting"
		elog "    ITK_WRAP_DIMS=X;Y;Z..."
		elog "in make.conf, default is 2;3 for 2D and 3D data"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWRAP_ITK_JAVA=OFF
		-DWRAP_ITK_TCL=OFF
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_PNG=ON
		-DITK_USE_SYSTEM_TIFF=ON
		-DITK_USE_SYSTEM_ZLIB=ON
		-DITK_USE_SYSTEM_GCCXML=ON
		-DITK_USE_SYSTEM_SWIG=ON
		-DITK_BUILD_ALL_MODULES=ON
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_EXAMPLES=OFF
		-DITK_COMPUTER_MEMORY_SIZE="${ITK_COMPUTER_MEMORY_SIZE:-1}"
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use review ITK_USE_REVIEW)
		$(cmake-utils_use itkv3compat ITKV3_COMPATIBILITY)
		$(cmake-utils_use sse2 VNL_CONFIG_ENABLE_SSE2)
	)
	if use fftw; then
		mycmakeargs+=(
			-DUSE_FFTWD=ON
			-DUSE_FFTWF=ON
			-DUSE_SYSTEM_FFTW=ON
			-DITK_WRAP_double=ON
			-DITK_WRAP_vector_double=ON
			-DITK_WRAP_covariant_vector_double=ON
			-DITK_WRAP_complex_double=ON
		)
	fi
	if use python; then
		mycmakeargs+=(
			-DITK_WRAP_PYTHON=ON
			-DITK_WRAP_DIMS="${ITK_WRAP_DIMS:-2;3}"
		)
	else
		mycmakeargs+=(
			-DITK_WRAP_PYTHON=OFF
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		docompress -x /usr/share/doc/${PF}/examples
		doins -r "${S}"/Examples/*
	fi

	echo "ITK_DATA_ROOT=${EROOT}/usr/share/${PN}/data" > ${T}/40${PN}
	local ldpath="${EROOT}/usr/$(get_libdir)/InsightToolkit"
	if use python; then
		echo "PYTHONPATH=${EROOT}/usr/$(get_libdir)/InsightToolkit/WrapITK/Python" >> ${T}/40${PN}
		ldpath="${ldpath}:${EROOT}/usr/$(get_libdir)/InsightToolkit/WrapITK/lib"
	fi
	echo "LDPATH=${ldpath}" >> ${T}/40${PN}

	doenvd "${T}"/40${PN}
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Finite State Transducer tools by Google et al"
HOMEPAGE="http://www.openfst.org"
SRC_URI="http://www.openfst.org/twiki/pub/FST/FstDownload/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
KEYWORDS="~amd64 ~x86"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

NORMAL_BUILD_DIR="${WORKDIR}/${P}"

src_configure() {
	openfst_configure() {
		ECONF_SOURCE="${S}" econf \
			--enable-compact-fsts \
			--enable-compress \
			--enable-const-fsts \
			--enable-far \
			--enable-linear-fsts \
			--enable-lookahead-fsts \
			--enable-mpdt \
			--enable-ngram-fsts \
			--enable-pdt \
			--enable-special \
			--enable-bin \
			--enable-grm \
			"$@"
	}

	openfst_py_configure() {
		mkdir -p "${BUILD_DIR}" || die
		run_in_build_dir openfst_configure --enable-python
	}

	if use python; then
		python_foreach_impl openfst_py_configure
	fi

	openfst_configure
}

src_compile() {
	default

	if use python; then
		openfst_foreach_py_emake pywrapfst_la_LIBADD="\
			${NORMAL_BUILD_DIR}/src/extensions/far/libfstfarscript.la\
			${NORMAL_BUILD_DIR}/src/extensions/far/libfstfar.la\
			${NORMAL_BUILD_DIR}/src/script/libfstscript.la\
			${NORMAL_BUILD_DIR}/src/lib/libfst.la\
			-lm \$(DL_LIBS)" all
	fi
}

src_install() {
	default

	if use python; then
		openfst_foreach_py_emake DESTDIR="${D}" install
	fi
}

openfst_foreach_py_emake() {
	openfst_py_emake() {
		pushd "${BUILD_DIR}/src/extensions/python" > /dev/null || die
		emake "$@"
		popd > /dev/null
	}

	python_foreach_impl openfst_py_emake \
		VPATH="${NORMAL_BUILD_DIR}/src/extensions/python" "$@"
}

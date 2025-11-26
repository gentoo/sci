# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1 optfeature

MY_PN="MadAnalysis5"
MY_PF=madanalysis5-${PV}

DESCRIPTION="A package for event file analysis and recasting of LHC results"
HOMEPAGE="
	https://github.com/MadAnalysis/madanalysis5
"
SRC_URI="https://github.com/MadAnalysis/madanalysis5/archive/refs/tags/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S=${WORKDIR}/${MY_PF}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-libs/zlib
	sci-physics/fastjet[${PYTHON_SINGLE_USEDEP}]
	sci-physics/root[${PYTHON_SINGLE_USEDEP}]
	sci-physics/delphes
	$(python_gen_cond_dep '
		>=dev-python/spey-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/spey-pyhf-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19.5[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.4.2[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.6.2[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

# Perserve permissions
src_unpack() {
	tar xvzf "${DISTDIR}/${MY_PN}-${PV}.tar.gz" -C "${WORKDIR}"
}

src_configure() {
	default
	# Won't find system installed delphes otherwise
	sed -i -e "s|self.delphes_includes\s*=\s*None|self.delphes_includes=\"${EPREFIX}/usr/include\"|" madanalysis/system/user_info.py || die
	sed -i -e "s|self.delphes_libs\s*=\s*None|self.delphes_libs=\"${EPREFIX}/usr/$(get_libdir)\"|" madanalysis/system/user_info.py || die
	# Fix include path
	sed -i 's|#include "external/ExRootAnalysis|#include "ExRootAnalysis|g' tools/SampleAnalyzer/Interfaces/delphes/*.cpp || die
}

src_compile() {
	default
	echo "1" | ./bin/ma5 --build || die
}

src_install() {
	# symlink entrypoint
	dosym ../../opt/${MY_PF}/bin/ma5 /usr/bin/ma5
	dosym  ../opt/${MY_PF} /opt/"${MY_PN}"
	mv "${WORKDIR}/${MY_PF}" "${ED}/opt/" || die

	#fperms -R a=u /opt/${MY_PF}
}

pkg_postinstall() {
	optfeature "latex support" virtual/latex-base
	optfeature "gnuplot support" sci-visualization/gnuplot
}

# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

DISTUTILS_OPTIONAL=1

inherit python-r1

DESCRIPTION="Documentation reference for PyTorch."
HOMEPAGE="https://pytorch.org/docs"
PYTORCH_NAME=${PN:0:7}
REPO_URI="https://github.com/${PYTORCH_NAME}/${PYTORCH_NAME}"
SRC_URI="${REPO_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-python/numpy
	dev-python/matplotlib
	>=sci-libs/pytorch-${PV}
	sci-libs/torchvision
	dev-python/sphinxcontrib-katex
	dev-python/javasphinx
	dev-python/pytorch-sphinx-theme
"

PATCHES=(
	"${FILESDIR}/0001-Don-t-prerender-TeX-parts.patch"
	"${FILESDIR}/0002-Use-MAKE-environment-variable-instead-of-make.patch"
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PYTORCH_NAME}-${PV}" "${S}"
}

src_compile() {
	local doc_build_dir="${S}/docs"
	cd "${doc_build_dir}"
	emake html-stable
}

src_install() {
	local doc_build_dir="${S}/docs"

	mkdir -p "${D}/usr/share/doc/${P}"
	cp -a "${doc_build_dir}/build/html" "${D}/usr/share/doc/${P}/html"
}

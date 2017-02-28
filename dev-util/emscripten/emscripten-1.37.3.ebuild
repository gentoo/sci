# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="LLVM-to-JavaScript Compiler"
HOMEPAGE="http://emscripten.org/"
SRC_URI="https://github.com/kripken/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="UoI-NCSA"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	~dev-util/emscripten-fastcomp-${PV}"
RDEPEND="${DEPEND}"

DEST="/usr/share/"
TEST="${WORKDIR}/test/"

prepare_file() {
	cp "${FILESDIR}/${1}" "${S}/" || die "could not copy '${1}'"
	sed -i "s/\${PV}/${PV}/g" "${S}/${1}" || \
		die "could not adjust path for '${1}'"
}

src_prepare() {
	prepare_file "99emscripten"
	prepare_file "emscripten.config"
	eapply "${FILESDIR}/${PV}/emcc.patch"
	eapply "${FILESDIR}/${PV}/emcmake.patch"
	eapply_user
}

src_test() {
	mkdir "${TEST}" || die "Could not create test directory!"
	cp "${FILESDIR}/hello_world.cpp" "${TEST}" || die "Could not copy example file"
	cp "${S}/emscripten.config" "${TEST}" || die "Could not copy config file"
	sed -i -e "/^EMSCRIPTEN_ROOT/s|/usr/share/|${S}|" \
		"${TEST}/emscripten.config" || die "Could not adjust path for testing"
	export EM_CONFIG="${TEST}/emscripten.config" || die "Could not export variable"
	../"${P}/emcc" "${TEST}/hello_world.cpp" -o "${TEST}/hello_world.js" || \
		die "Error during executing emcc!"
	test -f "${TEST}/hello_world.js" || die "Could not find '${TEST}/hello_world.js'"
	OUT=$(/usr/bin/node "${TEST}/hello_world.js") || \
		die "Could not execute /usr/bin/node"
	EXP=$(echo -e -n 'Hello World!\n') || die "Could not create expected string"
	if [ "${OUT}" != "${EXP}" ]; then
		die "Expected '${EXP}' but got '${OUT}'!"
	fi
	rm -r "${TEST}" || die "Could not clean-up '${TEST}'"
}

src_install() {
	dodir ${DEST}/${P}
	cp -R "${S}/" "${D}/${DEST}" || die "Could not install files"
	dosym ../share/${P}/emcc /usr/bin/emcc
	dosym ../share/${P}/emcmake /usr/bin/emcmake
	doenvd 99emscripten
	ewarn "If you consider using emscripten in an active shell,"\
		"please execute 'source /etc/profile'"
}

pkg_postinst() {
	elog "Running emscripten initialization, may take a few seconds..."
	export EM_CONFIG="${DEST}/${P}/emscripten.config" || die "Could not export variable"
	/usr/bin/emcc -v || die "Could not run emcc initialization"
}

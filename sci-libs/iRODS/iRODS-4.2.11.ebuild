# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake llvm

MESSAGING_COMMIT="24c73702c88e94c3b159dac97fe7a0640dfc209d"

DESCRIPTION="Integrated Rule Oriented Data System, a data management software"
HOMEPAGE="https://irods.org"
SRC_URI="
	https://github.com/irods/irods/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/irods/irods_schema_messaging/archive/${MESSAGING_COMMIT}.tar.gz -> ${P}_schema_messaging.tar.gz
"
S="${WORKDIR}/irods-${PV}"

LICENSE="BSD"
SLOT="0"
# need the c++ version of avro
KEYWORDS=""

DEPEND="
	app-arch/libarchive
	dev-cpp/catch:0
	dev-libs/avro-c
	dev-libs/boost:=
	dev-libs/jansson
	dev-libs/json-c
	dev-libs/libfmt
	dev-libs/openssl
	dev-libs/spdlog
	llvm-runtimes/libcxx
	sys-libs/pam
	net-libs/cppzmq
	net-libs/zeromq
"
RDEPEND="${DEPEND}"
BDEPEND="
	llvm-core/clang
"

src_unpack() {
	default
	mv "${WORKDIR}/irods_schema_messaging-${MESSAGING_COMMIT}/v1" "${S}/irods_schema_messaging/" || die
}

src_prepare() {
	cmake_src_prepare
	# use the correct lib dir
	find . -name "CMakeLists.txt" -exec sed -i \
		-e '/${IRODS_EXTERNALS_FULLPATH_.*}/s/\/lib\//\/lib64\//g' \
		{} + || die
}

src_configure() {
	local mycmakeargs=(
		-DIRODS_EXTERNALS_FULLPATH_CLANG="$(get_llvm_prefix)"
		-DIRODS_EXTERNALS_FULLPATH_CLANG_RUNTIME="$(get_llvm_prefix)"
		-DIRODS_EXTERNALS_FULLPATH_ARCHIVE="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_AVRO="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_BOOST="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_CATCH2="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_FMT="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_ZMQ="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_JANSSON="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_SPDLOG="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_CPPZMQ="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_JSON="${EPREFIX}/usr"
		-DIRODS_EXTERNALS_FULLPATH_NANODBC="${EPREFIX}/usr"
		# pretend we are Arch, otherwise fatal error
		-DIRODS_LINUX_DISTRIBUTION_NAME="arch"
		-DIRODS_LINUX_DISTRIBUTION_VERSION_MAJOR="1"
	)
	cmake_src_configure
}

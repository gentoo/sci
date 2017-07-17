# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs versionator alternatives-2 fortran-2

ACML_INST_DIR=opt/${PN}${PV}
QA_PREBUILT="${ACML_INST_DIR}/*/lib/*"

MYP=${PN}-$(replace_all_version_separators -)

DESCRIPTION="AMD Core Math Library for amd64 CPUs"
HOMEPAGE="http://developer.amd.com/tools-and-sdks/cpu-development/amd-core-math-library-acml/acml-downloads-resources/"

# here we go for the url mess
FCOMP64=""
URI="http://developer.amd.com/tools-and-sdks/cpu-development/amd-core-math-library-acml/acml-downloads-resources/"
for fcomp in gfortran ifort open64 pgi; do
	FCOMP64="${FCOMP64} ${fcomp}? ( ${URI}/${MYP}-${fcomp}-64bit.tgz
			int64? ( ${URI}/${MYP}-${fcomp}-64bit-int64.tgz ) )"
done
SRC_URI="
	amd64? ( ${FCOMP64}
		!gfortran? ( !ifort? ( !open64? ( !pgi? (
				${URI}/${MYP}-gfortran-64bit.tgz
				int64? ( ${URI}/${MYP}-gfortran-64bit-int64.tgz ) ) ) ) ) )"

LICENSE="ACML-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE="doc examples cpu_flags_x86_fma4 gfortran ifort int64 open64 openmp pgi static-libs test"
RESTRICT="fetch strip mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack ./contents-acml-*.tgz
	use openmp || rm -rf *_mp*
	use cpu_flags_x86_fma4 || rm -rf *_fma*
}

src_test() {
	local fdir d
	for fdir in */examples; do
		einfo "Testing acml in ${fdir}"
		pushd ${fdir} > /dev/null
		emake ACMLDIR="${S}/${fdir%/examples}"
		emake clean
		popd > /dev/null
	done
}

src_install() {
	# install libraries, pkgconfig file and eselect files for each profile
	local prof libs fdir libdir=$(get_libdir)  x
	for fdir in */lib; do
		fdir=$(dirname ${fdir})
		prof=acml-$(echo ${fdir} | sed \
			-e 's:mp:openmp:' \
			-e 's:_:-:g')
		use examples || rm -r ${fdir}/examples
		use static-libs || rm ${fdir}/lib/*.a
		dodir /${ACML_INST_DIR}
		cp -pPR ${fdir} "${ED}"/${ACML_INST_DIR} || die
		libs="$(find ${fdir} -name \*.so -printf '%f ' | sed -e 's:lib:-l:g' -e 's:\.so::g')"
		cat <<-EOF > ${prof}.pc
			prefix=${EROOT}/${ACML_INST_DIR}/${fdir}
			libdir=\${prefix}/lib
			includedir=\${prefix}/include
			Name: ${prof}
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} ${libs}
			Libs.private: -lm -lrt ${threads}
			Cflags: -I\${includedir}
		EOF
		insinto /usr/${libdir}/pkgconfig
		doins ${prof}.pc
		for x in blas lapack; do
			alternatives_for ${x} ${prof} 0 \
				/usr/${libdir}/pkgconfig/${x}.pc ${prof}.pc \
				/${ACML_INST_DIR}/${libdir} ${fdir}/lib
		done
	done

	echo > 35acml "LDPATH=${EROOT}/${ACML_INST_DIR}/${libdir}"
	doenvd 35acml

	# default profile: first one matching use flags
	local opts=gfortran
	for fdir in ifort open64 pgi; do
		use ${fdir} && opts=${fdir}
	done
	opts+="64"
	use cpu_flags_x86_fma4 && opts+="_fma4"
	use openmp && opts+="_mp"
	use int64 && opts+="_int64"
	dosym $(ls -1d */lib | grep ${opts}) /${ACML_INST_DIR}/${libdir}

	insinto /${ACML_INST_DIR}
	# info files go to standard /usr/share/info to avoid more env variables
	doinfo Doc/*info*
	rm Doc/*EULA* Doc/*info* || die
	use doc || rm -r Doc/*.pdf Doc/acml.html Doc/html
	doins -r Doc ReleaseNotes*
}

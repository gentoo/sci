#!/bin/bash

clean_git() {
   for f in $(find ./"$1" -name ".git"); do rm -rf $f; done
}

TEMP=/dev/shm/path64
TODAY=$(date -u +%Y%m%d)

[[ -d ${TEMP} ]] && rm -rf ${TEMP}
mkdir "${TEMP}" && cd "${TEMP}"

git clone git://github.com/pathscale/path64-suite.git path64
clean_git path64
ver=$(grep 'SET(PSC_FULL_VERSION' path64/CMakeLists.txt | cut -d'"' -f2)
tar cjf path64-suite-${ver}_pre${TODAY}.tbz2 path64

[[ -d ${TEMP}/path64/compiler ]] || mkdir -p ${TEMP}/path64/compiler
cd ${TEMP}/path64/compiler

for f in compiler assembler ; do 
   git clone git://github.com/path64/$f.git
done
git clone git://github.com/path64/debugger.git pathdb
for f in compiler-rt libcxxrt libdwarf-bsd libunwind stdcxx ; do 
	git clone git://github.com/pathscale/$f.git
done

clean_git
cd "${TEMP}"
tar cjf path64-compiler-${ver}_pre${TODAY}.tbz2 \
	path64/compiler/{compiler,compiler-rt,libcxxrt,libdwarf-bsd,libunwind,stdcxx}
tar cjf path64-debugger-${ver}_pre${TODAY}.tbz2 \
	path64/compiler/pathdb
tar cjf path64-assembler-${ver}_pre${TODAY}.tbz2 \
	path64/compiler/assembler


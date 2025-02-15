# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3

DESCRIPTION="String Graph OLC Assembler for short reads (overlap-layout-consensus)"
HOMEPAGE="https://github.com/jts/sga"
EGIT_REPO_URI="git://github.com/jts/sga"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="jemalloc python"

DEPEND="dev-cpp/sparsehash
	sci-biology/bamtools
	sys-libs/zlib
	jemalloc? ( dev-libs/jemalloc )"
RDEPEND="${DEPEND}
	python? ( sci-biology/pysam
			sci-biology/ruffus )"

# http://www.vcru.wisc.edu/simonlab/bioinformatics/programs/install/sga.htm
src_configure(){
	cd src || die
	./autogen.sh || die
	econf --with-bamtools=/usr
}

src_compile(){
	cd src || die
	default
}

src_install(){
	cd src || die
	dodoc README
	emake install DESTDIR="${D}"
	insinto /usr/share/sga/examples
	doins examples/*
	cd .. ||
	dodoc README.md
}

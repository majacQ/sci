# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs git-r3

DESCRIPTION="Reference-genome-assisted asssembly of contigs/scaffolds using PE reads"
HOMEPAGE="
	https://github.com/baoe/AlignGraph
	http://bioinformatics.oxfordjournals.org/content/30/12/i319.long"
EGIT_REPO_URI="https://github.com/baoe/AlignGraph.git"

LICENSE="Artistic-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/mummer
	sci-biology/blat
	sci-biology/bowtie"

# AlignGraph runs the alignment steps with BLAT and Bowtie2 automatically, but both
# need to be installed on the system. AlignGraph’s run time is currently 23–57 min
# per million aligned reads. In the performance tests of this study, the memory usage
# was 36–50 GB, and it stays <100 GB even for entire mammalian genomes. These requirements
# are more moderate than those of most de novo assemblers (Luo et al., 2012).

# 8 threads are hardcoded. Currently users cannot make changes to this, since this is
# a moderate choice for either single CPU machines (overhead for parallelization would
# not be too large) or multiple CPU machines. Another reason is, the bottleneck for the
# runtime is usually from BLAT, no matter how many threads there are for Bowtie2.
src_compile(){
	cd AlignGraph || die
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o AlignGraph AlignGraph.cpp -lpthread || die
	cd ../Eval-AlignGraph || die
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o Eval-AlignGraph Eval-AlignGraph.cpp -lpthread || die
}

src_install(){
	dobin AlignGraph/AlignGraph Eval-AlignGraph/Eval-AlignGraph
	dodoc README.md
}

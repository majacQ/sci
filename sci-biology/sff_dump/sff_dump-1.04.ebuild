# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Convert Roche SFF files to FASTA file format"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/${P}.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare(){
	default
	sed \
		-e 's:^CC :#CC :' \
		-e 's:^LD :#LD :' \
		-e 's:^CFLAGS.*:CFLAGS+= -D__LINUX__ -Wcast-align:' \
		-e 's:^LDFLAGS=:#LDFLAGS=:' \
		-i Makefile || die
	tc-export CC LD
}

src_install(){
	dobin sff_dump
}

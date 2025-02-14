# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 toolchain-funcs

DESCRIPTION="PAW atomic data generator"
HOMEPAGE="http://users.wfu.edu/natalie/papers/pwpaw/man.html"
SRC_URI="
	http://users.wfu.edu/natalie/papers/pwpaw/${P}.tar.gz
	http://users.wfu.edu/natalie/papers/pwpaw/atompaw.pdf
	http://users.wfu.edu/natalie/papers/pwpaw/notes/atompaw/atompawEqns.pdf
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libxc longplot"

RDEPEND="
	virtual/blas
	virtual/lapack
	libxc? ( >=sci-libs/libxc-2.0.1[fortran] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

FORTRAN_STANDARD=90

src_unpack() {
	unpack ${P}.tar.gz
	cp "${DISTDIR}"/atompaw.pdf "${DISTDIR}"/atompawEqns.pdf "${S}"/doc/ || die
}

src_prepare() {
	default
	use longplot && eapply "${FILESDIR}"/4.0-longplot.patch
}

src_configure() {
	econf \
		$(use_enable libxc) \
		--with-linalg-libs="$($(tc-getPKG_CONFIG) --libs blas lapack)" \
		--with-libxc-incs="-I/usr/include $($(tc-getPKG_CONFIG) --cflags libxc)" \
		--with-libxc-libs="$($(tc-getPKG_CONFIG) --libs libxc)" \
		FC="$(tc-getFC)" FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}" \
		CC="$(tc-getCC)" LDFLAGS="${LDFLAGS:- ${CFLAGS:- -O2}}"
}

src_install() {
	default
	dodoc doc/atompaw.pdf doc/atompawEqns.pdf
}

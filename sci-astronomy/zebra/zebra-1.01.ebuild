# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Galaxy redhift Bayesian analyzer"
HOMEPAGE="http://www.astro.phys.ethz.ch/exgal_ocosm/zebra/index.html"
SRC_URI="http://www.astro.phys.ethz.ch/exgal_ocosm/zebra/tar/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="
	sci-libs/gsl
	sci-libs/lapackpp
	virtual/blas
	virtual/cblas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	myeconfargs+=(
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-cblas="$($(tc-getPKG_CONFIG) --libs cblas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use doc && dodoc doc/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r scripts examples
	fi
}

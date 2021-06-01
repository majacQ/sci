# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Industrial strength theorem prover"
HOMEPAGE="https://www.cs.utexas.edu/users/moore/acl2/"
MY_PN=${PN}-devel
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="books"

BDEPEND="dev-lisp/sbcl"
DEPEND="
	dev-lisp/sbcl:=
	books? ( dev-lang/perl )
"
RDEPEND="${DEPEND}"

src_compile() {
	emake LISP="sbcl --noinform --noprint \
		--no-sysinit --no-userinit --disable-debugger"

	if use books; then
		echo
		einfo "Building certificates ..."
		einfo "(this may take hours to finish)"
		emake certify-books
	fi
}

src_install() {
	SAVED_NAME=saved_acl2
	sed -e "s:${S}:/usr/share/acl2:g" -i ${SAVED_NAME} || die
	if use books; then
		sed -e "/5/a export ACL2_SYSTEM_BOOKS=/usr/share/acl2/books/" \
			-i ${SAVED_NAME} || die
	fi
	dobin ${SAVED_NAME}

	insinto /usr/share/acl2
	doins TAGS ${SAVED_NAME}.core
	if use books; then
		doins -r books
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Fails to build with with "lua5-1".
LUA_COMPAT=( lua5-{3,4} luajit )

inherit lua-single

DESCRIPTION="Lisp-like language that compiles to Lua"
HOMEPAGE="https://fennel-lang.org/
	https://sr.ht/~technomancy/fennel/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~technomancy/${PN}"
else
	SRC_URI="https://git.sr.ht/~technomancy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
BDEPEND="${RDEPEND}"

src_prepare() {
	default

	# Turn off broken(?) tests. bug https://bugs.gentoo.org/906351
	sed -i -e 's|"failures",||' -e 's|"repl",||' test/init.lua || die
}

src_install() {
	emake LUA_LIB_DIR="${ED}/$(lua_get_lmod_dir)" PREFIX="${ED}/usr" install

	dodoc *.md
}

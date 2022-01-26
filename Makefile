.PHONY: all

test_file = $(wildcard test/*.lua)

.PHONY: $(test_file)
all: $(test_file)

$(test_file):
	lua $@

all: luacheck

luacheck:
	luacheck --config .luacheckrc ./



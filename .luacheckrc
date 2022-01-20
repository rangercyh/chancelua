codes = true
color = true

std = "max"

-- MaCabe 循环复杂度
max_cyclomatic_complexity = 10

include_files = {
    "chance.lua",
    "mt/*",
    "utils/*",
}

exclude_files = {
    "test/*",
    "utils/data.lua"
}

-- http://luacheck.readthedocs.io/en/stable/warnings.html#
ignore = {
    "212/self"
}

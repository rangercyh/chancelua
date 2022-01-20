local Base64 = require "utils.base64"

assert(Base64("") == "")
assert(Base64("f") == "Zg==")
assert(Base64("fo") == "Zm8=")
assert(Base64("foo") == "Zm9v")
assert(Base64("foob") == "Zm9vYg==")
assert(Base64("fooba") == "Zm9vYmE=")
assert(Base64("foobar") == "Zm9vYmFy")

assert(Base64("asdf") == "YXNkZg==")
assert(Base64("ssssssssssssssssssss") == "c3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3M=")

assert(Base64("A") == "QQ==")
assert(Base64("abcdefghijklmnop") == "YWJjZGVmZ2hpamtsbW5vcA==")
assert(Base64("0") == "MA==")
assert(Base64("0000") == "MDAwMA==")
assert(Base64(string.char(97, 98, 99)) == "YWJj")
assert(Base64(string.char(0,1,2,3,97,98,99)) == "AAECA2FiYw==")
assert(Base64("asdfasdfasdfasdf") == "YXNkZmFzZGZhc2RmYXNkZg==")

print("-------->>>>>>>> base64 test ok <<<<<<<<--------")

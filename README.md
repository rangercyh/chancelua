# Chancelua

A lua port from https://github.com/chancejs/chancejs

Chancelua - Random generator helper for Lua

## Usage

### basic
```lua
local Chance = require "chance"
local chance = Chance.new()
chance:bool()
chance:falsy()
chance:animal()
chance:character()
chance:floating()
chance:integer()
chance:natural()
chance:prime()
chance:is_prime()
chance:hex()
chance:letter()
chance:string()
chance:template()
```

## Notes

之前喜欢使用 chance.js 这个库，但是现在在 lua 上也类似的需求，所以想搞过来用，搜了下发现有一些类似的库，但都不满足我的使用习惯，所以干脆自己 port 一个

port 过程中有那么几点需要注意的：
1. lua 的数值范围跟 js 不太一样，尤其是 lua5.4 数值范围都在 64 位，js 的一些函数操作范围是 32 位的，在有一些计算上有些许调整
2. js 的一些字符接口使用的是 UTF-16 编码，比如 charCodeAt / fromCharCode 接口，而 lua 这边 string.byte / string.char 都是 UTF-8，所以有一些结果上不太一样
3. js 存在两种位右移运算符 >>(算术右移，首位用符号位填充)、>>>(逻辑右移动，首位用 0 填充)，lua 这边只有一种位右移运算，即逻辑右移，而且 js 是操作 32 位的运算数的，lua 是 64 位，所以单独实现了一套 bit32 的操作，当然 lua5.3 有单独的 bit 库，不过我一向用最新的 lua 所以不考虑
4. chance.js 实现了一套 MersenneTwister 随机算法，主要是 js 并没有统一的虚拟机实现，所以各家的 Math.random 随机算法各不相同，但是 lua 自己的虚拟机官方就这么一套，lua5.4 使用 xoshiro256** 算法生成 64 位随机数是确定的。所以其实没有必要重新写一套，直接用就好了，我只是顺手也写了一个，方便使用 chance.js 习惯的直接用
5. chance.js 实现的 MD5 算法也用 lua 重新实现了，base64 也是，不过没有暴露在 chance 的外层接口里，并没有依赖，需要用可以直接暴露出去
6. make 会遍历 test 目录下的所有 test 用例，chance.js 的绝大部分测试用例都用 assert 复写了，讲道理应该实现一个 lua 的 test 工具，有空再说吧。测试用例中关于随机性随时间变化的例子被移除了，毕竟 lua 没有时间控制函数，后面有空再用协程加一个看看

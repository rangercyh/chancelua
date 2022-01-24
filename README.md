# Chancelua

A lua port from https://github.com/chancejs/chancejs

Chancelua - Random generator helper for Lua

## Usage

### mersenne twister random
```lua
local Chance = require "chance"
local chance = Chance.new()

-- 获得一个 mersenne twister 随机器，seed 是整数种子，可以为 nil
-- 通常来说 seed 应该是整数，正负无所谓
local mt = chance:mersenne_twister(seed)
-- 初始化随机器，当你需要重置随机函数的时候可以调用它传递相同的随机种子
mt:init_genrand(seed)
-- 使用一个数组来初始化随机器，init_key 是一个数组 table，key_length 通常是数组长度
mt:init_by_array(init_key, key_length)
-- 随机生成一个 [0,0xffffffff] 的整数
mt:genrand_int32()
-- 随机生成一个 [0,0x7fffffff] 的整数
mt:genrand_int31()
-- 随机生成一个 [0,1] 的实数
mt:genrand_real1()
-- 随机生成一个 (0,1) 的实数
mt:genrand_real3()
-- 随机生成一个 [0,1) 的实数带有 53 位精度
mt:genrand_res53()
-- 随机生成一个 [0,1) 的实数
mt:random()
```

### basic
```lua
local Chance = require "chance"
local chance = Chance.new()
-- 随机布尔值，默认 50% 概率生成 true，likelihood 可以设置生成 true 的概率
chance:bool({ likelihood = 50 })
-- 随机生成一个值，pool 可以传递需要随机的值，默认值如下
chance:falsy({ pool = {false, nil, 0, {}, ''} })
-- 随机生成一个动物，默认动物在 data 数据里
-- type 传递动物类型，默认有：{"desert","forest","ocean","zoo","farm","pet","grassland"}
-- type 不传就从所有动物中随机一个
chance:animal({ type = "desert" })
-- 随机生成一个字符
-- 默认从 abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()[] 这些字符中返回一个
-- pool 可以传递随机池
-- alpha 是否添加字母， casing 控制字母大小写
-- numeric 是否添加数字
-- symbols 是否添加符号
chance:character({ pool = "abc" })
chance:character({ alpha = true, numeric = true, casing = "upper", symbols = true })
-- 随机生成一个浮点数
-- fixed 指定浮点数小数点保留位数，需要注意浮点数并不精确，无法做精确比较
-- min 浮点数最小值
-- max 浮点数最大值
-- 可以单独指定
chance:floating({ fixed = 4 })
chance:floating({ min = 90, max = 100 })
chance:floating({ fixed = 3, min = -9007199254740992 })
chance:floating({ fixed = 3, max = 9007199254740992 })
-- 随机生成一个整数，默认范围 [-2^53, 2^53]
-- 只指定一边，另一边用默认值，min/max 都在随机范围内
chance:integer()
chance:integer({ min = 100, max = 1000 })
chance:integer({ min = 100 })
chance:integer({ max = 1000 })
-- 随机生成一个自然数，默认范围 [1, 2^53]
-- min/max 指定范围，都是闭区间，min >= 0
-- numerals 可以单独指定范围 [10^(numerals-1), 10^numerals - 1]
-- exclude 用来排除指定的数
chance:natural()
chance:natural({ min = 100 })
chance:natural({ max = 100 })
chance:natural({ min = 99, max = 100 })
chance:natural({ min = 0, max = 0 })
chance:natural({ numerals = 2 })
chance:natural({ min = 1, max = 5, exclude = { 1, 3 } })
chance:natural({ min = 1, max = 5, exclude = {} })
-- 随机生成一个质数
-- 默认范围为 [0,10000] 以内的质数
-- min/max 指定范围，min >= 0
-- 质数都存在 data 里，默认值存了 2 - 10007 的这些质数
-- 这里的查找质数的方法太过简陋，超过 10000 的质数太慢，还是不要把 max 传太大了，有空换个更高效的生成质数的办法
chance:prime()
chance:prime({ min = 0, max = 10000 })
chance:prime({ min = 5000 })
chance:prime({ max = 20000 })
-- 随机生成16进制数字符串
-- 默认范围是 [0, 2^53]，小写字母表示
-- min/max 指定范围，min >= 0
-- casing 转换大小写
chance:hex()
chance:hex({ min = 0, max = 10000, casing = "upper" })
chance:hex({ min = 1, casing = "upper" })
chance:hex({ max = 1 })
chance:hex({ casing = "lower" })
-- 随机生成一个字母
-- 默认从26个小写字母中随机生成一个 abcdefghijklmnopqrstuvwxyz
-- casing 转换大小写
chance:letter()
chance:letter({ casing = "upper" })
-- 随机生成一个字符串
-- min/max 指定字符串长度范围
-- length 指定字符串长度，length >= 0
-- string 可以接受 chance:natural() 的参数模式
chance:string()
chance:string({ length = 14 })
chance:string({ min = 6, max = 10 })
-- 随机一个指定模式的字符串
--[[
模式用花括号括起来 {}
模式如下：
    # 一个随机数字
    a 一个随机小写字母
    A 一个随机大写字母
例子：
    chance:template("{AA###}-{##}")
]]
chance:template("ID-{Aa}-{##}")
chance:template("\\\\ID-\\{Aa}\\")
```

### finace
```lua
local Chance = require "chance"
local chance = Chance.new()
-- 随机一个信用卡号，该卡号可以通过卢恩校验
-- type 卡号类型｛ American Express/amex, Mastercard/mc, Visa/visa ... ｝类型在 data.lua 里 cc_types 表里，name/short name 均可接受
chance:cc()
chance:cc({ type = "Mastercard" })
chance:cc({ type = "visa" })
-- 随机一个信用卡类型
-- raw 返回信用卡类型完整信息，见 data.lua cc_types
chance:cc_type()
chance:cc_type({ raw = true })
chance:cc_type({ name = "Visa", raw = true })
chance:cc_type({ name = "Visa" })
-- 随机一种货币类型，见 data.lua currency_types
chance:currency()
-- 随机一个时区信息，见 data.lua timezones
chance:timezone()
-- 随机一个货币对
-- 默认返回一个table，包含两种货币信息，传 true 返回货币对字符串 EUR/USD
chance:currency_pair()
chance:currency_pair(true)
-- 随机数量美元字符串，$100.00 -$123.44，保留两位小数
-- min/max 美元范围
chance:dollar()
chance:dollar({ max = 20 })
chance:dollar({ min = 10 })
chance:dollar({ min = 10, max = 20 })
-- 随机数量欧元字符串，123.00€ -12.34€,传递参数同 chance.dollar()
chance:euro()
chance:euro({ max = 10 })
chance:euro({ min = 1 })
chance:euro({ min = 2, max = 5 })
-- 随机一个未来的时间点，默认是 XX/XXXX 月/年 字符串
-- raw 返回月、年的 table { month = xx, year = xxxx }
chance:exp()
chance:exp({ raw = true })
-- 随机一个月份
-- future 是否是未来的月份
chance:exp_month()
chance:exp_month({ future = true })
-- 随机一个未来的年份
chance:exp_year()
-- 随机一个增值税号（目前只支持国际的）
-- country 国家，目前其实只能传 it
chance:vat()
chance:vat({ country = "it" })
-- 随机一个国际银行账户号码
chance:iban()
```

## Notes

之前喜欢使用 chance.js 这个库，但是现在在 lua 上也类似的需求，所以想搞过来用，搜了下发现有一些类似的库，但都不满足我的使用习惯，所以干脆自己 port 一个

port 过程中有那么几点需要注意的：
1. lua 的数值范围跟 js 不太一样，尤其是 lua5.4 数值范围都在 64 位，js 的一些函数操作范围是 32 位的，在有一些计算上有些许调整
2. js 的一些字符接口使用的是 UTF-16 编码，比如 charCodeAt / fromCharCode 接口，而 lua 这边 string.byte / string.char 都是 UTF-8，所以有一些结果上不太一样
3. js 存在两种位右移运算符 >>(算术右移，首位用符号位填充)、>>>(逻辑右移动，首位用 0 填充)，lua 这边只有一种位右移运算，即逻辑右移，而且 js 是操作 32 位的运算数的，lua 是 64 位，所以单独实现了一套 bit32 的操作，当然 lua5.3 有单独的 bit 库，不过我一向用最新的 lua 所以不考虑，其次代码应该在 lua5.3 5.4 都 ok，主要是一些位运算符在 5.3 才有，更早的 lua 懒得兼容了，如果有有朋友有兴趣可以提 pr 兼容下
4. chance.js 实现了一套 MersenneTwister 随机算法，主要是 js 并没有统一的虚拟机实现，所以各家的 Math.random 随机算法各不相同，但是 lua 自己的虚拟机官方就这么一套，lua5.4 使用 xoshiro256** 算法生成 64 位随机数是确定的。所以其实没有必要重新写一套，直接用就好了，我只是顺手也写了一个，方便使用 chance.js 习惯的直接用
5. chance.js 实现的 MD5 算法也用 lua 重新实现了，base64 也是，不过没有暴露在 chance 的外层接口里，并没有依赖，需要用可以直接暴露出去
6. 去掉了几个 chance.js 里实在我觉得没啥用的接口，纯粹浪费代码行数
7. lua 的代码实现暂时没有太考虑性能问题，一些写法可能并不是最合适的，例如字符串用 .. 拼接这种，但主要目的还是在于方便使用，性能倒是次要考虑，有兴趣的朋友欢迎提pr优化性能
8. make 会遍历 test 目录下的所有 test 用例，用例对每个接口都做了测试，这算是我对自己的代码写过的最详细的测试了,chance.js 的绝大部分测试用例都用 assert 复写了，讲道理应该实现一个 lua 的 test 工具，有空再说吧。测试用例中关于随机性随时间变化的例子被移除了，毕竟 lua 没有时间控制函数，后面有空再用协程加一个看看，测试用例太多，一个用例基本都是跑1000次，所以非常慢

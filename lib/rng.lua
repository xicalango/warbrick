-- preakout (C) 2012 by Alexander Weld <alex.weld@gmx.net>
-- THE ALL MIGHTY RANDOM NUMBER GOD

RNG = class("RNG")

function RNG:int(min_or_max, max)
	if min_or_max == nil then
		error("Minimum one argument needed!")
	elseif max == nil then
		return math.random(min_or_max)
	else
		return math.random(min_or_max,max)
	end
end

function RNG:double(min_or_max, max)
	if min_or_max == nil then --got called with no parameters. Range = [0,1)
		return math.random()
	elseif max == nil then --got called with 1 parameter, Range = [0,min_or_max), min_or_max === max
		return math.random() * min_or_max
	else --git called with 2 parameters, Range = [min_or_max, max], min_or_max === min
		return (math.random() * (max - min_or_max)) + min_or_max
	end
end

function RNG:fromRange( range )
	local type = range.t or "d"
	
	if type == "i" then
		return self:int(range[1], range[2])
	elseif type == "d" then
		return self:double(range[1], range[2])
	else
		error("Unknown range type")
	end
end

function RNG:takeRandom(tbl)
    return tbl[math.random(1,#tbl)]
end
function RNG:takeRandomIx(tbl)
    return math.random(1,#tbl)
end


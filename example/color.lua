-- Server script btw ( can use in local script maybe ;-; )
task.wait()
local F = 30
local R = 144
local V = "VideoFrames"

local s = workspace:WaitForChild("Sound")
local r = game:GetService("RunService")

local b = workspace:WaitForChild("screen")
local v = workspace:WaitForChild(V)

local g = {}
local c = b.CFrame
local z = b.Size

local p = math.min(z.X, z.Y) / R
local d = p * 0.9

local o =
	c.Position
- c.RightVector * (p * R / 2)
	+ c.UpVector * (p * R / 2)
	+ c.LookVector * (d / 2 + 0.01)

local h = Instance.new("Folder")
h.Name = "VideoGrid"
h.Parent = workspace

for y = 1, R do
	for x = 1, R do
		local q = Instance.new("Part")
		q.Anchored = true
		q.Material = Enum.Material.SmoothPlastic
		q.Size = Vector3.new(p, p, d)
		q.Position =
			o
			+ c.RightVector * ((x - 0.5) * p) -- if video flip change to - like [ - c.RightVector * ((x - 0.5) * p) ]
		- c.UpVector * ((y - 0.5) * p) 
		q.Color = Color3.new(0, 0, 0)
		q.Parent = h
		g[#g + 1] = q
	end
end

local function l(i)
	local m = v:FindFirstChild("Chunk_" .. i)
	if not m then return nil end
	return require(m)
end

local tc = 0
while v:FindFirstChild("Chunk_" .. (tc + 1)) do
	tc += 1
end

local cf = l(1)
assert(cf)

local fpc = #cf
local tf = tc * fpc  

local ci = 1
local f = cf
local fc = #f
local t0 = os.clock()
local lf = -1

s.TimePosition = 0
s:Play()
b:Destroy()

r.Heartbeat:Connect(function()
	local t = os.clock() - t0
	local fr = math.floor(t * F) + 1

	if fr > tf then
		t0 = os.clock()
		lf = -1
		ci = 1
		f = l(1)
		fc = #f
		s.TimePosition = 0
		s:Play()
		return
	end

	if fr == lf then return end
	lf = fr

	local ni = math.floor((fr - 1) / fc) + 1
	if ni ~= ci then
		ci = ni
		f = l(ci)
		if not f then return end
		fc = #f
	end

	local fi = ((fr - 1) % fc) + 1
	local hx = f[fi]
	if not hx then return end

	local k = 1
	for i = 1, #g do
		local r = tonumber(hx:sub(k, k + 1), 16) or 0
		local g2 = tonumber(hx:sub(k + 2, k + 3), 16) or 0
		local b2 = tonumber(hx:sub(k + 4, k + 5), 16) or 0
		k += 6
		g[i].Color = Color3.fromRGB(r, g2, b2)
	end
end)

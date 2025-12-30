local A = game:GetService("AssetService")
local R = game:GetService("RunService")
local S = workspace:WaitForChild("Sound")
local B = bit32
local E = 720       -- resolution     
local F = 30        -- เปลี่ยนเป็น 60 เพราะ video ของคุณ encode ที่ 60fps
local N = "VideoFrames"
local W = workspace:WaitForChild("board")
local D = workspace:WaitForChild(N)
if not S.IsLoaded then
	S.Loaded:Wait()
end
local I = A:CreateEditableImage({
	Size = Vector2.new(E, E)
})
if not I then
	error("Failed to create EditableImage")
end
local G = Instance.new("SurfaceGui")
G.Face = Enum.NormalId.Front
G.AlwaysOnTop = false
G.LightInfluence = 0
G.Adornee = W
G.Parent = W
local L = Instance.new("ImageLabel")
L.Size = UDim2.fromScale(1, 1)
L.BackgroundTransparency = 1
L.ImageContent = Content.fromObject(I)
L.Parent = G
local P = E * E
local Y = P / 8
local U = buffer.create(P * 4)
local C = 1
local J = 1
local function Q(x)
	local m = D:FindFirstChild("Chunk_" .. x)
	if not m then
		return nil
	end
	return require(m)
end
local T = Q(C)
if not T then
	error("Chunk_1 not found")
end
task.wait()
S.TimePosition = 0
S:Play()
local Lf = -1
R.RenderStepped:Connect(function()
	if not S.IsPlaying then
		return
	end
	local f = math.floor(S.TimePosition * F) + 1
	if f == Lf then
		return
	end
	Lf = f
	local framesPerChunk = #T
	local ci = math.floor((f - 1) / framesPerChunk) + 1
	if ci ~= C then
		C = ci
		T = Q(C)
		if not T then
			print("Video finished")
			return
		end
	end
	J = ((f - 1) % framesPerChunk) + 1
	local X = T[J]
	if not X then
		return
	end
	if #X ~= Y * 2 then
		warn("Frame size mismatch")
	end
	local O = 0
	local K = 1
	for _ = 1, Y do
		local h = X:sub(K, K + 1)
		K += 2
		local v = tonumber(h, 16)
		if not v then
			break
		end
		for b = 7, 0, -1 do
			local c = B.band(B.rshift(v, b), 1) == 1 and 255 or 0
			buffer.writeu8(U, O,     c)
			buffer.writeu8(U, O + 1, c)
			buffer.writeu8(U, O + 2, c)
			buffer.writeu8(U, O + 3, 255)
			O += 4
		end
	end
	I:WritePixelsBuffer(
		Vector2.zero,
		Vector2.new(E, E),
		U
	)
end)

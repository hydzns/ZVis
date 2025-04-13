-- Server-side damage handler
local Debris = game:GetService("Debris")

-- Fungsi untuk memberikan damage dan memberi tag attacker
local function applyDamage(attacker, victim, amount)
	if not (attacker and victim and amount) then return end
	if not victim:FindFirstChild("Humanoid") then return end
	
	local humanoid = victim:FindFirstChild("Humanoid")

	-- Tambahkan tag "creator" agar client tahu siapa penyerangnya
	local tag = Instance.new("ObjectValue")
	tag.Name = "creator"
	tag.Value = attacker
	tag.Parent = humanoid
	Debris:AddItem(tag, 1.5) -- Hapus tag setelah 1.5 detik

	humanoid:TakeDamage(amount)
end

-- Contoh pemakaian:
-- applyDamage(player1, player2.Character, 50)

return applyDamage

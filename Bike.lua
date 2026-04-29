local textBox = script.Parent
local player = game.Players.LocalPlayer

-- [[ ตั้งค่าหน้าตา GUI เบื้องต้น ]]
textBox.Size = UDim2.new(0, 250, 0, 50)
textBox.Position = UDim2.new(0.5, -125, 0.1, 0) -- อยู่ตรงกลางด้านบน
textBox.PlaceholderText = "กรอกความเร็ว (เช่น 200)"
textBox.Text = ""
textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textBox.BackgroundTransparency = 0.5
textBox.TextColor3 = Color3.fromRGB(255, 255, 0) -- ตัวหนังสือสีเหลือง
textBox.TextScaled = true

-- ใส่ขอบโค้งให้สวยๆ
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = textBox

-- [[ ระบบจัดการความเร็ว ]]
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetSpeed = tonumber(textBox.Text)
        
        if targetSpeed then
            local char = player.Character
            local seat = (char and char:FindFirstChild("Humanoid")) and char.Humanoid.SeatPart
            
            if seat and seat:IsA("VehicleSeat") then
                -- 1. ปรับความเร็วสูงสุด
                seat.MaxSpeed = targetSpeed
                
                -- 2. ปรับ Torque (แรงบิด) เพื่อให้รถมีแรงส่งถึงความเร็วที่ตั้งไว้
                -- สูตร: ถ้าความเร็วเยอะ แรงบิดต้องเยอะตาม (กันรถอืด)
                seat.Torque = (targetSpeed * 50) + 10000 
                
                -- 3. ปรับ TurnSpeed (วงเลี้ยว) ให้สมดุลกับความเร็ว (กันรถคว่ำเวลาเลี้ยวเร็ว)
                if targetSpeed > 300 then
                    seat.TurnSpeed = 0.5
                else
                    seat.TurnSpeed = 2
                end

                textBox.Text = "SET SPEED: " .. targetSpeed
                print("รถของคุณถูกปรับความเร็วเป็น " .. targetSpeed .. " Studs/s เรียบร้อย!")
            else
                textBox.Text = "❌ ต้องนั่งบนรถก่อน!"
            end
        else
            textBox.Text = "❌ ใส่เฉพาะตัวเลข!"
        end
        
        -- รอ 2 วินาทีแล้วกลับไปเป็นช่องว่างให้พิมพ์ใหม่
        task.wait(2)
        textBox.Text = ""
    end
end)

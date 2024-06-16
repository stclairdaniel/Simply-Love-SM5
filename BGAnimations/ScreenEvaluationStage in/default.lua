-- assume that all human players failed
local failed = true

-- loop through all available human players
for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	-- if any of them passed, we want to display the "cleared" graphic
	if not STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetFailed() then
		failed = false
	end
end

if ThemePrefs.Get("VisualStyle") ~= "SRPG8" then
	local img = failed and "failed text.png" or "cleared text.png"

	return Def.ActorFrame{
		Def.Quad{
			InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end,
			OnCommand=function(self) self:sleep(0.2):linear(0.5):diffusealpha(0) end,
		},

		LoadActor(img)..{
			InitCommand=function(self) self:Center():zoom(0.8):diffusealpha(0) end,
			OnCommand=function(self) self:accelerate(0.4):diffusealpha(1):sleep(0.6):decelerate(0.4):diffusealpha(0) end
		}
	}
else
	local af = Def.ActorFrame{
		InitCommand=function(self)
			self:xy(SCREEN_WIDTH/2,SCREEN_HEIGHT/2-50)
			self:zoomy(0)
		end,
		OnCommand=function(self)
			self:decelerate(0.5)
			self:zoomy(1)
		end,
		Def.Quad{
			InitCommand=function(self)
				-- 100 + 140 = 240. SL is 480 tall, so 240 is the center.
				self:SetWidth(3/4*SCREEN_WIDTH):SetHeight(250):x(-SCREEN_WIDTH/4)
					:diffuse(color("#000000")):diffusealpha(0.99)
					:diffuseleftedge(color("0,0,0,0.4"))
			end,
			OnCommand=function(self)
				self:sleep(failed and 4 or 3.5)
						:decelerate(0.5):diffusealpha(0)
			end
		},

		Def.Quad{
			InitCommand=function(self)
				-- 100 + 140 = 240. SL is 480 tall, so 240 is the center.
				self:SetWidth(3/4*SCREEN_WIDTH):SetHeight(250):x(SCREEN_WIDTH/4)
					:diffuse(color("#000000")):diffusealpha(0.99)
					:diffuserightedge(color("0,0,0,0.4"))
			end,
			OnCommand=function(self)
				self:sleep(failed and 4 or 3.5)
						:decelerate(0.5):diffusealpha(0)
			end
		},
	}

	if failed then
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG8/Failed.mp4"),
			InitCommand=function(self)
				self:y(50):zoom(0.75):blend("BlendMode_Add")
			end,
			OnCommand=function(self)
				self:sleep(4)
					:linear(0.5):diffusealpha(0)
			end,
		}
	else
		af[#af+1] = Def.Sprite{
			Texture=image,
			InitCommand=function(self)
				self:zoom(0.25):zoomx(0.2):diffusealpha(0):addy(5)
			end,
			OnCommand=function(self)
				self:sleep(1):diffusealpha(1):queuecommand("Next")
			end,
			NextCommand=function(self)
				self:linear(3.25):zoomx(0.25)
						:decelerate(0.5):diffusealpha(0)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG8-Passed.ogg"))
			end
		}
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG8/Cleared.mp4"),
			InitCommand=function(self)
				self:y(50):zoom(0.75):blend("BlendMode_Add")
			end,
			OnCommand=function(self)
				self:sleep(3.5)
					:linear(0.5):diffusealpha(0)
			end,
		}

	end

	return af
end
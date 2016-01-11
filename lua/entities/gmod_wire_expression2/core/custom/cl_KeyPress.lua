hook.Add("PlayerBindPress", "E2MouseWheel", function(ply, bind, pressed)
	if (bind == "invprev") or (bind == "invnext") then RunConsoleCommand("wire_e2mkp",bind,"1") end
end)
function Advanced.LerpColor(fraction,color,newcolor)
	color.r = Lerp(fraction,color.r,newcolor.r)
	color.b = Lerp(fraction,color.b,newcolor.b)
	color.g = Lerp(fraction,color.g,newcolor.g)
	color.a = Lerp(fraction,color.a,newcolor.a)
	return color
end

function Advanced.DrawBackground(x,y,w,h)
	if !Advanced.background:GetBool() then return end
	surface.SetDrawColor(0,0,0,2.55*Advanced.alpha:GetFloat())
	surface.SetMaterial(Advanced.Blur)
	surface.DrawTexturedRect(x,y,w,h)
	surface.DrawRect(x,y,w,h)
end


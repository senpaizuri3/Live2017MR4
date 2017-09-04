--Supreme King Wrath
--fixed by MLD
function c511009537.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c511009537.condition)
	e1:SetTarget(c511009537.target)
	e1:SetOperation(c511009537.activate)
	c:RegisterEffect(e1)
	if not c511009537.global_check then
		c511009537.global_check=true
		c511009537[0]=0
		c511009537[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c511009537.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511009537.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511009537.checkop(e,tp,eg,ep,ev,re,r,rp)
	c511009537[ep]=c511009537[ep]+ev
end
function c511009537.clear(e,tp,eg,ep,ev,re,r,rp)
	c511009537[0]=0
	c511009537[1]=0
end
function c511009537.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c511009537.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and c511009537[tp]>=2000 
		and Duel.IsExistingMatchingCard(c511009537.cfilter,tp,LOCATION_ONFIELD,0,1,nil,13331639)
end
function c511009537.desfilter(c)
	return c:IsFacedown() or not c:IsCode(13331639)
end
function c511009537.filterchk(c,g,sg,ft,ftex,ftt,ect)
	if ftt<=0 then return false end
	local ftt=ftt-1
	local res
	if c:IsLocation(LOCATION_EXTRA) then
		if ftex<=0 or (ect and ect<=0) then return false end
		sg:AddCard(c)
		ftex=ftex-1
		if ect then ect=ect-1 end
		if sg:GetCount()<4 then
			res=g:IsExists(c511009537.filterchk,sg,g,sg,ft,ftex,ftt,ect)
		else
			res=sg:IsExists(c511009537.spfilterchk,nil,sg,Group.CreateGroup(),43387895,70771599,42160203,96733134)
		end
		sg:RemoveCard(c)
		ftex=ftex+1
		if ect then ect=ect+1 end
	else
		if ft<=0 then return false end
		sg:AddCard(c)
		ft=ft-1
		if sg:GetCount()<4 then
			res=g:IsExists(c511009537.filterchk,sg,g,sg,ft,ftex,ftt,ect)
		else
			res=sg:IsExists(c511009537.spfilterchk,nil,sg,Group.CreateGroup(),43387895,70771599,42160203,96733134)
		end
		sg:RemoveCard(c)
		ft=ft+1
	end
	return res
end
function c511009537.spfilterchk(c,g,sg,code,...)
	if not c:IsCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=g:IsExists(c511009537.spfilterchk,1,sg,g,sg,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c511009537.spfilter(c,e,tp)
	return c:IsCode(43387895,70771599,42160203,96733134) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c511009537.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		local dg=Duel.GetMatchingGroup(c511009537.desfilter,tp,LOCATION_MZONE,0,nil)
		local sg=Duel.GetMatchingGroup(c511009537.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+dg:FilterCount(function(c) return c:GetSequence()<5 end,nil)
		local ftt=Duel.GetUsableMZoneCount(tp)
		local ftex=Duel.GetLocationCountFromEx(tp,tp,dg)
		return sg:IsExists(c511009537.filterchk,1,nil,sg,Group.CreateGroup(),ft,ftex,ftt,ect)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c511009537.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c511009537.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)>0 or dg:GetCount()==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ftt=Duel.GetUsableMZoneCount(tp)
		local ftex=Duel.GetLocationCountFromEx(tp)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c511009537.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		local spg=Group.CreateGroup()
		while spg:GetCount()<4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:FilterSelect(tp,c511009537.filterchk,1,1,spg,g,spg,ft,ftex,ftt,ect)
			if not sg or sg:GetCount()<=0 then return false end
			spg:Merge(sg)
			local tc=sg:GetFirst()
			ftt=ftt-1
			if tc:IsLocation(LOCATION_EXTRA) then
				ftex=ftex-1
				if ect then ect=ect-1 end
			else
				ft=ft-1
			end
		end
		local tc=spg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=spg:GetNext()
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCode),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,69610326)
		local drg=Duel.GetMatchingGroup(c511009537.cfilter,tp,LOCATION_MZONE,0,nil,42160203)
		if og:GetCount()>1 and drg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12744567,0)) then
			Duel.BreakEffect()
			if drg:GetCount()>1 then
				drg=drg:Select(tp,1,1,nil)
			end
			Duel.HintSelection(drg)
			local sog=og:Select(tp,2,2,nil)
			Duel.Overlay(drg:GetFirst(),sog)
		end
	end
end

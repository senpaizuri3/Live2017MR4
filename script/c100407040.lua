--究極宝玉陣
--Ultimate Crystal Formation
--Scripted by Eerie Code
function c100407040.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c100407040.condition)
	e1:SetCost(c100407040.cost)
	e1:SetTarget(c100407040.target)
	e1:SetOperation(c100407040.activate)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c100407040.plcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100407040.pltg)
	e2:SetOperation(c100407040.plop)
	c:RegisterEffect(e2)
end
function c100407040.confilter(c,tp)
	return c:IsPreviousSetCard(0x1034) and c:GetPreviousControler()==tp
end
function c100407040.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100407040.confilter,1,nil,tp)
end
function c100407040.cfilter(c)
	return c:IsSetCard(0x1034) and (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c100407040.exfilter(c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c))>0
end
function c100407040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100407040.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=7
		and (Duel.GetLocationCountFromEx(tp)>0 or g:IsExists(c100407040.exfilter,1,nil,tp)) end
	local rg=Group.CreateGroup()
	local ft=Duel.GetLocationCountFromEx(tp)
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=nil
		if ft<1 then
			tc=g:FilterSelect(tp,c100407040.exfilter,1,1,nil,tp):GetFirst()
			ft=1
		else
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.SendtoGrave(rg,REASON_COST)
end
function c100407040.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2034) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c100407040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100407040.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100407040.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100407040.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end
function c100407040.plcfilter(c,tp)
	return c:IsPreviousSetCard(0x2034) and c:GetPreviousControler()==tp
		and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()~=tp
		and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100407040.plcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100407040.plcfilter,1,nil,tp)
end
function c100407040.plfilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c100407040.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100407040.plfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c100407040.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c100407040.plfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end

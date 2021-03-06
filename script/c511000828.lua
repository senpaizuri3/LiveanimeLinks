--Martyr Flag
function c511000828.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c511000828.condition)
	e1:SetCost(c511000828.cost)
	e1:SetOperation(c511000828.activate)
	c:RegisterEffect(e1)
end
function c511000828.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ((ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()))
end
function c511000828.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsLocation(LOCATION_HAND) and c511000828.cfilter2(c,tp)
end
function c511000828.cfilter2(c,tp)
	return Duel.IsExistingMatchingCard(c511000828.filter,tp,LOCATION_MZONE,0,1,c)
end
function c511000828.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.CheckReleaseGroupCost(tp,c511000828.cfilter2,1,false,nil,nil,tp)
	local b=Duel.IsExistingMatchingCard(c511000828.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
	if chk==0 then return a or b end
	if a and (not b or Duel.SelectYesNo(tp,aux.Stringid(63014935,2))) then
		local g=Duel.SelectReleaseGroupCost(tp,c511000828.cfilter2,1,1,false,nil,nil,tp)
		Duel.Release(g,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c511000828.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		Duel.SendtoGrave(sg,REASON_COST)
	end
end
function c511000828.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c511000828.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511000828.filter,tp,LOCATION_MZONE,0,nil)
	g:ForEach(function(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
	end)
end

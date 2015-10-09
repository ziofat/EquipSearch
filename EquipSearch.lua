EquipSearch = EquipSearch or {}
EquipSearch.tNpcList = {}
local INI_FILE_PATH = "Interface/EquipSearch/EquipSearch.ini"
local EXPAND_ITEM_TYPE = {}
local PAGE_RESULT_COUNT = 50
local RESULT_PAGE_START = 1
local tDataBase = {}
local tEquipdb = {}
--local tEnchant = {}
local tResult = {}
local tFilter = {
	nSort = 0,
	nSubSort = 0,
	nQuality = -1,
	szSchoolType = "",
	szGetType = "",
	szName = "",
	nLevelMin = 0,
	nLevelMax = 99,
	nQualityLevelMin = 0,
	nQualityLevelMax = 999,
	nRepresentID = -1,
	nColorID = -1,
	}
EquipSearch = EquipSearch or {}
EquipSearch.tSearchSort =
	{
		["兵刃"] =
		{
		 	nSortID = 1,
		 	tSubSort =
		 	{
		 		["棍类"]   = 1,
				["长兵"]   = 2,
				["短兵类"] = 3,				
				["双兵类"] = 5,
				["笔类"]   = 6,
				["重兵类"] = 7,
				["虫笛类"] = 8,
				["千机匣"] = 9,
				["弯刀"] = 10,
				["短棒"] = 11,
		 	},
		},
		["暗器"] =
		{
			nSortID = 2,
			tSubSort =
			{
				["投掷"] = 1,
				["弓弦"] = 2,
				--["机射"] = 3,
				["弹药"] = 4,
			},
		},
		["服饰"] =
		{
			nSortID = 3,
			tSubSort =
			{
				["上衣"] = 1,
				["帽子"] = 2,
				["腰带"] = 3,
				["下装"] = 4,
				["鞋子"] = 5,
				["护腕"] = 6,
			},
		},
		["饰物"] =
		{
			nSortID = 4,
			tSubSort =
			{
				["项链"] = 1,
				["戒指"] = 2,
				["腰坠"] = 3,
				["腰部挂件"] = 4,
				["背部挂件"] = 5,
				["披风"] = 6,
				["左肩"] = 7,
				["右肩"] = 8,
			},
		},
		["坐骑"] =
		{
			nSortID = 5,
			tSubSort =
			{
				["坐骑"]     = 1,
				["坐骑头饰"] = 2,
				["坐骑胸饰"] = 3,
				["坐骑足饰"] = 4,
				["坐骑鞍具"] = 5,
				["坐骑幼崽"] = 6,
			},
		},
		["包裹"] = {nSortID = 6, tSubSort = {}, },
		["秘笈"] =
		{
			nSortID = 7,
			tSubSort =
			{
				["江湖秘笈"] = 1,
				["纯阳秘笈"] = 2,
				["天策秘笈"] = 3,
				["少林秘笈"] = 4,
				["七秀秘笈"] = 5,
				["万花秘笈"] = 6,				
				["藏剑秘笈"] = 7,
				["五毒秘笈"] = 8,
				["唐门秘笈"] = 9,
				["明教秘笈"] = 10,
				["丐帮秘笈"] = 11,
			},
		},
		["配方"] =
		{
			nSortID = 8,
			tSubSort =
			{
				["缝纫配方"] = 1,
				["烹饪配方"] = 2,
				["医术配方"] = 3,
				["铸造配方"] = 4,
			},
		},
		["消耗品"] =
		{
			nSortID = 9,
			tSubSort =
			{
				["食物"]     = 1,
				["药品"]     = 2,
				--["物品强化"] = 3,
				["礼品"]     = 4,
				["草料"]     = 5,
			},
		},
		["物品强化"] =
		{
			nSortID = 13,
			tSubSort =
			{
				["帽子"] = 1,
				["上衣"] = 2,
				["下装"] = 3,
				["腰带"] = 4,
				["鞋子"] = 5,
				["护腕"] = 6,
				["武器"] = 7,
				["饰品"] = 8,
			},
		},
		["材料"] =
		{
			nSortID = 10,
			tSubSort =
			{
				["金属与矿物"] = 1,
				["药草"] = 2,
				["酒"]   = 3,
				["布料"] = 4,
				["皮料"] = 5,
				["肉类"] = 6,
				["纸墨"] = 7,
				["特殊材料"] = 8,
			},
		},
		["书籍"] =
		{
			nSortID = 12,
			tSubSort =
			{
				["杂集"] = 1,
				["道学"] = 2,
				["佛学"] = 3,
			},
		},
		["宝石"] =
		{
			nSortID = 15,
			tSubSort =
			{
				["金系五行石"] = 1,
				["木系五行石"] = 2,
				["水系五行石"] = 3,
				["火系五行石"] = 4,
				["土系五行石"] = 5,
				["五彩石"] = 6,
			},
		},
		["宝箱"] =
		{
			nSortID = 16,
			tSubSort =
			{
				["宝箱"] = 1,
				["钥匙"] = 2,
			},
		},
		["帮会产物"] =
		{
			nSortID = 14,
			tSubSort =
			{
				["瑰石"] = 1,
				["其他"] = 2,
			},
		},
		["其他"] =
		{
			nSortID = 20,
			tSubSort =
			{
				["垃圾"] = 1,
				["其他"] = 2,
			},
		},
	}

function EquipSearch.GetItemAuctionType(nAucType, nAucSubType)
    for k, v in pairs(EquipSearch.tSearchSort) do
        if v.nSortID == nAucType then
            for szKey, nID in pairs(v.tSubSort) do
                if nID == nAucSubType then
                    return szKey
                end
            end
        end
    end
end

function EquipSearch.FormatItemInfo(tLine, dwType)
	local szItemName = Table_GetItemName(tLine.UiID)
	return{
		dwTabType = dwType,
		nItemID = tLine.ID,	--物品ID
		szName = szItemName,	--物品名称
		nRepresentID = tLine.RepresentID or 0,	--模型ID
		nColorID = tLine.ColorID or 0,	--颜色ID
		szEquipType = EquipSearch.GetItemAuctionType(tLine.AucGenre, tLine.AucSubType) or "",	--装备类型
		nRequireLevel = tLine.Require1Value or 0,	--需求等级
		nQualityLevel = tLine.Level or 0,	--装备品级
		nQuality = tLine.Quality or 0,	--装备品质	
		szBelongSchool = tLine.BelongSchool or "",	--所属职业
		szMagicKind = tLine.MagicKind or "",	--类型
		szMagicType = tLine.MagicType or "",	--类型
		szGetType = tLine.GetType or "",	--获取类型
		szBelongMap = tLine.BelongMap or "",  --出处
		nAucGenre = tLine.AucGenre,
		nAucSubType = tLine.AucSubType,
		nCampRequest = tLine.RequireCamp,	--阵营需求
		}
end

function EquipSearch.FilterItem(tData)
	if (tFilter.nSort==0 or tFilter.nSort==tData.nAucGenre) and 
		(tFilter.nSubSort==0 or tFilter.nSubSort==tData.nAucSubType) and
		(tFilter.nQuality==-1 or tFilter.nQuality==tData.nQuality) and
		(tFilter.szName=="" or StringFindW(tData.szName, tFilter.szName) ) and
		(tFilter.szGetType =="" or StringFindW(tData.szGetType, tFilter.szGetType) ) and
		(tFilter.nLevelMin <= tData.nRequireLevel)	and 
		(tFilter.nLevelMax >= tData.nRequireLevel)	and 
		(tFilter.nQualityLevelMin <= tData.nQualityLevel)	and 
		(tFilter.nQualityLevelMax >= tData.nQualityLevel)	and
		(tFilter.nRepresentID==-1 or tFilter.nRepresentID==tData.nRepresentID) and
		(tFilter.nColorID==-1 or tFilter.nColorID==tData.nColorID) then
		if tFilter.szSchoolType == "" then
			return	true
		elseif tFilter.szSchoolType == "易筋经" then
			if (StringFindW(tData.szBelongSchool, "少林") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "元气")) then
				return true
			end
		elseif tFilter.szSchoolType == "洗髓经" then
			if (StringFindW(tData.szBelongSchool, "少林") and StringFindW(tData.szMagicKind, "防御")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "防御")) then
				return true
			end
		elseif tFilter.szSchoolType == "花间游" then
			if (StringFindW(tData.szBelongSchool, "万花") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "元气")) then
				return true
			end
		elseif tFilter.szSchoolType == "离经易道" then
			if (StringFindW(tData.szBelongSchool, "万花") and StringFindW(tData.szMagicKind, "治疗")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "治疗")) then
				return true
			end
		elseif tFilter.szSchoolType == "傲血战意" then
			if (StringFindW(tData.szBelongSchool, "天策") and StringFindW(tData.szMagicKind, "外功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "力道")) then
				return true
			end
		elseif tFilter.szSchoolType == "铁牢律" then
			if (StringFindW(tData.szBelongSchool, "天策") and StringFindW(tData.szMagicKind, "防御")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "防御")) then
				return true
			end
		elseif tFilter.szSchoolType == "太虚剑意" then
			if (StringFindW(tData.szBelongSchool, "纯阳") and StringFindW(tData.szMagicKind, "外功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "身法")) then
				return true
			end
		elseif tFilter.szSchoolType == "紫霞功" then
			if (StringFindW(tData.szBelongSchool, "纯阳") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "根骨")) then
				return true
			end
		elseif tFilter.szSchoolType == "冰心诀" then
			if (StringFindW(tData.szBelongSchool, "七秀") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "根骨")) then
				return true
			end
		elseif tFilter.szSchoolType == "云裳心经" then
			if (StringFindW(tData.szBelongSchool, "七秀") and StringFindW(tData.szMagicKind, "治疗")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "治疗")) then
				return true
			end
		elseif tFilter.szSchoolType == "毒经" then
			if (StringFindW(tData.szBelongSchool, "五毒") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "根骨")) then
				return true
			end
		elseif tFilter.szSchoolType == "补天诀" then
			if (StringFindW(tData.szBelongSchool, "五毒") and StringFindW(tData.szMagicKind, "治疗")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "治疗")) then
				return true
			end
		elseif tFilter.szSchoolType == "惊羽诀" then
			if (StringFindW(tData.szBelongSchool, "唐门") and StringFindW(tData.szMagicKind, "外功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "力道")) then
				return true
			end
		elseif tFilter.szSchoolType == "天罗诡道" then
			if (StringFindW(tData.szBelongSchool, "唐门") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "元气")) then
				return true
			end
		elseif tFilter.szSchoolType == "藏剑" then
			if (StringFindW(tData.szBelongSchool, "藏剑") and StringFindW(tData.szMagicKind, "外功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "身法")) then
				return true
			end
		elseif tFilter.szSchoolType == "丐帮" then
			if (StringFindW(tData.szBelongSchool, "丐帮") and StringFindW(tData.szMagicKind, "外功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "力道")) then
				return true
			end
		elseif tFilter.szSchoolType == "焚影圣诀" then
			if (StringFindW(tData.szBelongSchool, "明教") and StringFindW(tData.szMagicKind, "内功")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "元气")) then
				return true
			end
		elseif tFilter.szSchoolType == "明尊琉璃体" then
			if (StringFindW(tData.szBelongSchool, "明教") and StringFindW(tData.szMagicKind, "防御")) or
				(StringFindW(tData.szBelongSchool, "通用") and StringFindW(tData.szMagicKind, "防御")) then
				return true
			end
		elseif tFilter.szSchoolType == "精简（外功）" then
			if (StringFindW(tData.szBelongSchool, "精简") and StringFindW(tData.szMagicKind, "外功")) then
				return true
			end
		elseif tFilter.szSchoolType == "精简（内功）" then
			if (StringFindW(tData.szBelongSchool, "精简") and StringFindW(tData.szMagicKind, "内功")) then
				return true
			end
		elseif tFilter.szSchoolType == "精简（治疗）" then
			if (StringFindW(tData.szBelongSchool, "精简") and StringFindW(tData.szMagicKind, "治疗")) then
				return true
			end
		elseif tFilter.szSchoolType == "精简（防御）" then
			if (StringFindW(tData.szBelongSchool, "精简") and StringFindW(tData.szMagicKind, "防御")) then
				return true
			end
		end
		return false
	else
		return false
	end
end

function EquipSearch.ResetFilter()
	local frame = Station.Lookup("Normal/EquipSearch")
	local hWnd = frame:Lookup("Wnd_Search")
	hWnd:Lookup("Edit_ItemName"):SetText("")
	hWnd:Lookup("Edit_Level1"):SetText("")
	hWnd:Lookup("Edit_Level2"):SetText("")
	hWnd:Lookup("Edit_QualityLevel1"):SetText("")
	hWnd:Lookup("Edit_QualityLevel2"):SetText("")
	hWnd:Lookup("Edit_RepresentID"):SetText("")
	hWnd:Lookup("Edit_ColorID"):SetText("")
	
	tFilter.nQuality = -1
	tFilter.szSchoolType = ""
	tFilter.szGetType = ""
	tFilter.szName = ""
	tFilter.nLevelMin = 0
	tFilter.nLevelMax = 99
	tFilter.nQualityLevelMin = 0
	tFilter.nQualityLevelMax = 999
	tFilter.nRepresentID = -1
	tFilter.nColorID = -1
	EquipSearch.UpdateResult()
end

--刷新搜索结果
function EquipSearch.UpdateResult()
	local frame = Station.Lookup("Normal/EquipSearch")
	
	tResult = {}
	RESULT_PAGE_START = 1
	local nCount = 0 
	
	for i=2,#tDataBase,1 do
		tData = tDataBase[i]
		if EquipSearch.FilterItem(tData) then
			table.insert(tResult, tData)
		end
	end
	
	
	EquipSearch.UpdateResultList(frame, RESULT_PAGE_START, tResult)
end

--加载数据
function EquipSearch.LoadData()
	tDataBase = {}
	EquipSearch.Custom_Armor_List = KG_Table.Load(EquipSearch.Custom_Armor_Tab.Path, EquipSearch.Custom_Armor_Tab.Title) or 
															KG_Table.Load(EquipSearch.Custom_Armor_Tab_2.Path, EquipSearch.Custom_Armor_Tab_2.Title)	
	EquipSearch.Custom_Weapon_List = KG_Table.Load(EquipSearch.Custom_Weapon_Tab.Path, EquipSearch.Custom_Weapon_Tab.Title)or 
															KG_Table.Load(EquipSearch.Custom_Weapon_Tab_2.Path, EquipSearch.Custom_Weapon_Tab_2.Title)
	EquipSearch.Custom_Trinket_List = KG_Table.Load(EquipSearch.Custom_Trinket_Tab.Path, EquipSearch.Custom_Trinket_Tab.Title)or 
															KG_Table.Load(EquipSearch.Custom_Trinket_Tab_2.Path, EquipSearch.Custom_Trinket_Tab_2.Title)
	EquipSearch.Custom_Other_List = KG_Table.Load(EquipSearch.Custom_Other_Tab.Path, EquipSearch.Custom_Other_Tab.Title)or 
															KG_Table.Load(EquipSearch.Custom_Other_Tab_2.Path, EquipSearch.Custom_Other_Tab_2.Title)
	nCount = EquipSearch.Custom_Armor_List:GetRowCount()
	for i = nCount, 2, -1 do
		tLine = EquipSearch.Custom_Armor_List:GetRow(i)
		tData = EquipSearch.FormatItemInfo(tLine, ITEM_TABLE_TYPE.CUST_ARMOR)
		table.insert(tDataBase, tData)
	end
	
	nCount = EquipSearch.Custom_Weapon_List:GetRowCount()
	for i = nCount, 2, -1 do
		tLine = EquipSearch.Custom_Weapon_List:GetRow(i)
		tData = EquipSearch.FormatItemInfo(tLine, ITEM_TABLE_TYPE.CUST_WEAPON)
		table.insert(tDataBase, tData)
	end
	
	nCount = EquipSearch.Custom_Trinket_List:GetRowCount()
	for i = nCount, 2, -1 do
		tLine = EquipSearch.Custom_Trinket_List:GetRow(i)
		tData = EquipSearch.FormatItemInfo(tLine, ITEM_TABLE_TYPE.CUST_TRINKET)
		table.insert(tDataBase, tData)
	end
	
	nCount = EquipSearch.Custom_Other_List:GetRowCount()
	for i = nCount, 2, -1 do
		tLine = EquipSearch.Custom_Other_List:GetRow(i)
		tData = EquipSearch.FormatItemInfo(tLine, ITEM_TABLE_TYPE.OTHER)
		table.insert(tDataBase, tData)
	end
	
	EquipSearch.Custom_Armor_List = nil
	EquipSearch.Custom_Weapon_List = nil
	EquipSearch.Custom_Trinket_List = nil
	EquipSearch.Custom_Other_List = nil
	
	--读取装备大全数据库--
	EquipSearch.Equipdb_List = KG_Table.Load(EquipSearch.Equipdb_Txt.Path, EquipSearch.Equipdb_Txt.Title)
	nCount = EquipSearch.Equipdb_List:GetRowCount()
	for i = nCount, 2, -1 do
		tLine = EquipSearch.Equipdb_List:GetRow(i)
		local dwTabeType = tLine.TabType or 0
		local nID = tLine.ID or 0
		if not tEquipdb[dwTabeType] then
			tEquipdb[dwTabeType] = {}
		end
		tEquipdb[dwTabeType][nID] = 
		{
			szGetType = tLine.GetType or "",
			szGetDesc = tLine.Get_Desc or "",
			szGetForce = tLine.Get_Force or "",		
			szBelongMapID = tLine.BelongMapID or "",
			szPrestigeRequire = tLine.PrestigeRequire or "",
		}
	end
	EquipSearch.Equipdb_List = nil
	
	--从附魔数据读取马具表现ID--
	--[[EquipSearch.Enchant_List = KG_Table.Load(EquipSearch.Enchant_Tab.Path, EquipSearch.Enchant_Tab.Title)
	nCount = EquipSearch.Enchant_List:GetRowCount()
	for i=2,nCount,1 do
		tLine = EquipSearch.Enchant_List:GetRow(i)
		tData = {
		nRepresentIndex = tLine.RepresentIndex or 0,
		nRepresentID = tLine.RepresentID or 0,
		nUIID = tLine.UIID or 0,
		}
		if tData["nRepresentIndex"] >= 27 and tData["nRepresentIndex"] <= 30 then
			table.insert(tEnchant, tData)
		end
	end
	EquipSearch.Enchant_List = nil]]
end

function EquipSearch.OnFrameCreate()
	EquipSearch.UpdateItemTypeList(this)
	EquipSearch.ResetFilter()
end

RegisterEvent("NPC_ENTER_SCENE", function()
	EquipSearch.tNpcList[arg0] = 0
end)

RegisterEvent("NPC_LEAVE_SCENE", function()
	EquipSearch.tNpcList[arg0] = nil
end)

function EquipSearch.OnFrameBreathe()
	local frame = Station.Lookup("Normal/EquipSearch")
	local hWnd = frame:Lookup("Wnd_Search")
	tFilter.szName =  hWnd:Lookup("Edit_ItemName"):GetText() or ""
	tFilter.nLevelMin = tonumber(hWnd:Lookup("Edit_Level1"):GetText()) or 0
	tFilter.nLevelMax = tonumber(hWnd:Lookup("Edit_Level2"):GetText()) or 99
	tFilter.nQualityLevelMin = tonumber(hWnd:Lookup("Edit_QualityLevel1"):GetText()) or 0
	tFilter.nQualityLevelMax = tonumber(hWnd:Lookup("Edit_QualityLevel2"):GetText()) or 999
	tFilter.nRepresentID = tonumber(hWnd:Lookup("Edit_RepresentID"):GetText()) or -1
	tFilter.nColorID = tonumber(hWnd:Lookup("Edit_ColorID"):GetText()) or -1

end

--刷新目录菜单
function EquipSearch.UpdateItemTypeList(frame)
	local tItemType = {}
	for k, tSubType in pairs(EquipSearch.tSearchSort) do
		if tSubType.nSortID ~= 12 then --过滤掉书籍选项
			tItemType[tSubType.nSortID] = {szType = k, tSubType = {}}
			for i, v in pairs(tSubType.tSubSort) do
				tItemType[tSubType.nSortID].tSubType[v] = i
			end
		end
	end

	local hWnd = frame:Lookup("Wnd_Search")
	local hListLv1 = hWnd:Lookup("", "Handle_SearchList")
	hListLv1:Clear()

	for k, v in pairs(tItemType) do
		local hListLv2 = hListLv1:AppendItemFromIni(INI_FILE_PATH, "Handle_ListContent")
		local imgBg1 = hListLv2:Lookup("Image_SearchListBg1")
		local imgBg2 = hListLv2:Lookup("Image_SearchListBg2")
		local imgCover = hListLv2:Lookup("Image_SearchListCover")
		local imgMin = hListLv2:Lookup("Image_Minimize")

		if EXPAND_ITEM_TYPE.szType == v.szType then
			hListLv2.bSel = true
			local hListLv3 = hListLv2:Lookup("Handle_Items")
	    	local w, h = EquipSearch.AddItemSubTypeList(hListLv3, v.tSubType or {})
	    	imgBg1:Hide()
	    	imgBg2:Show()
	    	imgCover:Show()
	    	imgMin:SetFrame(8)

	    	local wB, _ = imgBg2:GetSize()
	    	imgBg2:SetSize(wB, h + 50)

	    	local wL, _ = hListLv2:GetSize()
	    	hListLv2:SetSize(wL, h + 50)
	    else
	    	imgBg1:Show()
	    	imgBg2:Hide()
	    	imgCover:Hide()
	    	imgMin:SetFrame(12)
	    	imgBg2:SetSize(0, 0)

	    	local w, h = imgBg1:GetSize()
	    	hListLv2:SetSize(w, h)
	    end

		hListLv2:Lookup("Text_ListTitle"):SetText(v.szType)
	end
	EquipSearch.OnUpdateItemTypeList(hListLv1)	--刷新滚动条
end

--添加子目录菜单
function EquipSearch.AddItemSubTypeList(hList, tSubType)
	for k, v in pairs(tSubType) do
		local hItem = hList:AppendItemFromIni(INI_FILE_PATH, "Handle_List01")
		local imgCover =  hItem:Lookup("Image_SearchListCover01")
		if EXPAND_ITEM_TYPE.szSubType == v then
			hItem.bSel = true
			imgCover:Show()
		else
			imgCover:Hide()
		end

		hItem:Lookup("Text_List01"):SetText(v)

	end
	hList:Show()
	hList:FormatAllItemPos()
	hList:SetSizeByAllItemSize()
	return hList:GetSize()
end

--刷新目录滚动条
function EquipSearch.OnUpdateItemTypeList(hList)
	hList:FormatAllItemPos()
	local hWnd = hList:GetParent():GetParent()
	local scroll = hWnd:Lookup("Scroll_Search")
	local w, h = hList:GetSize()
	local wAll, hAll = hList:GetAllItemSize()
	local nStepCount = math.ceil((hAll - h) / 10)

	scroll:SetStepCount(nStepCount)
	if nStepCount > 0 then
		scroll:Show()
		hWnd:Lookup("Btn_SUp"):Show()
		hWnd:Lookup("Btn_SDown"):Show()
	else
		scroll:Hide()
		hWnd:Lookup("Btn_SUp"):Hide()
		hWnd:Lookup("Btn_SDown"):Hide()
	end
end

--更新搜索结果列表
function EquipSearch.UpdateResultList(frame, nStart, tResult)
	if not tItemInfo then
		tItemInfo = {}
	end
	local player = GetClientPlayer()
	local hList, szItem = nil, nil
	local hList = frame:Lookup("Wnd_Result", "Handle_List")

	hList:Clear()
	hList.hSelItem = nil
    local nEnd = nStart + PAGE_RESULT_COUNT - 1
    nEnd = math.min(nEnd, #tResult)
    for i=nStart, nEnd, 1 do
        local tItem = tResult[i]
		-- if tItem.szName == "" then
        local hItem = hList:AppendItemFromIni(INI_FILE_PATH, "Handle_ItemList")
        local hBox = hItem:Lookup("Box_Bg")
        local hItemInfo = GetItemInfo(tItem.dwTabType, tItem.nItemID)
        local nIconID = Table_GetItemIconID(hItemInfo.nUiId)
        local tRecommend = g_tTable.EquipRecommend:Search(hItemInfo.nRecommendID)
        local szSchool = ""
        if tRecommend and tRecommend.szDesc then
            szSchool = tRecommend.szDesc
        end
        hItem.dwTabType = tItem.dwTabType
        hItem.nItemID = tItem.nItemID
		hItem.nRepresentID = tItem.nRepresentID
		hItem.nColorID = tItem.nColorID
		hItem.szEquipType = tItem.szEquipType
		
        hBox.dwTabType = tItem.dwTabType
        hBox.nItemID = tItem.nItemID
		hBox.nRepresentID = tItem.nRepresentID
		hBox.nColorID = tItem.nColorID
		hBox.szEquipType = tItem.szEquipType
		
        local szKey = tItem.dwTabType..tItem.nItemID

        hBox:SetObject(UI_OBJECT_ITEM_INFO, GLOBAL.CURRENT_ITEM_VERSION, tItem.dwTabType, tItem.nItemID)
        hBox:SetObjectIcon(nIconID)
        hItem:Lookup("Text_BoxName"):SetText(tItem.szName)
        local r, g, b = GetItemFontColorByQuality(hItemInfo.nQuality)
        hItem:Lookup("Text_BoxName"):SetFontColor(r, g, b)
        hItem:Lookup("Text_BoxCategory"):SetText(tItem.szEquipType)
        hItem:Lookup("Text_BoxLevel"):SetText(tItem.nRequireLevel)
        hItem:Lookup("Text_BoxQuality"):SetText(tItem.nQualityLevel)
        hItem:Lookup("Text_BoxRepresent"):SetText(hItem.nRepresentID)
        hItem:Lookup("Text_BoxColor"):SetText(tItem.nColorID)
        hItem:Lookup("Text_BoxSchool"):SetText(tItem.szBelongSchool.." "..tItem.szMagicKind.." "..tItem.szMagicType)
        hItem:Lookup("Text_BoxDrop"):SetText(tItem.szGetType.." "..tItem.szBelongMap)
        if i == nStart then
            EquipSearch.Selected(hItem)
        end
        EquipSearch.UpdateBgStatus(hItem, "Image_Light")
		-- end
    end
    EquipSearch.OnUpdateItemList(hList, true)	--刷新搜索结果滚动条
    
    local hWndRes = frame:Lookup("Wnd_Search")
    EquipSearch.UpdatePageInfo(hWndRes, nStart, #tResult)	--刷新结果列表翻页
end

--刷新结果列表翻页按钮
function EquipSearch.UpdatePageInfo(hWnd, nStart, nTotal)
	local player = GetClientPlayer()
	local btnBack = hWnd:Lookup("Btn_Back1")
	local btnNext = hWnd:Lookup("Btn_Next1")
	local text    = hWnd:Lookup("", "Text_Page1")
	
	local nEnd = nStart + PAGE_RESULT_COUNT - 1
	nEnd = math.min(nEnd, nTotal)
	btnBack:Enable(nStart ~= 1)
	btnNext:Enable(nEnd < nTotal)
	if nTotal == 0 then
		text:SetText("(0-0(0))")
	else
		if nEnd > nTotal then
			local szText = ""
			local nLargest = GetIntergerBit(nTotal)
			for i = 1, nLargest do
				szText = szText .. "?"
			end
			text:SetText(szText.."-"..szText.." ("..nTotal..")")
		else
			text:SetText(nStart.."-"..nEnd.." ("..nTotal..")")
		end
	end
end

--刷新结果栏选中项高亮
function EquipSearch.UpdateBgStatus(hItem, szImage)

	if not hItem then
		return
	end
	local img = hItem:Lookup(szImage)
	if not img then
		return
	end

	if hItem.bSel then
		img:Show()
		img:SetAlpha(255)
	elseif hItem.bOver then
		img:Show()
		img:SetAlpha(128)
	else
		img:Hide()
	end
end

--选中项目
function EquipSearch.Selected(hItem)
	if hItem then
		local hList = hItem:GetParent()
		local nCount = hList:GetItemCount() - 1
		for i=0, nCount, 1 do
			local hI = hList:Lookup(i)
			if hI.bSel then
				hI.bSel = false
				AuctionPanel.UpdateBgStatus(hI)
			end
		end
		hItem.bSel = true
		EquipSearch.UpdateBgStatus(hItem, "Image_Light")
	end
end

--刷新搜索结果滚动条
function EquipSearch.OnUpdateItemList(hList, bDefault)
	hList:FormatAllItemPos()
	local hWnd = hList:GetParent():GetParent()
	local scroll = hWnd:Lookup("Scroll_Result")
	local w, h = hList:GetSize()
	local wAll, hAll = hList:GetAllItemSize()
	local nStepCount = math.ceil((hAll - h) / 10)

	scroll:SetStepCount(nStepCount)
	if nStepCount > 0 then
		scroll:Show()
		hWnd:Lookup("Btn_RUp"):Show()
		hWnd:Lookup("Btn_RDown"):Show()
	else
		scroll:Hide()
		hWnd:Lookup("Btn_RUp"):Hide()
		hWnd:Lookup("Btn_RDown"):Hide()
	end
	if bStart then
		scroll:SetScrollPos(0)
	end
end

function EquipSearch.OnItemLButtonClick()
	local szName = this:GetName()
	
	if szName == "Handle_ListContent" then
		local szType = this:Lookup("Text_ListTitle"):GetText()
		if EXPAND_ITEM_TYPE.szType == szType then
			EXPAND_ITEM_TYPE = {}
			tFilter.nSort = 0
			tFilter.nSubSort = 0
		else
			EXPAND_ITEM_TYPE.szType = szType
			tFilter.nSort = EquipSearch.tSearchSort[szType].nSortID or 0
			tFilter.nSubSort = 0
		end
		EquipSearch.UpdateItemTypeList(this:GetRoot())	--刷新目录
		EquipSearch.UpdateResult()	--刷新结果
		PlaySound(SOUND.UI_SOUND,g_sound.Button)
	elseif szName == "Handle_List01" then
		local szSubType = this:Lookup("Text_List01"):GetText()
		EXPAND_ITEM_TYPE.szSubType = szSubType
		tFilter.nSubSort = EquipSearch.tSearchSort[EXPAND_ITEM_TYPE.szType].tSubSort[EXPAND_ITEM_TYPE.szSubType] or 0
		EquipSearch.UpdateItemTypeList(this:GetRoot())
		EquipSearch.UpdateResult()	--刷新结果
	elseif szName == "Handle_ItemList" or szName == "Box_Bg" or szName == "iteminfolink" then
		local iteminfo = GetItemInfo(this.dwTabType, this.nItemID)
		if iteminfo and Table_GetItemName(iteminfo.nUiId) ~= "" then
			this.nVersion = GLOBAL.CURRENT_ITEM_VERSION
			this.dwIndex = this.nItemID
			this:SetName("iteminfolink")
			OnItemLinkDown(this)
		end
	end
end

function EquipSearch.OnScrollBarPosChanged()
	local hWnd = this:GetParent()
	local nCurrentValue = this:GetScrollPos()
	local szName = this:GetName()
	local hBtnUp, hBtnDown, hList = nil, nil, nil
	if szName == "Scroll_Result" then
		hBtnUp = hWnd:Lookup("Btn_RUp")
		hBtnDown = hWnd:Lookup("Btn_RDown")
		hList = hWnd:Lookup("", "Handle_List")
	elseif szName == "Scroll_Search" then
		hBtnUp = hWnd:Lookup("Btn_SUp")
		hBtnDown = hWnd:Lookup("Btn_SDown")
		hList = hWnd:Lookup("", "Handle_SearchList")
	end

	if nCurrentValue == 0 then
		hBtnUp:Enable(false)
	else
		hBtnUp:Enable(true)
	end

	if nCurrentValue == this:GetStepCount() then
		hBtnDown:Enable(false)
	else
		hBtnDown:Enable(true)
	end
	hList:SetItemStartRelPos(0, -nCurrentValue * 10)
end

function EquipSearch.OnItemMouseWheel()
	local nDistance = Station.GetMessageWheelDelta()
	local szName = this:GetName()
	if szName == "Handle_List" then
		this:GetParent():GetParent():Lookup("Scroll_Result"):ScrollNext(nDistance)
	elseif szName == "Handle_SearchList" then
		this:GetParent():GetParent():Lookup("Scroll_Search"):ScrollNext(nDistance)
	end
	return true
end

function EquipSearch.OnLButtonHold()
	local szName = this:GetName()
	if szName == "Btn_RUp" then
		this:GetParent():Lookup("Scroll_Result"):ScrollPrev()
	elseif szName == "Btn_RDown" then
		this:GetParent():Lookup("Scroll_Result"):ScrollNext()
	elseif szName == "Btn_SUp" then
		this:GetParent():Lookup("Scroll_Search"):ScrollPrev()
	elseif szName == "Btn_SDown" then
		this:GetParent():Lookup("Scroll_Search"):ScrollNext()
	end
end

function EquipSearch.SplitString(szString, szType)
	local tSplited = {}
	local nLen = string.len(szString)
	local nBegin, nStart, nEnd = 1
	while true do
		if nBegin > nLen then
			return tSplited
		end
		if szType == "szGetType" then
			nStart, nEnd = string.find(szString, "%P+", nBegin)
			table.insert(tSplited, string.sub(szString, nStart, nEnd))
		elseif szType == "szGetDesc" then
			nStart, nEnd = string.find(szString, ".-%}", nBegin)
			table.insert(tSplited, string.sub(szString, nStart + 1, nEnd - 1))
		elseif szType == "szBossName" then
			nStart, nEnd = string.find(szString, ".-%]", nBegin)
			table.insert(tSplited, string.sub(szString, nStart + 1, nEnd - 1))
		elseif szType == "szBelongMapID" then
			nStart, nEnd = string.find(szString, "%d+", nBegin)
			table.insert(tSplited, tonumber(string.sub(szString, nStart, nEnd)))
		end
		nBegin = nEnd + 2
	end
end

function EquipSearch.GetDropInfoFromEquipdb(tData)
	local szTip = ""
	local szGetType = tData["szGetType"]
	local szGetDesc = tData["szGetDesc"]
	if szGetType == "" or szGetDesc == "" then
		return ""
	end
	local tGetType = EquipSearch.SplitString(szGetType, "szGetType")
	local tGetDesc = EquipSearch.SplitString(szGetDesc, "szGetDesc")
	for i, v in pairs (tGetType) do
		if v == "声望" then
			local szGetForce = tData["szGetForce"]
			local szPrestigeRequire = tData["szPrestigeRequire"]
			if szGetForce ~= "" or szPrestigeRequire ~= "" then
				szTip = szTip ..  GetFormatText(v .. "（" .. szGetForce .. " " .. szPrestigeRequire .. "）：\n  ", 23) .. GetFormatText(tGetDesc[i] .. "\n", 22)
			else
				szTip = szTip ..  GetFormatText(v .. "：\n  ", 23) .. GetFormatText(tGetDesc[i] .. "\n", 22)
			end
		elseif v == "副本" or v == "野外Boss" then
			local szBelongMapID = tData["szBelongMapID"]
			if szBelongMapID ~= "" then
				local tBossName = EquipSearch.SplitString(tGetDesc[i], "szBossName")
				local tBelongMapID =EquipSearch.SplitString(szBelongMapID, "szBelongMapID")
				szTip = szTip ..  GetFormatText(v .. "：\n", 23)
				for j, k in pairs (tBossName) do
					szTip = szTip ..  GetFormatText("  " .. Table_GetMapName(tBelongMapID[j]) .. "：", 21) .. GetFormatText(k .. "\n", 22)
				end
			else
				szTip = szTip ..  GetFormatText(v .. "：\n  ", 23) .. GetFormatText(tGetDesc[i] .. "\n", 22)
			end
		else
			szTip = szTip ..  GetFormatText(v .. "：\n  ", 23) .. GetFormatText(tGetDesc[i] .. "\n", 22)
		end
	end	
	return szTip
end

function EquipSearch.OnItemMouseEnter()
	local szName = this:GetName()
    if szName == "Handle_ItemList" or szName == "iteminfolink" then
		if IsAltKeyDown() then
			-- local szTip = ""
			-- if tEquipdb[this.dwTabType] then
			-- 	local tData = tEquipdb[this.dwTabType][this.nItemID]
			-- 	if tData then
			-- 		szTip = EquipSearch.GetDropInfoFromEquipdb(tData)
			-- 	end
			-- end
			-- local x, y = this:GetAbsPos()
			-- local w, h = this:GetSize()	
			-- if szTip ~= "" then
			-- 	OutputTip(szTip, 400, {x, y, w, h})
			-- else
			-- 	OutputTip(GetFormatText("暂无详细掉落信息", 20), 400, {x, y, w, h})
			-- end
		else
			local box = this:Lookup("Box_Bg")
			local x, y = box:GetAbsPos()
			local w, h = box:GetSize()
			OutputItemTip(UI_OBJECT_ITEM_INFO, GLOBAL.CURRENT_ITEM_VERSION, box.dwTabType, box.nItemID, {x, y, w, h})
			this:Lookup("Image_Light"):Show()
		end 
    elseif this:IsLink() and this:GetType() == "Text" then
        this.nFont=this:GetFontScheme()
        this:SetFontScheme(188)
	end
end

function EquipSearch.OnItemMouseLeave()
	local szName = this:GetName()
	if szName == "Handle_ItemList" or szName == "iteminfolink" then
        HideTip()
        this:Lookup("Image_Light"):Hide()
		this.bOver = false
    elseif this:IsLink() and this:GetType() == "Text" then
        this:SetFontScheme(this.nFont)
	end
end

function EquipSearch.OnLButtonClick() 
		local frame = Station.Lookup("Normal/EquipSearch")
    local szName = this:GetName()
    if szName == "Btn_Search" then
        EquipSearch.UpdateResult()
    elseif szName == "Btn_SearchDefault" then
    		EquipSearch.ResetFilter()				
    elseif szName == "Btn_Back1" then
        RESULT_PAGE_START = math.max(1, RESULT_PAGE_START - PAGE_RESULT_COUNT)
        EquipSearch.UpdateResultList(frame, RESULT_PAGE_START, tResult)
    elseif szName == "Btn_Next1" then
        RESULT_PAGE_START = RESULT_PAGE_START + PAGE_RESULT_COUNT
        EquipSearch.UpdateResultList(frame, RESULT_PAGE_START, tResult)
    elseif szName == "Btn_Filter" then
    
				if not this:IsEnabled() then
					return
				end
				local text = this:GetParent():Lookup("", "Text_Filter")
				local xA, yA = text:GetAbsPos()
				local w, h = text:GetSize()
				local menu =
					{
						nMiniWidth = w,
						x = xA, y = yA + h,
						fnCancelAction = function()
							local btn = Station.Lookup("Normal/EquipSearch/Wnd_Search/Btn_Filter")
							if btn then
								local x, y = Cursor.GetPos()
								local xA, yA = btn:GetAbsPos()
								local w, h = btn:GetSize()
								if x >= xA and x < xA + w and y >= yA and y <= yA + h then
									btn.bIgnor = true
								end
							end
						end,
						fnAction = function(UserData, bCheck)
							local frame = Station.Lookup("Normal/EquipSearch")
						end,
						fnAutoClose = function() if EquipSearch.IsOpened() then return false else return true end end,
					}
		
			   table.insert(menu, {szOption = "品质过滤",
			   {szOption = "任何品质", bMCheck = true, bChecked = (tFilter.nQuality == -1), fnAction = function() tFilter.nQuality = -1 EquipSearch.UpdateResult() end,},
			   {szOption = "破败", bMCheck = true, bChecked = (tFilter.nQuality == 0), fnAction = function() tFilter.nQuality = 0 EquipSearch.UpdateResult() end,rgb = {GetItemFontColorByQuality(0, false)},},
			   {szOption = "普通", bMCheck = true, bChecked = (tFilter.nQuality == 1), fnAction = function() tFilter.nQuality = 1 EquipSearch.UpdateResult() end,rgb = {GetItemFontColorByQuality(1, false)},},
			   {szOption = "精巧", bMCheck = true, bChecked = (tFilter.nQuality == 2), fnAction = function() tFilter.nQuality = 2 EquipSearch.UpdateResult() end,rgb = {GetItemFontColorByQuality(2, false)},},
			   {szOption = "卓越", bMCheck = true, bChecked = (tFilter.nQuality == 3), fnAction = function() tFilter.nQuality = 3 EquipSearch.UpdateResult() end,rgb = {GetItemFontColorByQuality(3, false)},},
			   {szOption = "珍奇", bMCheck = true, bChecked = (tFilter.nQuality == 4), fnAction = function() tFilter.nQuality = 4 EquipSearch.UpdateResult() end,rgb = {GetItemFontColorByQuality(4, false)},},
			   {szOption = "稀世", bMCheck = true, bChecked = (tFilter.nQuality == 5), fnAction = function() tFilter.nQuality = 5 EquipSearch.UpdateResult() end,rgb = {GetItemFontColorByQuality(5, false)},},
			  }
			   )
			   table.insert(menu, {szOption = "心法过滤",
			   {szOption = "任何心法", bMCheck = true, bChecked = tFilter.szSchoolType == "", fnAction = function() tFilter.szSchoolType = "" tFilter.szBelongSchool = "" tFilter.szMagicKind = "" EquipSearch.UpdateResult() end,},
			   {szOption = "少林（易筋经）", bMCheck = true, bChecked = tFilter.szSchoolType == "易筋经", fnAction = function() tFilter.szSchoolType = "易筋经" EquipSearch.UpdateResult() end,},
			   {szOption = "少林（洗髓经）", bMCheck = true, bChecked = tFilter.szSchoolType == "洗髓经", fnAction = function() tFilter.szSchoolType = "洗髓经" EquipSearch.UpdateResult() end,},
			   {szOption = "万花（花间游）", bMCheck = true, bChecked = tFilter.szSchoolType == "花间游", fnAction = function() tFilter.szSchoolType = "花间游" EquipSearch.UpdateResult() end,},
			   {szOption = "万花（离经易道）", bMCheck = true, bChecked = tFilter.szSchoolType == "离经易道", fnAction = function() tFilter.szSchoolType = "离经易道" EquipSearch.UpdateResult() end,},
			   {szOption = "天策（傲血战意）", bMCheck = true, bChecked = tFilter.szSchoolType == "傲血战意", fnAction = function() tFilter.szSchoolType = "傲血战意" EquipSearch.UpdateResult() end,},
			   {szOption = "天策（铁牢律）", bMCheck = true, bChecked = tFilter.szSchoolType == "铁牢律", fnAction = function() tFilter.szSchoolType = "铁牢律" EquipSearch.UpdateResult() end,},
			   {szOption = "纯阳（太虚剑意）", bMCheck = true, bChecked = tFilter.szSchoolType == "太虚剑意", fnAction = function() tFilter.szSchoolType = "太虚剑意" EquipSearch.UpdateResult() end,},
			   {szOption = "纯阳（紫霞功）", bMCheck = true, bChecked = tFilter.szSchoolType == "紫霞功", fnAction = function() tFilter.szSchoolType = "紫霞功" EquipSearch.UpdateResult() end,},
			   {szOption = "七秀（冰心诀）", bMCheck = true, bChecked = tFilter.szSchoolType == "冰心诀", fnAction = function() tFilter.szSchoolType = "冰心诀" EquipSearch.UpdateResult() end,},
			   {szOption = "七秀（云裳心经）", bMCheck = true, bChecked = tFilter.szSchoolType == "云裳心经", fnAction = function() tFilter.szSchoolType = "云裳心经" EquipSearch.UpdateResult() end,},
			   {szOption = "五毒（毒经）", bMCheck = true, bChecked = tFilter.szSchoolType == "毒经", fnAction = function() tFilter.szSchoolType = "毒经" EquipSearch.UpdateResult() end,},
			   {szOption = "五毒（补天诀）", bMCheck = true, bChecked = tFilter.szSchoolType == "补天诀", fnAction = function() tFilter.szSchoolType = "补天诀" EquipSearch.UpdateResult() end,},
			   {szOption = "唐门（惊羽诀）", bMCheck = true, bChecked = tFilter.szSchoolType == "惊羽诀", fnAction = function() tFilter.szSchoolType = "惊羽诀" EquipSearch.UpdateResult() end,},
			   {szOption = "唐门（天罗诡道）", bMCheck = true, bChecked = tFilter.szSchoolType == "天罗诡道", fnAction = function() tFilter.szSchoolType = "天罗诡道" EquipSearch.UpdateResult() end,},
			   {szOption = "藏剑", bMCheck = true, bChecked = tFilter.szSchoolType == "藏剑", fnAction = function() tFilter.szSchoolType = "藏剑" EquipSearch.UpdateResult() end,},
			   {szOption = "丐帮", bMCheck = true, bChecked = tFilter.szSchoolType == "丐帮", fnAction = function() tFilter.szSchoolType = "丐帮" EquipSearch.UpdateResult() end,},
			   {szOption = "明教（焚影圣诀）", bMCheck = true, bChecked = tFilter.szSchoolType == "焚影圣诀", fnAction = function() tFilter.szSchoolType = "焚影圣诀" EquipSearch.UpdateResult() end,},
			   {szOption = "明教（明尊琉璃体）", bMCheck = true, bChecked = tFilter.szSchoolType == "明尊琉璃体", fnAction = function() tFilter.szSchoolType = "明尊琉璃体" EquipSearch.UpdateResult() end,},
			   {szOption = "精简（外功）", bMCheck = true, bChecked = tFilter.szSchoolType == "精简（外功）", fnAction = function() tFilter.szSchoolType = "精简（外功）" EquipSearch.UpdateResult() end,},
			   {szOption = "精简（内功）", bMCheck = true, bChecked = tFilter.szSchoolType == "精简（内功）", fnAction = function() tFilter.szSchoolType = "精简（内功）" EquipSearch.UpdateResult() end,},
			   {szOption = "精简（治疗）", bMCheck = true, bChecked = tFilter.szSchoolType == "精简（治疗）", fnAction = function() tFilter.szSchoolType = "精简（治疗）" EquipSearch.UpdateResult() end,},
			   {szOption = "精简（防御）", bMCheck = true, bChecked = tFilter.szSchoolType == "精简（防御）", fnAction = function() tFilter.szSchoolType = "精简（防御）" EquipSearch.UpdateResult() end,},
			  }
			   )
			   table.insert(menu, {szOption = "来源过滤",
			   {szOption = "任何来源", bMCheck = true, bChecked = (tFilter.szGetType == ""), fnAction = function() tFilter.szGetType = "" EquipSearch.UpdateResult() end,},
			   {szOption = "商店", bMCheck = true, bChecked = (tFilter.szGetType == "商店"), fnAction = function() tFilter.szGetType = "商店" EquipSearch.UpdateResult() end,},
			   {szOption = "任务", bMCheck = true, bChecked = (tFilter.szGetType == "任务"), fnAction = function() tFilter.szGetType = "任务" EquipSearch.UpdateResult() end,},
			   {szOption = "野怪", bMCheck = true, bChecked = (tFilter.szGetType == "掉落"), fnAction = function() tFilter.szGetType = "掉落" EquipSearch.UpdateResult() end,},
			   {szOption = "副本", bMCheck = true, bChecked = (tFilter.szGetType == "副本"), fnAction = function() tFilter.szGetType = "副本" EquipSearch.UpdateResult() end,},
			   {szOption = "声望", bMCheck = true, bChecked = (tFilter.szGetType == "声望"), fnAction = function() tFilter.szGetType = "声望" EquipSearch.UpdateResult() end,},
			   {szOption = "帮贡", bMCheck = true, bChecked = (tFilter.szGetType == "贡"), fnAction = function() tFilter.szGetType = "贡" EquipSearch.UpdateResult() end,},
			   {szOption = "侠义值", bMCheck = true, bChecked = (tFilter.szGetType == "侠义值"), fnAction = function() tFilter.szGetType = "侠义值" EquipSearch.UpdateResult() end,},
			   {szOption = "威望", bMCheck = true, bChecked = (tFilter.szGetType == "威望"), fnAction = function() tFilter.szGetType = "威望" EquipSearch.UpdateResult() end,},
			   {szOption = "竞技场", bMCheck = true, bChecked = (tFilter.szGetType == "竞技场"), fnAction = function() tFilter.szGetType = "竞技场" EquipSearch.UpdateResult() end,},
			   {szOption = "道具换取", bMCheck = true, bChecked = (tFilter.szGetType == "道具换取"), fnAction = function() tFilter.szGetType = "道具换取" EquipSearch.UpdateResult() end,},
			   {szOption = "生活技能", bMCheck = true, bChecked = (tFilter.szGetType == "生活技能"), fnAction = function() tFilter.szGetType = "生活技能" EquipSearch.UpdateResult() end,},
			   {szOption = "野外BOSS", bMCheck = true, bChecked = (tFilter.szGetType == "野外BOSS"), fnAction = function() tFilter.szGetType = "野外BOSS" EquipSearch.UpdateResult() end,},
			   {szOption = "小橙武", bMCheck = true, bChecked = (tFilter.szGetType == "神兵试炼"), fnAction = function() tFilter.szGetType = "神兵试炼" EquipSearch.UpdateResult() end,},
			   {szOption = "活动", bMCheck = true, bChecked = (tFilter.szGetType == "活动"), fnAction = function() tFilter.szGetType = "活动" EquipSearch.UpdateResult() end,},
			   {szOption = "宠物", bMCheck = true, bChecked = (tFilter.szGetType == "宠物系统"), fnAction = function() tFilter.szGetType = "宠物系统" EquipSearch.UpdateResult() end,},
			  }
			   )
				PopupMenu(menu)

				
    elseif szName == "Btn_Close" then
        EquipSearch.Close()
    end
end

function EquipSearch.IsOpened()
	local frame = Station.Lookup("Normal/EquipSearch")
	if frame and frame:IsVisible() then
		return true
	end
end

function EquipSearch.Open()

	EquipSearch.LoadData()
	
	local frame = Station.Lookup("Normal/EquipSearch")
	if not frame then
		frame = Wnd.OpenWindow("Interface/EquipSearch/EquipSearch.ini", "EquipSearch")
	else 
		frame:Show()
	end
end

function EquipSearch.Close()
	RESULT_PAGE_START = 1
	EXPAND_ITEM_TYPE = {}
	tResult = {}
	tDataBase = {}
	if EquipSearch.IsOpened() then
		Wnd.CloseWindow("EquipSearch")
	end
	
end

local menu = {szOption = "装备查询插件", fnAction = function() if EquipSearch.IsOpened() then EquipSearch.Close() else EquipSearch.Open() end end}
RegisterEvent("LOGIN_GAME", function()
	TraceButton_AppendAddonMenu({menu})
end)
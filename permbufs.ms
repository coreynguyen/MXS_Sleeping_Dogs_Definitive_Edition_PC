/*	======================================================================
	
	Maxscript:    [PC] Sleeping Dog - Definitive Edition
	Author:       mariokart64n
	Date:         June 06, 2024
	
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	
	Description:
		imports 3d models of the characters
	
	Change Log:
		2024-06-09
			- wrote importer
	
	======================================================================	*/

gc()
clearListener()
try(DestroyDialog sddef_mesh)catch(sddef_mesh)
rollout sddef_mesh "SDDEF Tool" (
	group "Skeleton" (
		button btn_skeleton "Load" width:120 height:36 align:#center
		button btn_make_rig "Build" width:120 height:36 align:#center
		dropdownlist ddl_skeleton "Skeletons:"
		checkbox chk_clear "Reset Scene" checked:true
		)
	group "Mesh" (
		button btn_import "Import" width:120 height:36 align:#center
		button btn_export "Export" width:120 height:36 align:#center
		)
	label lbl_loaded "File Loaded: <  NOTHING  >" align:#center
	label lbl_author "mariokart64n" align:#left across:2
	label lbl_date "June 6, 2024" align:#right
	
	
	struct byteArray (
		size = 0,
		data = #(),
		fn readFromStream &f fsize:0 = (
			if f != undefined then (
				local pos = ftell f
				if fsize == 0 do (
					fseek f 0 #seek_end
					fsize = (ftell f) - pos
					fseek f pos #seek_set
					)
				size = fsize
				local count = (size / 4) as integer
				local leftover = (mod size 4) as integer
				if (count + leftover) > 0 do (
					data[count + leftover] = 1
					local i = 1
					for i = 1 to count do (data[i] = readLong f)
					for i = (1 + count) to (count + leftover) do (data[i] = readByte f)
					)
				) else (format "stream is invalid\n")
			),
		fn writeToStream &s = (
			local count = (size / 4) as integer
			local leftover = (mod size 4) as integer
			if (count + leftover) > 0 do (
				local i = 1
				for i = 1 to count do (writeLong s data[i])
				for i = (1 + count) to (count + leftover) do (writeByte s data[i])
				)
			),
		fn read file = (
			local f = undefined
			if (f = try(fopen file "rbS")catch(undefined)) != undefined then (
				data = #()
				readFromStream f fsize:(getFileSize file)
				fclose f
				) else (format "Error:\tFailed to Load File\n")
			),
		fn write file = (
			local s = undefined
			if size >= data.count and data.count > 0 and (s = try(fopen file "wbS")catch(undefined)) != undefined then (
				writeToStream(&s)
				fclose s
				) else (format "Error:\tFailed to Save File\n")
			)
		)
	
	struct ResourceEntry_t (
		/*uint32_t*/ m_TypeUID = 0,
		/*
			RESOURCE_TYPE_ActionTreeResource					0x4BCE8537
			RESOURCE_TYPE_AlphaState							0x1BCFF4D5
			RESOURCE_TYPE_Animation								0x8ACF9964
			RESOURCE_TYPE_AnimationGroupResource				0x3D0EBC72
			RESOURCE_TYPE_AudioFXSettings						0xAF8870AB
			RESOURCE_TYPE_BIGFile								0x2C5C40A8
			RESOURCE_TYPE_BIGFileNameLookup						0x164013D5
			RESOURCE_TYPE_BSP									0x4F05B59A
			RESOURCE_TYPE_BSPDebugData							0xE2C5C78C
			RESOURCE_TYPE_BeamSettings							0x80EF0B08
			RESOURCE_TYPE_BlendTreeResource						0xE691BB97
			RESOURCE_TYPE_BonePalette							0x982456DB
			RESOURCE_TYPE_Buffer								0x7A971479
			RESOURCE_TYPE_BufferD3DResource						0x45E061F6
			RESOURCE_TYPE_ChunkFileFatIndex						0xE445B80C
			RESOURCE_TYPE_ChunkFileIndex						0x7040F7D2
			RESOURCE_TYPE_Cloud									0x06526B66
			RESOURCE_TYPE_CloudScene							0xD49B8DA4
			RESOURCE_TYPE_CollisionInstance						0xA0B2CC13
			RESOURCE_TYPE_CollisionMeshBundle					0xBD226A08
			RESOURCE_TYPE_CoronaFlareSettings					0x9D6378CC
			RESOURCE_TYPE_CoverData								0x5DEB3457
			RESOURCE_TYPE_DecalSettings							0xDCAEC503
			RESOURCE_TYPE_DynamicCoverData						0xE5150CC0
			RESOURCE_TYPE_DynamicCoverGroupBundle				0x7117991B
			RESOURCE_TYPE_DynamicLightGroupSettings				0x230C8A9C
			RESOURCE_TYPE_DynamicLightSettings					0x8D0E8333
			RESOURCE_TYPE_EffectEmitterSettings					0xD9B10F14
			RESOURCE_TYPE_FXForceSettings						0x77554FC5
			RESOURCE_TYPE_FXSettings							0x12289ADB
			RESOURCE_TYPE_FarGroundLayout						0xF40E78D9
			RESOURCE_TYPE_FlareSettings							0x83574C18
			RESOURCE_TYPE_Font									0x2A1BE612
			RESOURCE_TYPE_GeoSettings							0x52A8963A
			RESOURCE_TYPE_ImposterGroup							0xAEDF1081
			RESOURCE_TYPE_LightGroup							0x7480E00F
			RESOURCE_TYPE_LightningSettings						0xB4AEE124
			RESOURCE_TYPE_Locators								0x15506061
			RESOURCE_TYPE_Material								0xF5F8516F
			RESOURCE_TYPE_MaterialTable							0xEB9FE716
			RESOURCE_TYPE_ModelData								0x6DF963B3
			RESOURCE_TYPE_MorphTargets							0x02CD0C47
			RESOURCE_TYPE_MovieResourceData						0xE9453F67
			RESOURCE_TYPE_NISSpatialData						0xC762C801
			RESOURCE_TYPE_NavMeshData							0xDD3C7B19
			RESOURCE_TYPE_ParkourContainer						0xBDE53ECA
			RESOURCE_TYPE_ParkourContainerBundle				0x12D3A53D
			RESOURCE_TYPE_ParkourInstance						0xC31501A5
			RESOURCE_TYPE_ParticleEmitterSettings				0xD05B6976
			RESOURCE_TYPE_PropertySet							0x5B9BF81E
			RESOURCE_TYPE_RasterState							0xB27A4B38
			RESOURCE_TYPE_ReflectResource						0x616A903F
			RESOURCE_TYPE_ReflectionGroup						0xD53B5BAC
			RESOURCE_TYPE_Rig									0x1418DD74
			RESOURCE_TYPE_RigInfoResource						0x036C2E8E
			RESOURCE_TYPE_RigInstance							0x5C66C6BD
			RESOURCE_TYPE_RoadNetwork							0x94132761
			RESOURCE_TYPE_SceneLayer							0xE7F23AEE
			RESOURCE_TYPE_SceneryGroup							0x7480E00B
			RESOURCE_TYPE_ScreenParticleEmitterSettings			0x657192D6
			RESOURCE_TYPE_SectionEffects						0x89A7BDF7
			RESOURCE_TYPE_SectionLayout							0x3E50F7D5
			RESOURCE_TYPE_ShaderBinary							0x985BE50C
			RESOURCE_TYPE_ShaderTemplate						0x0C46AEEF
			RESOURCE_TYPE_Sidewalk								0x2C81C14B
			RESOURCE_TYPE_StateBlock							0xAF015A94
			RESOURCE_TYPE_SymbolTableResource					0xE4868DBE
			RESOURCE_TYPE_TerrainData							0xC462DD28
			RESOURCE_TYPE_Texture								0xCDBFA090
			RESOURCE_TYPE_TextureD3DResource					0x501B8E62
			RESOURCE_TYPE_TrackStripSettings					0x86DE69F6
			RESOURCE_TYPE_TrueCrowdDataBase						0x90EEF023
			RESOURCE_TYPE_UELFragmentTable						0x32890C01
			RESOURCE_TYPE_UILocalization						0x90CE6B7A
			RESOURCE_TYPE_UIMinimapTile							0x9F34FF46
			RESOURCE_TYPE_UIScreen								0x442A39D9
			RESOURCE_TYPE_UniqueUIDTableResource				0x2C40FA26
			RESOURCE_TYPE_VertexDecl							0xF7FC6B2D
			RESOURCE_TYPE_VolumetricEffectSettings				0xA8EB0D0C
			RESOURCE_TYPE_WeightSetGroupResource				0x1146D4C8
			RESOURCE_TYPE_XMLFile								0x24D0C3A0
			RESOURCE_TYPE_ZoneLayout							0x43FF83A9
		*/
		/*uint32_t[2]*/ m_EntrySize = #(0, 0),
		/*uint32_t*/ m_Offset = 0,
		/*uint8_t[m_Offset]*/ reserved = #(),
		/*uint32_t[256]*/ g_CRC32Table = #(
			0x00000000L, 0x04C11DB7L, 0x09823B6EL, 0x0D4326D9L, 0x130476DCL, 0x17C56B6BL, 0x1A864DB2L, 0x1E475005L,
			0x2608EDB8L, 0x22C9F00FL, 0x2F8AD6D6L, 0x2B4BCB61L, 0x350C9B64L, 0x31CD86D3L, 0x3C8EA00AL, 0x384FBDBDL,
			0x4C11DB70L, 0x48D0C6C7L, 0x4593E01EL, 0x4152FDA9L, 0x5F15ADACL, 0x5BD4B01BL, 0x569796C2L, 0x52568B75L,
			0x6A1936C8L, 0x6ED82B7FL, 0x639B0DA6L, 0x675A1011L, 0x791D4014L, 0x7DDC5DA3L, 0x709F7B7AL, 0x745E66CDL,
			0x9823B6E0L, 0x9CE2AB57L, 0x91A18D8EL, 0x95609039L, 0x8B27C03CL, 0x8FE6DD8BL, 0x82A5FB52L, 0x8664E6E5L,
			0xBE2B5B58L, 0xBAEA46EFL, 0xB7A96036L, 0xB3687D81L, 0xAD2F2D84L, 0xA9EE3033L, 0xA4AD16EAL, 0xA06C0B5DL,
			0xD4326D90L, 0xD0F37027L, 0xDDB056FEL, 0xD9714B49L, 0xC7361B4CL, 0xC3F706FBL, 0xCEB42022L, 0xCA753D95L,
			0xF23A8028L, 0xF6FB9D9FL, 0xFBB8BB46L, 0xFF79A6F1L, 0xE13EF6F4L, 0xE5FFEB43L, 0xE8BCCD9AL, 0xEC7DD02DL,
			0x34867077L, 0x30476DC0L, 0x3D044B19L, 0x39C556AEL, 0x278206ABL, 0x23431B1CL, 0x2E003DC5L, 0x2AC12072L,
			0x128E9DCFL, 0x164F8078L, 0x1B0CA6A1L, 0x1FCDBB16L, 0x018AEB13L, 0x054BF6A4L, 0x0808D07DL, 0x0CC9CDCAL,
			0x7897AB07L, 0x7C56B6B0L, 0x71159069L, 0x75D48DDEL, 0x6B93DDDBL, 0x6F52C06CL, 0x6211E6B5L, 0x66D0FB02L,
			0x5E9F46BFL, 0x5A5E5B08L, 0x571D7DD1L, 0x53DC6066L, 0x4D9B3063L, 0x495A2DD4L, 0x44190B0DL, 0x40D816BAL,
			0xACA5C697L, 0xA864DB20L, 0xA527FDF9L, 0xA1E6E04EL, 0xBFA1B04BL, 0xBB60ADFCL, 0xB6238B25L, 0xB2E29692L,
			0x8AAD2B2FL, 0x8E6C3698L, 0x832F1041L, 0x87EE0DF6L, 0x99A95DF3L, 0x9D684044L, 0x902B669DL, 0x94EA7B2AL,
			0xE0B41DE7L, 0xE4750050L, 0xE9362689L, 0xEDF73B3EL, 0xF3B06B3BL, 0xF771768CL, 0xFA325055L, 0xFEF34DE2L,
			0xC6BCF05FL, 0xC27DEDE8L, 0xCF3ECB31L, 0xCBFFD686L, 0xD5B88683L, 0xD1799B34L, 0xDC3ABDEDL, 0xD8FBA05AL,
			0x690CE0EEL, 0x6DCDFD59L, 0x608EDB80L, 0x644FC637L, 0x7A089632L, 0x7EC98B85L, 0x738AAD5CL, 0x774BB0EBL,
			0x4F040D56L, 0x4BC510E1L, 0x46863638L, 0x42472B8FL, 0x5C007B8AL, 0x58C1663DL, 0x558240E4L, 0x51435D53L,
			0x251D3B9EL, 0x21DC2629L, 0x2C9F00F0L, 0x285E1D47L, 0x36194D42L, 0x32D850F5L, 0x3F9B762CL, 0x3B5A6B9BL,
			0x0315D626L, 0x07D4CB91L, 0x0A97ED48L, 0x0E56F0FFL, 0x1011A0FAL, 0x14D0BD4DL, 0x19939B94L, 0x1D528623L,
			0xF12F560EL, 0xF5EE4BB9L, 0xF8AD6D60L, 0xFC6C70D7L, 0xE22B20D2L, 0xE6EA3D65L, 0xEBA91BBCL, 0xEF68060BL,
			0xD727BBB6L, 0xD3E6A601L, 0xDEA580D8L, 0xDA649D6FL, 0xC423CD6AL, 0xC0E2D0DDL, 0xCDA1F604L, 0xC960EBB3L,
			0xBD3E8D7EL, 0xB9FF90C9L, 0xB4BCB610L, 0xB07DABA7L, 0xAE3AFBA2L, 0xAAFBE615L, 0xA7B8C0CCL, 0xA379DD7BL,
			0x9B3660C6L, 0x9FF77D71L, 0x92B45BA8L, 0x9675461FL, 0x8832161AL, 0x8CF30BADL, 0x81B02D74L, 0x857130C3L,
			0x5D8A9099L, 0x594B8D2EL, 0x5408ABF7L, 0x50C9B640L, 0x4E8EE645L, 0x4A4FFBF2L, 0x470CDD2BL, 0x43CDC09CL,
			0x7B827D21L, 0x7F436096L, 0x7200464FL, 0x76C15BF8L, 0x68860BFDL, 0x6C47164AL, 0x61043093L, 0x65C52D24L,
			0x119B4BE9L, 0x155A565EL, 0x18197087L, 0x1CD86D30L, 0x029F3D35L, 0x065E2082L, 0x0B1D065BL, 0x0FDC1BECL,
			0x3793A651L, 0x3352BBE6L, 0x3E119D3FL, 0x3AD08088L, 0x2497D08DL, 0x2056CD3AL, 0x2D15EBE3L, 0x29D4F654L,
			0xC5A92679L, 0xC1683BCEL, 0xCC2B1D17L, 0xC8EA00A0L, 0xD6AD50A5L, 0xD26C4D12L, 0xDF2F6BCBL, 0xDBEE767CL,
			0xE3A1CBC1L, 0xE760D676L, 0xEA23F0AFL, 0xEEE2ED18L, 0xF0A5BD1DL, 0xF464A0AAL, 0xF9278673L, 0xFDE69BC4L,
			0x89B8FD09L, 0x8D79E0BEL, 0x803AC667L, 0x84FBDBD0L, 0x9ABC8BD5L, 0x9E7D9662L, 0x933EB0BBL, 0x97FFAD0CL,
			0xAFB010B1L, 0xAB710D06L, 0xA6322BDFL, 0xA2F33668L, 0xBCB4666DL, 0xB8757BDAL, 0xB5365D03L, 0xB1F740B4L
			),
		t_types = #(
			0x4BCE8537L, -- ActionTreeResource
			0x1BCFF4D5L, -- AlphaState
			0x8ACF9964L, -- Animation
			0x3D0EBC72L, -- AnimationGroupResource
			0xAF8870ABL, -- AudioFXSettings
			0x2C5C40A8L, -- BIGFile
			0x164013D5L, -- BIGFileNameLookup
			0x4F05B59AL, -- BSP
			0xE2C5C78CL, -- BSPDebugData
			0x80EF0B08L, -- BeamSettings
			0xE691BB97L, -- BlendTreeResource
			0x982456DBL, -- BonePalette
			0x7A971479L, -- Buffer
			0x45E061F6L, -- BufferD3DResource
			0xE445B80CL, -- ChunkFileFatIndex
			0x7040F7D2L, -- ChunkFileIndex
			0x06526B66L, -- Cloud
			0xD49B8DA4L, -- CloudScene
			0xA0B2CC13L, -- CollisionInstance
			0xBD226A08L, -- CollisionMeshBundle
			0x9D6378CCL, -- CoronaFlareSettings
			0x5DEB3457L, -- CoverData
			0xDCAEC503L, -- DecalSettings
			0xE5150CC0L, -- DynamicCoverData
			0x7117991BL, -- DynamicCoverGroupBundle
			0x230C8A9CL, -- DynamicLightGroupSettings
			0x8D0E8333L, -- DynamicLightSettings
			0xD9B10F14L, -- EffectEmitterSettings
			0x77554FC5L, -- FXForceSettings
			0x12289ADBL, -- FXSettings
			0xF40E78D9L, -- FarGroundLayout
			0x83574C18L, -- FlareSettings
			0x2A1BE612L, -- Font
			0x52A8963AL, -- GeoSettings
			0xAEDF1081L, -- ImposterGroup
			0x7480E00FL, -- LightGroup
			0xB4AEE124L, -- LightningSettings
			0x15506061L, -- Locators
			0xF5F8516FL, -- Material
			0xEB9FE716L, -- MaterialTable
			0x6DF963B3L, -- ModelData
			0x02CD0C47L, -- MorphTargets
			0xE9453F67L, -- MovieResourceData
			0xC762C801L, -- NISSpatialData
			0xDD3C7B19L, -- NavMeshData
			0xBDE53ECAL, -- ParkourContainer
			0x12D3A53DL, -- ParkourContainerBundle
			0xC31501A5L, -- ParkourInstance
			0xD05B6976L, -- ParticleEmitterSettings
			0x5B9BF81EL, -- PropertySet
			0xB27A4B38L, -- RasterState
			0x616A903FL, -- ReflectResource
			0xD53B5BACL, -- ReflectionGroup
			0x1418DD74L, -- Rig
			0x036C2E8EL, -- RigInfoResource
			0x5C66C6BDL, -- RigInstance
			0x94132761L, -- RoadNetwork
			0xE7F23AEEL, -- SceneLayer
			0x7480E00BL, -- SceneryGroup
			0x657192D6L, -- ScreenParticleEmitterSettings
			0x89A7BDF7L, -- SectionEffects
			0x3E50F7D5L, -- SectionLayout
			0x985BE50CL, -- ShaderBinary
			0x0C46AEEFL, -- ShaderTemplate
			0x2C81C14BL, -- Sidewalk
			0xAF015A94L, -- StateBlock
			0xE4868DBEL, -- SymbolTableResource
			0xC462DD28L, -- TerrainData
			0xCDBFA090L, -- Texture
			0x501B8E62L, -- TextureD3DResource
			0x86DE69F6L, -- TrackStripSettings
			0x90EEF023L, -- TrueCrowdDataBase
			0x32890C01L, -- UELFragmentTable
			0x90CE6B7AL, -- UILocalization
			0x9F34FF46L, -- UIMinimapTile
			0x442A39D9L, -- UIScreen
			0x2C40FA26L, -- UniqueUIDTableResource
			0xF7FC6B2DL, -- VertexDecl
			0xA8EB0D0CL, -- VolumetricEffectSettings
			0x1146D4C8L, -- WeightSetGroupResource
			0x24D0C3A0L, -- XMLFile
			0x43FF83A9L  -- ZoneLayout
			),
		fn StringHash32 str p_PrevHash:0xFFFFFFFFL = (
			local len = str.count
			for i = 1 to len do (
				local char = (bit.charasint (substring str i 1)) as integer
				local index = (bit.and (bit.xor char (bit.shift p_PrevHash -24)) 0xFF) + 1
				p_PrevHash = (bit.xor (g_CRC32Table[index]) (bit.and (bit.shift p_PrevHash 8) 0xFFFFFFFFL))
				)
			p_PrevHash
			),
		fn size = (16 + m_Offset),
		fn read f = (
			reserved = #()
			m_TypeUID = readLong f #unsigned
			local result = (findItem t_types m_TypeUID) > 0
			if result do (
				m_EntrySize = #(readLong f #unsigned, readLong f #unsigned)
				m_Offset = readLong f #unsigned
				if m_Offset > 0 do (
					reserved[m_Offset] = 0
					local i = 1
					for i = 1 to m_Offset do (
						reserved[i] = readByte f #unsigned
						)
					)
				)
			result
			),
		fn write &s = (
			writeLong s m_TypeUID #unsigned
			writeLong s m_EntrySize[1] #unsigned
			writeLong s m_EntrySize[2] #unsigned
			writeLong s reserved.count #unsigned
			local i = 1
			for i = 1 to reserved.count do (
				writeByte s reserved[i] #unsigned
				)
			)
		)

	struct ResourceData_t ( -- 62 bytes
		/*ResourceEntry_t*/ base = ResourceEntry_t(),
		/*uint8_t[24]*/ pad1 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x18)
		/*uint32_t*/ m_NameUID = 0, -- hash generated off the full name of 'm_DebugName' presumably
		/*uint8_t[20]*/ pad2 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x14)
		/*uint32_t*/ m_ChunkUID = 0, -- Hash of the File Type
		/*
			Resource_ActionTreeResourceInventory 0x8DB8241B
			Resource_AlphaStateInventory 0x12C800F2
			Resource_AnimationGroupResourceInventory 0x58087229
			Resource_AnimationInventory 0x53F1685E
			Resource_AudioFXSettingsInventory 0xD77CCEB2
			Resource_BIGFileInventory 0x2AE784F9
			Resource_BIGFileNameLookupInventory 0x21EFAF30
			Resource_BSPDebugDataInventory 0xA076E719
			Resource_BSPInventory 0x45ED23E5
			Resource_BeamSettingsInventory 0xA0AAE10F
			Resource_BlendTreeResourceInventory 0x02680E48
			Resource_BonePaletteInventory 0x50A819E3
			Resource_BufferD3DResourceInventory 0x171246AD
			Resource_BufferInventory 0x92CDEC8F
			Resource_ChunkFileFatIndexInventory 0xE36C885C
			Resource_ChunkFileIndexInventory 0xF569FE1B
			Resource_CloudInventory 0x528C47E3
			Resource_CloudSceneInventory 0x4438A32F
			Resource_CollisionInstanceInventory 0x7970FB96
			Resource_CollisionMeshBundleInventory 0x1723EA91
			Resource_CoronaFlareSettingsInventory 0xB76CCFB8
			Resource_CoverDataInventory 0x8DADDB7E
			Resource_DecalSettingsInventory 0xAE323146
			Resource_DynamicCoverDataInventory 0xE5150EE3
			Resource_DynamicCoverGroupBundleInventory 0xEC7A2131
			Resource_DynamicLightGroupSettingsInventory 0x19B59D34
			Resource_DynamicLightSettingsInventory 0xD6CD7114
			Resource_EffectEmitterSettingsInventory 0xFF1F2832
			Resource_FXForceSettingsInventory 0x433ED8DF
			Resource_FXSettingsInventory 0xED341A8D
			Resource_FarGroundLayout 0x2A05C2B9
			Resource_FlareSettingsInventory 0xA6535FBB
			Resource_FontInventory 0x69FCCB4C
			Resource_GeoSettingsInventory 0xF1734D8E
			Resource_ImposterGroupInventory 0x4E23B4B4
			Resource_LightGroupInventory 0xF0A0724F
			Resource_LightningSettingsInventory 0x21AE1C64
			Resource_LocatorsInventory 0x3EDDEFF0
			Resource_MaterialInventory 0xB4C26312
			Resource_MaterialTableInventory 0x80D1F139
			Resource_ModelDataInventory 0xA2ADCD77
			Resource_MorphTargetsInventory 0xC62C2822
			Resource_MovieResourceDataInventory 0x399051EF
			Resource_NISSpatialDataInventory 0x59362AA3
			Resource_NavMeshDataInventory 0x5D7E8ADF
			Resource_ParkourContainerBundleInventory 0x4558A12E
			Resource_ParkourContainerInventory 0x15E16140
			Resource_ParkourInstanceInventory 0x98CD09F8
			Resource_ParticleEmitterSettingsInventory 0x3BEE21DC
			Resource_PropertySetInventory 0x54606C31
			Resource_RasterStateInventory 0x3BC715E0
			Resource_ReflectionGroupInventory 0xEFAA9CC0
			Resource_ReflectResourceInventory 0x5B00F999
			Resource_ResourceFileInventory 0xA428072C
			Resource_RigInfoResourceInventory 0xAEF1F66F
			Resource_RigInstanceInventory 0x9A00456E
			Resource_RigInventory 0x39BC0A7E
			Resource_RoadNetworkInventory 0xA4F6DEDB
			Resource_SceneLayerInventory 0xE0F4D9CC
			Resource_SceneryGroupInventory 0xF0A07244
			Resource_ScreenParticleEmitterSettingsInventory 0x354C3CDC
			Resource_SectionEffectsInventory 0x468D9324
			Resource_SectionLayoutInventory 0xEC35A8A0
			Resource_ShaderBinaryInventory 0xE80F42E1
			Resource_ShaderInventory 0x8B5561A1
			Resource_ShaderTemplateInventory 0x1FD4E5C5
			Resource_SidewalkInventory 0x43E99F7E
			Resource_StateBlockInventory 0x4D04C7F2
			Resource_SymbolTableResourceInventory 0x7C98C388
			Resource_TerrainDataInventory 0x392C3181
			Resource_TextureD3DResourceInventory 0xEF77C5F7
			Resource_TextureInventory 0x8B43FABF
			Resource_TrackStripSettingsInventory 0x69CE5438
			Resource_TrueCrowdDataBaseInventory 0x4AEEEFDE
			Resource_UELFragmentTableInventory 0x2DB16C3E
			Resource_UILocalizationInventory 0x90CE6B7A
			Resource_UIMinimapTileInventory 0xB9C2B9E0
			Resource_UIScreenInventory 0x442A39D9
			Resource_UniqueUIDTableResourceInventory 0xEF00811C
			Resource_VertexDeclInventory 0x3E5FDA3E
			Resource_VolumetricEffectSettingsInventory 0xE4B8F46A
			Resource_WeightSetGroupResourceInventory 0x50C27D5F
			Resource_XMLFileInventory 0x4FF578D5
			Resource_ZoneLayout 0xC35E39D5
		*/
		/*char[36]*/ m_DebugName = "", -- 36 characters,
		
		fn size = (16 + base.m_EntrySize[1]), -- resource size, includes m_Resource
		fn read f = (
			local result = base.read(f)
			if result do (
				local i = 1
				for i = 1 to 24 do (pad1[i] = readByte f #unsigned)
				m_NameUID = readLong f #unsigned
				for i = 1 to 20 do (pad1[i] = readByte f #unsigned)
				m_ChunkUID = readLong f #unsigned
				m_DebugName = ""
				local b = 0
				for i = 1 to 36 do (
					b = readbyte f #unsigned
					if b == 0 then (
						fseek f (36 - i) #seek_cur
						exit
						)
					else (
						m_DebugName += bit.IntAsChar b
						)
					)
				)
			result
			),
		fn write &s = (
			base.write(&s)
			local i = 1
			for i = 1 to 24 do (writeByte s pad1[i] #unsigned)
			writeLong s m_NameUID #unsigned
			for i = 1 to 20 do (writeByte s pad2[i] #unsigned)
			writeLong s m_ChunkUID #unsigned
			local b = 0
			for i = 1 to 36 do (
				if i <= m_DebugName.count then (
					b = bit.CharAsInt (subString m_DebugName i 1)
					writeByte s b #unsigned
					)
				else (
					writeByte s 0 #unsigned
					)
				)
			)
		)

	struct ResourceHandle_t ( -- 32 Bytes
		/*uint64_t*/ m_Prev = 0,
		/*uint64_t*/ m_Next = 0,
		/*uint64_t*/ m_Data = 0,
		/*uint32_t*/ m_NameUID = 0,
		/*uint32_t*/ m_TailPad = 0,
		fn read f = (
			m_Prev = readLongLong f #unsigned
			m_Next = readLongLong f #unsigned
			m_Data = readLongLong f #unsigned
			m_NameUID = readLong f #unsigned
			m_TailPad = readLong f #unsigned
			),
		fn write &s = (
			writeLongLong s m_Prev
			writeLongLong s m_Next
			writeLongLong s m_Data
			writeLong s m_NameUID #unsigned
			writeLong s m_TailPad #unsigned
			)
		)
	
	struct Vertex_t (
		/*qVector3*/ m_Position = [0.0, 0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord0 = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord1 = [0.0, 0.0],
		/*qVector3*/ m_Normal = #(0, 0, 0, 0),
		/*qVector3*/ m_Tangent = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_Color = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_BoneID = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_Weight = #(1.0, 0.0, 0.0, 0.0) -- should add up to 1.0
		)
	
	struct Buffer_t (
		/*
			I'm not sure what informs me of how to read the buffers?
		*/
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint32_t*/ m_Type = 0, -- 0=Vertices, 1=Faces
		/*uint32_t*/ m_Size = 0, -- just size of the buffer, not including padding
		/*uint64_t*/ m_DataOffset = 0xD0,
		/*uint32_t*/ m_ElementSize = 0,
		/*uint32_t*/ m_NumElements = 0,
		/*uint8_t[192]*/ m_BufferPadding = #(
			/*
				looks like someone skipped this unknown data, does not look like padding.
				there are offsets here that point to structures within..
				
				there are some values that look like LOD or draw distance stuff
			*/
			0xA0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x4D, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC6, 0x42,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x42, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x30, 0x41, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			),
		/*void**/ m_Buffer = #(), -- buffer appears padded to a 16byte alignment with 0's
		fn size = (104 + m_Resource.base.reserved.count + m_BufferPadding.count + 24 + (m_ElementSize * m_NumElements) + (mod (16-(mod (m_ElementSize * m_NumElements) 16)) 16)),
		fn readHalf bstream = (
			local inputAsInt = readshort bstream #unsigned
			local sign = (bit.and (bit.shift inputAsInt -15) 0x00000001)
			local exponent = (bit.shift (bit.and inputAsInt 0x7C00) -10) as integer + 112
			local fraction = (bit.and inputAsInt 0x03FF)
			bit.intasfloat (
				(bit.or (bit.or (bit.shift fraction 13) (bit.shift exponent 23)) (bit.shift sign 31))
				)
			),
		fn writeHalf &bstream val = (
			-- "https://galfar.vevb.net/wp/2011/16bit-half-float-in-pascaldelphi/"
			local Sign = 0
			local exponent=0
			local Mantissa=0
			local Result = 0
			local Src = bit.floatAsInt (val as float)
			-- Extract sign, exponentonent, and mantissa from Single number
			Sign = bit.shift Src -31
			exponent = (bit.shift (bit.and Src 0x7F800000) -23) - 127 + 15
			Mantissa = bit.and Src 0x007FFFFF
			if exponent >= 0 and exponent <= 30 then (
				-- Simple case - round the significand and combine it with the sign and exponentonent
				Result = bit.or (bit.shift Sign 15) (bit.or (bit.shift exponent 10) (bit.shift (Mantissa + 0x00001000) -13))
				)
			else (
				if Src == 0 then (
					-- Input float is zero - return zero
					Result = 0
					)
				else (
					-- Difficult case - lengthy conversion
					if exponent <= 0 then (
						if exponent <= -10 then (         
							-- Input float's value is less than HalfMin, return zero
							Result = 0
							)
						else (
							-- Float is a normalized Single whose magnitude is less than HalfNormMin.  
							-- We convert it to denormalized half.
							Mantissa = bit.shift (bit.or Mantissa 0x00800000) -(1 - exponent)
							-- Round to nearest
							if (bit.or Mantissa 0x00001000) >= 0 then
							Mantissa = Mantissa + 0x00002000
							-- Assemble Sign and Mantissa (exponent is zero to get denormalized number)
							Result = bit.or (bit.shift Sign 15) (bit.shift Mantissa -13)
							)
						)
					else (
						if exponent = 255 - 127 + 15 then (
							if Mantissa = 0 then (
								-- Input float is infinity, create infinity half with original sign
								Result = (bit.shift Sign 15) or 0x7C00
								)
							else (
								-- Input float is NaN, create half NaN with original sign and mantissa
								Result = bit.or (bit.shift Sign 15) (bit.or 0x7C00 (bit.shift Mantissa -13))
								)
							)
						else (
							-- exponent is > 0 so input float is normalized Single
							-- Round to nearest
							if (bit.and Mantissa 0x00001000) >= 0 then (
								Mantissa = Mantissa + 0x00002000
								if (bit.and Mantissa 0x00800000) >= 0 then (
									Mantissa = 0
									exponent = exponent + 1
									)
								)
							if exponent >= 30 then (
								-- exponentonent overflow - return infinity half
								Result = (bit.shift Sign 15) or 0x7C00
								)
							else (
								-- Assemble normalized half
								Result = bit.or (bit.shift Sign 15) (bit.or (bit.shift exponent 10) (bit.shift Mantissa -13))
								)
							)
						)
					)
				)
			writeshort bstream result #unsigned
			),
		fn read f = (
			local pos = ftell f
			m_Resource.read(f)
			
			if m_Resource.base.m_TypeUID == 0x7A971479 or m_Resource.base.m_TypeUID == 2056721529 do (
				
				m_Type = readLong f #unsigned
				m_Size = readLong f #unsigned
				
				local addr_DataOffset = ftell f
				m_DataOffset = readLongLong f
				m_ElementSize = readLong f #unsigned
				m_NumElements = readLong f #unsigned
				
				local i = 1
				for i = 1 to 192 do (m_BufferPadding[i] = readByte f #unsigned)
				
				m_Buffer = #()
				if m_NumElements > 0 and m_DataOffset > 0 and addr_DataOffset + m_DataOffset <= pos + m_Resource.size() do (
					if m_Type == 0 then ( -- Vertices
						
						-- Add vertices first, the components seem to be in multiple files
						m_Buffer[m_NumElements] = Vertex_t()
						for i = 1 to m_NumElements do (
							m_Buffer[i] = Vertex_t()
							)
						
						for i = 1 to m_NumElements do (
							case m_ElementSize of (
								4: (
									m_Buffer[i].m_TexCoord0 = [readHalf f, readHalf f]
									)
								8: (
									m_Buffer[i].m_BoneID = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
									m_Buffer[i].m_Weight = #((readByte f #unsigned) / 255.0, (readByte f #unsigned) / 255.0, (readByte f #unsigned) / 255.0, (readByte f #unsigned) / 255.0)
									)
								24: (
									m_Buffer[i].m_Position = [readFloat f, readFloat f, readFloat f]
									m_Buffer[i].m_Color = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned) -- this might be the W component for the position?
									m_Buffer[i].m_Normal = #((readByte f #signed) / 127.0, (readByte f #signed) / 127.0, (readByte f #signed) / 127.0, (readByte f #signed) / 127.0)
									m_Buffer[i].m_Tangent = #((readByte f #signed) / 127.0, (readByte f #signed) / 127.0, (readByte f #signed) / 127.0, (readByte f #signed) / 127.0)
									)
								default: continue
								)
							)
						)
					else if m_Type == 1 then ( -- Faces
						m_Buffer[m_NumElements] = 0
						for i = 1 to m_NumElements do (
							m_Buffer[i] = 0
							case m_ElementSize of (
								1: m_Buffer[i] = readByte f #unsigned
								2: m_Buffer[i] = readShort f #unsigned
								4: m_Buffer[i] = readLong f #unsigned
								8: m_Buffer[i] = readLongLong f #unsigned
								default: continue
								)
							)
						)
					else (
						format "Unsupported m_Type {%}\n" m_Type
						)
					)
				)
			),
		fn write &s = (
			-- Recalculate Offsets
			m_NumElements = m_Buffer.count
			m_DataOffset = m_BufferPadding.count + 16 -- 0xD0 (192 bytes)
			m_Size = m_ElementSize * m_NumElements
			m_Resource.base.m_EntrySize = #(size() - 16, size() - 16)
			
			-- Write ResourceData_t
			m_Resource.write(&s)  
			
			-- Write Sub Header
			writeLong s m_Type #unsigned
			writeLong s m_Size #unsigned
			
			writeLongLong s m_DataOffset #unsigned
			
			writeLong s m_ElementSize #unsigned
			writeLong s m_NumElements #unsigned
			
			-- Write m_BufferPadding
			local i = 1
			for i = 1 to m_BufferPadding.count do (
				writeByte s m_BufferPadding[i] #unsigned
				)
			
			-- Write the buffer data
			if m_NumElements > 0 and m_DataOffset > 0 then (
				
				-- Write buffer elements
				if m_Type == 0 then ( -- Vertices
					for i = 1 to m_NumElements do (
						case m_ElementSize of (
							4: (
								writeHalf &s m_Buffer[i].m_TexCoord0[1]
								writeHalf &s m_Buffer[i].m_TexCoord0[2]
								)
							8: (
								writeByte s m_Buffer[i].m_BoneID[1] #unsigned
								writeByte s m_Buffer[i].m_BoneID[2] #unsigned
								writeByte s m_Buffer[i].m_BoneID[3] #unsigned
								writeByte s m_Buffer[i].m_BoneID[4] #unsigned
								writeByte s (m_Buffer[i].m_Weight[1] * 255) #unsigned
								writeByte s (m_Buffer[i].m_Weight[2] * 255) #unsigned
								writeByte s (m_Buffer[i].m_Weight[3] * 255) #unsigned
								writeByte s (m_Buffer[i].m_Weight[4] * 255) #unsigned
								)
							24: (
								writeFloat s m_Buffer[i].m_Position[1]
								writeFloat s m_Buffer[i].m_Position[2]
								writeFloat s m_Buffer[i].m_Position[3]
								
								writeByte s m_Buffer[i].m_Color[1] #unsigned
								writeByte s m_Buffer[i].m_Color[2] #unsigned
								writeByte s m_Buffer[i].m_Color[3] #unsigned
								writeByte s m_Buffer[i].m_Color[4] #unsigned
								
								writeByte s (m_Buffer[i].m_Normal[1] * 127) #signed
								writeByte s (m_Buffer[i].m_Normal[2] * 127) #signed
								writeByte s (m_Buffer[i].m_Normal[3] * 127) #signed
								writeByte s (m_Buffer[i].m_Normal[4] * 127) #signed
								
								writeByte s (m_Buffer[i].m_Tangent[1] * 127) #signed
								writeByte s (m_Buffer[i].m_Tangent[2] * 127) #signed
								writeByte s (m_Buffer[i].m_Tangent[3] * 127) #signed
								writeByte s (m_Buffer[i].m_Tangent[4] * 127) #signed
								
								)
							default: continue
							)
						)
					)
				else if m_Type == 1 then ( -- Faces
					for i = 1 to m_NumElements do (
						case m_ElementSize of (
							1: writeByte s m_Buffer[i] #unsigned
							2: writeShort s m_Buffer[i] #unsigned
							4: writeLong s m_Buffer[i] #unsigned
							8: writeLongLong s m_Buffer[i] #unsigned
							default: continue
							)
						)
					)
				)
			
			-- Write buffer padding
			local n_padding = mod (16-(mod (m_ElementSize * m_NumElements) 16)) 16
			for i = 1 to n_padding do (writeByte s 0)
			)
		)
	
	struct BonePallete_t (
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint32_t*/ m_NumPalettes = 1, -- always 1 in my samples
		/*uint32_t*/ m_NumBones = 0,
		/*int64_t*/ m_BoneNameTableOffset = 0,
		/*int64_t*/ m_BoneUIDTableOffset = 0,
		/*int64_t*/ m_BoneFullUIDTableOffset = 0,
		/*uint8_t[8]*/ pad16 = #(0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x8)
		/*uint8_t[m_NumBones]*/ m_BoneIndexTable = #(), -- table pads out using -1 to a 40 byte alignment ?
		/*char[64][m_NumBones]*/ m_BoneNameTable = #(),
		/*uint32_t[m_NumBones]*/ m_BoneUIDTable = #(), -- Uppercase CRC32 Hash on truncated name of 35 characters
		/*uint32_t[m_NumBones]*/ m_BoneFullUIDTable = #(), -- Uppercase CRC32 Hash on full name
		
		/*
			BoneUID_SubTargetingLocation_0									0xBB1C653D

			// Character
			BoneUID_Bip01_Head												0x22C14F2A
			BoneUID_Bip01_Neck												0x7A930844
			BoneUID_Bip01_Pelvis											0xD2BB382A
			BoneUID_Bip01_Spine												0x19725F7B
			BoneUID_Bip01_Spine1											0xCC742058
			BoneUID_Bip01_Spine2											0xC1370681
			BoneUID_Bip01_Spine3											0xC5F61B36
			BoneUID_Bip01_L_Calf											0x8C4CF328
			BoneUID_Bip01_L_Clavicle										0x66DAA3C6
			BoneUID_Bip01_L_Foot											0x11BA157D
			BoneUID_Bip01_L_Forearm											0xA1A434BF
			BoneUID_Bip01_L_ForeTwist										0xA31CF44B
			BoneUID_Bip01_L_Hand											0xBCA17C2D
			BoneUID_Bip01_L_Prop											0x20B0980D
			BoneUID_Bip01_L_Thigh											0x8B6836A7
			BoneUID_Bip01_L_UpperArm										0x7B83579D
			BoneUID_Bip01_R_Calf											0xB9BD7DCF
			BoneUID_Bip01_R_Clavicle										0x5079DA61
			BoneUID_Bip01_R_Foot											0x244B9B9A
			BoneUID_Bip01_R_Forearm											0x1222EA6D
			BoneUID_Bip01_R_ForeTwist										0xCED17369
			BoneUID_Bip01_R_Hand											0x8950F2CA
			BoneUID_Bip01_R_Prop											0x154116EA
			BoneUID_Bip01_R_Thigh											0xB911D75C
			BoneUID_Bip01_R_UpperArm										0x4D202E3A

			// Prop
			BoneUID_AttachSync												0x3CCC4E9A
			BoneUID_Grip_L_Elbow											0x5E475D84
			BoneUID_Grip_L_Hand												0xCED9F5F1
			BoneUID_Grip_L_Shoulder											0xD5628948
			BoneUID_Grip_R_Elbow											0x6C3EBC7F
			BoneUID_Grip_R_Hand												0xFB287B16
			BoneUID_Grip_R_Shoulder											0xE3C1F0EF
			BoneUID_Head													0x2BB14144
			BoneUID_HeadSync												0x396998B8

			// Vehicle
			BoneUID_C_SeatSync01											0xBB1C653D
			BoneUID_C_SeatSync02											0xB65F43E4
			BoneUID_C_SeatSync03											0xB29E5E53
			BoneUID_C_SeatSync04											0xACD90E56
			BoneUID_M_Trunk													0x8DDDC9FD

			// Generic
			BoneUID_CameraSync01											0x31F17B03
			BoneUID_Sync01													0x806F7A7E
			BoneUID_Sync02													0xB65F43E4
			BoneUID_Sync03													0xACD90E56
			BoneUID_Sync04													0xB29E5E53
		*/
		fn size = (104 + m_Resource.base.reserved.count + 40 + m_NumBones + (mod (40-(mod m_NumBones 40)) 40) + (m_NumBones * 72)),
		fn read f = (
			local pos = ftell f
			m_Resource.read(f)
			if m_Resource.base.m_TypeUID == 0x982456DB or m_Resource.base.m_TypeUID == -1742448933 do (
				
				m_NumPalettes = readLong f #unsigned
				m_NumBones = readLong f #unsigned
				
				local addr_BoneNameTableOffset = ftell f
				m_BoneNameTableOffset = readLongLong f #unsigned -- 0x70 (112)
				
				local addr_BoneUIDTableOffset = ftell f
				m_BoneUIDTableOffset = readLongLong f #unsigned -- 0x78 (120)
				
				local addr_BoneFullUIDTableOffset = ftell f
				m_BoneFullUIDTableOffset = readLongLong f #unsigned -- 0x80 (128)
				
				pad16 = #(
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
					)
				
				m_BoneIndexTable = #()
				if m_NumBones > 0 do (
					/*
						I didn't have an example of a multi-palette, this code assumes there's only one
					*/
					
					m_BoneIndexTable[m_NumBones] = 0
					local i = 1
					for i = 1 to m_NumBones do (
						m_BoneIndexTable[i] = readByte f #unsigned
						)
					)
				
				m_BoneNameTable = #()
				if m_NumBones > 0 and m_BoneNameTableOffset > 0 and addr_BoneNameTableOffset + m_BoneNameTableOffset <= pos + m_Resource.size() do (
					m_BoneNameTable[m_NumBones] = ""
					local i = 1, j = 1, b = 0
					for i = 1 to m_NumBones do (
						fseek f (addr_BoneNameTableOffset + m_BoneNameTableOffset + ((i - 1) * 0x40)) #seek_set
						m_BoneNameTable[i] = ""
						for j = 1 to 64 do (
							b = readByte f #unsigned
							if b > 0 then (
								m_BoneNameTable[i] += bit.IntAsChar b
								) else (exit)
							)
						)
					)
				
				m_BoneUIDTable = #()
				if m_NumBones > 0 and m_BoneUIDTableOffset > 0 and addr_BoneUIDTableOffset + m_BoneUIDTableOffset <= pos + m_Resource.size() do (
					fseek f (addr_BoneUIDTableOffset + m_BoneUIDTableOffset) #seek_set
					m_BoneUIDTable[m_NumBones] = 0
					local i = 1
					for i = 1 to m_NumBones do (
						m_BoneUIDTable[i] = readLong f #unsigned
						)
					)
				
				m_BoneFullUIDTable = #()
				if m_NumBones > 0 and m_BoneFullUIDTableOffset > 0 and addr_BoneFullUIDTableOffset + m_BoneFullUIDTableOffset <= pos + m_Resource.size() do (
					fseek f (addr_BoneFullUIDTableOffset + m_BoneFullUIDTableOffset) #seek_set
					m_BoneFullUIDTable[m_NumBones] = 0
					local i = 1
					for i = 1 to m_NumBones do (
						m_BoneFullUIDTable[i] = readLong f #unsigned
						)
					)
				)
			),
		fn write &s = (
			
			-- Recalculate Offsets
			local n_padding = mod (160-(mod m_NumBones 160)) 160
			m_NumBones = m_BoneNameTable.count
			m_NumPalettes = 1 -- samples I have only had 1
			m_BoneNameTableOffset = 32 + m_NumBones + n_padding
			m_BoneUIDTableOffset = m_BoneNameTableOffset + (m_NumBones * 64) - 8
			m_BoneFullUIDTableOffset = m_BoneUIDTableOffset + (m_NumBones * 4) - 8
			m_Resource.base.m_EntrySize = #(size() - 16, size() - 16)
			
			-- Write File Header
			m_Resource.write(&s)
			
			-- Write Sub Header
			writeLong s m_NumPalettes #unsigned
			writeLong s m_NumBones #unsigned
			writeLongLong s m_BoneNameTableOffset #unsigned
			writeLongLong s m_BoneUIDTableOffset #unsigned
			writeLongLong s m_BoneFullUIDTableOffset #unsigned
			
			local i = 1
			for i = 1 to 8 do (
				writeByte s pad16[i] #unsigned
				)
			
			-- Write m_BoneIndexTable
			for i = 1 to m_NumBones do (
				writeByte s m_BoneIndexTable[i] #unsigned
				)
			
			-- Write Padding
			for i = 1 to n_padding do (
				writeByte s 0xFF #unsigned
				)
			
			-- Write m_BoneNameTable
			for i = 1 to m_NumBones do (
				local name = m_BoneNameTable[i]
				for j = 1 to 64 do (
					if j <= name.count then (
						writeByte s (bit.charAsInt name[j]) #unsigned
						)
					else (
						writeByte s 0 #unsigned
						)
					)
				)
			
			-- Write m_BoneUIDTable
			for i = 1 to m_NumBones do (
				writeLong s m_BoneUIDTable[i] #unsigned
				)
			
			-- Write m_BoneFullUIDTable
			for i = 1 to m_NumBones do (
				writeLong s m_BoneFullUIDTable[i] #unsigned
				)
			
			)
		)
	
	struct MaterialUser_t ( -- 16 bytes
		/*uint16_t*/ m_VisibilityFlags = 0,
		/*uint16_t*/ m_ShadowFlags = 0,
		/*uint8_t[12]*/ m_Align = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		fn read f = (
			m_VisibilityFlags = readShort f #unsigned
			m_ShadowFlags = readShort f #unsigned
			m_Align = #(
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
				)
			),
		fn write &s = (
			writeShort s m_VisibilityFlags #unsigned
			writeShort s m_ShadowFlags #unsigned
			local i = 1
			for i = 1 to m_Align.count do (
				writeByte s m_Align[i] #unsigned
				)
			)
		)
	
	struct StateParam_t ( -- 12 bytes
		/*uint32_t*/ m_NameUID = 0,
		/*uint32_t*/ m_TypeUID = 0,
		/*uint16_t*/ m_ParamIndex = 0,
		/*uint8_t[2]*/ pad15 = #(0, 0), -- UFG_PAD(0x2)
		fn read f = (
			m_NameUID = readLong f #unsigned
			m_TypeUID = readLong f #unsigned
			m_ParamIndex = readShort f #unsigned
			pad15 = #(readByte f #unsigned, readByte f #unsigned)
			),
		fn write &s = (
			writeLong s m_NameUID #unsigned
			writeLong s m_TypeUID #unsigned
			writeShort s m_ParamIndex #unsigned
			local i = 1
			for i = 1 to pad15.count do (
				writeByte s pad15[i] #unsigned
				)
			)
		)

	struct MaterialParam_t ( -- 56 bytes
		/*StateParam_t*/ m_StateParam = StateParam_t(),
		/*uint8_t[28]*/ pad12 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x1C)
		/*uint32_t*/ m_NameUID = 0,
		/*uint8_t[4]*/ pad13 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*uint32_t*/ m_TypeUID = 0,
		/*uint8_t[4]*/ pad14 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		fn read f = (
			m_StateParam.read(f)
			pad12 = #(
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
				)
			m_NameUID = readLong f #unsigned
			pad13 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
			m_TypeUID = readLong f #unsigned
			pad14 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
			),
		fn write &s = (
			m_StateParam.write(&s)
			local i = 1
			for i = 1 to pad12.count do (
				writeByte s pad12[i] #unsigned
				)
			writeLong s m_NameUID #unsigned
			for i = 1 to pad13.count do (
				writeByte s pad13[i] #unsigned
				)
			writeLong s m_TypeUID #unsigned
			for i = 1 to pad14.count do (
				writeByte s pad14[i] #unsigned
				)
			)
		)
	
	struct Material_t (
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint8_t[8]*/ pad10 = #(0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x8)
		/*uint64_t[2]*/ m_StateBlockMask = #(0, 0),
		/*uint32_t*/ m_NumParams = 0,
		/*uint8_t[4]*/ pad11 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_MaterialUserOffset = 0,
		/*MaterialParam_t[m_NumParams]*/m_ParamTable = #(),
		/*MaterialUser_t*/ m_MaterialUser = MaterialUser_t(),
		fn size = (104 + m_Resource.base.reserved.count + (m_ParamTable.count * 56) + (mod (16-(mod (m_ParamTable.count * 56) 16)) 16) + 56),
		fn read f = (
			local pos = ftell f
			m_Resource.read(f)
			
			if m_Resource.base.m_TypeUID == 0xF5F8516F or m_Resource.base.m_TypeUID == -168275601 do (
				
				pad10 = #(
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
					)
				m_StateBlockMask = #(readLongLong f, readLongLong f)
				m_NumParams = readLong f #unsigned
				pad11 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
				local addr_MaterialUserOffset = ftell f
				m_MaterialUserOffset = readLongLong f -- 0x88 (136)
				
				m_ParamTable = #()
				if m_NumParams > 0 do (
					m_ParamTable[m_NumParams] = MaterialParam_t()
					local i = 1
					for i = 1 to m_NumParams do (
						m_ParamTable[i] = MaterialParam_t()
						m_ParamTable[i].read(f)
						)
					)
				
				if m_MaterialUserOffset > 0 and addr_MaterialUserOffset + m_MaterialUserOffset <= pos + m_Resource.size() do (
					fseek f (addr_MaterialUserOffset + m_MaterialUserOffset) #seek_set
					m_MaterialUser.read(f)
					)
				)
			),
		fn write &s = (
			
			-- Recalculate Offsets
			m_NumParams = m_ParamTable.count
			m_MaterialUserOffset = 8 + (m_NumParams * 56) + (mod (16-(mod (m_NumParams * 56) 16)) 16)
			m_Resource.base.m_EntrySize = #(size() - 16, size() - 16)
			
			-- Write File Header
			m_Resource.write(&s)
			
			-- Write Sub Header
			local i = 1
			for i = 1 to pad10.count do (
				writeByte s pad10[i] #unsigned
				)
			writeLongLong s m_StateBlockMask[1] #unsigned
			writeLongLong s m_StateBlockMask[2] #unsigned
			writeLong s m_NumParams #unsigned
			for i = 1 to pad11.count do (
				writeByte s pad11[i] #unsigned
				)
			
			writeLongLong s m_MaterialUserOffset #unsigned
			
			for i = 1 to m_NumParams do (
				m_ParamTable[i].write(&s)
				)
			local padding = mod (16-(mod (m_NumParams * 56) 16)) 16
			for i = 1 to padding do (
				writeByte s 0
				)
			
			m_MaterialUser.write(&s)
			)
		)
	
	struct Mesh_t ( -- 272 bytes
		/*ResourceHandle_t*/ m_MaterialHandle = ResourceHandle_t(),
		/*ResourceHandle_t*/ m_VertexDeclHandle = ResourceHandle_t(),
		/*ResourceHandle_t*/ m_IndexBufferHandle = ResourceHandle_t(),
		/*ResourceHandle_t*/ m_VertexBufferHandles = #(ResourceHandle_t(), ResourceHandle_t(), ResourceHandle_t(), ResourceHandle_t()),
		/*int32_t*/ m_PrimType = 0,
		/*int32_t*/ m_IndexStart = 0,
		/*uint32_t*/ m_NumPrims = 0,
		/*uint8_t[4]*/ pad6 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_Description = 0,
		/*uint8_t[24]*/ pad7 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		fn read f = (
			m_MaterialHandle.read(f)
			m_VertexDeclHandle.read(f)
			m_IndexBufferHandle.read(f)
			local i = 1
			for i = 1 to 4 do (
				m_VertexBufferHandles[i].read(f)
				)
			m_PrimType = readLong f #signed
			m_IndexStart = readLong f #signed
			m_NumPrims = readLong f #unsigned
			for i = 1 to 4 do (
				pad6[i] = readByte f #unsigned
				)
			m_Description = readLongLong f
			for i = 1 to 24 do (
				pad7[i] = readByte f #unsigned
				)
			),
		fn write &s = (
			m_MaterialHandle.write(&s)
			m_VertexDeclHandle.write(&s)
			m_IndexBufferHandle.write(&s)
			local i = 1
			for i = 1 to 4 do (
				m_VertexBufferHandles[i].write(&s)
				)
			writeLong s m_PrimType #signed
			writeLong s m_IndexStart #signed
			writeLong s m_NumPrims #unsigned
			for i = 1 to pad6.count do (
				writeByte s pad6[i] #unsigned
				)
			writeLongLong s m_Description
			for i = 1 to pad7.count do (
				writeByte s pad7[i] #unsigned
				)
			)
		)

	struct ModelUser_t ( -- 16 Bytes
		/*int64_t*/ m_SoftBodyDataOffset = 0,
		/*uint32_t*/ m_HasSoftBodyInfo = 0,
		/*uint8_t[4]*/ pad9 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		fn read f = (
			m_SoftBodyDataOffset = readLongLong f
			m_HasSoftBodyInfo = readLong f #unsigned
			local i = 1
			for i = 1 to 4 do (pad9[i] = readByte f #unsigned)
			),
		fn write &s = (
			writeLongLong s m_SoftBodyDataOffset
			writeLong s m_HasSoftBodyInfo #unsigned
			local i = 1
			for i = 1 to pad9.count do (
				writeByte s pad9[i] #unsigned
				)
			)
		)

	struct MeshUnknown_t ( -- 32 bytes
		/*int64_t*/ m_Value = 0x10,
		/*uint8_t[8]*/ pad8 = #(0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x8)
		/*int32_t*/ m_Value1 = 0x42,
		/*float[]*/ m_Value2 = [110.0, 0.0, 0.0],
		fn size = (32),
		fn read f = (
			m_Value = readLongLong f
			local i = 1
			for i = 1 to 8 do (pad8[i] = readByte f #unsigned)
			m_Value1 = readLong f #unsigned
			m_Value2 = [readFloat f, readFloat f, readFloat f]
			),
		fn write &s = (
			writeLongLong s m_Value
			local i = 1
			for i = 1 to pad8.count do (
				writeByte s pad8[i] #unsigned
				)
			writeLong s m_Value1 #unsigned
			for i = 1 to 3 do (
				writeFloat s m_Value2[i]
				)
			)
		)

	struct ModelData_t (
		/*
			pointers are relative to the start of the address defined for the address. (relative basically)
		*/
		/*ResourceData_t*/m_Resource = ResourceData_t(),
		/*float[3]*/ m_AABBMin = [0.0, 0.0, 0.0],
		/*uint32_t*/ m_NumPrims = 0,
		/*float[3]*/ m_AABBMax = [0.0, 0.0, 0.0],
		/*uint8_t[4]*/ pad1 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_MaterialTableHandle = ResourceHandle_t(),
		/*int64_t*/ m_BonePaletteHandle = ResourceHandle_t(),
		/*int64_t*/ m_MeshOffset = 0,
		/*uint32_t*/ m_NumMeshes = 0,
		/*uint8_t[4]*/ pad2 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_ModelUserOffset = 0,
		/*uint8_t[4]*/ pad3 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*uint32_t*/ m_LastUsedFrameNum = 0,
		/*uint8_t[4]*/ pad4 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_MemoryPool = 0,
		/*int64_t*/ m_MorphTargetsHandle = ResourceHandle_t(),
		/*int64_t*/ m_LocatorsHandle = ResourceHandle_t(),
		/*uint8_t[12]*/ pad5 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0xC)
		/*MeshUnknown_t*/ unk1 = MeshUnknown_t(),
		/*ModelUser_t*/ m_MaterialUser = ModelUser_t(),
		/*int64_t[m_NumMeshes]*/ m_MeshOffsetTable = #(),
		/*Mesh_t[m_NumMeshes]*/ m_MeshTable = #(),
		fn size = (104 + m_Resource.base.reserved.count + 264 + (m_NumMeshes * 280)),
		fn read &f = (
			local pos = ftell f
			local result = false
			m_Resource.read(f)
			
			if m_Resource.base.m_TypeUID == 0x6DF963B3 or m_Resource.base.m_TypeUID ==  1845060531 do (
				
				m_AABBMin = [readFloat f, readFloat f, readFloat f]
				m_NumPrims = readLong f #unsigned
				m_AABBMax = [readFloat f, readFloat f, readFloat f]
				pad1 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
				m_MaterialTableHandle.read(f)
				m_BonePaletteHandle.read(f)
				
				local addr_MeshOffset = ftell f
				m_MeshOffset = readLongLong f -- 0xC8 (200)
				m_NumMeshes = readLong f #unsigned
				pad2 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
				
				
				local addr_ModelUserOffset = ftell f
				m_ModelUserOffset = readLongLong f -- 0xD8 (216)
				pad3 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
				m_LastUsedFrameNum = readLong f #unsigned
				pad4 = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
				m_MemoryPool = readLongLong f
				m_MorphTargetsHandle.read(f)
				m_LocatorsHandle.read(f)
				pad5 = #(
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
					)
				unk1.read(f)
				
				if m_ModelUserOffset > 0 and addr_ModelUserOffset + m_ModelUserOffset <= pos + m_Resource.size() do (
					fseek f (addr_ModelUserOffset + m_ModelUserOffset) #seek_set
					m_MaterialUser.read(f)
					)
				
				m_MeshOffsetTable = #()
				m_MeshTable = #()
				if m_NumMeshes > 0 and m_MeshOffset > 0 and addr_MeshOffset + m_MeshOffset <= pos + m_Resource.size() do (
					fseek f (addr_MeshOffset + m_MeshOffset) #seek_set
					m_MeshOffsetTable[m_NumMeshes] = 0
					m_MeshTable[m_NumMeshes] = Mesh_t()
					local i = 1
					for i = 1 to m_NumMeshes do (
						m_MeshOffsetTable[i] = readLongLong f
						)
					for i = 1 to m_NumMeshes do (
						m_MeshTable[i] = Mesh_t()
						if m_MeshOffsetTable[i] == 0 do continue
						fseek f (addr_MeshOffset + m_MeshOffset + ((i - 1) * 0x08) + m_MeshOffsetTable[i]) #seek_set
						m_MeshTable[i].read(f)
						)
					)
				
				
				result = true
				)
			result
			),
		fn write &s = (
			
			-- Recalculate Offsets
			m_NumMeshes = m_MeshTable.count
			m_MeshOffset = 168
			m_ModelUserOffset = 136
			m_MaterialUser.m_SoftBodyDataOffset = 16 + (m_NumMeshes * 280)
			m_MeshOffsetTable = #()
			local i = 1
			if m_NumMeshes > 0 do (
				m_MeshOffsetTable[m_NumMeshes] = 0
				for i = 1 to m_NumMeshes do (
					m_MeshOffsetTable[i] = ((i - 1) * 272) + ((m_NumMeshes - (i - 1)) * 8)
					)
				)
			m_Resource.base.m_EntrySize = #(size() - 16, size() - 16)
			
			-- Write File Header
			m_Resource.write(&s)
			
			-- Write Sub Header
			for i = 1 to 3 do (
				writeFloat s m_AABBMin[i]
				)
			
			writeLong s m_NumPrims #unsigned
			for i = 1 to 3 do (
				writeFloat s m_AABBMax[i]
				)
			
			for i = 1 to pad1.count do (
				writeByte s pad1[i] #unsigned
				)
			m_MaterialTableHandle.write(&s)
			m_BonePaletteHandle.write(&s)
			
			writeLongLong s m_MeshOffset
			writeLong s m_NumMeshes #unsigned
			for i = 1 to pad2.count do (
				writeByte s pad2[i] #unsigned
				)
			
			writeLongLong s m_ModelUserOffset #unsigned
			for i = 1 to pad3.count do (
				writeByte s pad3[i] #unsigned
				)
			
			writeLong s m_LastUsedFrameNum #unsigned
			for i = 1 to pad4.count do (
				writeByte s pad4[i] #unsigned
				)
			
			writeLongLong s m_MemoryPool
			m_MorphTargetsHandle.write(&s)
			m_LocatorsHandle.write(&s)
			
			for i = 1 to pad5.count do (
				writeByte s pad5[i] #unsigned
				)
			
			unk1.write(&s)
			
			m_MaterialUser.write(&s)
			
			for i = 1 to m_NumMeshes do (
				writeLongLong s m_MeshOffsetTable[i] #unsigned
				)
			
			for i = 1 to m_NumMeshes do (
				m_MeshTable[i].write(&s)
				)
			
			)
		)
	
	struct hkPackFileSection_t (
		
		name = "",
		unk02 = 0, -- 0xFF000000
		unk03 = 0, -- address, probably start of havok file
		unk04 = 0, -- size
		unk05 = 0, -- maybe this crap is sub header shit?
		unk06 = 0,
		unk07 = 0,
		unk08 = 0,
		unk09 = 0,
		unk10 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		fn readStringFixed &f len = (
			local str = ""
			local i = 1
			local b = 0
			for i = 1 to len do (
				b = readbyte f #unsigned
				if b == 0 then (
					fseek f (len - i) #seek_cur
					exit
					)
				else (
					str += bit.IntAsChar b
					)
				)
			str
			),
		fn read &f = (
			
			name = readStringFixed f 16
			unk02 = readLong f #unsigned
			unk03 = readLong f #unsigned
			unk04 = readLong f #unsigned
			unk05 = readLong f #unsigned
			unk06 = readLong f #unsigned
			unk07 = readLong f #unsigned
			unk08 = readLong f #unsigned
			unk09 = readLong f #unsigned
			local i = 1
			for i = 1 to 16 do (unk10[i] = readByte f #unsigned)
			)
		
		)
	
	struct SkeletonData_t (
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint32_t*/ hkFileHash = 0,
		/*uint32_t*/ hkFileSize = 0,
		/*uint8_t[176]*/reserved1 = #(),
		
		-- havok file starts here
		/*uint32_t*/ magic1 = 0x57E0E057,
		/*uint32_t*/ magic2 = 0x10C0C010,
		/*uint32_t*/ userTag = 0,
		/*uint32_t*/ version = 0,
		/*uint8_t*/ pointerSize = 0,
		/*uint8_t*/ littleEndian = 0,
		/*uint8_t*/ reuseBaseClassPadding = 0,
		/*uint8_t*/ emptyBaseClassOptimization = 0,
		/*int32_t*/ numSections = 0,
		/*int32_t*/ contentsSectionIndex = 0,
		/*int32_t*/ contentsSectionOffset = 0,
		/*int32_t*/ contentsClassNameSectionIndex = 0,
		/*int32_t*/ contentsClassNameSectionOffset = 0,
		/*uint8_t[16]*/ contentsVersion = "",
		/*hkPackFileSection_t*/contentSections = #(),
		
		-- Data In the Havok File
		bone_count = 0,
		filename = "",
		parent_indices = #(),
		boneNames = #(),
		boneTrasforms = #(),
		boneHashes = #(),
		parentBoneHashes = #(),
		parentBoneInices = #(),
		boneMatrices = #(),
		fn read f = (
			m_Resource.read(f)
			
			-- Clear Data
			bone_count = 0
			filename = ""
			parent_indices = #()
			boneNames = #()
			boneTrasforms = #()
			boneHashes = #()
			parentBoneHashes = #()
			parentBoneInices = #()
			boneMatrices = #()
			
			-- Read Sub Header
			hkFileHash = readLong f #unsigned
			hkFileSize = readLong f #unsigned
			local i = 1
			reserved1 = #()
			reserved1[176] = 0
			for i = 1 to 176 do (reserved1[i] = readByte f #unsigned)
			
			-- Read Havok File
			local pos = ftell f
			contentSections = #()
			magic1 = readLong f #unsigned
			if magic1 == 0x57E0E057 do (
				magic2 = readLong f #unsigned
				if magic2 == 0x10C0C010 do (
					userTag = readLong f #unsigned
					version = readLong f #unsigned
					if version == 11 then (
						pointerSize = readByte f #unsigned
						littleEndian = readByte f #unsigned
						reuseBaseClassPadding = readByte f #unsigned
						emptyBaseClassOptimization = readByte f #unsigned
						numSections = readLong f #signed
						contentsSectionIndex = readLong f #signed
						contentsSectionOffset = readLong f #signed
						contentsClassNameSectionIndex = readLong f #signed
						contentsClassNameSectionOffset = readLong f #signed
						local util = hkPackFileSection_t()
						
						contentsVersion = util.readStringFixed f 16
						
						fseek f (mod (16-(mod ((ftell f) - pos) 16)) 16) #seek_cur
						
						if contentsVersion == "hk_2013.2.0-r1" then (
							if numSections > 0 do (
								contentSections[numSections] = hkPackFileSection_t()
								for i = 1 to numSections do (
									contentSections[i] = hkPackFileSection_t()
									contentSections[i].read(f)
									
									)
								)
							fseek f (pos + 64 + (numSections * 64) + contentsClassNameSectionOffset) #seek_set
							local data_type = readString f
							fseek f (mod (16-(mod (ftell f - pos) 16)) 16) #seek_cur
								
							local data_pos = ftell f
							if data_type == "hkaSkeleton" then (
								local sec = hkPackFileSection_t()
								for sec in contentSections where sec.name == "__data__" do (
									
									if data_pos == pos + sec.unk03 then (
										
										-- Skip 32
										fseek f (data_pos + 32) #seek_set
										
										-- hope that the bone count is here, there seems to be 3 entries, each 16 bytes.
										-- however there appears to be additional dummy entries, so getting to this table end is risky
										bone_count = readLong f #unsigned
										if bone_count > 0 then (
											
											local offset_table_pos = data_pos + sec.unk04
											fseek f offset_table_pos #seek_set
											
											local unk10 = readLong f #unsigned
											local unk11 = readLong f #unsigned -- filenane address
											local unk12 = readLong f #unsigned -- address to the table of addresses
											local unk13 = readLong f #unsigned -- Index Table Address
											local unk14 = readLong f #unsigned
											local unk15 = readLong f #unsigned -- Table2 Address
											
											--format "unk10: \t%\n" unk10
											--format "unk11: \t%\n" unk11
											----format "unk12: \t%\n" unk12
											--format "unk13: \t%\n" unk13
											--format "unk14: \t%\n" unk14
											--format "unk15: \t%\n" unk15
											
											fseek f (data_pos + unk11) #seek_set
											filename = readString f
											--format "filename: \t%\n" filename
											
											fseek f (data_pos + unk13) #seek_set
											parent_indices = #()
											parent_indices[bone_count] = 0
											for j = 1 to bone_count do (
												parent_indices[j] = readShort f #signed
												)
											
											local unk16 = 0
											local unk17 = 0
											local j = 1
											boneNames = #()
											boneNames[bone_count] = ""
											for j = 1 to bone_count do (
												fseek f (offset_table_pos + unk12 + ((j - 1) * 8)) #seek_set
												unk16 = readLong f #unsigned -- points to a weird table, mostly 0's and maybe times a 1 is in there?
												unk17 = readLong f #unsigned -- points to the bone name
												fseek f (data_pos + unk17) #seek_set
												boneNames[j] = readString f
												)
											
											
											
											
											fseek f (offset_table_pos + unk12 + (bone_count * 8)) #seek_set
											
											local unk18 = readLong f #unsigned -- ?
											local unk19 = readLong f #unsigned -- address to the position table
											
											--format "unk18: \t%\n" unk18
											--format "unk19: \t%\n" unk19
											
											
											boneTrasforms = #()
											boneTrasforms[bone_count] = #(
												#(0.0, 0.0, 0.0, 1.0),
												#(0.0, 0.0, 0.0, 1.0),
												#(0.0, 0.0, 0.0, 1.0)
												)
											fseek f (data_pos + unk19) #seek_set
											for j = 1 to bone_count do (
												boneTrasforms[j] = #(
													#(readFloat f, readFloat f, readFloat f, readFloat f),
													#(readFloat f, readFloat f, readFloat f, readFloat f),
													#(readFloat f, readFloat f, readFloat f, readFloat f)
													)
												)
											
											fseek f (pos + hkFileSize) #seek_set
											boneHashes = #()
											boneHashes[bone_count] = 0
											for j = 1 to bone_count do (
												boneHashes[j] = readLong f #unsigned
												)
											
											parentBoneHashes = #()
											parentBoneInices = #()
											parentBoneHashes[bone_count] = 0
											parentBoneInices[bone_count] = 0
											for j = 1 to bone_count do (
												parentBoneHashes[j] = readLong f #unsigned
												parentBoneInices[j] = readLong f #unsigned
												)
											
											fseek f (mod (16-(mod (bone_count * 12) 16)) 16) #seek_cur
											boneMatrices = #()
											boneMatrices[bone_count] = #(
												#(1.0, 0.0, 0.0, 0.0),
												#(0.0, 1.0, 0.0, 0.0),
												#(0.0, 0.0, 1.0, 0.0),
												#(0.0, 0.0, 0.0, 1.0)
												)
											for j = 1 to bone_count do (
												boneMatrices[j] = #(
													#(readFloat f, readFloat f, readFloat f, readFloat f),
													#(readFloat f, readFloat f, readFloat f, readFloat f),
													#(readFloat f, readFloat f, readFloat f, readFloat f),
													#(readFloat f, readFloat f, readFloat f, readFloat f)
													)
												)
											) else (format "Error: Ant got no bones\n")
										) else (format "Error2: an expectation about how the sections works, didn't work\n")
									exit
									)
								) else (format "Error1: an expectation about how the sections works, didn't work\n")
							) else (format "Error1: wrong havok version?\n")
						) else (format "Error2: wrong havok version?\n")
					)
				)
			),
		fn build mscale:39.3701 = (
			local boneArray = #()
			local i = 1
			if bone_count > 0 do (boneArray[bone_count] = undefined)
			for i = 1 to bone_count do (
				boneArray[i] = dummy()
				boneArray[i].name = boneNames[i]
				boneArray[i].rotation = quat boneTrasforms[i][2][1] boneTrasforms[i][2][2] boneTrasforms[i][2][3] boneTrasforms[i][2][4]
				boneArray[i].position = [boneTrasforms[i][1][1], boneTrasforms[i][1][2], boneTrasforms[i][1][3]] * boneTrasforms[i][1][4] * mscale
				boneArray[i].scale = [boneTrasforms[i][3][1], boneTrasforms[i][3][2], boneTrasforms[i][3][3]]
				boneArray[i].showLinksOnly = boneArray[i].showLinks = true
				)
			
			local parent_index = 0
			for i = 1 to bone_count do (
				parent_index = parent_indices[i] + 1
				if parent_index > 0 then (
					boneArray[i].transform *= boneArray[parent_index].transform
					boneArray[i].parent = boneArray[parent_index]
					)
				)
			)
		)
	
	struct ResourceFile_t (
		SkeletonData = #(),
		ModelData = #(),
		MaterialData = #(),
		BufferData = #(),
		BonePalleteData = #(),
		Data = #(),
		index = #(),
		fn read file = (
			local f = try(fopen file "rb")catch(undefined)
			
			if f != undefined then (
				
				fseek f 0 #seek_end
				local fsize = ftell f
				fseek f 0 #seek_set
				
				local res = ResourceData_t()
				local pos = 0
				while (pos = ftell f) + 16 < fsize do (
					res = ResourceData_t()
					if not res.read(f) do (
						format "Error: Unsupported file {%}\n" file
						exit
						)
					fseek f pos #seek_set
					case res.base.m_TypeUID of (
						(337173876): ( -- SkeletonData_t
							local skl = SkeletonData_t()
							skl.read(f)
							append SkeletonData skl
							append index #(#rig, SkeletonData.count)
							skl = undefined
							)
						(1845060531): ( -- ModelData_t
							local mdl = ModelData_t()
							mdl.read(f)
							append ModelData mdl
							append index #(#model, ModelData.count)
							mdl = undefined
							)
						(-168275601): ( -- Material_t
							local mat = Material_t()
							mat.read(f)
							append MaterialData mat
							append index (#(#material, MaterialData.count))
							mat = undefined
							)
						(2056721529): ( -- Buffer_t
							local buf = Buffer_t()
							buf.read(f)
							append BufferData buf
							append index (#(#buffer, BufferData.count))
							buf = undefined
							)
						(-1742448933): ( -- BonePallete_t
							local pal = BonePallete_t()
							pal.read(f)
							append BonePalleteData pal
							append index #(#pallete, BonePalleteData.count)
							pal = undefined
							)
						default: (
							local dat = byteArray()
							dat.readFromStream f fsize:(res.size())
							append Data dat
							append index #(#data, Data.count)
							dat = undefined
							)
						)
					fseek f (pos + res.size()) #seek_set
					)
				
				) else (format "failed to open file {%}\n" file)
			),
		fn write &s = (
			local i
			for i in index do (
				case i[1] of (
					#model: (ModelData[i[2]].write(&s))
					#material: (MaterialData[i[2]].write(&s))
					#buffer: (BufferData[i[2]].write(&s))
					#pallete: (BonePalleteData[i[2]].write(&s))
					#data: (Data[i[2]].writeToStream(&s))
					)
				)
			),
		fn save file = (
			local s = try(fopen file "wb") catch(undefined)
			if s != undefined then (
				save(&s)
				fclose s
				)
			else (
				format "failed to open file {%}\n" file
				)
			),
		fn build mscale:39.3701 = (
			/*
			
				looks like I read the ModelData and the ResourceHandle provides the hash values that
				connect the vertex buffers to a given piece of geometry.
				
				I just could not wrap my brain around how to handle this, its somewhat a complex process
				of lookups and such and then I don't know how to combine that into a model in the end.
				
				I instead just go straight for the buffer in a hacky way, I hope thats okay.
			*/
			-- there should only be one ModelData i suppose, but loop over it
			
			max modify mode
			
			
			--if SkeletonData.count > 0 do (
			--	SkeletonData[1].build()
			--	)
			
			-- need to capture vertices
			local vertices = #()
			local vertex_count = 0
			local vtx
			for vtx in BufferData where (vtx.m_Type == 0 and vtx.m_ElementSize == 24) do (
				vertices = copy vtx.m_Buffer #nomap
				vertex_count = vtx.m_NumElements
				exit
				)
			if vertex_count > 0 do (
				local uvw
				local v = 1
				for uvw in BufferData where (uvw.m_Type == 0 and uvw.m_ElementSize == 4) do (
					for v = 1 to vertex_count do (
						vertices[v].m_TexCoord0 = uvw.m_Buffer[v].m_TexCoord0
						)
					exit
					)
				local skn
				local boneidArray = #()
				local weightArray = #()
				
				boneidArray[vertex_count] = #(1,0,0,0)
				weightArray[vertex_count] = #(1.0,0.0,0.0,0.0)
				
				/*
					in the parsing I already added +1 to make the boneid's a base-1 to work with 3ds max
					and weights already changed from ints to floats
					
					otherwise I would have done it here
				*/
				for skn in BufferData where (skn.m_Type == 0 and skn.m_ElementSize == 8) do (
					for v = 1 to vertex_count do (
						boneidArray[v] = skn.m_Buffer[v].m_BoneID
						weightArray[v] = skn.m_Buffer[v].m_Weight
						)
					exit
					)
				
				local vertArray = #()
				local uvw0Array = #()
				vertArray[vertex_count] = [0.0, 0.0, 0.0]
				uvw0Array[vertex_count] = [0.0, 0.0, 0.0]
				for v = 1 to vertex_count do (
					vertArray[v] = [vertices[v].m_Position[1], vertices[v].m_Position[2], vertices[v].m_Position[3]] * mscale
					uvw0Array[v] = [vertices[v].m_TexCoord0[1], 1.0-vertices[v].m_TexCoord0[2], 0.0]
					)
				
				-- need to capture the faces
				local faceArray = #()
				local matidArray = #()
				local matid = 1
				local vpos = 1
				local tri
				for tri in BufferData where tri.m_Type == 1 do (
					
					-- working in reverse here, lets read the materials from the model data
					local mdl
					for mdl in ModelData do (
						
						local mat
						for mat in mdl.m_MeshTable do (
							
							/*
								this is where I would have been able to connect the various buffer files to this sub-mesh
								...but its complicated to deal with... 
								so I assume there are not multiple buffers and just go for it without reading connections
								
								-- these are the hashes to each buffer I would need to read from
								mat.m_MaterialHandle.m_NameUID
								mat.m_VertexDeclHandle.m_NameUID
								mat.m_IndexBufferHandle.m_NameUID
								mat.m_MaterialHandle.m_NameUID
								mat.m_VertexBufferHandles[1].m_NameUID
								mat.m_VertexBufferHandles[2].m_NameUID
								mat.m_VertexBufferHandles[3].m_NameUID
								
							*/
							case mat.m_PrimType of (
								0: ( -- Points
									)
								1: ( -- Line-Strip
									)
								2: ( -- Lines
									)
								3: ( -- Triangles
									local x = 1, k = 1, face = [1,1,1]
									for v = 1 to mat.m_NumPrims do (
										k = ((v - 1) * 3) + mat.m_IndexStart
										face = [1,1,1]
										for x = 1 to 3 do (
											face[x] = tri.m_Buffer[k + x] + vpos
											)
										append faceArray face
										append matidArray matid
										)
									)
								4: ( -- Triangle-Strip
									)
								5: ( -- Triangle-Fan
									)
								)
							matid += 1
							)
						
						
						exit
						)
					
					exit
					)
				
				local msh = mesh vertices:vertArray tverts:uvw0Array faces:faceArray materialIds:matidArray
				buildTVFaces msh
				local i = 1
				for i = 1 to faceArray.count do (setTVFace msh i faceArray[i])
				
				if matid > 2 do (
					matid -= 1
					msh.material = MultiMaterial numsubs:matid
					for v = 1 to matid do (
						msh.material[v] = StandardMaterial()
						msh.material[v].diffuse = random white black
						)
					
					)
				msh.backfacecull = on
				msh.displayByLayer = false
				msh.wirecolor = random (color 0 0 0) (color 255 255 255)
				--if mshName != "" do msh.name = mshName
				for i = 1 to msh.numfaces do setFaceSmoothGroup msh i 1
				
				update msh
				select msh
				
				
				/*
				if impNormals do (
					local normID = #{}
					local normMod = Edit_Normals()
					addmodifier msh normMod ui:off
					normMod.selectBy = 1
					normMod.displayLength = 6.4516 * mscale
					
					--msh.Edit_Normals.MakeExplicit selection:#{1..(vertex_normal.count)}
					
					normID = #{}
					--apply normals
					for i = 1 to normArray.count do (
						normID = #{} --free normID
						normMod.ConvertVertexSelection #{i} &normID
						for ii in normID do (
							normMod.SetNormal ii (normalize normArray[i])
							)
						)
					--collapseStack submesh
					subobjectLevel = 0
					)
				*/
				
				-- capture the bone pallete
				local pal
				for pal in BonePalleteData do (
					
					if pal.m_NumBones == 0 do exit
					
					-- build skeleton
					local boneArray = #()
					boneArray[pal.m_NumBones] = undefined
					local n = 1
					for n = 1 to pal.m_NumBones do (
						boneArray[n] = getNodeByName pal.m_BoneNameTable[n]
						if boneArray[n] == undefined do (
							boneArray[n] = Dummy boxsize:[0.02, 0.02, 0.02]
							boneArray[n].name = pal.m_BoneNameTable[n]
							)
						)
					
					
					
					local skinMod = undefined, num_bones = 0, boneMap = #()
					local numBones = 4, bone_index = 1, bi = #(), bw = #()
					local bneTmp = #(), ii = 1
					
					-- apply a skin modifier
					skinMod = skin()
					addModifier msh skinMod ui:off
					
					-- assign bones to skin modifier, from the weight pallete
					for i = 1 to boneArray.count do (
						skinOps.addbone skinMod boneArray[i] (
							if i == boneArray.count then 1 else 0
							)
						)
					
					-- create a bonemap
					if boneArray.count > 0 do (
						-- get names of bones in skin list
						bneTmp[boneArray.count] = ""
						for i = 1 to boneArray.count do (
							bneTmp[i] = skinOps.GetBoneName skinMod i 0
							)
						-- map boneArray to skin list
						boneMap[boneArray.count] = 1
						for i = 1 to boneArray.count do (
							boneMap[i] = 1 -- default assignment to first bone in skin list
							bone_index = findItem bneTmp boneArray[i].name
							if bone_index > 0 do (boneMap[i] = bone_index)
							)
						)
					
					-- apply weights to skin modifier
					modPanel.setCurrentObject skinMod
					for i = 1 to vertex_count do (
						bi = #()
						bw = #()
						bi[numBones] = 0
						bw[numBones] = 0.0
						for ii = 1 to numBones do (
							bone_index = findItem pal.m_BoneIndexTable (boneidArray[i][ii])
							bi[ii] = boneMap[bone_index]
							bw[ii] = weightArray[i][ii]
							)
						skinOps.ReplaceVertexWeights skinMod i bi bw
						)
					
					if skinOps.isWeightToolOpen skinMod == 0 do (
						skinOps.WeightTool skinMod
						)
					skinMod.filter_vertices = on
					exit
					)
				
				)
			
			),
		fn import mscale:0.0254 = (
			local faceArray = #()
			local vertArray = #()
			local uvw0Array = #()
			local normArray = #()
			local tangArray = #()
			local mat_count = 0
			local matidArray = #()
			local weightArray = #()
			local boneidArray = #()
			
			
			local boneArray = #()
			local vertLookup = #()
			local boneLookup = #()
			local bone_count = 0
			local matCountArray = #()
			
			-- Ensure the scene is in modify mode
			setCommandPanelTaskMode #modify
			local sel = #()
			
			-- Collet Scene Objects
			if selection.count > 0 then (
				sel = selection as array
				)
			else (
				sel = objects as array
				)
			local geo = for o in sel where findItem (#(Editable_Mesh,Editable_Poly,PolyMeshObject)) (classOf o) > 0 collect o
			for msh in geo do (
				select msh
				local num_verts = msh.numverts
				local num_faces = msh.numfaces
				local hasUV = try(if getNumTVerts msh > 0 then true else false) catch(false)
				
				local vertNomrals = #()
				local vertTangents = #()
				
				local skin_modifier = undefined
				local normal_modifier = undefined
				local mesh_modifier = undefined
				
				-- Search for existing Modifiers
				for m in msh.modifiers do (
					if classOf m == Skin do skin_modifier = m
					if classOf m == Edit_Normals do normal_modifier = m
					if classOf m == Edit_Mesh do mesh_modifier = m
					)
				
				-- Add "Edit_Normals" Modifier if it doesn't exist
				if normal_modifier == undefined do (
					normal_modifier = Edit_Normals ()
					addModifier msh normal_modifier
					)
				
				modPanel.setCurrentObject normal_modifier
				
				-- Collect Normals
				vertNomrals[num_faces] = #([0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0])
				for ii = 1 to num_faces do (
					vertNomrals[ii] = #([0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0])
					for iii = 1 to 3 do (
						vertNomrals[ii][iii] = (
							normalize (
								((matrix3 [1,0,0] [0,1,0] [0,0,1] (normal_modifier.GetNormal (normal_modifier.GetNormalID ii iii))) * \
								(msh.transform*(matrix3 [1,0,0] [0,1,0] [0,0,1] -msh.transform.row4))).row4
								)
							)
						)
					)
				
				-- Collect Blend Weights
				if skin_modifier != undefined then (
					boneLookup = #()
					bone_count = skinOps.GetNumberBones skin_modifier
					boneLookup[bone_count] = ""
					boneArray[bone_count] = undefined
					for i = 1 to bone_count do (
						boneLookup[i] = skinOps.GetBoneName skin_modifier i 0
						boneArray[i] = getNodeByName boneLookup[i]
						)
					
					local test_boneweights = for v = 1 to num_verts collect #()
					local test_boneids = for v = 1 to num_verts collect #()
					for v = 1 to num_verts do (
						local wv = #()
						local bi = #()
						local vertex_bone_count = skinOps.GetVertexWeightCount skin_modifier v
						if vertex_bone_count > 0 then (
							for x = 1 to vertex_bone_count do (
								local bone_weight = skinops.getvertexweight skin_modifier v x
								local bone_index = skinOps.GetVertexWeightBoneID skin_modifier v x
								local bone_index = findItem boneLookup (skinOps.GetBoneName skin_modifier bone_index 0)
								local a = findItem bi bone_index
								if a > 0 then (
									wv[a] += bone_weight
									)
								else (
									append wv bone_weight
									append bi bone_index
									)
								)
							)
						else (
							bi = #(1)
							wv = #(1.0)
							)
						test_boneids[v] = bi
						test_boneweights[v] = wv
						)
					)
				else (
					local bone_index = 1
					if msh.parent != undefined do (
						bone_index = findItem boneLookup msh.parent.name
						)
					if bone_index < 0 do (
						bone_index = 1
						)
					for v = 1 to num_verts do (
						test_boneids[v] = #(bone_index)
						test_boneweights[v] = #(1.0)
						)
					)
				
				-- Triangulate mesh if needed
				if mesh_modifier == undefined do (
					mesh_modifier = Edit_Mesh()
					addModifier msh mesh_modifier
					)
				
				-- Collect Materials
				local faceMats = for f = 1 to num_faces collect 0
				local uniqueMatids = #()
				local maxmatsubs = 0
				local mat = msh.material
				local multimat = (classOf mat == Multimaterial)
				if multimat then (
					maxmatsubs = mat.numsubs
					for f = 1 to num_faces do ( -- Get MatIds
						faceMats[f] = getFaceMatID msh f
						if faceMats[f] > maxmatsubs do (
							faceMats[f] = mod (getFaceMatID msh f) maxmatsubs
							)
						local x = findItem uniqueMatids faceMats[f]
						if x == 0 do (
							append uniqueMatids faceMats[f]
							)
						)
					)
				else (
					append uniqueMatids 1
					)
				
				-- Optimize Data
				local faceSel = #{1..num_faces} -- Speed up matid lookup
				
				local mat_face_count = 0
				for m = 1 to uniqueMatids.count do ( -- Loop Through Each Unique MatID
					local mat_face_count = 0
					for f in faceSel do (
						if uniqueMatids[m] == faceMats[f] or multimat == false do (
							local face = getFace msh f
							local uvface = if hasUV then getTVFace msh f else [1, 1, 1]
							local nface = [1, 1, 1]
							
							mat_face_count += 1
							
							for v = 1 to 3 do (
								local texcoord = if hasUV then getTVert msh uvface[v] else [0.0, 0.0, 0.0]
								local p = getVert msh face[v]
								local n = vertNomrals[f][v]
								local w = test_boneids[face[v]] * test_boneweights[face[v]]
								local a = normalize ([(p+n.x), (texcoord.x+n.y), (w+n.z)])
								local x = findItem vertLookup a
								if x == 0 then ( -- Not in Array, Have to add to Vertex Buffer
									append vertArray p
									append vertLookup a
									nface[v] = vertArray.count
									)
								else ( -- Duplicate, Can Reference Vertex Buffer
									nface[v] = x
									)
								)
							append faceArray nface
							f = false -- remove face from selection
							)
						)
					if mat_face_count > 0 do (
						append matCountArray mat_face_count
						)
					)
				
				-- Clean Up
				setCommandPanelTaskMode #create
				if normal_modifier != undefined do deletemodifier msh normal_modifier
				if mesh_modifier != undefined do deletemodifier msh mesh_modifier
				
				-- Deselect mesh
				deselect msh
				)
			
			-- Iterate over the BufferData structure to overwrite relevant buffers
				
				
			for pal in BonePalleteData do (
				for buf in BufferData do (
					case buf.m_Type of (
						0: (
							if buf.m_ElementSize == 24 then (
								buf.m_Buffer = for i = 1 to vertArray.count collect (
									(Vertex_t \
										m_Position:(vertArray[i] * mscale) \
										m_Normal:normArray[i] \
										m_Tangent:tangArray[i] \
										)
									)
								buf.m_NumElements = vertArray.count
								)
							else if buf.m_ElementSize == 8 then (
								buf.m_Buffer = #()
								buf.m_Buffer[weightArray.count] = Vertex_t()
								for i = 1 to weightArray.count do (
									buf.m_Buffer[i] = Vertex_t()
									buf.m_Buffer[i].m_BoneID = #(0, 0, 0, 0)
									buf.m_Buffer[i].m_Weight = #(1.0, 0.0, 0.0, 0.0)
									for ii = 1 to test_boneweights[i].count do (
										buf.m_Buffer[i].m_BoneID[ii] = test_boneweights[i][ii]
										buf.m_Buffer[i].m_Weight[ii] = test_boneweights[i][ii]
										)
									)
								buf.m_NumElements = weightArray.count
								)
							else if buf.m_ElementSize == 4 then (
								buf.m_Buffer = for i = 1 to uvw0Array.count collect (
									(Vertex_t m_TexCoord0:[uvw0Array[i].x, 1.0-uvw0Array[i].y])
									)
								buf.m_NumElements = uvw0Array.count
								)
							)
						1: (
							-- Handle index buffer data
							for face in faceArray do (
								for f = 1 to 3 do (
									append buf.m_Buffer (face[f] - 1) -- Subtract 1 for 0-based indexing
									)
								)
							buf.m_NumElements = faceArray.count * 3 -- Number of indices
							)
						)
					)
				exit
				)
			for mdl in ModelData do (
				mdl.m_NumMeshes = matCountArray.count
				mdl.m_AABBMin = msh.min * mscale
				mdl.m_AABBMax = msh.max * mscale
				--m_MaterialTableHandle.m_NameUID -- assign a new material file
				
				-- Update mdl to match material count
				while mdl.m_MeshTable.count < mat_count do (
					append mdl.m_MeshTable (mdl.m_MeshTable[mdl.m_MeshTable.count])
					)
				
				while mdl.m_MeshTable.count > mat_count do (
					deleteItem mdl.m_MeshTable mdl.m_MeshTable.count
					)
				
				-- Initialize material update
				local face_pos = 0
				
				for mid = 1 to mat_count do (
					local faceCount = 0
					
					for f = 1 to matidArray.count do (
						if matidArray[f] == mid then (
							faceCount += 1
							)
						)
					
					mdl.m_MeshTable[mid].m_PrimType = 3 -- Assuming triangle list
					mdl.m_MeshTable[mid].m_IndexStart = face_pos
					mdl.m_MeshTable[mid].m_NumPrims = faceCount
					face_pos += faceCount * 3 -- Increment by number of indices (3 per face)
					
					--mdl.m_MeshTable[mid].m_MaterialHandle.m_NameUID -- assign a new material file
					--mdl.m_MeshTable[mid].m_VertexDeclHandle.m_NameUID -- assign a new vertex declaration
					--mdl.m_MeshTable[mid].m_IndexBufferHandle.m_NameUID -- assign a new face index buffer
					--mdl.m_MeshTable[mid].m_VertexBufferHandles[1].m_NameUID -- assign a positions buffer
					--mdl.m_MeshTable[mid].m_VertexBufferHandles[2].m_NameUID -- assign a uv buffer
					--mdl.m_MeshTable[mid].m_VertexBufferHandles[3].m_NameUID -- assign a blend weight buffer
					)
				
				exit
				)
			-- Print success message
			format "Model data imported successfully.\n"
			)
		)
	
	

	
	local bin = ResourceFile_t()
	local rig = ResourceFile_t()
	
	fn setCustomProperty propName propValue = (
		-- Determine the type of the property value and add it accordingly
		case classOf propValue of (
			string: fileProperties.addProperty #custom propName propValue
			integer: fileProperties.addProperty #custom propName propValue
			float: fileProperties.addProperty #custom propName propValue
			boolean: fileProperties.addProperty #custom propName propValue
			date: fileProperties.addProperty #custom propName (propValue as string) #date
			default: format "Unsupported property type for property: %\n" propName
			)
		)
	
	fn getCustomProperty propName = (
		local propValue = undefined
		local propIndex = fileProperties.findProperty #custom propName
		if propIndex != 0 then (
			propValue = fileProperties.getPropertyValue #custom propIndex
			)
		else (
			format "Property '%' not found.\n" propName
			)
		format "propValue: \t%\n" propValue
		propValue
		)
	
	fn read file = (
		
		
		if doesFileExist file do (
			bin = ResourceFile_t()
			bin.read(file)
			bin.build()
			
			--local sfile = (getFilenamePath file) + (getFilenameFile file) + "_edit" + (getFilenameType file)
			--bin.save(sfile)
			
			
			
			)
		)
	
	on sddef_mesh open do (
		local sdde_rig_file = getCustomProperty "sdde_rig_file"
		
		if sdde_rig_file != undefined and doesFileExist sdde_rig_file do (
			rig = ResourceFile_t()
			rig.read(sdde_rig_file)
			if rig.SkeletonData.count > 0 do (
				ddl_skeleton.items = for o in rig.SkeletonData collect o.filename
				
				local sdde_rig_select = getCustomProperty "sdde_rig_select"
				if sdde_rig_select != undefined and sdde_rig_select <= rig.SkeletonData.count do (
					ddl_skeleton.selection = sdde_rig_select
					)
				)
			)
		)
	
	on sddef_mesh close do (
		
		)
	
	on btn_skeleton pressed do (
		local file = GetOpenFileName caption:"open CharacterRigs.bin"  types: "CharacterRigs.bin|CharacterRigs.bin|"
		if file != undefined and file != "" do (
			rig = ResourceFile_t()
			rig.read(file)
			if rig.SkeletonData.count > 0 then (
				ddl_skeleton.items = for o in rig.SkeletonData collect o.filename
				setCustomProperty "sdde_rig_file" file
				)
			else (
				ddl_skeleton.items = #()
				)
			)
		)
	
	on btn_make_rig pressed do (
		if rig.SkeletonData.count > 0 and ddl_skeleton.selection <= rig.SkeletonData.count do (
			if chk_clear.checked do (delete $*)
			rig.SkeletonData[ddl_skeleton.selection].build()
			--messageBox "TaDa!"
			)
		)
	on btn_import pressed do (
		local file = GetOpenFileName caption:"Open PERM Model" types:"SDDE Binary Model (*.perm.bin)|*.perm.bin|All Files (*.*)|*.*|"
		if file != undefined and file != "" do (
			read(file)
			lbl_loaded.caption = filenameFromPath file
			)
		)
	on btn_export pressed do (
		local file = GetSaveFileName caption:"Open PERM Model" types:"SDDE Binary Model (*.perm.bin)|*.perm.bin|All Files (*.*)|*.*|"
		if file != undefined and file != "" do (
			local s = try(fopen file "wb")catch(undefined)
			if s != undefined then (
				--bin.import()
				bin.write(&s)
				fclose s
				) else (messageBox "Failed to Write File")
			)
		)
	on ddl_skeleton selected sel do (
		setCustomProperty "sdde_rig_select" sel
		)
	)
createDialog sddef_mesh
-- sddef_mesh.read(
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\0 AMANDADATE_MAT2HAI~ndadate_hd.ufg (Material).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\8 AMANDADATE_HD_SKIN_BODY.BonePalette (BonePalette).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\13 AMANDADATE_HD_SKIN_BODY (ModelData).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\9 AMANDADATE_HD_SKIN_BODY.IndexBuffer (Buffer).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\10 AMANDADATE_HD_SKIN_B~cl.Skinned.0.0 (Buffer).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\11 AMANDADATE_HD_SKIN_B~cl.Skinned.1.0 (Buffer).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\12 AMANDADATE_HD_SKIN_B~cl.Skinned.2.0 (Buffer).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\amanda_full_body\\AmandaDate_HD.perm.bin"
-- 	)
fn batch = (
-- 	local files = join (getFiles "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Characters\\*.perm.bin") (getFiles "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\*.perm.bin")
-- 	local file
-- 	for file in files do (
-- 		sddef_mesh.read(file)
-- 		)
	delete $*
	sddef_mesh.read("C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Alex_HD_Skeleton.bin")
	sddef_mesh.read("C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\Alex_HD.perm.bin")
	)
--batch()

/*	======================================================================
	
	Maxscript:    [PC] Sleeping Dog - Definitive Edition
	Author:       mariokart64n
	Date:         June 06, 2024
	
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	
	Description:
		imports 3d models of the characters
	
	Change Log:
		2024-06-28
			- wrote exporter
		
		2024-06-25
			- Support importing morph that was hidden in the vertex buffer
			- Fixed weight import
			- Added mini .bin resource manager
			- Minor UI changes
			
		2024-06-23
			- Refinements to the Importer, can now import multiple models
		
		2024-06-09
			- wrote importer
	
	======================================================================	*/


/*

build order for what it matters

MATERIAL     0xF5F8516F 0xB4C26312
MATERIAL     0xF5F8516F 0xB4C26312
MATERIAL     0xF5F8516F 0xB4C26312
BONE PALETTE 0x982456DB 0x50A819E3
INDEX BUFFER 0x7A971479 0x92CDEC8F
SKIN0        0x7A971479 0x92CDEC8F
SKIN1        0x7A971479 0x92CDEC8F
SKIN2        0x7A971479 0x92CDEC8F
MODEL DATA   0x6DF963B3 0xA2ADCD77

other blocks
TEXTURE      0xCDBFA090 0x8B43FABF





all the materials are defined first

then each model is packed, if there is relating data then the




*/

gc()
clearListener()
if (heapSize < 100000000) do (heapSize += (100000000-heapSize)) -- bump up to 100mbs ^_^



global arr = #()

-- Functions for backwards compatibility
if classof substituteString == UndefinedClass do (
	fn substituteString inputString findthis replacewiththis ignoreCase:true = (
		local str = "", idx = #(), o = 0
		for i = 1 to inputString.count do (
			str = substring inputString i -1
			if str.count >= findthis.count do (
				if matchpattern str pattern:(findthis + "*") ignoreCase:ignoreCase do (
					append idx i
					)
				)
			)
		str = inputString
		o = replacewiththis.count - findthis.count
		for i = 1 to idx.count do (
			str = replace str (idx[i] + (o * (i - 1))) findthis.count replacewiththis
			)
		str
		)
	)

if classof addModifier == UndefinedClass do (
	fn addModifier msh mo = (
		select msh
		modPanel.addModToSelection mo ui:off
		mo
		)
	)

if classof toUpper == UndefinedClass do (
	fn toUpper outstring = (
		local i = 1, j = 1
		local upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		local lower="abcdefghijklmnopqrstuvwxyz"
		for i=1 to outstring.count do (
			j = findString lower outstring[i]
			if (j != undefined) do outstring[i]=upper[j]
			)
		outstring
		)
	)

if classof toLower == UndefinedClass do (
	fn toLower outstring = (
		local i = 1, j = 1
		local upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		local lower="abcdefghijklmnopqrstuvwxyz"
		for i=1 to outstring.count do (
			j = findString upper outstring[i]
			if (j != undefined) do outstring[i]=lower[j]
			)
		outstring
		)
	)

if classof appendIfUnique == UndefinedClass do (
	fn appendIfUnique array value = (
		local result = false
		local index = findItem array value
		if index == 0 do (
			append array value
			result = true
			)
		result
		)
	)
	
if classof sdde_material == UndefinedClass do (
	sdde_material = attributes "sdde_material" (
		parameters main rollout:params (
			profile type:#integer ui:ddl_profile default:1
			ishader_type type:#integer ui:ddl_ishader_type default:1
			raster_type type:#integer ui:ddl_raster_type default:1
			visible_on type:#boolean ui:chk_visible_on default:true
			ambient_on type:#boolean ui:chk_ambient_on default:false
			ambient_id type:#string ui:edt_ambient_id default:"0xFFFFFFFF"
			diffuse_on type:#boolean ui:chk_diffuse_on default:false
			diffuse_id type:#string ui:edt_diffuse_id default:"0xFFFFFFFF"
			diffuse2_on type:#boolean ui:chk_diffuse2_on default:false
			diffuse2_id type:#string ui:edt_diffuse2_id default:"0xFFFFFFFF"
			blend_on type:#boolean ui:chk_blend_on default:false
			blend_id type:#string ui:edt_blend_id default:"0xFFFFFFFF"
			world_on type:#boolean ui:chk_world_on default:false
			world_id type:#string ui:edt_world_id default:"0xFFFFFFFF"
			bump_on type:#boolean ui:chk_bump_on default:false
			bump_id type:#string ui:edt_bump_id default:"0xFFFFFFFF"
			bump2_on type:#boolean ui:chk_bump2_on default:false
			bump2_id type:#string ui:edt_bump2_id default:"0xFFFFFFFF"
			specular_on type:#boolean ui:chk_specular_on default:false
			specular_id type:#string ui:edt_specular_id default:"0xFFFFFFFF"
			specular2_on type:#boolean ui:chk_specular2_on default:false
			specular2_id type:#string ui:edt_specular2_id default:"0xFFFFFFFF"
			noise_on type:#boolean ui:chk_noise_on default:false
			noise_id type:#string ui:edt_noise_id default:"0xFFFFFFFF"
			unknown1_on type:#boolean ui:chk_unknown1_on default:false
			unknown1_id type:#string ui:edt_unknown1_id default:"0xFFFFFFFF"
			unknown2_on type:#boolean ui:chk_unknown2_on default:false
			unknown2_id type:#string ui:edt_unknown2_id default:"0xFFFFFFFF"
			unknown3_on type:#boolean ui:chk_unknown3_on default:false
			unknown3_id type:#string ui:edt_unknown3_id default:"0xFFFFFFFF"
			unknown4_on type:#boolean ui:chk_unknown4_on default:false
			unknown4_id type:#string ui:edt_unknown4_id default:"0xFFFFFFFF"
			stateblock1_on type:#boolean ui:chk_stateblock1_on default:false
			stateblock1_id type:#string ui:edt_stateblock1_id default:"0xFFFFFFFF"
			stateblock2_on type:#boolean ui:chk_stateblock2_on default:false
			stateblock2_id type:#string ui:edt_stateblock2_id default:"0xFFFFFFFF"
			stateblock3_on type:#boolean ui:chk_stateblock3_on default:false
			stateblock3_id type:#string ui:edt_stateblock3_id default:"0xFFFFFFFF"
			stateblock4_on type:#boolean ui:chk_stateblock4_on default:false
			stateblock4_id type:#string ui:edt_stateblock4_id default:"0xFFFFFFFF"
			stateblock5_on type:#boolean ui:chk_stateblock5_on default:false
			stateblock5_id type:#string ui:edt_stateblock5_id default:"0xFFFFFFFF"
			stateblock6_on type:#boolean ui:chk_stateblock6_on default:false
			stateblock6_id type:#string ui:edt_stateblock6_id default:"0xFFFFFFFF"
			
			--on height set val do
			)
		rollout params "SDDE Parameters" (
			dropdownlist ddl_profile "Load Profile" items:#("", "Shader1", "Shader2", "Shader3", "Shader4") default:profile
			group "Notes" (
				label lbl1 "    Nothing about the material data makes any sense to me," align:#left
				--label lbl2 "there are thousands of data combinations so" align:#left
				label lbl3 "    I tried my best to simplify it as best I could." align:#left
				--label lbl4 "Unsure why options have unique hashes assigned" align:#left
				--label lbl5 "they may be referencing more textures maps?" align:#left
				)
			
			group "Options" (
				checkbox chk_visible_on "Visible" align:#left checked:visible_on
				label lbl_ishader_type "Shader" align:#left across:2
				dropdownlist ddl_ishader_type "" fieldWidth:200 align:#right items:#("", "0x06D01A50", "0x3C1D8CA0", "0x84141A2A", "0x84889C9C", "0xCEE200FC", "0xE83D2493") default:ishader_type
				label lbl_raster_type "Raster" align:#left across:2
				dropdownlist ddl_raster_type "" fieldWidth:200 align:#right items:#("", "0xFFFFFFFF", "0x418CAF43", "0x940FB8EC") default:raster_type
				)
			
			group "Map Slots" (
				checkbox chk_ambient_on "Ambient" align:#left  across:2 checked:ambient_on
				editText edt_ambient_id "" align:#right fieldWidth:200 text:ambient_id enabled:ambient_on
				
				checkbox chk_diffuse_on "Diffuse" align:#left across:2 checked:diffuse_on
				editText edt_diffuse_id "" align:#right fieldWidth:200 text:diffuse_id enabled:diffuse_on
				
				checkbox chk_diffuse2_on "Diffuse2" align:#left across:2 checked:diffuse2_on
				editText edt_diffuse2_id "" align:#right fieldWidth:200 text:diffuse2_id enabled:diffuse2_on
				
				checkbox chk_blend_on "Blend" align:#left across:2 checked:blend_on
				editText edt_blend_id "" align:#right fieldWidth:200 text:blend_id enabled:blend_on
				
				checkbox chk_world_on "World" align:#left across:2 checked:world_on
				editText edt_world_id "" align:#right fieldWidth:200 text:world_id enabled:world_on
				
				checkbox chk_bump_on "Bump" align:#left across:2 checked:bump_on
				editText edt_bump_id "" align:#right fieldWidth:200 text:bump_id enabled:bump_on
				
				checkbox chk_bump2_on "Bump2" align:#left across:2 checked:bump2_on
				editText edt_bump2_id "" align:#right fieldWidth:200 text:bump2_id enabled:bump2_on
				
				checkbox chk_specular_on "Specular" align:#left across:2 checked:specular_on
				editText edt_specular_id "" align:#right fieldWidth:200 text:specular_id enabled:specular_on
				
				checkbox chk_specular2_on "Specular2" align:#left across:2 checked:specular2_on
				editText edt_specular2_id "" align:#right fieldWidth:200 text:specular2_id enabled:specular2_on
				
				checkbox chk_noise_on "Noise" align:#left across:2 checked:noise_on
				editText edt_noise_id "" align:#right fieldWidth:200 text:noise_id enabled:noise_on
				
				checkbox chk_unknown1_on "Unknown1" align:#left across:2 checked:unknown1_on
				editText edt_unknown1_id "" align:#right fieldWidth:200 text:unknown1_id enabled:unknown1_on
				
				checkbox chk_unknown2_on "Unknown2" align:#left across:2 checked:unknown2_on
				editText edt_unknown2_id "" align:#right fieldWidth:200 text:unknown2_id enabled:unknown2_on
				
				checkbox chk_unknown3_on "Unknown3" align:#left across:2 checked:unknown3_on
				editText edt_unknown3_id "" align:#right fieldWidth:200 text:unknown3_id enabled:unknown3_on
				
				checkbox chk_unknown4_on "Unknown4" align:#left across:2 checked:unknown4_on
				editText edt_unknown4_id "" align:#right fieldWidth:200 text:unknown4_id enabled:unknown4_on
				
				checkbox chk_stateblock1_on "Unknown7" align:#left  across:2 checked:stateblock1_on
				editText edt_stateblock1_id "" align:#right fieldWidth:200 text:stateblock1_id enabled:stateblock1_on
				
				checkbox chk_stateblock2_on "Unknown8" align:#left  across:2 checked:stateblock2_on
				editText edt_stateblock2_id "" align:#right fieldWidth:200 text:stateblock2_id enabled:stateblock2_on
				
				checkbox chk_stateblock3_on "Unknown9" align:#left  across:2 checked:stateblock3_on
				editText edt_stateblock3_id "" align:#right fieldWidth:200 text:stateblock3_id enabled:stateblock3_on
				
				checkbox chk_stateblock4_on "SpecularLook" align:#left  across:2 checked:stateblock4_on
				editText edt_stateblock4_id "" align:#right fieldWidth:200 text:stateblock4_id enabled:stateblock4_on
				
				checkbox chk_stateblock5_on "TextureAnim" align:#left  across:2 checked:stateblock5_on
				editText edt_stateblock5_id "" align:#right fieldWidth:200 text:stateblock5_id enabled:stateblock5_on
				
				checkbox chk_stateblock6_on "DepthBiasSortLayer" align:#left  across:2 checked:stateblock6_on
				editText edt_stateblock6_id "" align:#right fieldWidth:200 text:stateblock6_id enabled:stateblock6_on
				)
			on ddl_profile selected i do (
				chk_ambient_on.checked = edt_ambient_id.enabled = false
				chk_diffuse_on.checked = edt_diffuse_id.enabled = false
				chk_diffuse2_on.checked = edt_diffuse2_id.enabled = false
				chk_blend_on.checked = edt_blend_id.enabled = false
				chk_world_on.checked = edt_world_id.enabled = false
				chk_bump_on.checked = edt_bump_id.enabled = false
				chk_bump2_on.checked = edt_bump2_id.enabled = false
				chk_specular_on.checked = edt_specular_id.enabled = false
				chk_specular2_on.checked = edt_specular2_id.enabled = false
				chk_noise_on.checked = edt_noise_id.enabled = false
				chk_unknown1_on.checked = edt_unknown1_id.enabled = false
				chk_unknown2_on.checked = edt_unknown2_id.enabled = false
				chk_unknown3_on.checked = edt_unknown3_id.enabled = false
				chk_unknown4_on.checked = edt_unknown4_id.enabled = false
				chk_stateblock1_on.checked = edt_stateblock1_id.enabled = false
				chk_stateblock2_on.checked = edt_stateblock2_id.enabled = false
				chk_stateblock3_on.checked = edt_stateblock3_id.enabled = false
				chk_stateblock4_on.checked = edt_stateblock4_id.enabled = false
				chk_stateblock5_on.checked = edt_stateblock5_id.enabled = false
				chk_stateblock6_on.checked = edt_stateblock6_id.enabled = false
				case i of (
					2: (
						chk_diffuse_on.checked = edt_diffuse_id.enabled = true
						chk_specular_on.checked = edt_specular_id.enabled = true
						chk_bump_on.checked = edt_bump_id.enabled = true
						chk_stateblock3_on.checked = edt_stateblock3_id.enabled = true
						)
					3: (
						chk_diffuse_on.checked = edt_diffuse_id.enabled = true
						chk_specular_on.checked = edt_specular_id.enabled = true
						chk_bump_on.checked = edt_bump_id.enabled = true
						chk_unknown2_on.checked = edt_unknown2_id.enabled = true
						chk_unknown3_on.checked = edt_unknown3_id.enabled = true
						chk_stateblock1_on.checked = edt_stateblock1_id.enabled = true
						chk_stateblock2_on.checked = edt_stateblock2_id.enabled = true
						)
					4: (
						chk_diffuse_on.checked = edt_diffuse_id.enabled = true
						chk_specular_on.checked = edt_specular_id.enabled = true
						chk_specular2_on.checked = edt_specular2_id.enabled = true
						chk_bump_on.checked = edt_bump_id.enabled = true
						chk_bump2_on.checked = edt_bump2_id.enabled = true
						chk_unknown2_on.checked = edt_unknown2_id.enabled = true
						chk_unknown3_on.checked = edt_unknown3_id.enabled = true
						chk_unknown4_on.checked = edt_unknown4_id.enabled = true
						chk_stateblock1_on.checked = edt_stateblock1_id.enabled = true
						)
					5: (
						chk_diffuse_on.checked = edt_diffuse_id.enabled = true
						chk_noise_on.checked = edt_noise_id.enabled = true
						chk_stateblock4_on.checked = edt_stateblock4_id.enabled = true
						chk_stateblock5_on.checked = edt_stateblock5_id.enabled = true
						chk_stateblock6_on.checked = edt_stateblock6_id.enabled = true
						)
					)
				)
			on chk_ambient_on changed state do (edt_ambient_id.enabled = state)
			on chk_diffuse_on changed state do (edt_diffuse_id.enabled = state)
			on chk_diffuse2_on changed state do (edt_diffuse2_id.enabled = state)
			on chk_blend_on changed state do (edt_blend_id.enabled = state)
			on chk_world_on changed state do (edt_world_id.enabled = state)
			on chk_bump_on changed state do (edt_bump_id.enabled = state)
			on chk_bump2_on changed state do (edt_bump2_id.enabled = state)
			on chk_specular_on changed state do (edt_specular_id.enabled = state)
			on chk_specular2_on changed state do (edt_specular2_id.enabled = state)
			on chk_noise_on changed state do (edt_noise_id.enabled = state)
			on chk_unknown1_on changed state do (edt_unknown1_id.enabled = state)
			on chk_unknown2_on changed state do (edt_unknown2_id.enabled = state)
			on chk_unknown3_on changed state do (edt_unknown3_id.enabled = state)
			on chk_unknown4_on changed state do (edt_unknown4_id.enabled = state)
			on chk_stateblock1_on changed state do (edt_stateblock1_id.enabled = state)
			on chk_stateblock2_on changed state do (edt_stateblock2_id.enabled = state)
			on chk_stateblock3_on changed state do (edt_stateblock3_id.enabled = state)
			on chk_stateblock4_on changed state do (edt_stateblock4_id.enabled = state)
			on chk_stateblock5_on changed state do (edt_stateblock5_id.enabled = state)
			on chk_stateblock6_on changed state do (edt_stateblock6_id.enabled = state)
			)
		)
	)

try(DestroyDialog sddef_mesh)catch(sddef_mesh)
rollout sddef_mesh "SDDE Tool" (
	group "Skeleton" (
		button btn_skeleton "Load" width:120 height:36 align:#center toolTip:"Load CharacterRig.bin or individual skeleton.bin"
		button btn_make_rig "Build" width:120 height:36 align:#center toolTip:"Build the skeleton from the list below"
		dropdownlist ddl_skeleton "Skeletons:" toolTip:"Select desired skeleton"
		)
	group "Mesh" (
		label lbl_loaded "File Loaded: <  NOTHING  >" align:#center
		button btn_import "Import" width:120 height:36 align:#center toolTip:"import and build a .perm.bin model"
		checkbox chk_colours "Colors" align:#left checked:true across:2 toolTip:"Apply Vertex Colors If Present"
		checkbox chk_normals "Normals" align:#left checked:true toolTip:"Apply Vertex Vertex Normals If Present"
		checkbox chk_weights "Weights" align:#left checked:true across:2 toolTip:"Apply Weights If Present"
		checkbox chk_morphs "Morphs" align:#left checked:true enabled:false toolTip:"Apply Morphs If Present"
		button btn_export "Export" width:120 height:36 align:#center toolTip:"exports a new .perm.bin from scene model"
		checkbox chk_optimize "Optimize Vertices" align:#left checked:true toolTip:"removes duplicated vertices"
		checkbox chk_onlyselected "Only Selected" align:#left checked:false toolTip:"only export objects in selection"
		)
	group "Options" (
		button btn_scale_reset "Reset" width:36 height:16 align:#left across:2 toolTip:"Reset scale back to meters to inches (39.37)"
		spinner spn_scale "Scale" fieldWidth:60 type:#float scale:0.01 range:[-1000000.0, 1000000.0, 39.37007874015748031496062992125984251968503937007] toolTip:"scale value for import and export"
		checkbox chk_clear "Reset Scene" checked:true align:#right toolTip:"deletes everything in the scene on import operations"
		)
	group "Resource Manager" (
		button btn_res_open "Open" width:66 height:26 across:2
		button btn_res_save "Save" width:66 height:26
		label lbl_dmy6 ""
		editText edt_res_hash "Hash:" fieldWidth:100 align:#left
		editText edt_res_type "Type:" fieldWidth:100 align:#left
		editText edt_res_chunk "Class:" fieldWidth:100 align:#left
		editText edt_res_name ""
		multilistbox mlb_resources "" height:12
		button btn_res_del "x" width:16 height:16 align:#left toolTip:"Delete" across:8
		label lbl_dmy3
		label lbl_dmy4
		button btn_res_export "<<" width:16 height:16 align:#center toolTip:"Export"
		button btn_res_add ">>" width:16 height:16 align:#center toolTip:"Import"
		button btn_res_undo "U" width:16 height:16 align:#center toolTip:"Undo"
		button btn_res_up "^" width:16 height:16 align:#center toolTip:"Move Up"
		button btn_res_down "v" width:16 height:16 align:#center toolTip:"Move Down"
		)
	label lbl_dmy1 ""
	label lbl_author "mariokart64n" align:#left across:2
	label lbl_date "June 28, 2024" align:#right
	
	
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
		fn truncate txt max_length:35 tilde_pos:20 = (
			local result = txt
			if txt.count > max_length do (
				
				-- Calculate the length of the suffix
				suffix_length = max_length - tilde_pos - 1
				
				-- Get the prefix and suffix
				prefix = substring txt 1 tilde_pos
				suffix = substring txt (txt.count - suffix_length + 1) suffix_length
				
				-- Combine prefix, tilde, and suffix
				result = prefix + "~" + suffix
				)
			result
			),
		fn StringHash32 str p_PrevHash:-1 = (
			local len = str.count
			for i = 1 to len do (
				local char = (bit.charAsInt (substring str i 1)) as integer
				local index = (bit.and (bit.xor char (bit.shift p_PrevHash -24)) 0xFF) + 1
				p_PrevHash = (bit.xor ((g_CRC32Table[index] as integer)) (bit.and (bit.shift p_PrevHash 8) -1))
				)
			
			if p_PrevHash > 0x7FFFFFFF do (
				p_PrevHash = p_PrevHash - 0x100000000
				)
				
			p_PrevHash
			),
		fn Hash32HexString val = (
			local n = ""
			"0x" + (subString (n = "00000000" + (toUpper(bit.IntAsHex (val as integer)))) (n.count - 7) 8)
			),
		fn convertHexString str = (
			-- Trim any leading or trailing spaces from the string
			str = trimRight (trimLeft str)
			
			-- Initialize the result with a default value
			local result = -1
			
			-- Check if the string starts with '0x'
			local i = findString (filterString str " ")[1] "0x"
			if i != undefined then (
				-- Extract the substring after '0x' and convert it to an integer
				result = bit.HexAsInt(substring str i -1)
				)
			else (
				
				result = StringHash32 str
				
				)
			
			-- Ensure the result is a 32-bit signed integer
			if result > 0x7FFFFFFF then (
				result -= 0x100000000
				)
			
			result
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
		fn setDebugName inputString = (
			local ss = filterString inputString " ."
			if ss.count > 0 and matchPattern ss[1] pattern:"0x*" then (
				
				-- Convert hex value to integer
				local intValue = (ss[1] + "L") as integer
				
				if intValue != undefined then (
					
					-- Convert to signed 32-bit integer using bitwise operations
					if intValue > 0x7FFFFFFF do intValue = intValue - 0x100000000
					
					m_NameUID = intValue
					m_DebugName = trimLeft (subString inputString (ss[1].count + 1) -1)
					if m_DebugName.count == 0 do (m_DebugName = inputString)
					)
				else (
					m_NameUID = base.StringHash32 inputString
					m_DebugName = base.truncate inputString
					)
				)
			else (
				m_NameUID = base.StringHash32 inputString
				m_DebugName = base.truncate inputString
				)
			local fullstr = m_DebugName
			m_DebugName = base.truncate m_DebugName
			fullstr
			),
		fn setType type = (
			case type of (
				#model: (
					base.m_TypeUID = 1845060531
					m_ChunkUID     = -1565667977
					)
				#material: (
					base.m_TypeUID = -168275601
					m_ChunkUID     = -1262329070
					)
				#buffer: (
					base.m_TypeUID = 2056721529
					m_ChunkUID     = -1831998321
					)
				#pallete: (
					base.m_TypeUID = -1742448933
					m_ChunkUID     = 1353193955
					)
				#texture: (
					base.m_TypeUID = -843079536
					m_ChunkUID     = -1958479169
					)
				#skeleton: (
					base.m_TypeUID = 1960646676
					m_ChunkUID     = 2114632761
					)
				)
			),
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
		/*uint64_t*/ m_Prev = 0, -- Always 0
		/*uint64_t*/ m_Next = 0, -- Always 0
		/*uint64_t*/ m_Data = 0, -- Always 0
		/*uint32_t*/ m_NameUID = 0,
		/*uint32_t*/ m_TailPad = 0, -- Always 0
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
	
	struct ResourceType_t (
		ActionTreeResource              = 1271825719,   -- 0x4BCE8537
		AlphaState                      = 466613461,    -- 0x1BCFF4D5
		Animation                       = -1966106268,  -- 0x8ACF9964
		AnimationGroupResource          = 1024375922,   -- 0x3D0EBC72
		AudioFXSettings                 = -1350012757,  -- 0xAF8870AB
		BIGFile                         = 744243368,    -- 0x2C5C40A8
		BIGFileNameLookup               = 373298133,    -- 0x164013D5
		BSP                             = 1325774234,   -- 0x4F05B59A
		BSPDebugData                    = -490354804,   -- 0xE2C5C78C
		BeamSettings                    = -2131817720,  -- 0x80EF0B08
		BlendTreeResource               = -426656873,   -- 0xE691BB97
		BonePalette                     = -1742448933,  -- 0x982456DB
		Buffer                          = 2056721529,   -- 0x7A971479
		BufferD3DResource               = 1172333046,   -- 0x45E061F6
		ChunkFileFatIndex               = -465192948,   -- 0xE445B80C
		ChunkFileIndex                  = 1883305938,   -- 0x7040F7D2
		Cloud                           = 106064742,    -- 0x06526B66
		CloudScene                      = -728003164,   -- 0xD49B8DA4
		CollisionInstance               = -1598895085,  -- 0xA0B2CC13
		CollisionMeshBundle             = -1121818104,  -- 0xBD226A08
		CoronaFlareSettings             = -1654425396,  -- 0x9D6378CC
		CoverData                       = 1575695447,   -- 0x5DEB3457
		DecalSettings                   = -592526077,   -- 0xDCAEC503
		DynamicCoverData                = -451605312,   -- 0xE5150CC0
		DynamicCoverGroupBundle         = 1897371931,   -- 0x7117991B
		DynamicLightGroupSettings       = 588024476,    -- 0x230C8A9C
		DynamicLightSettings            = -1928428749,  -- 0x8D0E8333
		EffectEmitterSettings           = -642707692,   -- 0xD9B10F14
		FXForceSettings                 = 2002079685,   -- 0x77554FC5
		FXSettings                      = 304650971,    -- 0x12289ADB
		FarGroundLayout                 = -200378151,   -- 0xF40E78D9
		FlareSettings                   = -2091430888,  -- 0x83574C18
		Font                            = 706471442,    -- 0x2A1BE612
		GeoSettings                     = 1386780218,   -- 0x52A8963A
		ImposterGroup                   = -1361112959,  -- 0xAEDF1081
		LightGroup                      = 1954603023,   -- 0x7480E00F
		LightningSettings               = -1263607516,  -- 0xB4AEE124
		Locators                        = 357589089,    -- 0x15506061
		Material                        = -168275601,   -- 0xF5F8516F
		MaterialTable                   = -341842154,   -- 0xEB9FE716
		ModelData                       = 1845060531,   -- 0x6DF963B3
		MorphTargets                    = 46992455,     -- 0x02CD0C47
		MovieResourceData               = -381337753,   -- 0xE9453F67
		NISSpatialData                  = -949827583,   -- 0xC762C801
		NavMeshData                     = -583238887,   -- 0xDD3C7B19
		ParkourContainer                = -1109049654,  -- 0xBDE53ECA
		ParkourContainerBundle          = 315860285,    -- 0x12D3A53D
		ParkourInstance                 = -1022033499,  -- 0xC31501A5
		ParticleEmitterSettings         = -799315594,   -- 0xD05B6976
		PropertySet                     = 1536948254,   -- 0x5B9BF81E
		RasterState                     = -1300608200,  -- 0xB27A4B38
		ReflectResource                 = 1634373695,   -- 0x616A903F
		ReflectionGroup                 = -717530196,   -- 0xD53B5BAC
		Rig                             = 337173876,    -- 0x1418DD74
		RigInfoResource                 = 57421454,     -- 0x036C2E8E
		RigInstance                     = 1550239421,   -- 0x5C66C6BD
		RoadNetwork                     = -1810684063,  -- 0x94132761
		SceneLayer                      = -403555602,   -- 0xE7F23AEE
		SceneryGroup                    = 1954603019,   -- 0x7480E00B
		ScreenParticleEmitterSettings   = 1701941974,   -- 0x657192D6
		SectionEffects                  = -1985495561,  -- 0x89A7BDF7
		SectionLayout                   = 1045493717,   -- 0x3E50F7D5
		ShaderBinary                    = -1738808052,  -- 0x985BE50C
		ShaderTemplate                  = 205958895,    -- 0x0C46AEEF
		Sidewalk                        = 746701131,    -- 0x2C81C14B
		StateBlock                      = -1358865772,  -- 0xAF015A94
		SymbolTableResource             = -460943938,   -- 0xE4868DBE
		TerrainData                     = -1000153816,  -- 0xC462DD28
		Texture                         = -843079536,   -- 0xCDBFA090
		TextureD3DResource              = 1343983202,   -- 0x501B8E62
		TrackStripSettings              = -2032244234,  -- 0x86DE69F6
		TrueCrowdDataBase               = -1863389149,  -- 0x90EEF023
		UELFragmentTable                = 847842305,    -- 0x32890C01
		UILocalization                  = -1865520262,  -- 0x90CE6B7A
		UIMinimapTile                   = -1623916730,  -- 0x9F34FF46
		UIScreen                        = 1143618009,   -- 0x442A39D9
		UniqueUIDTableResource          = 742455846,    -- 0x2C40FA26
		VertexDecl                      = -134452435,   -- 0xF7FC6B2D
		VolumetricEffectSettings        = -1460990708,  -- 0xA8EB0D0C
		WeightSetGroupResource          = 289854664,    -- 0x1146D4C8
		XMLFile                         = 617661344,    -- 0x24D0C3A0
		ZoneLayout                      = 1140818857    -- 0x43FF83A9
		)
	
	struct ResourceInventory_t (
		ActionTree                      = -1917311973,  -- 0x8DB8241B
		AlphaState                      = 315097330,    -- 0x12C800F2
		AnimationGroup                  = 1476948521,   -- 0x58087229
		Animation                       = 1408329822,   -- 0x53F1685E
		AudioFXSettings                 = -679686478,   -- 0xD77CCEB2
		BIGFile                         = 719815929,    -- 0x2AE784F9
		BIGFileNameLookup               = 569356080,    -- 0x21EFAF30
		BSPDebugData                    = -1602820327,  -- 0xA076E719
		BSP                             = 1173169125,   -- 0x45ED23E5
		BeamSettings                    = -1599414001,  -- 0xA0AAE10F
		BlendTree                       = 40373832,     -- 0x02680E48
		BonePalette                     = 1353193955,   -- 0x50A819E3
		BufferD3D                       = 387073709,    -- 0x171246AD
		Buffer                          = -1831998321,  -- 0x92CDEC8F
		ChunkFileFatIndex               = -479426468,   -- 0xE36C885C
		ChunkFileIndex                  = -177603045,   -- 0xF569FE1B
		Cloud                           = 1384925155,   -- 0x528C47E3
		CloudScene                      = 1144562479,   -- 0x4438A32F
		CollisionInstance               = 2037447574,   -- 0x7970FB96
		CollisionMeshBundle             = 388229777,    -- 0x1723EA91
		CoronaFlareSettings             = -1217605704,  -- 0xB76CCFB8
		CoverData                       = -1917985922,  -- 0x8DADDB7E
		DecalSettings                   = -1372442298,  -- 0xAE323146
		DynamicCoverData                = -451604765,   -- 0xE5150EE3
		DynamicCoverGroupBundle         = -327540431,   -- 0xEC7A2131
		DynamicLightGroupSettings       = 431332660,    -- 0x19B59D34
		DynamicLightSettings            = -691179244,   -- 0xD6CD7114
		EffectEmitterSettings           = -14735310,    -- 0xFF1F2832
		FXForceSettings                 = 1128192223,   -- 0x433ED8DF
		FXSettings                      = -315352435,   -- 0xED341A8D
		FarGroundLayout                 = 705020601,    -- 0x2A05C2B9
		FlareSettings                   = -1504485445,  -- 0xA6535FBB
		Font                            = 1778174796,   -- 0x69FCCB4C
		GeoSettings                     = -244101746,   -- 0xF1734D8E
		ImposterGroup                   = 1310962868,   -- 0x4E23B4B4
		LightGroup                      = -257920433,   -- 0xF0A0724F
		LightningSettings               = 565058660,    -- 0x21AE1C64
		Locators                        = 1054732272,   -- 0x3EDDEFF0
		Material                        = -1262329070,  -- 0xB4C26312
		MaterialTable                   = -2133724871,  -- 0x80D1F139
		ModelData                       = -1565667977,  -- 0xA2ADCD77
		MorphTargets                    = -970184670,   -- 0xC62C2822
		MovieResourceData               = 965759471,    -- 0x399051EF
		NISSpatialData                  = 1496722083,   -- 0x59362AA3
		NavMeshData                     = 1568574175,   -- 0x5D7E8ADF
		ParkourContainerBundle          = 1163436334,   -- 0x4558A12E
		ParkourContainer                = 367092032,    -- 0x15E16140
		ParkourInstance                 = -1731393032,  -- 0x98CD09F8
		ParticleEmitterSettings         = 1005461980,   -- 0x3BEE21DC
		PropertySet                     = 1415605297,   -- 0x54606C31
		RasterState                     = 1002903008,   -- 0x3BC715E0
		ReflectionGroup                 = -274031424,   -- 0xEFAA9CC0
		Reflect                         = 1526790553,   -- 0x5B00F999
		ResourceFile                    = -1540880596,  -- 0xA428072C
		RigInfo                         = -1359874449,  -- 0xAEF1F66F
		RigInstance                     = -1711258258,  -- 0x9A00456E
		Rig                             = 968624766,    -- 0x39BC0A7E
		RoadNetwork                     = -1527324965,  -- 0xA4F6DEDB
		SceneLayer                      = -520824372,   -- 0xE0F4D9CC
		SceneryGroup                    = -257920444,   -- 0xF0A07244
		ScreenParticleEmitterSettings   = 894188764,    -- 0x354C3CDC
		SectionEffects                  = 1183683364,   -- 0x468D9324
		SectionLayout                   = -332027744,   -- 0xEC35A8A0
		ShaderBinary                    = -401653023,   -- 0xE80F42E1
		Shader                          = -1957338719,  -- 0x8B5561A1
		ShaderTemplate                  = 534046149,    -- 0x1FD4E5C5
		Sidewalk                        = 1139384190,   -- 0x43E99F7E
		StateBlock                      = 1292158962,   -- 0x4D04C7F2
		SymbolTable                     = 2090386312,   -- 0x7C98C388
		TerrainData                     = 959197569,    -- 0x392C3181
		TextureD3D                      = -277363209,   -- 0xEF77C5F7
		Texture                         = -1958479169,  -- 0x8B43FABF
		TrackStripSettings              = 1775129656,   -- 0x69CE5438
		TrueCrowdDataBase               = 1257172958,   -- 0x4AEEEFDE
		UELFragmentTable                = 766602302,    -- 0x2DB16C3E
		UILocalization                  = -1865520262,  -- 0x90CE6B7A
		UIMinimapTile                   = -1178420768,  -- 0xB9C2B9E0
		UIScreen                        = 1143618009,   -- 0x442A39D9
		UniqueUIDTable                  = -285179620,   -- 0xEF00811C
		VertexDecl                      = 1046469182,   -- 0x3E5FDA3E
		VolumetricEffectSettings        = -457640854,   -- 0xE4B8F46A
		WeightSetGroup                  = 1354923359,   -- 0x50C27D5F
		XMLFile                         = 1341487317,   -- 0x4FF578D5
		ZoneLayout                      = -1017234987   -- 0xC35E39D5
		)
	
	struct VertexElement_t (
		POSITION        = 0x00000000,
		NORMAL          = 0x00000001,
		TANGENT         = 0x00000002,
		COLOR0          = 0x00000003,
		COLOR1          = 0x00000004,
		TEXCOORD0       = 0x00000005,
		TEXCOORD1       = 0x00000006,
		TEXCOORD2       = 0x00000007,
		TEXCOORD3       = 0x00000008,
		TEXCOORD4       = 0x00000009,
		TEXCOORD5       = 0x0000000A,
		TEXCOORD6       = 0x0000000B,
		TEXCOORD7       = 0x0000000C,
		BLENDINDEX      = 0x0000000D,
		BLENDWEIGHT     = 0x0000000E,
		BINORMAL        = 0x0000000F,
		NUM_VERTEX_ELEMENTS= 0x00000010,
		FORCE_DWORD     = 0xFFFFFFFF
		)
	
	struct VertexType_t (
		FLOAT3          = 0x00000000, -- 12 bytes
		FLOAT4          = 0x00000001, -- 16 bytes
		HALF2           = 0x00000002, --  4 bytes
		UBYTE4          = 0x00000003, --  4 bytes
		COLOR4          = 0x00000004, --  4 bytes
		UBYTE4N         = 0x00000005, --  4 bytes
		N11_11_10       = 0x00000006, --  4 bytes
		HALF4           = 0x00000007, --  8 bytes
		HALF3           = 0x00000008, --  6 bytes
		SINT16_2        = 0x00000009, --  4 bytes
		SHORT4          = 0x0000000A, --  8 bytes
		SHORT4N         = 0x0000000B, --  8 bytes
		SHORT4_FIXED4_12= 0x0000000C, --  8 bytes
		SHORT4_FIXED8_8 = 0x0000000D, --  8 bytes
		UINT1           = 0x0000000E, --  4 bytes
		UBYTE4_DELTA    = 0x0000000F, --  4 bytes
		BYTE4N          = 0x00000010, --  4 bytes
		NUM_VERTEX_TYPES= 0x00000011,
		FORCE_DWORD     = 0xFFFFFFFF
		)
	
	struct VertexDecl_t (
		CloudWisp           = -405799839,   -- 	0xE7CFFC61,
		Decal               = 310511282,    -- 	0x128206B2,
		Dynamic             = 1688485294,   -- 	0x64A43DAE,
		FBX                 = -294576617,   -- 	0xEE711E17,
		FBX2                = 1435092877,   -- 	0x5589C78D,
		GeoParticle         = 626549113,    -- 	0x25586179,
		LightCard           = 1872864310,   -- 	0x6FA1A436,
		Lightning           = 8460150,      -- 	0x00811776,
		MorphTarget         = 1881798074,   -- 	0x7029F5BA,
		MultiMorphTarget    = 107257493,    -- 	0x06649E95,
		NC                  = 883623142,    -- 	0x34AB04E6,
		Particle            = -677002041,   -- 	0xD7A5C4C7,
		Rain                = 1214554056,   -- 	0x48649FC8,
		ScreenParticle      = 1026789957,   -- 	0x3D339245,
		Skinned             = 661362023,    -- 	0x276B9567,
		SkinnedDecal        = 603153703,    -- 	0x23F36527,
		SkinnedUVNT         = -1403155998,  -- 	0xAC5D89E2,
		Slim                = -1858774779,  -- 	0x91355905,
		SlimUV              = 2114811187,   -- 	0x7E0D7533,
		UV2                 = 667453717,    -- 	0x27C88915,
		UV2C                = 1999152459,   -- 	0x7728A54B,
		UV2N                = 1189421976,   -- 	0x46E52398,
		UV2NC               = -219745429,   -- 	0xF2E6F36B,
		UV2NT               = -1599047650,  -- 	0xA0B0781E,
		UV2NTC              = 2022842016,   -- 	0x78921EA0,
		UVC                 = -1010988731,  -- 	0xC3BD8945,
		UVCNPacked          = -254167006,   -- 	0xF0D9B822,
		UVN                 = -227537002,   -- 	0xF2700F96,
		UVNPacked           = 1913096439,   -- 	0x720788F7,
		UVNT                = -1683583556,  -- 	0x9BA68DBC,
		UVNTC               = -1860298159,  -- 	0x911E1A51,
		VehicleGlassUV2NTC  = -795872486,   -- 	0xD08FF31A,
		VehicleUV2NTC       = -1081078114,  -- 	0xBF900E9E,
		VehicleUVNTC        = -499847302,   -- 	0xE234EF7A,
		WaterSurface        = -747008515    -- 	0xD3798DFD
		)
	
	struct FVF_t (            -- Flexible Vertex Format
		m_Position      = 0,  -- Offset in bytes where this element starts in the vertex buffer
		m_Size          = 0,  -- Size of this element in bytes
		m_Datatype      = 0,  -- Data type of the element (e.g., FLOAT3, FLOAT4, UBYTE4)
		m_Component     = 0,  -- Component type (e.g., POSITION, NORMAL, TEXCOORD0)
		m_Index         = 0   -- Buffer index or stream number this element belongs to
		)
	
	struct Vertex_t (
		/*float[4]*/ m_Position      = [0.0, 0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord0     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord1     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord2     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord3     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord4     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord5     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord6     = [0.0, 0.0],
		/*qHalfFloat[2]*/ m_TexCoord7     = [0.0, 0.0],
		/*uint8_t[4]*/ m_Normal        = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_BiNormal      = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_Tangent       = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_Color         = #(0, 0, 0, 0), -- Color0
		/*uint8_t[4]*/ m_Illum         = #(0, 0, 0, 0), -- Color1
		/*uint8_t[4]*/ m_BoneID = #(0, 0, 0, 0),
		/*uint8_t[4]*/ m_Weight = #(1.0, 0.0, 0.0, 0.0)
		)
	
	struct Buffer_t (
		/*
			Here are the known vertex formats for the vertex buffers
			assigned under 'm_VertexBufferHandles' in Mesh_t
			
			0x276B9567 	661362023
				m_VertexBufferHandles[1] = Skinned.0.0      @ 24 Bytes
				m_VertexBufferHandles[2] = Skinned.1.0      @  8 Bytes
				m_VertexBufferHandles[3] = Skinned.2.0      @  4 Bytes
				 * there is an unknown index on these that is either 0 or 1, probably cause you can daisy chain vertex buffers
				OR
				m_VertexBufferHandles[1] = MorphTarget.0.0  @  8 Bytes
				
			0x960F70F2 	-227537002
				m_VertexBufferHandles[1] = SkinnedUVNT.0.0  @ 24 Bytes
				m_VertexBufferHandles[2] = SkinnedUVNT.1.0  @  8 Bytes
				m_VertexBufferHandles[2] = SkinnedUVNT.2.0  @  4 Bytes
			
			0xE2895DAC 	-1403155998
				m_VertexBufferHandles[1] = UVN.0.0          @ 12 Bytes
				m_VertexBufferHandles[2] = UVN.1.0          @  8 Bytes
				

		*/
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint16_t*/ m_Type = 0, -- 0=Vertices, 1=Faces
		/*uint16_t*/ m_Index = 0, -- 0 or 1
		/*
			not sure what this is, does not look like an index.
			shows up as 1 on models that only have a single set of buffers
			so there would be no reason for it to be an index..
			
			File:	C:\Users\Corey\Downloads\export\sdde_perms\Characters\AM_B_003.perm.bin
				1: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|1|SKIN.tiffany_hd.ufg
				2: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|2|HAIR.tiffany_hd.ufg
				3: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|6|LASHES~tiffany_hd.ufg
				4: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|3|SKIRT.tiffany_hd.ufg
				5: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|0|BODY.tiffany_hd.ufg
				6: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|5|BLING.tiffany_hd.ufg
				7: MATERIAL     	0x62329070	0x68275601 	TIFFANY_MAT|4|EYES.tiffany_hd.ufg
				8: BONE PALETTE 	0x53193955	0x42448933 	TIFFANY_HD_SKIN_BODY.BonePalette
				9: INDEXBUFFER  	0x31998321	0x56721529 	TIFFANY_HD_SKIN_BODY.IndexBuffer
				10: SKINNED      	0x31998321	0x56721529 	TIFFANY_HD_SKIN_BODY~cl.Skinned.0.0   (mIndex = 1)
				11: SKINNED      	0x31998321	0x56721529 	TIFFANY_HD_SKIN_BODY~cl.Skinned.1.0   (mIndex = 1)
				12: SKINNED      	0x31998321	0x56721529 	TIFFANY_HD_SKIN_BODY~cl.Skinned.2.0   (mIndex = 1)
				13: MODEL DATA   	0x65667977	0x45060531 	TIFFANY_HD_SKIN_BODY
				
				
			File:	C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Tiffany_HD.perm.bin
				1: MATERIAL     	0x62329070	0x68275601 	ALEX_MATHD|1|A_EYE_M~HD.alex_hd.ufg
				2: MATERIAL     	0x62329070	0x68275601 	ALEX_MATHD|0|A_BODY_~HD.alex_hd.ufg
				3: MATERIAL     	0x62329070	0x68275601 	ALEX_MATHD|6|ALEXSKI~HD.alex_hd.ufg
				4: MATERIAL     	0x62329070	0x68275601 	ALEX_MATHD|5|A_HAIR_~HD.alex_hd.ufg
				5: MATERIAL     	0x62329070	0x68275601 	ALEX_MATHD|4|A_JACKE~HD.alex_hd.ufg
				6: MATERIAL     	0x62329070	0x68275601 	ALEX_MATHD|3|A_PANTS~HD.alex_hd.ufg
				7: BONE PALETTE 	0x53193955	0x42448933 	ALEX_SKIN_BODY_HD.BonePalette
				8: INDEXBUFFER  	0x31998321	0x56721529 	ALEX_SKIN_BODY_HD.IndexBuffer
				9: SKINNED      	0x31998321	0x56721529 	ALEX_SKIN_BODY_HD.Ve~cl.Skinned.0.0   (mIndex = 0)
				10: SKINNED      	0x31998321	0x56721529 	ALEX_SKIN_BODY_HD.Ve~cl.Skinned.1.0   (mIndex = 0)
				11: SKINNED      	0x31998321	0x56721529 	ALEX_SKIN_BODY_HD.Ve~cl.Skinned.2.0   (mIndex = 0)
				12: MODEL DATA   	0x65667977	0x45060531 	ALEX_SKIN_BODY_HD
				
			
			File:	C:\Users\Corey\Downloads\export\sdde_perms\Characters\AM_B_003.perm.bin
				1: MATERIAL     	0x62329070	0x68275601 	B_003_MAT|0|BODY_MAT.am_b_003.ufg
				2: MATERIAL     	0x62329070	0x68275601 	B_003_MAT|1|ARMS_MAT.am_b_003.ufg
				3: BONE PALETTE 	0x53193955	0x42448933 	AS_033_SKIN_BODY_B_MT00.BonePalette
				4: INDEXBUFFER  	0x31998321	0x56721529 	AS_033_SKIN_BODY_B_MT00.IndexBuffer
				5: SKINNED      	0x31998321	0x56721529 	AS_033_SKIN_BODY_B_M~cl.Skinned.0.0   (mIndex = 1)
				6: SKINNED      	0x31998321	0x56721529 	AS_033_SKIN_BODY_B_M~cl.Skinned.1.0   (mIndex = 1)
				7: SKINNED      	0x31998321	0x56721529 	AS_033_SKIN_BODY_B_M~cl.Skinned.2.0   (mIndex = 1)
				8: MODEL DATA   	0x65667977	0x45060531 	AS_033_SKIN_BODY_B_MT00
				9: BONE PALETTE 	0x53193955	0x42448933 	AS_033_SKIN_BODY_A_MT00.BonePalette
				10: INDEXBUFFER  	0x31998321	0x56721529 	AS_033_SKIN_BODY_A_MT00.IndexBuffer
				11: SKINNED      	0x31998321	0x56721529 	AS_033_SKIN_BODY_A_M~cl.Skinned.0.0   (mIndex = 0)
				12: SKINNED      	0x31998321	0x56721529 	AS_033_SKIN_BODY_A_M~cl.Skinned.1.0   (mIndex = 0)
				13: SKINNED      	0x31998321	0x56721529 	AS_033_SKIN_BODY_A_M~cl.Skinned.2.0   (mIndex = 0)
				14: MODEL DATA   	0x65667977	0x45060531 	AS_033_SKIN_BODY_A_MT00
				
			File:	C:\Users\Corey\Downloads\export\sdde_perms\Characters\AF_H_009.perm.bin
				1: MATERIAL     	0x62329070	0x68275601 	AF_SKIN.af_h_009.ufg
				2: MATERIAL     	0x62329070	0x68275601 	AF_EYE.af_h_009.ufg
				3: BONE PALETTE 	0x53193955	0x42448933 	AF_H_009_SKIN_HEAD_A~00.BonePalette
				4: INDEXBUFFER  	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_A~00.IndexBuffer
				5: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_A~cl.Skinned.0.0  (mIndex = 0)
				6: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_A~cl.Skinned.1.0  (mIndex = 0)
				7: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_A~cl.Skinned.2.0  (mIndex = 0)
				8: MODEL DATA   	0x65667977	0x45060531 	AF_H_009_SKIN_HEAD_A_MT00
				9: BONE PALETTE 	0x53193955	0x42448933 	AF_H_009_SKIN_HEAD_C~00.BonePalette
				10: INDEXBUFFER  	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_C~00.IndexBuffer
				11: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_C~cl.Skinned.0.0  (mIndex = 0)
				12: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_C~cl.Skinned.1.0  (mIndex = 0)
				13: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_C~cl.Skinned.2.0  (mIndex = 0)
				14: MODEL DATA   	0x65667977	0x45060531 	AF_H_009_SKIN_HEAD_C_MT00
				15: BONE PALETTE 	0x53193955	0x42448933 	AF_H_009_SKIN_HEAD_B~00.BonePalette
				16: INDEXBUFFER  	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_B~00.IndexBuffer
				17: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_B~cl.Skinned.0.0  (mIndex = 0)
				18: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_B~cl.Skinned.1.0  (mIndex = 0)
				19: SKINNED      	0x31998321	0x56721529 	AF_H_009_SKIN_HEAD_B~cl.Skinned.2.0  (mIndex = 0)
				20: MODEL DATA   	0x65667977	0x45060531 	AF_H_009_SKIN_HEAD_B_MT00
				
			I think I need to investigate the data around the vertex buffers that have the 1 set.
			such as the ModelData, IndexBuffer, and Bone Pallete
		*/
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
		
		-- below not part of the file structure, but is used to properly read structure
		vertDeclType = 0,
		vertDeclIndex = 0,
		fn extractComponents fileName = (
			local result = #("", 0, 0)
			
			-- Split the filename by dots
			components = filterString fileName "."
			
			-- Check if the length of components is greater than 3
			if components.count >= 3 then (
				-- Extract the third, second, and first components from the right
				thirdFromRight = components[components.count - 2]
				secondFromRight = components[components.count - 1]
				firstFromRight = components[components.count]
				
				-- Return the formatted array
				result = #(thirdFromRight, secondFromRight, firstFromRight)
				)
			result[1] + "." + (result[2] as string) + "." + (result[3] as string)
			),
		fn guessBufferKind = (
			
			/*
				The buffer itself doesn't type itself, rather the ModelData contains
				a vertex declaration. I would need to parse over all the ModelData files
				prior in order to type and purpose each buffer.
				
				as a sort of hack here we can try to type the buffer without the
				reading the ModelData and rather doing an analysis of the debug name.
				
				Known Types & Strides
					
					Skinned.0.0         = 24 bytes
					Skinned.1.0         = 8 bytes
					Skinned.2.0         = 4 bytes
					IndexBuffer         = 2 or 4 bytes
					phTarget            = 8 bytes
					UVN.0.0             = 12 bytes
					UVN.1.0             = 8 bytes
					SkinnedUVNT.0.0     = 24 bytes
					SkinnedUVNT.1.0     = 8 bytes
					SkinnedUVNT.2.0     = 4 bytes
			*/
			
			if matchPattern m_Resource.m_DebugName pattern:"*Skinned.*" ignoreCase:false then (
				--local kind = (extractComponents m_Resource.m_DebugName) + " @ " + (m_ElementSize as string)
				local ss = filterString m_Resource.m_DebugName "."
				if ss.count > 1 do (vertDeclIndex = try(ss[ss.count - 1] as integer)catch(0))
				--format "kind: %\n" kind
				vertDeclType = 661362023 -- Skinned
				)
			else if matchPattern m_Resource.m_DebugName pattern:"*dexBuffer" ignoreCase:false then (
				--local kind = "IndexBuffer @ " + (m_ElementSize as string) -- 2 or 4
				--format "kind: %\n" kind
				vertDeclType = 0 -- IndexBuffer
				)
			else if matchPattern m_Resource.m_DebugName pattern:"*rget.*" ignoreCase:false then (
				--local kind = "phTarget @ " + (m_ElementSize as string) -- 8
				--format "kind: %\n" kind
				vertDeclType = 1881798074 -- phTarget
				)
			else if matchPattern m_Resource.m_DebugName pattern:"*.UVN.*" ignoreCase:false then (
				--local kind = (extractComponents m_Resource.m_DebugName) + " @ " + (m_ElementSize as string)
				--format "kind: %\n" kind
				vertDeclType = -227537002 -- UVN
				)
			else if matchPattern m_Resource.m_DebugName pattern:"*dUVNT.*" ignoreCase:false then (
				local ss = filterString m_Resource.m_DebugName "."
				--local kind = ""
				if ss.count > 1 do (
					--kind = "SkinnedUVNT." + ss[ss.count - 1] + "." + ss[ss.count] + " @ " + (m_ElementSize as string
					vertDeclIndex = try(ss[ss.count - 1] as integer)catch(0)
					)
				--format "kind: %\n" kind
				vertDeclType = -1403155998 -- SkinnedUVNT
				)
			),
		fn buffer_kind = (
			local v = VertexDecl_t()
			if m_Type == 0 then (
				case vertDeclType of (
					(v.CloudWisp): "CloudWisp"
					(v.Decal): "Decal"
					(v.Dynamic): "Dynamic"
					(v.FBX): "FBX"
					(v.FBX2): "FBX2"
					(v.GeoParticle): "GeoParticle"
					(v.LightCard): "LightCard"
					(v.Lightning): "Lightning"
					(v.MorphTarget): "MorphTarget"
					(v.MultiMorphTarget): "MultiMorphTarget"
					(v.NC): "NC"
					(v.Particle): "Particle"
					(v.Rain): "Rain"
					(v.ScreenParticle): "ScreenParticle"
					(v.Skinned): "Skinned"
					(v.SkinnedDecal): "SkinnedDecal"
					(v.SkinnedUVNT): "SkinnedUVNT"
					(v.Slim): "Slim"
					(v.SlimUV): "SlimUV"
					(v.UV2): "UV2"
					(v.UV2C): "UV2C"
					(v.UV2N): "UV2N"
					(v.UV2NC): "UV2NC"
					(v.UV2NT): "UV2NT"
					(v.UV2NTC): "UV2NTC"
					(v.UVC): "UVC"
					(v.UVCNPacked): "UVCNPacked"
					(v.UVN): "UVN"
					(v.UVNPacked): "UVNPacked"
					(v.UVNT): "UVNT"
					(v.UVNTC): "UVNTC"
					(v.VehicleGlassUV2NTC): "VehicleGlassUV2NTC"
					(v.VehicleUV2NTC): "VehicleUV2NTC"
					(v.VehicleUVNTC): "VehicleUVNTC"
					(v.WaterSurface): "WaterSurface"
					default: "Undeclared"
					)
				)
			else ("IndexBuffer")
			),
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
		fn decodePackedNormal packedNormal xBits yBits zBits = (
			local totalBits = 32
			local wBits = totalBits - xBits - yBits - zBits

			local xShift = totalBits - xBits
			local yShift = totalBits - xBits - yBits
			local zShift = totalBits - xBits - yBits - zBits

			local xMask = (bit.shift 1 xBits) - 1
			local yMask = (bit.shift 1 yBits) - 1
			local zMask = (bit.shift 1 zBits) - 1

			local x = bit.and (bit.shift packedNormal -xShift) xMask
			local y = bit.and (bit.shift packedNormal -yShift) yMask
			local z = bit.and (bit.shift packedNormal -zShift) zMask

			-- Convert from unsigned to signed
			x = if x >= (bit.shift 1 (xBits - 1)) then x - (bit.shift 1 xBits) else x
			y = if y >= (bit.shift 1 (yBits - 1)) then y - (bit.shift 1 yBits) else y
			z = if z >= (bit.shift 1 (zBits - 1)) then z - (bit.shift 1 zBits) else z

			-- Normalize the components
			x = x / ((bit.shift 1 (xBits - 1)) - 1.0)
			y = y / ((bit.shift 1 (yBits - 1)) - 1.0)
			z = z / ((bit.shift 1 (zBits - 1)) - 1.0)

			return #(x, y, z, 0.0)
			),
		fn getFlexibleVertexFormat &vertexDecl = (
			local d=VertexDecl_t()
			local v=VertexElement_t()
			local t=VertexType_t()
			local fvf=#()
			case vertexDecl of (
				(d.CloudWisp): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:16 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:32 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD2 m_Index:1,
						FVF_t m_Position:48 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD3 m_Index:1
						)
					)
				(d.Decal): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:20 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.TANGENT m_Index:0
						)
					)
				(d.Dynamic): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:0,
						FVF_t m_Position:20 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:32 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TANGENT m_Index:0,
						FVF_t m_Position:44 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:0
						)
					)
				(d.FBX): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:8 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:20 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TANGENT m_Index:1,
						FVF_t m_Position:32 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1,
						FVF_t m_Position:36 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:1,
						FVF_t m_Position:40 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1
						)
					)
				(d.FBX2): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:2,
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.NORMAL m_Index:3,
						FVF_t m_Position:12 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TANGENT m_Index:3,
						FVF_t m_Position:24 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:3,
						FVF_t m_Position:28 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:3
						)
					)
				(d.GeoParticle): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:24 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TANGENT m_Index:0,
						FVF_t m_Position:36 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0,
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:16 m_Size:8 m_Datatype:t.HALF4 m_Component:v.TEXCOORD2 m_Index:1,
						FVF_t m_Position:24 m_Size:8 m_Datatype:t.HALF4 m_Component:v.TEXCOORD3 m_Index:1,
						FVF_t m_Position:32 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD4 m_Index:1,
						FVF_t m_Position:48 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TEXCOORD5 m_Index:1,
						FVF_t m_Position:60 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TEXCOORD6 m_Index:1,
						FVF_t m_Position:72 m_Size:8 m_Datatype:t.HALF4 m_Component:v.TEXCOORD7 m_Index:1,
						FVF_t m_Position:80 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1
						)
					)
				(d.LightCard): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD1 m_Index:0,
						FVF_t m_Position:28 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0,
						FVF_t m_Position:32 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:0
						)
					)
				(d.Lightning): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:24 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0,
						FVF_t m_Position:28 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:0
						)
					)
				(d.MorphTarget): (
					fvf=#(
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.UBYTE4_DELTA m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0
						)
					)
				(d.MultiMorphTarget): (
					fvf=#(
						FVF_t m_Position:0 m_Size:8 m_Datatype:t.SHORT4_FIXED4_12 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0
						)
					)
				(d.NC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.Particle): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:16 m_Size:8 m_Datatype:t.HALF4 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:24 m_Size:8 m_Datatype:t.HALF4 m_Component:v.TEXCOORD2 m_Index:1,
						FVF_t m_Position:32 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD3 m_Index:1,
						FVF_t m_Position:48 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TEXCOORD4 m_Index:1,
						FVF_t m_Position:60 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.TEXCOORD5 m_Index:1,
						FVF_t m_Position:72 m_Size:8 m_Datatype:t.HALF4 m_Component:v.TEXCOORD6 m_Index:1,
						FVF_t m_Position:80 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1
						)
					)
				(d.Rain): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0
						)
					)
				(d.ScreenParticle): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0,
						FVF_t m_Position:16 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.TEXCOORD1 m_Index:0
						)
					)
				(d.Skinned): (
					if vertDeclIndex == 0 and m_ElementSize == 8 then (
						vertDeclType = d.MorphTarget
						getFlexibleVertexFormat vertDeclType
						)
					else (
						fvf=#(
							FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
							FVF_t m_Position:16 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0,
							FVF_t m_Position:20 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:0,
							FVF_t m_Position:0 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:1,
							FVF_t m_Position:4 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1,
							FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:2
							)
						)
					)
				(d.SkinnedDecal): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:20 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:0,
						FVF_t m_Position:24 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:0
						)
					)
				(d.SkinnedUVNT): (
					if vertDeclIndex == 0 and m_ElementSize == 8 then (
						vertDeclType = d.MorphTarget
						getFlexibleVertexFormat vertDeclType
						)
					else (
						fvf=#(
							FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
							FVF_t m_Position:16 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0,
							FVF_t m_Position:20 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:0,
							FVF_t m_Position:0 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:1,
							FVF_t m_Position:4 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1,
							FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:2
							)
						)
					)
				(d.Slim): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0
						)
					)
				(d.SlimUV): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1
						)
					)
				(d.UV2): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1
						)
					)
				(d.UV2C): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.UV2N): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1
						)
					)
				(d.UV2NC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.UV2NT): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:1
						)
					)
				(d.UV2NTC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:1,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.UVC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.UVCNPacked): (
					fvf=#(
						FVF_t m_Position:0 m_Size:8 m_Datatype:t.HALF4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.UVNPacked): (
					fvf=#(
						FVF_t m_Position:0 m_Size:8 m_Datatype:t.HALF4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1
						)
					)
				(d.UVN): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1
						)
					)
				(d.UVNT): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:1
						)
					)
				(d.UVNTC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:12 m_Datatype:t.FLOAT3 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:1,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:1,
						FVF_t m_Position:12 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:1
						)
					)
				(d.VehicleGlassUV2NTC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:20 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:2,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:2,
						FVF_t m_Position:8 m_Size:4 m_Datatype:t.COLOR4 m_Component:v.COLOR0 m_Index:2
						)
					)
				(d.VehicleUV2NTC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:20 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:2,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD1 m_Index:2
						)
					)
				(d.VehicleUVNTC): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:16 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:20 m_Size:4 m_Datatype:t.BYTE4N m_Component:v.TANGENT m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.UBYTE4 m_Component:v.BLENDINDEX m_Index:1,
						FVF_t m_Position:4 m_Size:4 m_Datatype:t.UBYTE4N m_Component:v.BLENDWEIGHT m_Index:1,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:2
						)
					)
				(d.WaterSurface): (
					fvf=#(
						FVF_t m_Position:0 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.POSITION m_Index:0,
						FVF_t m_Position:16 m_Size:16 m_Datatype:t.FLOAT4 m_Component:v.NORMAL m_Index:0,
						FVF_t m_Position:0 m_Size:4 m_Datatype:t.HALF2 m_Component:v.TEXCOORD0 m_Index:1
						)
					)
				)
			),
		fn read f = (
			local pos = ftell f
			
			m_Resource.read(f)
			if m_Resource.base.m_TypeUID == 0x7A971479 or m_Resource.base.m_TypeUID == 2056721529 do (
				
				m_Type = readShort f #unsigned
				m_Index = readShort f #unsigned
				m_Size = readLong f #unsigned
				--if m_Index != 0 do format "%: \t%\n" pos m_Index
				local addr_DataOffset = ftell f
				m_DataOffset = readLongLong f
				m_ElementSize = readLong f #unsigned
				m_NumElements = readLong f #unsigned
				
				local i = 1
				for i = 1 to 192 do (m_BufferPadding[i] = readByte f #unsigned)
				
				
				-- We need to know the descriptor before we can read the buffer,
				-- If not already set we can attempt to guess
				if m_Type == 0 and vertDeclType == 0 do (
					guessBufferKind()
					)
				
				m_Buffer = #()
				if m_NumElements > 0 and m_DataOffset > 0 and addr_DataOffset + m_DataOffset <= pos + m_Resource.size() do (
					if m_Type == 0 then ( -- Vertices
						if vertDeclType != 0 then (
							
							local fvf = getFlexibleVertexFormat(vertDeclType)
							
							m_Buffer[m_NumElements] = Vertex_t()
							
							local p = ftell f
							local j = 0
							local val = #(0.0, 0.0, 0.0, 0.0)
							local t = VertexType_t()
							local c = VertexElement_t()
							
							for j = 1 to m_NumElements do (
								m_Buffer[j] = Vertex_t()
								
								for v in fvf do (
									
									if v.m_Index != vertDeclIndex do continue
									
									fseek f (p + ((j - 1) * m_ElementSize) + v.m_Position) #seek_set
									
									val = #(0.0, 0.0, 0.0, 0.0)
									case v.m_Datatype of (
										(t.FLOAT3):             val = #(readFloat f, readFloat f, readFloat f, 0.0)
										(t.FLOAT4):             val = #(readFloat f, readFloat f, readFloat f, readFloat f)
										(t.HALF2):              val = #(readHalf f, readHalf f, 0.0, 0.0)
										(t.UBYTE4):             val = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
										(t.COLOR4):             val = #(readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned)
										(t.UBYTE4N):            val = #((readByte f #unsigned) / 255.0, (readByte f #unsigned) / 255.0, (readByte f #unsigned) / 255.0, (readByte f #unsigned) / 255.0)
										(t.N11_11_10):          val = decodePackedNormal (readLong f #unsigned) 11 11 10
										(t.HALF4):              val = #(readHalf f, readHalf f, readHalf f, readHalf f)
										(t.HALF3):              val = #(readHalf f, readHalf f, readHalf f, 0.0)
										(t.SINT16_2):           val = #(readShort f #signed, readShort f #signed, 0.0, 0.0)
										(t.SHORT4):             val = #(readShort f #signed, readShort f #signed, readShort f #signed, readShort f #signed)
										(t.SHORT4N):            val = #((readShort f #signed) / 32767.0, (readShort f #signed) / 32767.0, (readShort f #signed) / 32767.0, (readShort f #signed) / 32767.0)
										(t.SHORT4_FIXED4_12):   val = #((readShort f #signed) / 4096.0, (readShort f #signed) / 4096.0, (readShort f #signed) / 4096.0, (readShort f #signed) / 4096.0)
										(t.SHORT4_FIXED8_8):    val = #((readShort f #signed) / 256.0, (readShort f #signed) / 256.0, (readShort f #signed) / 256.0, (readShort f #signed) / 256.0)
										(t.UINT1):              val = #(readLong f #unsigned, 0.0, 0.0, 0.0)
										(t.UBYTE4_DELTA):       val = #(((readByte f #unsigned) - 127) / 512.0, ((readByte f #unsigned) - 127) / 512.0, ((readByte f #unsigned) - 127) / 512.0, ((readByte f #unsigned) - 127) / 512.0)
										(t.BYTE4N):             val = #(((readByte f #unsigned) / 255.0) * 2.0 - 1.0, ((readByte f #unsigned) / 255.0) * 2.0 - 1.0, ((readByte f #unsigned) / 255.0) * 2.0 - 1.0, ((readByte f #unsigned) / 255.0) * 2.0 - 1.0)
										)
									
									case v.m_Component of (
										(c.POSITION):   (m_Buffer[j].m_Position     = [val[1], val[2], val[3]]                          )
										(c.NORMAL):     (m_Buffer[j].m_Normal       = val                                               )
										(c.BINORMAL):   (m_Buffer[j].m_BiNormal     = val                                               )
										(c.TANGENT):    (m_Buffer[j].m_Tangent      = val                                               )
										(c.COLOR0):     (m_Buffer[j].m_Color        = color val[1] val[2] val[3] val[4]                 )
										(c.COLOR1):     (m_Buffer[j].m_Illum        = color val[1] val[2] val[3] val[4]                 )
										(c.TEXCOORD0):  (m_Buffer[j].m_TexCoord0    = [val[1], val[2]]                                  )
										(c.TEXCOORD1):  (m_Buffer[j].m_TexCoord1    = [val[1], val[2]]                                  )
										(c.TEXCOORD2):  (m_Buffer[j].m_TexCoord2    = [val[1], val[2]]                                  )
										(c.TEXCOORD3):  (m_Buffer[j].m_TexCoord3    = [val[1], val[2]]                                  )
										(c.TEXCOORD4):  (m_Buffer[j].m_TexCoord4    = [val[1], val[2]]                                  )
										(c.TEXCOORD5):  (m_Buffer[j].m_TexCoord5    = [val[1], val[2]]                                  )
										(c.TEXCOORD6):  (m_Buffer[j].m_TexCoord6    = [val[1], val[2]]                                  )
										(c.TEXCOORD7):  (m_Buffer[j].m_TexCoord7    = [val[1], val[2]]                                  )
										(c.BLENDINDEX): (m_Buffer[j].m_BoneID       = val                                               )
										(c.BLENDWEIGHT):(m_Buffer[j].m_Weight       = val                                               )
										)
									)
								)
							)
						else (format "vertDeclType Not Set m_Type % {%}\n" m_Type (f as string))
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
						format "Unsupported m_Type % {%}\n" m_Type (f as string)
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
			writeShort s m_Type #unsigned
			writeShort s m_Index #unsigned
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
					
					local fvf = getFlexibleVertexFormat(vertDeclType)
					local j = 0
					local val = #(0.0, 0.0, 0.0, 0.0)
					local t = VertexType_t()
					local c = VertexElement_t()
					
					for j = 1 to m_NumElements do (
						
						
						for v in fvf do (
							
							if v.m_Index != vertDeclIndex do continue
							
							
							val = #(0.0, 0.0, 0.0, 0.0)
							case v.m_Component of (
								(c.POSITION):   (val = #(m_Buffer[j].m_Position[1], m_Buffer[j].m_Position[2], m_Buffer[j].m_Position[3], 1.0))
								(c.NORMAL):     (val = m_Buffer[j].m_Normal)
								(c.BINORMAL):   (val = m_Buffer[j].m_BiNormal)
								(c.TANGENT):    (val = m_Buffer[j].m_Tangent                                    )
								(c.COLOR0):     (     val = #(m_Buffer[j].m_Color.red, m_Buffer[j].m_Color.blue, m_Buffer[j].m_Color.green, m_Buffer[j].m_Color.alpha)        )
								(c.COLOR1):     (val = #(m_Buffer[j].m_Illum.red, m_Buffer[j].m_Illum.blue, m_Buffer[j].m_Illum.green, m_Buffer[j].m_Illum.alpha)      )
								(c.TEXCOORD0):  (val = #(m_Buffer[j].m_TexCoord0[1], m_Buffer[j].m_TexCoord0[2], 0.0, 0.0))
								(c.TEXCOORD1):  (val = #(m_Buffer[j].m_TexCoord1[1], m_Buffer[j].m_TexCoord1[2], 0.0, 0.0))
								(c.TEXCOORD2):  (val = #(m_Buffer[j].m_TexCoord2[1], m_Buffer[j].m_TexCoord2[2], 0.0, 0.0))
								(c.TEXCOORD3):  (val = #(m_Buffer[j].m_TexCoord3[1], m_Buffer[j].m_TexCoord3[2], 0.0, 0.0))
								(c.TEXCOORD4):  (val = #(m_Buffer[j].m_TexCoord4[1], m_Buffer[j].m_TexCoord4[2], 0.0, 0.0))
								(c.TEXCOORD5):  (val = #(m_Buffer[j].m_TexCoord5[1], m_Buffer[j].m_TexCoord5[2], 0.0, 0.0))
								(c.TEXCOORD6):  (val = #(m_Buffer[j].m_TexCoord6[1], m_Buffer[j].m_TexCoord6[2], 0.0, 0.0))
								(c.TEXCOORD7):  (val = #(m_Buffer[j].m_TexCoord7[1], m_Buffer[j].m_TexCoord7[2], 0.0, 0.0))
								(c.BLENDINDEX): (val = #(m_Buffer[j].m_BoneID[1], m_Buffer[j].m_BoneID[2], m_Buffer[j].m_BoneID[3], m_Buffer[j].m_BoneID[4])        )
								(c.BLENDWEIGHT):(val = #(m_Buffer[j].m_Weight[1], m_Buffer[j].m_Weight[2], m_Buffer[j].m_Weight[3], m_Buffer[j].m_Weight[4])        )
								)
							
							case v.m_Datatype of (
								(t.FLOAT3): (
									writeFloat s val[1]
									writeFloat s val[2]
									writeFloat s val[3]
									)
								(t.FLOAT4): (
									writeFloat s val[1]
									writeFloat s val[2]
									writeFloat s val[3]
									writeFloat s val[4]
									)
								(t.HALF2): (
									writeHalf s val[1]
									writeHalf s val[2]
									)
								(t.UBYTE4): (
									writeByte s val[1] #unsigned
									writeByte s val[2] #unsigned
									writeByte s val[3] #unsigned
									writeByte s val[4] #unsigned
									)
								(t.COLOR4): (
									writeByte s val[1] #unsigned
									writeByte s val[2] #unsigned
									writeByte s val[3] #unsigned
									writeByte s val[4] #unsigned
									)
								(t.UBYTE4N): (
									writeByte s (val[1] * 255.0) #unsigned
									writeByte s (val[2] * 255.0) #unsigned
									writeByte s (val[3] * 255.0) #unsigned
									writeByte s (val[4] * 255.0) #unsigned
									)
								(t.N11_11_10): (
									local x = (val[1] * 1023.0) as integer  -- 11 bits
									local y = (val[2] * 1023.0) as integer  -- 11 bits
									local z = (val[3] * 511.0) as integer   -- 10 bits
									local packedNormal = bit.or (bit.or ((bit.shift x -21) (bit.shift y -10))) z
									writeLong s packedNormal #unsigned
									)
								(t.HALF4): (
									writeHalf &s val[1]
									writeHalf &s val[2]
									writeHalf &s val[3]
									writeHalf &s val[4]
									)
								(t.HALF3): (
									writeHalf &s val[1]
									writeHalf &s val[2]
									writeHalf &s val[3]
									)
								(t.SINT16_2): (
									writeShort s val[1] #signed
									writeShort s val[2] #signed
									)
								(t.SHORT4): (
									writeShort s val[1] #signed
									writeShort s val[2] #signed
									writeShort s val[3] #signed
									writeShort s val[4] #signed
									)
								(t.SHORT4N): (
									writeShort s (val[1] * 32767.0) #signed
									writeShort s (val[2] * 32767.0) #signed
									writeShort s (val[3] * 32767.0) #signed
									writeShort s (val[4] * 32767.0) #signed
									)
								(t.SHORT4_FIXED4_12): (
									writeShort s (val[1] * 4096.0) #signed
									writeShort s (val[2] * 4096.0) #signed
									writeShort s (val[3] * 4096.0) #signed
									writeShort s (val[4] * 4096.0) #signed
									)
								(t.SHORT4_FIXED8_8): (
									writeShort s (val[1] * 256.0) #signed
									writeShort s (val[2] * 256.0) #signed
									writeShort s (val[3] * 256.0) #signed
									writeShort s (val[4] * 256.0) #signed
									)
								(t.UINT1): (
									writeLong s val[1] #unsigned
									)
								(t.UBYTE4_DELTA): (
									writeByte s ((val[1] * 512.0) + 127) #unsigned
									writeByte s ((val[2] * 512.0) + 127) #unsigned
									writeByte s ((val[3] * 512.0) + 127) #unsigned
									writeByte s ((val[4] * 512.0) + 127) #unsigned
									)
								(t.BYTE4N): (
									writeByte s ((val[1] * 0.5 + 0.5) * 255.0) #unsigned
									writeByte s ((val[2] * 0.5 + 0.5) * 255.0) #unsigned
									writeByte s ((val[3] * 0.5 + 0.5) * 255.0) #unsigned
									writeByte s ((val[4] * 0.5 + 0.5) * 255.0) #unsigned
									)
								)
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
		fn size = (104 + m_Resource.base.reserved.count + 40 + m_NumBones + (mod (160-(mod m_NumBones 160)) 160) + (m_NumBones * 72)),
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
						-- oddly there is -1 used as padding, and in one example 'ELITEGHOUL'
						-- the bone count reads into these -1 which is causing crashing with
						-- the mesh import.
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
			m_NumBones = m_BoneNameTable.count
			local n_padding = mod (160-(mod m_NumBones 160)) 160
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
	
	struct TextureUserPlat_t ( -- 16 bytes
		/*int32_t*/ m_Value1 = 0x42,
		/*float*/ m_Value2 = 11.0,
		/*uint8_t[8]*/ pad19 = #(0, 0, 0, 0, 0, 0, 0, 0),
		fn size = (16),
		fn read f = (
			m_Value1 = readLong f #unsigned
			m_Value2 = readFloat f
			pad19 = #(
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
				readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
				)
			),
		fn write &s = (
			writeLong s m_Value1 #unsigned
			writeFloat s m_Value2
			local i = 1
			for i = 1 to pad19.count do (
				writeByte s pad19[i] #unsigned
				)
			)
		)
	
	struct TextureUser_t (
		/*ResourceHandle_t*/ mAlphaStateHandle = ResourceHandle_t(),
		/*ResourceHandle_t*/ mRasterStateHandle = ResourceHandle_t(),
		fn read f = (
			mAlphaStateHandle.read(f)
			mRasterStateHandle.read(f)
			),
		fn write &s = (
			mAlphaStateHandle.write(&s)
			mRasterStateHandle.write(&s)
			)
		)
	
	struct Texture_t (
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint32_t*/ m_Flags = 0,
		/*
			FLAG_CLAMPU = 0x1,
			FLAG_CLAMPV = 0x2,
			FLAG_MIRRORU = 0x4,
			FLAG_MIRRORV = 0x8,
			FLAG_LINEAR = 0x100,
			FLAG_LE = 0x200,
			FLAG_CPU_WRITABLE = 0x400,
			FLAG_TARGET = 0x800,
			FLAG_PS3_TARGET_TILED = 0x1000,
			FLAG_IN_INVENTORY = 0x2000,
			FLAG_CREATED_AT_RUNTIME = 0x4000,
			FLAG_MOVING = 0x8000,
			FLAG_NO_EXPAND_AS_16 = 0x10000,
			FLAG_MOVIE_TEXTURE = 0x20000,
			FLAG_CPU_READABLE = 0x40000,
			FLAG_MIPS_SHADER_SRC = 0x80000,
			FLAG_PRESENT_BUFFER = 0x100000,
			FLAG_ALIASED_TEXTURE = 0x200000,
			FLAG_PC_MAIN_MEM_COPY = 0x400000,
			FLAG_PC_UNORDERED_ACCESS = 0x800000,
			FLAG_REBIND_DATAHANDLE = 0x1000000,
			FLAG_XB1_USE_ESRAM = 0x2000000,
			FLAG_MSAA_2X = 0x4000000,
			FLAG_MSAA_4x = 0x8000000,
			FLAG_SAMPLER_ADDRESS_MASK = 0xF,
			FLAG_RUNTIME_MASK = 0x100A000,
		*/
		/*uint8_t*/ m_Format = 9,
		/*
			FORMAT_A8R8G8B8 = 0x0,
			FORMAT_DXT1 = 0x1,
			FORMAT_DXT3 = 0x2,
			FORMAT_DXT5 = 0x3,
			FORMAT_R5G6B5 = 0x4,
			FORMAT_A1R5G5B5 = 0x5,
			FORMAT_X8 = 0x6,
			FORMAT_X16 = 0x7,
			FORMAT_CXT1 = 0x8,
			FORMAT_DXN = 0x9,
			FORMAT_BC6H_UF16 = 0xA,
			FORMAT_BC6H_SF16 = 0xB,
			FORMAT_BC7_UNORM = 0xC,
			FORMAT_BC7_UNORM_SRGB = 0xD,
			FORMAT_R32F = 0xE,
			FORMAT_X16FY16FZ16FW16F = 0xF,
			FORMAT_D24S8 = 0x10,
			FORMAT_D24FS8 = 0x11,
			FORMAT_SHADOW = 0x12,
			FORMAT_DEPTHCOPY = 0x13,
			FORMAT_A2R10G10B10 = 0x14,
			FORMAT_A2R10G10B10F = 0x15,
			FORMAT_A16B16G16R16 = 0x16,
			NUM_TEX_FORMATS = 0x17,
		*/
		/*uint8_t*/ m_Type = 0,
		/*
			TYPE_2D = 0x0,
			TYPE_3D = 0x1,
			TYPE_CUBE = 0x2,
			TYPE_2D_ARRAY = 0x3,
			NUM_TEX_TYPES = 0x4,
		*/
		/*uint8_t*/ m_Aniso = 0,
		/*
			ANISO_X1 = 0x0,
			ANISO_X2 = 0x1,
			ANISO_X4 = 0x2,
			ANISO_X6 = 0x3,
			ANISO_X8 = 0x4,
			ANISO_X10 = 0x5,
			ANISO_X12 = 0x6,
			ANISO_X16 = 0x7,
		*/
		/*uint8_t*/ m_MipMapBiasPreset = 0,
		/*
			MIPMAP_BIAS_PRESET_UNSPECIFIED = 0x0,
			MIPMAP_BIAS_PRESET_EAGLE_EYE = 0x9,
			MIPMAP_BIAS_PRESET_SLIDER0 = 0xA,
			MIPMAP_BIAS_PRESET_SLIDER1 = 0xB,
			MIPMAP_BIAS_PRESET_SLIDER2 = 0xC,
			MIPMAP_BIAS_PRESET_SLIDER3 = 0xD,
			MIPMAP_BIAS_PRESET_SLIDER4 = 0xE,
			MIPMAP_BIAS_PRESET_CUSTOM = 0xF,
		*/
		/*uint32_t*/ m_MipMapBias = 0,
		/*uint16_t*/ m_Width = 0,
		/*uint16_t*/ m_Height = 0,
		/*uint8_t*/ m_NumMipMaps = 1,
		/*uint8_t*/ m_Filter = 0,
		/*
			FILTER_DEFAULT = 0x0,
			FILTER_LINEAR = 0x1,
			FILTER_POINT = 0x2,
			FILTER_ANISOTROPIC = 0x3,
			FILTER_CONVOLUTION = 0x4,
		*/
		/*uint16_t*/ m_Depth = 1,
		/*uint32_t*/ m_AlphaStateUID = 0x2782CCE6,
		/*uint64_t*/ m_TextureUserOffset = 0,
		/*uint32_t*/ m_ImageDataByteSize = 0,
		/*uint32_t*/ m_LastUsedFrameNum = 0,
		/*uint64_t*/ m_ImageDataPosition = 0,
		/*uint64_t*/ m_VRAMPool = 0,
		/*uint64_t*/ m_MemoryPool = 0,
		/*ResourceHandle_t*/ m_ResourceUID = ResourceHandle_t(),

		/*uint8_t[24]*/ pad17 = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		/*uint64_t*/ m_TextureUserPlatOffset = 0, -- address to TextureUserPlat
		/*uint8_t[168]*/ pad18 = #(
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			),
		/*TextureUser_t*/ m_TextureUser = TextureUser_t(), -- 64 bytes
		/*TextureUserPlat_t*/ m_TextureUserPlat = TextureUserPlat_t(), -- 16 bytes
		fn read f = (
			local pos = ftell f
			local result = false
			m_Resource.read(f)
			
			if m_Resource.base.m_TypeUID == 0xCDBFA090 or m_Resource.base.m_TypeUID == -843079536 do (
				m_Flags = readLong f #unsigned
				m_Format = readByte f #unsigned
				m_Type = readByte f #unsigned
				m_Aniso = readByte f #unsigned
				m_MipMapBiasPreset = readByte f #unsigned
				m_MipMapBias = readLong f #unsigned
				m_Width = readShort f #unsigned
				m_Height = readShort f #unsigned
				m_NumMipMaps = readByte f #unsigned
				m_Filter = readByte f #unsigned
				m_Depth = readShort f #unsigned
				m_AlphaStateUID = readLong f #unsigned
				local pos_TextureUserOffset = ftell f
				m_TextureUserOffset = readLongLong f #unsigned
				m_ImageDataByteSize = readLong f #unsigned
				m_LastUsedFrameNum = readLong f #unsigned
				m_ImageDataPosition = readLongLong f
				m_VRAMPool = readLongLong f -- these are wrong, but it just fills of space
				m_MemoryPool = readLongLong f
				m_ResourceUID.read(f)
				pad17 = #(
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
					)
				local pos_TextureUserPlatOffset = ftell f
				m_TextureUserPlatOffset = readLongLong f
				pad18 = #(
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned,
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned,
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned,
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned,
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned,
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned,
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, 
					readByte f #unsigned, readByte f #unsigned, readByte f #unsigned, readByte f #unsigned
					)
				if m_TextureUserOffset > 0 do (
					fseek f (pos_TextureUserOffset + m_TextureUserOffset) #seek_set
					m_TextureUserPlat.read(f)
					)
				if m_TextureUserPlatOffset > 0 do (
					fseek f (pos_TextureUserOffset + m_TextureUserPlatOffset) #seek_set
					m_TextureUserPlat.read(f)
					)
				result = true
				)
			result
			)
		)
	
	struct MaterialUser_t ( -- 16 bytes
		/*uint16_t*/ m_VisibilityFlags = 1, --  Either 1 or 31
		/*uint16_t*/ m_ShadowFlags = 0, -- always 0
		/*uint8_t[12]*/ m_Align = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -- always 0s
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
	
	struct StateParamSlot_t (
		Ambient                      = 1533629930,   -- 0x5B6955EA
		Bump                         = -1380050342,  -- 0xADBE1A5A  
		Bump2                        = -1555506141,  -- 0xA348DC23  
		Diffuse                      = -589273463,   -- 0xDCE06689  
		Diffuse2                     = 423694195,    -- 0x19410F73
		Diffuse_Blend                = 936776567,    -- 0x37D61377  
		Diffuse_World                = 100227825,    -- 0x05F95AF1
		Noise                        = 1676202779,   -- 0x63E8D31B
		Normal                       = -324155511,   -- 0xECADC789
		Specular                     = -884601145,   -- 0xCB460EC7  
		Specular2                    = -310392314,   -- 0xED7FCA06  
		Unknown1                     = -1389972713,  -- 0xAD26B317  
		Unknown2                     = -1439698447,  -- 0xAA2FF1F1  
		Unknown3                     = 746467177,    -- 0x2C7E2F69  
		Unknown4                     = 76571916      -- 0x0490650C  
		)
	
	struct StateParamType_t (
		iTexture                = -935889837,   -- 0xC8377453  
		iAlphaState             = -342330225,   -- 0xEB98748F  
		iRasterState            = -1061001754,  -- 0xC0C265E6  
		iShader                 = 1545193780,   -- 0x5C19C934  
		sbDepthBiasSortLayer    = -244067581,   -- 0xF173D303  
		sbSpecularLook          = -366541308,   -- 0xEA270604  
		sbTextureAnim           = -1292512270,  -- 0xB2F5D3F2  
		Unknown7                = -1396934011,  -- 0xACBC7A85  
		Unknown8                = -1579086515,  -- 0xA1E10D4D  
		Unknown9                = 920930327     -- 0x36E44817  
		)
	
	struct AlphaState_t (
		None                     = 662883558,    -- 0x2782CCE6,
		Modulated                = -1551679522,  -- 0xA3833FDE
		ModulatedRGBSolidAlpha   = 349120206,    -- 0x14CF26CE
		Additive                 = 1775952593,   -- 0x69DAE2D1
		Premultipled             = -89056095,    -- 0xFAB11CA1
		PremultipledModulate     = -2074035010,  -- 0x8460BCBE
		PremultipledAdditive     = -630453795,   -- 0xDA6C09DD
		PunchThru                = 721849354,    -- 0x2B068C0A
		FeatherPunchThru         = -1145803578,  -- 0xBBB46CC6
		Mask                     = 2085185948,   -- 0x7C49699C
		Overlay                  = -303549566,   -- 0xEDE83382
		Screen                   = -697783528,   -- 0xD668AB18
		Min_                     = 1537972824,   -- 0x5BAB9A58
		Max_                     = -2022420536,  -- 0x87744FC8
		Subtract                 = 717233154,    -- 0x2AC01C02
		ReverseSubtract          = 818834184,    -- 0x30CE6B08
		Copy_                    = 2015536557,   -- 0x7822A5AD
		NoColourWrite            = -1851597485,  -- 0x91A2DD53
		ModulatedMaskRGB         = -773675157,   -- 0xD1E2A76B
		ModulatedRGBSrcAlpha     = 1857940896    -- 0x6EBDEDA0
		)
	
	struct RasterState_t (
		None                    = 1660426324,   -- 0x62F81854
		Normal                  = 543723269,    -- 0x20688F05
		DisableWrite            = -262489691,   -- 0xF05AB9A5
		InvertDisableWrite      = 1265402560,   -- 0x4B6C82C0
		DisableDepthTest        = 206781021,    -- 0x0C533A5D
		DoubleSided             = -1810908948,  -- 0x940FB8EC
		DoubleSidedAlpha        = 1099738947,   -- 0x418CAF43
		InvertCulling           = -1130385655   -- 0xBC9FAF09
		)
	
	struct StateParam_t ( -- 12 bytes
		/*
			m_NameUID and m_TypeUID are the same except for when m_TypeUID is a texture
			then m_NameUID represents the texture type
		*/
		/*uint32_t*/ m_NameUID = 0,
		/*
			Ambient                 0x5B6955EA
			Bump                    0xADBE1A5A  -1380050342
			Bump (2)                0xA348DC23  -1555506141
			Diffuse                 0xDCE06689  -589273463
			Diffuse (2)             0x19410F73
			Diffuse Blend           0x37D61377  936776567
			Diffuse World           0x05F95AF1
			Noise                   0x63E8D31B  1676202779
			Normal                  0xECADC789
			Specular                0xCB460EC7  -884601145
			Specular (2)            0xED7FCA06  -310392314
			Unknown1                0xAD26B317  -1389972713
			Unknown2                0xAA2FF1F1  -1439698447
			Unknown3                0x2C7E2F69  746467177
			Unknown4                0x0490650C  76571916
		*/
		/*uint32_t*/ m_TypeUID = 0,
		/*
			iTexture                0xC8377453  -935889837
			iAlphaState             0xEB98748F  -342330225
			iRasterState            0xC0C265E6  -1061001754
			iShader                 0x5C19C934  1545193780
			sbDepthBiasSortLayer    0xF173D303  -244067581
			sbSpecularLook          0xEA270604  -366541308
			sbTextureAnim           0xB2F5D3F2  -1292512270
			Unknown7                0xACBC7A85  -1396934011
			Unknown8                0xA1E10D4D  -1579086515
			Unknown9                0x36E44817  920930327
		*/
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
		/*
			ALPHASTATE      0x12C800F2  315097330
							m_NameUID = 0xFFFFFFFF  -1
			
			# --------------------------------------- #
			RASTERSTATE     0x3BC715E0  1002903008
							m_NameUID = 0xFFFFFFFF  -1
							m_NameUID = 0x418CAF43  1099738947
							m_NameUID = 0x940FB8EC  -1810908948
			
			# --------------------------------------- #
			SHADER          0x8B5561A1  -1957338719
							m_NameUID = 0x3C1D8CA0  1008569504
							m_NameUID = 0x06D01A50  114301520
							m_NameUID = 0x84889C9C  -2071421796
							m_NameUID = 0x84141A2A  -2079057366
							m_NameUID = 0xE83D2493  -398646125
							m_NameUID = 0xCEE200FC  -824049412
			
			# --------------------------------------- #
			STATEBLOCK      0x4D04C7F2  1292158962
							* 58 types
			
			# --------------------------------------- #
			TEXTURE         0x8B43FABF  -1958479169
							* 2701 types
			
			# --------------------------------------- #
		*/
		/*uint8_t[4]*/ pad13 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*uint32_t*/ m_TypeUID = 0,
		/*
			MATERIAL_ALPHASTATE			0x12C800F2 	315097330
			MATERIAL_RASTERSTATE		0x3BC715E0 	1002903008
			MATERIAL_SHADER				0x8B5561A1 	-1957338719
			MATERIAL_STATEBLOCK			0x4D04C7F2 	1292158962
			MATERIAL_TEXTURE			0x8B43FABF 	-1958479169
		*/
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
			
			--if m_TypeUID != -1958479169 then
			--"(MaterialParam_t m_StateParam:(StateParam_t m_NameUID:" + (m_StateParam.m_NameUID as string) + " m_TypeUID:" + (m_StateParam.m_TypeUID as string) + ") m_NameUID:" + (m_NameUID as string) + " m_TypeUID:" + (m_TypeUID as string) + ")"
			--else ""
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
		/*
			materials were a bit complicated,
		*/
		/*ResourceData_t*/ m_Resource = ResourceData_t(),
		/*uint8_t[8]*/ pad10 = #(0, 0, 0, 0, 0, 0, 0, 0), -- UFG_PAD(0x8)
		/*uint64_t[2]*/ m_StateBlockMask = #(0, 0),
		/*uint32_t*/ m_NumParams = 0,
		/*uint8_t[4]*/ pad11 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_MaterialUserOffset = 0,
		/*MaterialParam_t[m_NumParams]*/m_ParamTable = #(),
		/*MaterialUser_t*/ m_MaterialUser = MaterialUser_t(),
		fn size = (104 + m_Resource.base.reserved.count + (m_ParamTable.count * 56) + (mod (16-(mod (m_ParamTable.count * 56) 16)) 16) + 56),
		fn printHashes = (
			for p in m_ParamTable do (
				format "%\t%\t%\t%\t%\n" \
					(m_Resource.base.Hash32HexString p.m_NameUID) \
					(m_Resource.base.Hash32HexString p.m_TypeUID) \
					(m_Resource.base.Hash32HexString p.m_StateParam.m_NameUID) \
					(m_Resource.base.Hash32HexString p.m_StateParam.m_TypeUID) \
					(m_Resource.base.Hash32HexString p.m_StateParam.m_ParamIndex)
				)
			),
		fn read f verbose:false = (
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
				if verbose do format "\nMaterial - %\n:" m_Resource.m_DebugName
				if verbose do format "m_NumParams: \t%\n" m_NumParams
				m_ParamTable = #()
				local str = ""
				if m_NumParams > 0 do (
					m_ParamTable[m_NumParams] = MaterialParam_t()
					local i = 1
					for i = 1 to m_NumParams do (
						m_ParamTable[i] = MaterialParam_t()
						m_ParamTable[i].read(f)
						--local rr = m_ParamTable[i].read(f)
						--str += rr
						--if str.count > 0 and i != m_NumParams and rr.count > 0 do str += ", "
						if verbose do format "\tPARAM %\n" i
						if verbose do format "\tm_NameUID: \t0x%\n" (bit.IntAsHex (m_ParamTable[i].m_NameUID as integer))
						if verbose do format "\tm_TypeUID: \t%\n" (#("ALPHASTATE", "RASTERSTATE", "SHADER", "STATEBLOCK", "TEXTURE"))[findItem (#(315097330, 1002903008, -1957338719, 1292158962, -1958479169)) m_ParamTable[i].m_TypeUID]
						if verbose do format "\tm_StateParam:\n"
						--if verbose do format "\t\tm_NameUID: \t0x%\n" (bit.IntAsHex (m_ParamTable[i].m_StateParam.m_NameUID as integer))
						if verbose do format "\t\tm_NameUID: \t%\n" (#("Unknown", "Ambient", "Bump", "Bump (2)", "Diffuse", "Diffuse (2)", "Diffuse Blend", "Diffuse World", "Noise", "Normal", "Specular"))[(findItem (#(1533629930, -1380050342, -1555506141, -589273463, 423694195, 936776567, 100227825, 1676202779, -324155511, -884601145)) m_ParamTable[i].m_StateParam.m_NameUID) + 1]	
						if verbose do format "\t\tm_TypeUID: \t0x%\n" (bit.IntAsHex (m_ParamTable[i].m_StateParam.m_TypeUID as integer))
						if verbose do format "\t\tm_ParamIndex: \t%\n" m_ParamTable[i].m_StateParam.m_ParamIndex
						)
					
					)
				
				if m_MaterialUserOffset > 0 and addr_MaterialUserOffset + m_MaterialUserOffset <= pos + m_Resource.size() do (
					fseek f (addr_MaterialUserOffset + m_MaterialUserOffset) #seek_set
					m_MaterialUser.read(f)
					)
				)
			--printHashes()
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
			--printHashes()
			),
		fn setSceneMaterial = (
			/*
				There is a ton of hashes so its very confusing just exactly how to translate the
				material data into something easy to understand and edit.
				
				
				As best I can figure there are a combination of 4 state block types so i have
				used those as specifiers to set a shader profile.
				
				however, when you look at the state blocks they have 58 unique name references.
				so, its very possible that the state blocks are also texture maps...
				
				
				regardless its the 
			*/
			-- Create a standard material
			
			
			local u = ResourceEntry_t()
			local matName = getFilenameFile m_Resource.m_DebugName
			local l = findString matName "~"
			if l != undefined and l > 1 do (
				matName = subString matName 1 (l - 1)
				)
			
			local myMaterial = StandardMaterial shaderType:1 name:((u.Hash32HexString m_Resource.m_NameUID) + " " + matName)
			
			
			-- Add custom attributes to the material
			custAttributes.add myMaterial sdde_material
			
			myMaterial.diffuse = random white black
			
			local p
			local stateblock1_id = 0
			local stateblock2_id = 0
			local stateblock3_id = 0
			local stateblock4_id = 0
			local stateblock5_id = 0
			local stateblock6_id = 0
			local bump_id = 0
			local ambient_id = 0
			local diffuse_id = 0
			local diffuse2_id = 0
			local bump2_id = 0
			local blend_id = 0
			local world_id = 0
			local specular_id = 0
			local specular2_id = 0
			local noise_id = 0
			local unknown1_id = 0
			local unknown2_id = 0
			local unknown3_id = 0
			local unknown4_id = 0
			local ishader_type = 1
			local raster_type = 1
			
			local ri = ResourceInventory_t()
			local pt = StateParamType_t()
			local ps = StateParamSlot_t()
			local rs = RasterState_t()
			
			for p in m_ParamTable do (
				case p.m_TypeUID of (
					(ri.AlphaState):    () -- they all have this entry and its hashes are the same
					(ri.Shader):  ishader_type    = (findItem (#(114301520, 1008569504, -2079057366, -2071421796, -824049412, -398646125)) p.m_NameUID) + 1 -- iShader
					(ri.RasterState):   ( -- iRasterState
						--format "raster_type: 0x%\n" (toUpper(bit.IntAsHex p.m_NameUID))
						raster_type    = (findItem (#(-1, rs.DoubleSidedAlpha, rs.DoubleSided)) p.m_NameUID) + 1
						)
					(ri.StateBlock):   ( -- StateBlock
						case p.m_StateParam.m_TypeUID of (
							(pt.Unknown7):              stateblock1_id   = p.m_NameUID -- unknown7
							(pt.Unknown8):              stateblock2_id   = p.m_NameUID -- unknown8
							(pt.Unknown9):              stateblock3_id   = p.m_NameUID -- unknown9
							(pt.sbSpecularLook):        stateblock4_id   = p.m_NameUID -- sbSpecularLook
							(pt.sbTextureAnim):         stateblock5_id   = p.m_NameUID -- sbTextureAnim
							(pt.sbDepthBiasSortLayer):  stateblock6_id   = p.m_NameUID -- sbDepthBiasSortLayer
							
							default: format "Unknown StateBlock: %\n" p.m_StateParam.m_TypeUID
							)
						)
					(ri.Texture):  ( -- Texture
						case p.m_StateParam.m_TypeUID of (
							(pt.iTexture): (
								-- Texture
								case p.m_StateParam.m_NameUID of (
									(ps.Bump):          bump_id         = p.m_NameUID
									(ps.Ambient):       ambient_id      = p.m_NameUID
									(ps.Diffuse):       diffuse_id      = p.m_NameUID
									(ps.Diffuse2):      diffuse2_id     = p.m_NameUID
									(ps.Bump2):         bump2_id        = p.m_NameUID
									(ps.Diffuse_Blend): blend_id        = p.m_NameUID
									(ps.Diffuse_World): world_id        = p.m_NameUID
									(ps.Specular):      specular_id     = p.m_NameUID
									(ps.Specular2):     specular2_id    = p.m_NameUID
									(ps.Noise):         noise_id        = p.m_NameUID
									(ps.Unknown1):      unknown1_id     = p.m_NameUID
									(ps.Unknown2):      unknown2_id     = p.m_NameUID
									(ps.Unknown3):      unknown3_id     = p.m_NameUID
									(ps.Unknown4):      unknown4_id     = p.m_NameUID
									default: format "Unknown Texture2: %\n" p.m_StateParam.m_NameUID
									)
								)
							default: format "Unknown Texture1: %\n" p.m_StateParam.m_TypeUID
							)
						)
					default: format "Unknown Parameter: %\n" p.m_TypeUID
					)
				)
			
			
			if (stateblock4_id != 0 or stateblock5_id != 0 or stateblock6_id != 0) then (
				myMaterial.profile = 5
				)
			else if stateblock2_id != 0 then (
				myMaterial.profile = 3
				)
			else if stateblock1_id != 0 then (
				myMaterial.profile = 4
				)
			else (
				myMaterial.profile = 2
				)
			
			myMaterial.visible_on = m_MaterialUser.m_VisibilityFlags > 1
			myMaterial.ishader_type = ishader_type
			myMaterial.raster_type = raster_type
			
			
			if (myMaterial.bump_on          = bump_id)       != 0 do (myMaterial.bump_id        = u.Hash32HexString bump_id)
			if (myMaterial.ambient_on       = ambient_id)    != 0 do (myMaterial.ambient_id     = u.Hash32HexString ambient_id)
			if (myMaterial.diffuse_on       = diffuse_id)    != 0 do (myMaterial.diffuse_id     = u.Hash32HexString diffuse_id)
			if (myMaterial.diffuse2_on      = diffuse2_id)   != 0 do (myMaterial.diffuse2_id    = u.Hash32HexString diffuse2_id)
			if (myMaterial.bump2_on         = bump2_id)      != 0 do (myMaterial.bump2_id       = u.Hash32HexString bump2_id)
			if (myMaterial.blend_on         = blend_id)      != 0 do (myMaterial.blend_id       = u.Hash32HexString blend_id)
			if (myMaterial.world_on         = world_id)      != 0 do (myMaterial.world_id       = u.Hash32HexString world_id)
			if (myMaterial.specular_on      = specular_id)   != 0 do (myMaterial.specular_id    = u.Hash32HexString specular_id)
			if (myMaterial.specular2_on     = specular2_id)  != 0 do (myMaterial.specular2_id   = u.Hash32HexString specular2_id)
			if (myMaterial.noise_on         = noise_id)      != 0 do (myMaterial.noise_id       = u.Hash32HexString noise_id)
			if (myMaterial.unknown1_on      = unknown1_id)   != 0 do (myMaterial.unknown1_id    = u.Hash32HexString unknown1_id)
			if (myMaterial.unknown2_on      = unknown2_id)   != 0 do (myMaterial.unknown2_id    = u.Hash32HexString unknown2_id)
			if (myMaterial.unknown3_on      = unknown3_id)   != 0 do (myMaterial.unknown3_id    = u.Hash32HexString unknown3_id)
			if (myMaterial.unknown4_on      = unknown4_id)   != 0 do (myMaterial.unknown4_id    = u.Hash32HexString unknown4_id)
			if (myMaterial.stateblock1_on   = stateblock1_id)!= 0 do (myMaterial.stateblock1_id = u.Hash32HexString stateblock1_id)
			if (myMaterial.stateblock2_on   = stateblock2_id)!= 0 do (myMaterial.stateblock2_id = u.Hash32HexString stateblock2_id)
			if (myMaterial.stateblock3_on   = stateblock3_id)!= 0 do (myMaterial.stateblock3_id = u.Hash32HexString stateblock3_id)
			if (myMaterial.stateblock4_on   = stateblock4_id)!= 0 do (myMaterial.stateblock4_id = u.Hash32HexString stateblock4_id)
			if (myMaterial.stateblock5_on   = stateblock5_id)!= 0 do (myMaterial.stateblock5_id = u.Hash32HexString stateblock5_id)
			if (myMaterial.stateblock6_on   = stateblock6_id)!= 0 do (myMaterial.stateblock6_id = u.Hash32HexString stateblock6_id)
			
			myMaterial
			),
		fn getSceneMaterial mat = (
			local profile       = try(mat.profile - 1)      catch(0)
			local ishader_type  = try(mat.ishader_type - 1) catch(1) 
			local raster_type   = try(mat.raster_type - 1)  catch(1)
			local ambient_on    = try(mat.ambient_on)       catch(false)
			local ambient_id    = try(mat.ambient_id)       catch("0xFFFFFFFF")
			local diffuse_on    = try(mat.diffuse_on)       catch(false)
			local diffuse_id    = try(mat.diffuse_id)       catch("0xFFFFFFFF")
			local diffuse2_on   = try(mat.diffuse2_on)      catch(false)
			local diffuse2_id   = try(mat.diffuse2_id)      catch("0xFFFFFFFF")
			local blend_on      = try(mat.blend_on)         catch(false)
			local blend_id      = try(mat.blend_id)         catch("0xFFFFFFFF")
			local world_on      = try(mat.world_on)         catch(false)
			local world_id      = try(mat.world_id)         catch("0xFFFFFFFF")
			local bump_on       = try(mat.bump_on)          catch(false)
			local bump_id       = try(mat.bump_id)          catch("0xFFFFFFFF")
			local bump2_on      = try(mat.bump2_on)         catch(false)
			local bump2_id      = try(mat.bump2_id)         catch("0xFFFFFFFF")
			local specular_on   = try(mat.specular_on)      catch(false)
			local specular_id   = try(mat.specular_id)      catch("0xFFFFFFFF")
			local specular2_on  = try(mat.specular2_on)     catch(false)
			local specular2_id  = try(mat.specular2_id)     catch("0xFFFFFFFF")
			local noise_on      = try(mat.noise_on)         catch(false)
			local noise_id      = try(mat.noise_id)         catch("0xFFFFFFFF")
			local unknown1_on   = try(mat.unknown1_on)      catch(false)
			local unknown1_id   = try(mat.unknown1_id)      catch("0xFFFFFFFF")
			local unknown2_on   = try(mat.unknown2_on)      catch(false)
			local unknown2_id   = try(mat.unknown2_id)      catch("0xFFFFFFFF")
			local unknown3_on   = try(mat.unknown3_on)      catch(false)
			local unknown3_id   = try(mat.unknown3_id)      catch("0xFFFFFFFF")
			local unknown4_on   = try(mat.unknown4_on)      catch(false)
			local unknown4_id   = try(mat.unknown4_id)      catch("0xFFFFFFFF")
			local stateblock1_on= try(mat.stateblock1_on)   catch(false)
			local stateblock1_id= try(mat.stateblock1_id)   catch("0xFFFFFFFF")
			local stateblock2_on= try(mat.stateblock2_on)   catch(false)
			local stateblock2_id= try(mat.stateblock2_id)   catch("0xFFFFFFFF")
			local stateblock3_on= try(mat.stateblock3_on)   catch(false)
			local stateblock3_id= try(mat.stateblock3_id)   catch("0xFFFFFFFF")
			local stateblock4_on= try(mat.stateblock4_on)   catch(false)
			local stateblock4_id= try(mat.stateblock4_id)   catch("0xFFFFFFFF")
			local stateblock5_on= try(mat.stateblock5_on)   catch(false)
			local stateblock5_id= try(mat.stateblock5_id)   catch("0xFFFFFFFF")
			local stateblock6_on= try(mat.stateblock6_on)   catch(false)
			local stateblock6_id= try(mat.stateblock6_id)   catch("0xFFFFFFFF")
			local shader_list   = #(114301520, 1008569504, -2079057366, -2071421796, -824049412, -398646125) -- 0x06D01A50, 0x3C1D8CA0, 0x84141A2A, 0x84889C9C, 0xCEE200FC, 0xE83D2493
			local raster_list   = #(-1, 1099738947, -1810908948) -- 0xFFFFFFFF, 0x418CAF43, 0x940FB8EC
			local visible_on    = try(mat.visible_on)catch(true)
			
			local ri = ResourceInventory_t()
			local pt = StateParamType_t()
			local ps = StateParamSlot_t()
			
			m_MaterialUser.m_VisibilityFlags = if visible_on then 1 else 31
			m_ParamTable = #(
				(MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.iShader     m_TypeUID:pt.iShader)      m_NameUID:shader_list[ishader_type] m_TypeUID:ri.Shader), 	-- iShader
				(MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.iAlphaState m_TypeUID:pt.iAlphaState)  m_NameUID:-1 m_TypeUID:ri.AlphaState) 						-- iAlphaState
				)
			if stateblock4_on or stateblock5_on or stateblock6_on then ( -- Shader Profile 4
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.sbSpecularLook         m_TypeUID:pt.sbSpecularLook)        m_NameUID:(m_Resource.base.convertHexString stateblock4_id) m_TypeUID:ri.StateBlock)    -- sbSpecularLook
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.sbTextureAnim          m_TypeUID:pt.sbTextureAnim)         m_NameUID:(m_Resource.base.convertHexString stateblock5_id) m_TypeUID:ri.StateBlock)    -- sbTextureAnim
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.sbDepthBiasSortLayer   m_TypeUID:pt.sbDepthBiasSortLayer)  m_NameUID:(m_Resource.base.convertHexString stateblock6_id) m_TypeUID:ri.StateBlock)    -- sbDepthBiasSortLayer
				)
			else if stateblock2_on then ( -- Shader Profile 2
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.Unknown8 m_TypeUID:pt.Unknown8) m_NameUID:(m_Resource.base.convertHexString stateblock2_id) m_TypeUID:ri.StateBlock) -- unknown8
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.Unknown7 m_TypeUID:pt.Unknown7) m_NameUID:(m_Resource.base.convertHexString stateblock1_id) m_TypeUID:ri.StateBlock) -- unknown7
				)
			else if stateblock1_on then ( -- Shader Profile 3
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.Unknown7 m_TypeUID:pt.Unknown7) m_NameUID:(m_Resource.base.convertHexString stateblock1_id) m_TypeUID:ri.StateBlock) -- unknown7
				)
			else ( -- Shader Profile 1
				append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.Unknown9 m_TypeUID:pt.Unknown9) m_NameUID:(m_Resource.base.convertHexString stateblock3_id) m_TypeUID:ri.StateBlock) -- unknown9
				)
			if ambient_on       do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Ambient        m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString ambient_id)      m_TypeUID:ri.Texture))
			if diffuse_on       do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Diffuse        m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString diffuse_id)      m_TypeUID:ri.Texture))
			if diffuse2_on      do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Diffuse2       m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString diffuse2_id)     m_TypeUID:ri.Texture))
			if blend_on         do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Diffuse_Blend  m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString blend_id)        m_TypeUID:ri.Texture))
			if world_on         do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Diffuse_World  m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString world_id)        m_TypeUID:ri.Texture))
			if bump_on          do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Bump           m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString bump_id)         m_TypeUID:ri.Texture))
			if bump2_on         do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Bump2          m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString bump2_id)        m_TypeUID:ri.Texture))
			if specular_on      do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Specular       m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString specular_id)     m_TypeUID:ri.Texture))
			if specular2_on     do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Specular2      m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString specular2_id)    m_TypeUID:ri.Texture))
			if noise_on         do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Noise          m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString noise_id)        m_TypeUID:ri.Texture))
			if unknown1_on      do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Unknown1       m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString unknown1_id)     m_TypeUID:ri.Texture))
			if unknown2_on      do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Unknown2       m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString unknown2_id)     m_TypeUID:ri.Texture))
			if unknown3_on      do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Unknown3       m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString unknown3_id)     m_TypeUID:ri.Texture))
			if unknown4_on      do (append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:ps.Unknown4       m_TypeUID:pt.iTexture) m_NameUID:(m_Resource.base.convertHexString unknown4_id)     m_TypeUID:ri.Texture))
			
			
			append m_ParamTable (MaterialParam_t m_StateParam:(StateParam_t m_NameUID:pt.iRasterState m_TypeUID:pt.iRasterState) m_NameUID:raster_list[raster_type] m_TypeUID:ri.RasterState) -- iRasterState
			m_NumParams = m_ParamTable.count
			)
		
		)
	
	struct Mesh_t ( -- 272 bytes
		/*ResourceHandle_t*/ m_MaterialHandle = ResourceHandle_t(),
		/*ResourceHandle_t*/ m_VertexDeclHandle = ResourceHandle_t(), -- not located within the perm bin
		/*
			enum VertexDecl {
				CloudWisp         = 0xE7CFFC61,
				Decal             = 0x128206B2,
				Dynamic           = 0x64A43DAE,
				FBX               = 0xEE711E17,
				FBX2              = 0x5589C78D,
				GeoParticle       = 0x25586179,
				LightCard         = 0x6FA1A436,
				Lightning         = 0x0811776,
				MorphTarget,
				MultiMorphTarget,
				NC                = 0x34AB04E6,
				Particle          = 0xD7A5C4C7,
				Rain,
				ScreenParticle    = 0x3D339245,
				Skinned           = 0x276B9567,
				SkinnedDecal      = 0x23F36527,
				SkinnedUVNT       = 0xAC5D89E2,
				Slim,
				SlimUV            = 0x7E0D7533,
				UV2               = 0x27C88915,
				UV2C              = 0x7728A54B,
				UV2N              = 0x46E52398,
				UV2NC             = 0xF2E6F36B,
				UV2NT             = 0xA0B0781E,
				UV2NTC            = 0x78921EA0,
				UVC               = 0xC3BD8945,
				UVCNPacked        = 0xF0D9B822,
				UVN               = 0xF2700F96,
				UVNPacked         = 0x720788F7,
				UVNT              = 0x9BA68DBC,
				UVNTC             = 0x911E1A51,
				VehicleGlassUV2NTC= 0xD08FF31A,
				VehicleUV2NTC     = 0xBF900E9E,
				VehicleUVNTC      = 0xE234EF7A,
				WaterSurface      = 0xD3798DFD
			};
		*/
		/*ResourceHandle_t*/ m_IndexBufferHandle = ResourceHandle_t(),
		/*ResourceHandle_t*/ m_VertexBufferHandles = #(ResourceHandle_t(), ResourceHandle_t(), ResourceHandle_t(), ResourceHandle_t()),
		/*int32_t*/ m_PrimType = 3, -- Always 3
		/*
			0 = Points
			1 = Line-Strip
			2 = Lines
			3 = Triangles
			4 = Triangle-Strip
			5 = Triangle-Fan
			6 = Quads
		*/
		/*int32_t*/ m_IndexStart = 0,
		/*uint32_t*/ m_NumPrims = 0,
		/*uint8_t[4]*/ pad6 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*int64_t*/ m_Description = 0, -- Always 0
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

	struct SoftBodyData_t (
		unk30 = 0L,
		unk31 = 0L,
		unk32 = 0L,
		unk33 = 0L,
		unk34 = 0,
		unk35 = 0,
		unk36 = 0,
		unk37 = 0,
		unk38 = #(),
		unk39 = #(),
		unk40 = #(),
		unk41 = #(),
		fn read &f = (
			local pos_unk30 = ftell f
			unk30 = readLongLong f
			local pos_unk31 = ftell f
			unk31 = readLongLong f
			local pos_unk32 = ftell f
			unk32 = readLongLong f
			local pos_unk33 = ftell f
			unk33 = readLongLong f
			unk34 = readLong f #unsigned
			unk35 = readLong f #unsigned
			unk36 = readLong f #unsigned
			unk37 = readLong f #unsigned
			local i = 1
			
			unk38 = #()
			unk39 = #()
			unk40 = #()
			unk41 = #()
			
			if unk30 > 0 and unk35 > 0 do (
				fseek f (pos_unk30 + unk30) #seek_set
				unk38[unk35] = 0
				for i = 1 to unk35 do (
					unk38[i] = readShort f #unsigned
					)
				)
			
			if unk31 > 0 and unk35 > 0 do (
				fseek f (pos_unk31 + unk31) #seek_set
				unk39[unk35] = 0
				for i = 1 to unk35 do (
					unk39[i] = readShort f #unsigned
					)
				)
			
			if unk32 > 0 and unk36 > 0 do (
				fseek f (pos_unk32 + unk32) #seek_set
				unk40[unk36] = #(0, 0)
				for i = 1 to unk35 do (
					unk40[i] = #(readShort f #unsigned, readShort f #unsigned)
					)
				)
			
			if unk33 > 0 and unk37 > 0 do (
				fseek f (pos_unk33 + unk33) #seek_set
				unk40[unk36] = 0
				for i = 1 to unk35 do (
					unk40[i] = readShort f #unsigned
					)
				)
			)
		)
	
	struct ModelUser_t ( -- 16 Bytes
		/*int64_t*/ m_SoftBodyDataOffset = 0, -- Offset points to the end of the file if m_HasSoftBodyInfo = 0
		/*uint32_t*/ m_HasSoftBodyInfo = 0, -- 0=disabled, 1=enabled
		/*uint8_t[4]*/ pad9 = #(0, 0, 0, 0), -- UFG_PAD(0x4)
		/*SoftBodyData_t*/ SoftBodyData = SoftBodyData_t(),
		fn read f = (
			local pos_SoftBodyDataOffset = ftell f
			m_SoftBodyDataOffset = readLongLong f
			m_HasSoftBodyInfo = readLong f #unsigned
			local i = 1
			for i = 1 to 4 do (pad9[i] = readByte f #unsigned)
			
			if m_HasSoftBodyInfo > 0 do (
				fseek f (pos_SoftBodyDataOffset + m_SoftBodyDataOffset) #seek_set
				SoftBodyData.read(f)
				)
			),
		fn write &s = (
			writeLongLong s m_SoftBodyDataOffset
			writeLong s (m_HasSoftBodyInfo = 0) #unsigned -- I don't know how this data works, so disable data
			local i = 1
			for i = 1 to pad9.count do (
				writeByte s pad9[i] #unsigned
				)
			)
		)
	
	struct ModelData_t (
		/*
			pointers are relative to the start of the address defined for the address. (relative basically)
			
			There is reference to Morph data, but I can't find an example of this field being used. 
			Rather, the morphs seem to be hacked into the vertex buffer. 
			It's tricky since there is no indicator aside from the debug name possibly containing
			the word 'MorphTarget,' which I can't rely on since the debug names are truncated to 21 characters.
		*/
		/*ResourceData_t*/      m_Resource              = ResourceData_t(),
		/*float[3]*/            m_AABBMin               = [0.0, 0.0, 0.0],
		/*uint32_t*/            m_NumPrims              = 0,
		/*float[3]*/            m_AABBMax               = [0.0, 0.0, 0.0],
		/*uint8_t[4]*/          pad1                    = #(0, 0, 0, 0),                            -- UFG_PAD(0x4)
		/*int64_t*/             m_MaterialTableHandle   = ResourceHandle_t(),                       -- Not set here? is later defined on Mesh_t
		/*int64_t*/             m_BonePaletteHandle     = ResourceHandle_t(),
		/*int64_t*/             m_MeshOffset            = 0,
		/*uint32_t*/            m_NumMeshes             = 0,
		/*uint8_t[4]*/          pad2                    = #(0, 0, 0, 0),                            -- UFG_PAD(0x4)
		/*int64_t*/             m_ModelUserOffset       = 0,
		/*uint8_t[4]*/          pad3                    = #(0, 0, 0, 0),                            -- UFG_PAD(0x4)
		/*uint32_t*/            m_LastUsedFrameNum      = 0,                                        -- always 0
		/*uint8_t[4]*/          pad4                    = #(0, 0, 0, 0),                            -- UFG_PAD(0x4)
		/*int64_t*/             m_MemoryPool            = 0,                                        -- always 0
		/*int64_t*/             m_MorphTargetsHandle    = ResourceHandle_t(),                       -- Is never set
		/*int64_t*/             m_LocatorsHandle        = ResourceHandle_t(),                       -- Is never set
		/*uint8_t[12]*/         pad5                    = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),    -- UFG_PAD(0xC)
		/*int64_t*/             m_Value                 = 0x10,
		/*uint8_t[8]*/          pad8                    = #(0, 0, 0, 0, 0, 0, 0, 0),                -- UFG_PAD(0x8)
		/*TextureUserPlat_t*/   unk1                    = TextureUserPlat_t(),
		/*ModelUser_t*/         m_MaterialUser          = ModelUser_t(),
		/*int64_t[m_NumMeshes]*/m_MeshOffsetTable       = #(),
		/*Mesh_t[m_NumMeshes]*/ m_MeshTable             = #(),
		fn size = (104 + m_Resource.base.reserved.count + 264 + (m_NumMeshes * 280)),
		fn printHashes = (
			format "\nMaterial\tBonePalette\tMorpher\tLocator\tMaterial2\tVertexDecl\tIndexBuffer\tPosBuff\tWeightBuf\tTexcoordBuf\n"
			format "%\t%\t%\t%\n" \
				(m_Resource.base.Hash32HexString m_MaterialTableHandle.m_NameUID) \
				(m_Resource.base.Hash32HexString m_BonePaletteHandle.m_NameUID) \
				(m_Resource.base.Hash32HexString m_MorphTargetsHandle.m_NameUID) \
				(m_Resource.base.Hash32HexString m_LocatorsHandle.m_NameUID)
			
			for m in m_MeshTable do (
				format "\t\t\t\t%\t%\t%\t%\t%\t%\t%\n" \
					(m_Resource.base.Hash32HexString m.m_MaterialHandle.m_NameUID) \
					(m_Resource.base.Hash32HexString m.m_VertexDeclHandle.m_NameUID) \
					(m_Resource.base.Hash32HexString m.m_IndexBufferHandle.m_NameUID) \
					(m_Resource.base.Hash32HexString m.m_VertexBufferHandles[1].m_NameUID) \
					(m_Resource.base.Hash32HexString m.m_VertexBufferHandles[2].m_NameUID) \
					(m_Resource.base.Hash32HexString m.m_VertexBufferHandles[3].m_NameUID) \
					(m_Resource.base.Hash32HexString m.m_VertexBufferHandles[4].m_NameUID)
				)
			),
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
				
				m_Value = readLongLong f -- address for 'unk1'
				pad8 = #(
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
				
				--printHashes()
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
			m_Value = 16
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
			
			writeLongLong s m_Value
			for i = 1 to pad8.count do (
				writeByte s pad8[i] #unsigned
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
												parentBoneHashes[j] = readLong f #unsigned -- hash
												parentBoneInices[j] = readLong f #unsigned -- bone index, in relation to the name
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
		fn build mscale:39.3701 useColors:true = (
			
			
			
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
				boneArray[i].wirecolor = color 174 186 203
				
				--local bone_index = findItem parentBoneInices (i - 1)
				--boneArray[i].name = ("0x" + (subString (n = "00000000" + (toUpper(bit.IntAsHex parentBoneHashes[bone_index]))) (n.count - 7) 8)) + " " + boneNames[i]
				--boneArray[i].name = ("0x" + (subString (n = "00000000" + (toUpper(bit.IntAsHex boneHashes[i]))) (n.count - 7) 8)) + " " + boneNames[i]
				
				--local n = ""
				setUserProp boneArray[i] "UID" boneHashes[i]
				
				)
			
			local parent_index = 0
			for i = 1 to bone_count do (
				parent_index = parent_indices[i] + 1
				if parent_index > 0 then (
					boneArray[i].transform *= boneArray[parent_index].transform
					boneArray[i].parent = boneArray[parent_index]
					)
				)
			
			-- color bones to classic biped
			if useColors do (
				for i = 1 to bone_count do (
					
					boneArray[i].wirecolor = (color 224 198 87)
					if matchPattern boneNames[i] pattern:"*Head*" then (
						boneArray[i].wirecolor = color 166 202 240
						)
					else if matchPattern boneNames[i] pattern:"*Spine*" or matchPattern boneNames[i] pattern:"*Neck*" then (
						boneArray[i].wirecolor = color 8 110 134
						)
					
					if abs boneArray[i].position.x > 0.01 do (
						if boneArray[i].position.x < 0.0 then (
							boneArray[i].wirecolor = color 6 134 6
							if matchPattern boneNames[i] pattern:"*Finger0*" or matchPattern boneNames[i] pattern:"*Thumb*" then (
								boneArray[i].wirecolor = color 224 198 87
								)
							else if matchPattern boneNames[i] pattern:"*Finger*" do (
								boneArray[i].wirecolor = color 113 134 6
								)
							)
						else (
							boneArray[i].wirecolor = color 28 28 177
							if matchPattern boneNames[i] pattern:"*Finger0*" or matchPattern boneNames[i] pattern:"*Thumb*" then (
								boneArray[i].wirecolor = color 134 6 6
								)
							else if matchPattern boneNames[i] pattern:"*Finger*" do (
								boneArray[i].wirecolor = color 108 8 136
								)
							)
						
						)
					if matchPattern boneNames[i] pattern:"*face*" then (
						boneArray[i].wirecolor = color 166 202 240
						)
					else if matchPattern boneNames[i] pattern:"*Direction*" or matchPattern boneNames[i] pattern:"*Sync*" then (
						boneArray[i].wirecolor = color 115 115 115
						)
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
		
		fn read file verbose:false = (
			local f = try(fopen file "rb")catch(undefined)
			if verbose do format "File:\t%\n" file
			if f != undefined then (
				
				fseek f 0 #seek_end
				local fsize = ftell f
				fseek f 0 #seek_set
				local BufferDataAddrs = #() -- the buffer can't be prased without reading the vertex declare from the ModelData first.
				local BufferDataHeader = #()
				local BufferDataFormat = #()
				local res = ResourceData_t()
				local pos = 0
				local r = ResourceType_t()
				while (pos = ftell f) + 16 < fsize do (
					res = ResourceData_t()
					if not res.read(f) do (
						format "Error: Unsupported file {%}\n" file
						exit
						)
					fseek f pos #seek_set
					case res.base.m_TypeUID of (
						(r.Rig): ( -- SkeletonData_t
							local skl = SkeletonData_t()
							skl.read(f)
							append SkeletonData skl
							append index #(#rig, SkeletonData.count)
							if verbose do format "\t%: %\t%\t% \t%\n" index.count "SKELETON     " (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) skl.m_Resource.m_DebugName
							skl = undefined
							)
						(r.ModelData): ( -- ModelData_t
							local mdl = ModelData_t()
							mdl.read(f)
							append ModelData mdl
							append index #(#model, ModelData.count)
							if verbose do format "\t%: %\t%\t% \t%\n" index.count "MODEL DATA   " (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) mdl.m_Resource.m_DebugName
							mdl = undefined
							)
						(r.Material): ( -- Material_t
							local mat = Material_t()
							mat.read(f)
							append MaterialData mat
							append index (#(#material, MaterialData.count))
							if verbose do format "\t%: %\t%\t% \t%\n" index.count "MATERIAL     " (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) mat.m_Resource.m_DebugName
							mat = undefined
							)
						(r.Buffer): ( -- Buffer_t
							
							if verbose then (
								
								local buf = Buffer_t()
								buf.read(f)
								append BufferData buf
								append index (#(#buffer, BufferData.count))
								
								format "\t%: %\t%\t% \t%\n" index.count (subString ((toUpper (buf.buffer_kind())) + "             ") 1 13) (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) buf.m_Resource.m_DebugName
								
								buf = undefined
								)
							else (
								append BufferDataAddrs (ftell f)
								append BufferDataHeader res
								append BufferDataFormat #(0, 0) -- placeholder
								append index (#(#buffer, (BufferData.count + BufferDataAddrs.count)))
								

								)
							)
						(r.BonePalette): ( -- BonePallete_t
							local pal = BonePallete_t()
							pal.read(f)
							append BonePalleteData pal
							append index #(#pallete, BonePalleteData.count)
							if verbose do format "\t%: %\t%\t% \t%\n" index.count "BONE PALETTE " (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) pal.m_Resource.m_DebugName
							pal = undefined
							)
						--  r.Texture  -- Texture_t
						(r.Texture): if verbose do format "\t%: %\t%\t% \t%\n" index.count "TEXTURE      " (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) res.m_DebugName
						default: (
							local dat = byteArray()
							dat.readFromStream f fsize:(res.size())
							append Data dat
							append index #(#data, Data.count)
							if verbose do format "\t%: %\t%\t% \t%\n" index.count "UNKNWOWN     " (res.base.Hash32HexString res.m_ChunkUID) (res.base.Hash32HexString res.base.m_TypeUID) res.m_DebugName
							dat = undefined
							)
						)
					fseek f (pos + res.size()) #seek_set
					)
				
				if not verbose do (
					-- Parse all ModelData in order to type the vertex buffers
					for mdl in ModelData do (
						for msh in mdl.m_MeshTable do (
							
							for b = 1 to BufferDataHeader.count do (
								if msh.m_IndexBufferHandle.m_NameUID == BufferDataHeader[b].m_NameUID do (
									BufferDataFormat[b] = #(0, -1)
									)
								)
							
							
							for b = 1 to BufferDataHeader.count do (
								for v = 1 to msh.m_VertexBufferHandles.count do (
									if msh.m_VertexBufferHandles[v].m_NameUID == BufferDataHeader[b].m_NameUID do (
										BufferDataFormat[b] = #(v - 1, msh.m_VertexDeclHandle.m_NameUID)
										)
									)
								)
							)
						)
					
					-- Read Buffers
					for i = 1 to BufferDataHeader.count do (
						fseek f BufferDataAddrs[i] #seek_set
						
						local buf = Buffer_t vertDeclIndex:BufferDataFormat[i][1] vertDeclType:BufferDataFormat[i][2]
						
						if buf.vertDeclType == -1 do (
							buf.m_Type = 1
							vertDeclType = 0
							)
						
						buf.read(f)
						append BufferData buf
						buf = undefined
						)
					)
				fclose f
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
				write(&s)
				fclose s
				)
			else (
				format "failed to open file {%}\n" file
				)
			),
		fn build mscale:39.3701 impNormals:true impSkin:false impColors:false impMorphs:true = (
			
			max modify mode
			
			if SkeletonData.count > 0 do (
				SkeletonData[1].build mscale:mscale
				)
			
			local mdl = ModelData_t()
			local vcolorArray = #()
			local morphArray = #()
			for mdl in ModelData do (
				local vbuf_indices = #()
				local vbuf_counts = #()
				
				-- Get the bonePalete
				local bonePalette = undefined
				local pal = BonePallete_t()
				for pal in BonePalleteData where pal.m_Resource.m_NameUID == mdl.m_BonePaletteHandle.m_NameUID do (
					bonePalette = pal
					exit
					)
				
				local obj = Mesh_t()
				local matid = 1
				local vpos = 0
				local faceArray = #()
				local matidArray = #()
				local boneidArray = #()
				local weightArray = #()
				local vertArray = #()
				local normArray = #()
				local uvw0Array = #()
				local mat = undefined
				
				
				if mdl.m_MeshTable.count > 0 do (
					mat = MultiMaterial numsubs:mdl.m_MeshTable.count
					)
				
				
				-- Combine SubMeshes into a Single Mesh Object
				local isMorphTarget = true
				for obj in mdl.m_MeshTable do (
					
					-- Get the Material
					local m = Material_t()
					
					for m in MaterialData where m.m_Resource.m_NameUID == obj.m_MaterialHandle.m_NameUID do (
						
						-- Create a StandardMaterial with Custom Material Attributes
						mat.materialList[matid] = m.setSceneMaterial()
						
						-- Ensure that the diffuse color is random for testing
						--mat.materialList[matid].shaderType = 1 -- Metal?
						--mat.materialList[matid].diffuse = random white black
						
						
						--mat.materialList[matid].ishader_type = 2
						
						local matName = mat.materialList[matid].name
						local matNameS = filterString matName "|"
						if matNameS.count > 1 then (
							-- they truncate the name after 21 characters I think, so some of the info may be missing
							
							-- first element is name of the sub material
							mat.name = matNameS[1]
							local matNameIndex = findString matNameS[1] " "
							if matNameIndex != undefined and matNameIndex > 1 do (
								
								mat.names[matid] = subString mat.name 1 (matNameIndex - 1)
								mat.name = subString mat.name (matNameIndex + 1) -1
								)
							
							-- second element is the mat index
							if matNameS.count >= 2 do (
								local matNum = try(matNameS[2] as integer)catch(undefined)
								if matNum != undefined do (
									-- hmm this goes out of bounds, maybe its just the original material id order?
									--mat.materialIDList[matid] = matNum + 1
									)
								)
							
							-- third element is the sub material name
							if matNameS.count >= 3 do (
								mat.materialList[matid].name = matNameS[3]
								)
							)
						else (
							local matNameIndex = findString matName " "
							if matNameIndex != undefined and matNameIndex > 1 do (
								
								mat.names[matid] = subString matName 1 (matNameIndex - 1)
								--mat.name = subString matName (matNameIndex + 1) -1
								mat.materialList[matid].name = subString matName (matNameIndex + 1) -1
								)
							)
						exit
						)
					
					-- Get Buffers
					local indexBuffer = 0
					local vertBuffer0 = 0
					local vertBuffer1 = 0
					local vertBuffer2 = 0
					local vertBuffer3 = 0
					local b = 1
					
-- 					if (obj.m_VertexDeclHandle.m_NameUID == 661362023 or obj.m_VertexDeclHandle.m_NameUID == -227537002) then (
-- 						-- Skinned Mesh
-- 						format "SKINNED MESH\n\n"
-- 						)
-- 					else if obj.m_VertexDeclHandle.m_NameUID == -1403155998 then (
-- 						-- UVs?
-- 						format "UV MESH\n\n"
-- 						)
					
					for b = 1 to BufferData.count do (
						if BufferData[b].m_Resource.m_NameUID == obj.m_IndexBufferHandle.m_NameUID then (
							indexBuffer = b
							)
						else if BufferData[b].m_Resource.m_NameUID == obj.m_VertexBufferHandles[1].m_NameUID then (
							vertBuffer0 = b -- Positions
							--if matchPattern BufferData[b].m_Resource.m_DebugName pattern:"*phTarget*" do (
							--	impColors = true
							--	)
							)
						else if BufferData[b].m_Resource.m_NameUID == obj.m_VertexBufferHandles[2].m_NameUID then (
							vertBuffer1 = b -- Weights
							)
						else if BufferData[b].m_Resource.m_NameUID == obj.m_VertexBufferHandles[3].m_NameUID then (
							vertBuffer2 = b -- UV's
							)
						else if BufferData[b].m_Resource.m_NameUID == obj.m_VertexBufferHandles[4].m_NameUID then (
							vertBuffer3 = b
							)
						)
-- 					format "indexBuffer: \t%\n" indexBuffer
-- 					format "vertBuffer0: \t%\n" vertBuffer0
-- 					format "vertBuffer1: \t%\n" vertBuffer1
-- 					format "vertBuffer2: \t%\n" vertBuffer2
-- 					format "vertBuffer3: \t%\n" vertBuffer3
-- 					
-- 					if indexBuffer > 0 do format "indexBuffer.m_Index: \t%\n" BufferData[indexBuffer].m_Index
-- 					if vertBuffer0 > 0 do format "vertBuffer0.m_Index: \t%\n" BufferData[vertBuffer0].m_Index
-- 					if vertBuffer1 > 0 do format "vertBuffer1.m_Index: \t%\n" BufferData[vertBuffer1].m_Index
-- 					if vertBuffer2 > 0 do format "vertBuffer2.m_Index: \t%\n" BufferData[vertBuffer2].m_Index
-- 					if vertBuffer3 > 0 do format "vertBuffer3.m_Index: \t%\n" BufferData[vertBuffer3].m_Index
-- 					format "\n"
					
					local vbuf_index = findItem vbuf_indices vertBuffer0
					
					if vbuf_index == 0 do (
						
						--print "CReating New Buffer"
						
						-- New Vertex Buffer, probably need to accumlate the two vertex buffers?
						append vbuf_indices vertBuffer0
						append vbuf_counts vpos
						vbuf_index = vbuf_counts.count
						
						
						
						-- need to capture vertices
						local vertex_count = BufferData[vertBuffer0].m_NumElements
						local d = VertexDecl_t()
						if BufferData[vertBuffer0].vertDeclType != d.MorphTarget do (
							isMorphTarget = false
							)
						
						
						--format "isMorphTarget: \t%\n" isMorphTarget
						
						if vertex_count > 0 do (
							
							/*
								in the parsing I already added +1 to make the boneid's a base-1 to work with 3ds max
								and weights already changed from ints to floats
								
								otherwise I would have done it here
							*/
							
							
							
							--
							-- Copy Positions
							if vertBuffer0 > 0 then (
								for v = 1 to vertex_count do (
									append vertArray ([BufferData[vertBuffer0].m_Buffer[v].m_Position[1], BufferData[vertBuffer0].m_Buffer[v].m_Position[2], BufferData[vertBuffer0].m_Buffer[v].m_Position[3]] * mscale)
									append normArray [BufferData[vertBuffer0].m_Buffer[v].m_Normal[1], BufferData[vertBuffer0].m_Buffer[v].m_Normal[2], BufferData[vertBuffer0].m_Buffer[v].m_Normal[3]]
									)
								)
							else (
								for v = 1 to vertex_count do (
									append vertArray [0.0, 0.0, 0.0]
									)
								)
							
							-- Copy Weights
							local v = 1
							if vertBuffer1 > 0 then (
								for v = 1 to vertex_count do (
									append boneidArray BufferData[vertBuffer1].m_Buffer[v].m_BoneID
									append weightArray BufferData[vertBuffer1].m_Buffer[v].m_Weight
									)
								)
							else (
								for v = 1 to vertex_count do (
									append boneidArray (#(1,0,0,0))
									append weightArray (#(1.0,0.0,0.0,0.0))
									)
								)
							
							-- Copy UVs
							if vertBuffer2 > 0 then (
								for v = 1 to vertex_count do (
									append uvw0Array [BufferData[vertBuffer2].m_Buffer[v].m_TexCoord0[1], 1.0-BufferData[vertBuffer2].m_Buffer[v].m_TexCoord0[2], 0.0]
									)
								)
							else (
								for v = 1 to vertex_count do (
									append uvw0Array [0.0, 0.0, 0.0]
									)
								)
							
							
							vpos += vertex_count
							)
						
						)
					
					if indexBuffer > 0 do (
						local v = 1, x = 1, k = 1, face = [1,1,1]
						for v = 1 to obj.m_NumPrims do (
							k = ((v - 1) * 3) + obj.m_IndexStart
							face = [1,1,1]
							for x = 1 to 3 do (
								face[x] = BufferData[indexBuffer].m_Buffer[k + x] + 1 + vbuf_counts[vbuf_index] -- offset the index to a base of 1 to work with 3dsmax
								)
							append faceArray face
							append matidArray matid
							)
						)
					
					
					matid += 1
					)
				
				
				local msh = mesh vertices:vertArray tverts:uvw0Array faces:faceArray materialIds:matidArray
				buildTVFaces msh
				local i = 1
				for i = 1 to faceArray.count do (setTVFace msh i faceArray[i])
				
				msh.material = mat
				msh.backfacecull = on
				msh.displayByLayer = false
				msh.wirecolor = random (color 0 0 0) (color 255 255 255)
				msh.name = (mdl.m_Resource.base.Hash32HexString mdl.m_Resource.m_NameUID) + " " + mdl.m_Resource.m_DebugName
				
				for i = 1 to msh.numfaces do setFaceSmoothGroup msh i 1
				
				--format "MESH: \t%\n" msh.name
				
				update msh
				select msh
				
				if impColors and vcolorArray.count > 0 do (
					
					
					
					
					setNumCPVVerts msh vertArray.count
					defaultVCFaces msh
					local vc
					local clonedMesh = #()
					
					for vc = 1 to vcolorArray.count do (
						
						
						if maxOps.CloneNodes msh offset:[-20*vc, 0, 0]cloneType:#copy newNodes:&clonedMesh do (
							
							
							
							-- Store current modifiers
							--local modifiersBackup = #()
							--for m in msh.modifiers do (
							--	append modifiersBackup m
							--	)
							
							-- Remove all modifiers temporarily
							--while msh.modifiers.count > 0 do (
							--	deleteModifier msh msh.modifiers[1]
							--	)
							
							
							local colorArray = vcolorArray[vc][2]
							local illumArray = vcolorArray[vc][3]
							for v = 1 to colorArray.count do (setVertColor clonedMesh[1] v colorArray[i]) -- Color
							for v = 1 to illumArray.count do (meshop.setVertColor clonedMesh[1] -1 v illumArray[v]) -- Illum Color
							
							--for i = 1 to colorArray.count do (meshop.setMapVert msh -2 i ([0.0, 0.0, 0.0] + (colorArray[i].alpha / 255.0))) -- Alpha
							--for i = 1 to faceArray.count do (setVCFace msh i faceArray[i])
							
							
							local vcolMod = VertexPaint()
							addmodifier clonedMesh[1] vcolMod-- ui:off
							clonedMesh[1].showVertexColors = on
							--vcolMod.MergeVertexColors clonedMesh[1]
							--modPanel.setCurrentObject vcolMod
							--local vps = vcolMod.AcquirePaintState msh
							--vcolMod.MergeVertexColors msh
							--vcolMod.ApplyPaintState msh vps
							--vcolMod.ReleasePaintState msh vps
							
							-- Reapply the stored modifiers
							--for m in modifiersBackup do (
							--	addModifier msh m
							--	)

							
							)
						
						
						
						)
					
					
					
					vcolorArray = #()
					)
				
				if impSkin and bonePalette != undefined and bonePalette.m_NumBones > 0 do (
					
					-- build skeleton
					local boneArray = #()
					boneArray[bonePalette.m_NumBones] = undefined
					local n = 1
					for n = 1 to bonePalette.m_NumBones do (
						boneArray[n] = getNodeByName bonePalette.m_BoneNameTable[n]
						if boneArray[n] == undefined do (
							boneArray[n] = Dummy boxsize:[0.02, 0.02, 0.02]
							boneArray[n].name = bonePalette.m_BoneNameTable[n]
							setUserProp boneArray[n] "UID" bonePalette.m_BoneFullUIDTable[n]
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
					local index_success = true
					for i = 1 to vertArray.count do (
						bi = #()
						bw = #()
						for ii = 1 to numBones do (
							if weightArray[i][ii] < 0.000001 do continue
							bone_index = findItem bonePalette.m_BoneIndexTable boneidArray[i][ii]
							if bone_index == 0 do (
								index_success = false
								bone_index = 1
								)
							append bi boneMap[bone_index]
							append bw weightArray[i][ii]
							)
						skinOps.ReplaceVertexWeights skinMod i bi bw
						)
					if skinOps.isWeightToolOpen skinMod == 0 do (
						skinOps.WeightTool skinMod
						)
					skinMod.filter_vertices = on
					
					)
				
				if impMorphs do (
					if isMorphTarget then (
						append morphArray msh
						)
					else if morphArray.count > 0 then (
						local morph_index = 1
						local morMod = undefined
						for i = 1 to morphArray.count do (
							if morphArray[i] == undefined do continue
							if morphArray[i].numverts == msh.numverts and msh.numverts > 0 do (
								if morMod == undefined do (
									morMod = Morpher()
									addModifier msh morMod
									)
								
								local morVerts = #()
								morVerts[msh.numverts] = [0.0, 0.0, 0.0]
								for x = 1 to msh.numverts do (
									
									local vert = getVert msh x
									local offset = getVert morphArray[i] x
									
									morVerts[x] = vert + offset
									)
								local tar = mesh vertices:morVerts faces:#()
								WM3_MC_BuildFromNode morMod morph_index tar
								WM3_MC_SetName morMod morph_index morphArray[i].name
								delete tar
								delete morphArray[i]
								morph_index += 1
								morphArray[i] = undefined
								)
							)
						)
					)
				
				if impNormals do (
					local normID = #{}
					local normMod = Edit_Normals()
					addmodifier msh normMod ui:off
					normMod.selectBy = 1
					normMod.displayLength = 0.0254 * mscale
					
					--normMod.MakeExplicit selection:#{1..(normArray.count)}
					
					normID = #{}
					--apply normals
					local i = 1, ii = 1
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
				
				)
			),
		fn getVertexID_FNVa inputArray = ( -- FNVa Hash
			local fnvPrime = 16777619
			local offsetBasis = -2128831035
			local hash = offsetBasis
			for val in inputArray do (
				for i = 0 to 3 do (
					local intVal = bit.floatAsInt val
					local shiftedVal = bit.shift intVal (-8 * i)
					local byte = bit.and shiftedVal 0xFF
					hash = bit.xor hash byte
					local product = hash * fnvPrime
					hash = bit.and product -1
					)
				)
			hash
			),
		fn getVertexID inputArray = (
			/*
				was getting collisions with the hash, it might not even be any faster then just doing a string compare
			*/
			local str = ""
			for v in inputArray do (str += bit.IntAsHex(bit.floatAsInt v))
			str
			),
		fn export selectionOnly:false mscale:0.0254 optimizeVerts:false = (
			
			max modify mode
			
			-- Collect Scene Objects
			local sceneObjects = #()
			if selectionOnly then (sceneObjects = selection as array)
			else (sceneObjects = objects as array)
			
			-- Collect Only Mesh Objects
			local meshObjects = for o in sceneObjects where (findItem (#(Editable_mesh, Editable_Poly, PolyMeshObject)) (classOf o)) > 0 collect o
			
			-- Check there are models to process
			if meshObjects.count > 0 then (
				
				-- Ensure previous Resources are deleted
				SkeletonData = #()
				ModelData = #()
				MaterialData = #()
				BufferData = #()
				BonePalleteData = #()
				Data = #()
				index = #()
				
				-- Enumerators
				local rt = ResourceType_t()
				local ri = ResourceInventory_t()
				local vd = VertexDecl_t()
				
				for o in meshObjects do (
					
					-- Get Snapshot, which will collaspe the modifier and triangulate mesh
					local tmesh = snapshotAsMesh o
					
					-- Get Face Count
					local face_count = tmesh.numfaces
					if face_count > 0 do (
						
						-- Initialize arrays
						local vertArray = #()
						local normArray = #()
						local binormArray = #()
						local tangArray = #()
						local boneidArray = #()
						local weightArray = #()
						local uvs0Array = #()
						local faceArray = #()
						local morArray = #()
						local normArrayM = #()
						local aabbArrayM = #()
						local matArray = #()
						local tfm = o.transform.rotationPart as matrix3
						local boneArray = #()
						local boneNames = #()
						
						-- Dimension Arrays
						faceArray[face_count] = [1, 1 ,1]
						vertArray[face_count * 3] = [0.0, 0.0, 0.0]
						uvs0Array[face_count * 3] = [0.0, 0.0, 0.0]
						normArray[face_count * 3] = [0.0, 0.0, 0.0]
						binormArray[face_count * 3] = [0.0, 0.0, 0.0]
						tangArray[face_count * 3] = [0.0, 0.0, 0.0]
						weightArray[face_count * 3] = #(1.0, 0.0, 0.0, 0.0)
						boneidArray[face_count * 3] = #(1, 0, 0, 0)
						
						-- Read Faces
						for i = 1 to face_count do (
							faceArray[i] = getFace tmesh i
							)
						
						-- Read Positions
						local v = 0
						for i = 1 to face_count do (
							for ii = 1 to 3 do (
								vertArray[v + ii] = getVert tmesh faceArray[i][ii]
								)
							v += 3
							)
						
						-- Read Texture Coordinates
						v = 0
						for i = 1 to face_count do (
							local tvface = getTVFace tmesh i
							for ii = 1 to 3 do (
								uvs0Array[v + ii] = getTVert tmesh tvface[ii]
								--uvs0Array[v + ii] = [uvs0Array[v + ii][1], 1.0 - uvs0Array[v + ii][2], 0.0]
								)
							v += 3
							)
						
						
						-- Read Blend Weights
						local pal = BonePallete_t m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.BonePalette) m_ChunkUID:ri.BonePalette)
						
						local wvArray = #()
						local biArray = #()
						local maxInfluences = 4
						local skin_modifier = o.modifiers[#Skin]
						if skin_modifier != undefined and o.numverts > 0 then (
							select o
							modPanel.setCurrentObject skin_modifier
							local numSkinBones = skinOps.GetNumberBones skin_modifier
							local skinBoneNames = #()
							if numSkinBones > 0 do (
								skinBoneNames[numSkinBones] = ""
								)
							for i = 1 to numSkinBones do (
								skinBoneNames[i] = skinOps.GetBoneName skin_modifier i 0
								local b = getNodeByName skinBoneNames[i]
								local bone_index = findItem boneArray b
								if bone_index == 0 do (
									append boneNames skinBoneNames[i]
									append boneArray b
									bone_index = boneArray.count
									
									pal.m_NumBones += 1
									append pal.m_BoneIndexTable (bone_index - 1)
									append pal.m_BoneNameTable skinBoneNames[i]
									local nameHash = pal.m_Resource.base.StringHash32 (toUpper skinBoneNames[i])
									--local nameHash = getUserProp o "UID"
									
									append pal.m_BoneUIDTable nameHash
									append pal.m_BoneFullUIDTable nameHash
									
									)
								)
							-- Initialize weight and bone arrays for the object
							wvArray[o.numverts] = #()
							biArray[o.numverts] = #()
							
							for i = 1 to o.numverts do (
								local wv = #()
								local bi = #()
								local numBoneWeights = skinOps.GetVertexWeightCount skin_modifier i
								
								if numBoneWeights > 0 then (
									for ii = 1 to numBoneWeights do (
										local weight = skinops.GetVertexWeight skin_modifier i ii
										local boneID = skinOps.GetVertexWeightBoneID skin_modifier i ii
										if boneID > 0 then (
											boneID = findItem boneNames skinBoneNames[boneID]
											)
										else (
											boneID = 1
											)
										boneID -= 1
										append wv weight
										append bi boneID
										)
									)
								else (
									bi = #(0)
									wv = #(1.0)
									)
								
								-- If the number of weights exceeds the maximum influences
								while wv.count > maxInfluences do (
									-- Custom bubble sort to sort weights and corresponding bones by weight
									for j = 1 to wv.count - 1 do (
										for k = 1 to wv.count - j do (
											if wv[k] > wv[k + 1] do (
												swap wv[k] wv[k + 1]
												swap bi[k] bi[k + 1]
												)
											)
										)
									
									-- Remove the smallest weight and distribute it among the remaining weights
									local removedWeight = wv[1]
									for k = 2 to wv.count do (
										wv[k] += removedWeight / (wv.count - 1)
										)
									deleteItem wv 1
									deleteItem bi 1
									)
								
								-- Normalize weights to ensure they sum to 1.0
								local totalWeight = 0.0
								for weight in wv do (
									totalWeight += weight
									)
								if totalWeight != 1.0 do (
									for j = 1 to wv.count do (
										wv[j] /= totalWeight
										)
									)
								
								wvArray[i] = wv
								biArray[i] = bi
								)
							)
						else (
							-- No Weights, Add the mesh as a bone, and weight it to the bone
							append boneNames o.name
							append boneArray o
							wvArray[o.numverts] = #()
							biArray[o.numverts] = #()
							for i = 1 to o.numverts do wvArray[i] = #(1.0)
							for i = 1 to o.numverts do biArray[i] = #(1)
							
							pal.m_NumBones += 1
							append pal.m_BoneIndexTable (boneNames.count - 1)
							append pal.m_BoneNameTable o.name
							local nameHash = pal.m_Resource.base.StringHash32 o.name
							append pal.m_BoneUIDTable nameHash
							append pal.m_BoneFullUIDTable nameHash
							)
						
						-- The rest needs to be accessed from the modifiers, I'll add a editable mesh mod to triangulate the mesh
						local normal_modifier = Edit_Normals() -- spawn modifier
						local mesh_modifier = Edit_Mesh() -- spawn modifier
						
						-- Apply Modifiers to access the vertex normals, delete after
						addModifier o mesh_modifier -- triangulate
						addModifier o normal_modifier -- normals
						
						-- Read Normals
						modPanel.setCurrentObject normal_modifier -- select modifier
						for ii = 1 to face_count do (
							for iii = 1 to 3 do (
								normArray[((ii - 1) * 3) + iii] = (
									normalize (
										(transMatrix (
											normal_modifier.GetNormal (normal_modifier.GetNormalID ii iii)
											)) * tfm
										).row4
									)
								)
							)
						
						
						-- Generate Tangents from Normals and UV's
						v = 0
						for i = 1 to face_count do (
							-- Edge Delta
							local dV1 = vertArray[v + 1] - vertArray[v + 2]
							local dV2 = vertArray[v + 1] - vertArray[v + 3]
							
							-- UV Delta
							local dUV1 = (uvs0Array[v + 1] + [0.0, 1.0, 0.0]) - (uvs0Array[v + 2] + [0.0, 1.0, 0.0])
							local dUV2 = (uvs0Array[v + 1] + [0.0, 1.0, 0.0]) - (uvs0Array[v + 3] + [0.0, 1.0, 0.0])
							
							-- UV Direction, 'Handedness'
							local sign = if (dUV1.x * dUV2.y - dUV1.y * dUV2.x) < 0 then -1 else 1
							
							-- Fractional or Handedness?
							local fac = 1.0 / (dUV1.x * dUV2.y - dUV2.x * dUV1.y)-- * sign
							
							-- Calculate Tangent
							local tangent = [
								fac * (dUV2.y * dV1.x - dUV1.y * dV2.x), \
								fac * (dUV2.y * dV1.y - dUV1.y * dV2.y), \
								fac * (dUV2.y * dV1.z - dUV1.y * dV2.z) \
								]
							
							-- Bi-Normal
							local binormal = [
								fac * (-dUV2.x * dV1.x + dUV1.x * dV2.x), \
								fac * (-dUV2.x * dV1.y + dUV1.x * dV2.y), \
								fac * (-dUV2.x * dV1.z + dUV1.x * dV2.z) \
								]
							
							for ii = 1 to 3 do (
								-- orthonormalized tangent space
								local normal = normArray[v + ii]
								local t = tangent - normal * (dot tangent normal)    -- orthonormalization of the tangent vectors
								local b = binormal - normal * (dot binormal normal)  -- orthonormalization of the binormal vectors to the normal vector 
								b = normalize (b - t * (dot b t ))                   -- orthonormalization of the binormal vectors to the tangent vector
								t = normalize t
								tangArray[v + ii] = t
								binormArray[v + ii] = b
								)
							v += 3
							)
						
						
						-- Read Morph Targets
						local mBuf = #()
						for morphMod in o.modifiers where classOf morphMod == Morpher do (
							
							-- activate morpher
							select o
							modPanel.setCurrentObject morphMod
							
							-- Loop Through the 100 morpher Channels
							for m = 1 to 100 do (
								
								-- Skip if no vertices in morpher
								if WM3_MC_NumMPts morphMod m == 0 do continue
								
								local morphBuf = Buffer_t m_Type:0 m_ElementSize:8 vertDeclType:vd.MorphTarget m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.Buffer) m_ChunkUID:ri.Buffer)
								morphBuf.m_Resource.setDebugName ((WM3_MC_GetName morphMod m) + ".VertexDecl.MorphTarget.0.0.0")
								
								append mBuf morphBuf
								
								-- Get Existing Target Value
								local morValue = WM3_MC_GetValue morphMod m
								
								-- Set Target Value to Max (100)
								WM3_MC_SetValue morphMod m 100.0
								
								-- Convert Mesh to Memory Object (t)
								local mt = snapshotAsMesh o
								
								-- Reset Arrays
								local morph_verts = #()	-- Temp Buffer to Store Positions
								local morph_norms = #() -- Temp Buffer to Store Normals
								morph_verts[face_count * 3] = [0.0, 0.0, 0.0]
								morph_norms[face_count * 3] = [0.0, 0.0, 0.0]
								
								-- select modifier
								modPanel.setCurrentObject normal_modifier
								
								-- Read the normals
								for ii = 1 to face_count do (
									for iii = 1 to 3 do (
										morph_norms[((ii - 1) * 3) + iii] = (
											normalize (
												(transMatrix (
													normal_modifier.GetNormal (normal_modifier.GetNormalID ii iii)
													)) * tfm
												).row4
											)
										morph_norms[((ii - 1) * 3) + iii] -= normArray[((ii - 1) * 3) + iii]
										)
									)
								
								-- Read the positions
								v = 0
								for ii = 1 to face_count do (
									for iii = 1 to 3 do (
										morph_verts[((ii - 1) * 3) + iii] = getVert mt faceArray[ii][iii]
										morph_verts[((ii - 1) * 3) + iii] -= vertArray[((ii - 1) * 3) + iii]
										)
									v += 3
									)
								
								-- return target value back to original value
								modPanel.setCurrentObject morphMod
								WM3_MC_SetValue morphMod m morValue
								
								
								append morArray morph_verts
								append normArrayM morph_norms
								append aabbArrayM #(o.min, o.max)
								
								-- remove mesh memory object
								delete mt
								)
							)
						
						
						
						-- Remove modifiers needed to capture the vertex normals
						deleteModifier o mesh_modifier
						deleteModifier o normal_modifier
						
						
						local index_start = index.count + 1
						
						-- Store bone Pallete
						append BonePalleteData pal
						
						-- Update Resource Hierarchy
						append index #(#pallete, BonePalleteData.count)
						
						-- Collect Materials
						local matCount = 1
						local objMaterials = #(undefined)
						if classOf o.material == MultiMaterial then (
							if o.material.numsubs > 0 do (
								matCount = o.material.numsubs
								objMaterials = o.material
								)
							) else (objMaterials = #(o.material))
						
						-- Create a Resource Object
						local mdl = ModelData_t m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.ModelData) m_ChunkUID:ri.ModelData)
						local model_name = mdl.m_Resource.setDebugName o.name
						
						mdl.m_AABBMin = o.min * mscale
						mdl.m_AABBMax = o.max * mscale
						mdl.m_NumPrims = face_count
						pal.m_Resource.setDebugName (model_name + ".BonePalette")
						mdl.m_BonePaletteHandle.m_NameUID = pal.m_Resource.m_NameUID
						mdl.m_NumMeshes = matCount
						
						
						-- Dimension SubMesh Objects
						mdl.m_MeshTable = #()
						mdl.m_MeshTable[matCount] = Mesh_t()
						
						
						-- Create Geoemtry Buffer Objects
						local face_size = 2
						if face_count > 0xFFFF do (face_size = 4)
						local ibuf = Buffer_t m_Type:1 m_ElementSize:face_size m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.Buffer) m_ChunkUID:ri.Buffer)
						local vbuf0 = Buffer_t m_Type:0 m_ElementSize:24 vertDeclType:vd.Skinned vertDeclIndex:0 m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.Buffer) m_ChunkUID:ri.Buffer)
						local vbuf1 = Buffer_t m_Type:0 m_ElementSize:8 vertDeclType:vd.Skinned vertDeclIndex:1 m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.Buffer) m_ChunkUID:ri.Buffer)
						local vbuf2 = Buffer_t m_Type:0 m_ElementSize:4 vertDeclType:vd.Skinned vertDeclIndex:2 m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.Buffer) m_ChunkUID:ri.Buffer)
						ibuf.m_Resource.setDebugName (model_name + ".IndexBuffer")
						vbuf0.m_Resource.setDebugName (model_name + ".VertexBufferDecl.Skinned.0.0")
						vbuf1.m_Resource.setDebugName (model_name + ".VertexBufferDecl.Skinned.1.0")
						vbuf2.m_Resource.setDebugName (model_name + ".VertexBufferDecl.Skinned.2.0")
						
						
						-- Sort Components By Material Face ID
						local faceSel = #{1..(face_count)} -- Set faces that are to be read to bit array
						
						
						-- loop through each material, check for relating mat id agasint each face material index
						v = 0 -- set vertex index
						local face_index = 0 -- keep track of the face start position
						local vert_index = 0 -- keep track of the face start position
						for m = 1 to matCount do (
							
							
							-- Generate Name for Material
							local matHashID = try(objMaterials.names[m] + " ")catch("")
							local matName = "Material #" + (m as string)
							if classOf objMaterials[m] == StandardMaterial or classOf objMaterials[m] == PhysicalMaterial do (
								matName = objMaterials[m].name
								)
							
							-- Create a Material object
							local ufg = Material_t m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.Material) m_ChunkUID:ri.Material)
							ufg.m_Resource.setDebugName (matHashID + model_name + "|" + ((m - 1) as string) + "|" + matName + ".ufg")
							
							-- Read Materials
							ufg.getSceneMaterial objMaterials[m]
							
							append MaterialData ufg
							
							
							-- Create a SubMesh Object
							mdl.m_MeshTable[m] = Mesh_t()
							mdl.m_MeshTable[m].m_MaterialHandle.m_NameUID = ufg.m_Resource.m_NameUID
							mdl.m_MeshTable[m].m_IndexBufferHandle.m_NameUID = ibuf.m_Resource.m_NameUID
							mdl.m_MeshTable[m].m_VertexBufferHandles[1].m_NameUID = vbuf0.m_Resource.m_NameUID
							mdl.m_MeshTable[m].m_VertexBufferHandles[2].m_NameUID = vbuf1.m_Resource.m_NameUID
							mdl.m_MeshTable[m].m_VertexBufferHandles[3].m_NameUID = vbuf2.m_Resource.m_NameUID
							mdl.m_MeshTable[m].m_VertexBufferHandles[4].m_NameUID = 0
							mdl.m_MeshTable[m].m_VertexDeclHandle.m_NameUID = vd.Skinned -- Skinned Mesh
							mdl.m_MeshTable[m].m_PrimType = 3 -- Triangle List
							mdl.m_MeshTable[m].m_IndexStart = 0
							mdl.m_MeshTable[m].m_NumPrims = 0
							
							
							-- count how many faces per material, its possible there could be none
							local commitedFaces = 0
							local vertLookup = #()
							local vpos = 0
							
							-- loop through each face set in the bit array
							for f in faceSel do (
								
								-- Check face material index againt the material index
								if (mod ((getFaceMatID tmesh f) - 1) matCount) + 1 == m do (
									
									-- eliminate face index from bit array
									faceSel[f] = false
									
									-- increment material face count for this material index
									commitedFaces+=1
									
									-- add the 3 verts to the vertex buffer
									
									if optimizeVerts then (
										
										local nface = [1,1,1]
										for i = 1 to 3 do (
											
											local ii = ((f - 1) * 3) + i
											--local vhash = getVertexID (join #(
											--	vertArray[ii][1], vertArray[ii][2], vertArray[ii][3],
											--	normArray[ii][1], normArray[ii][2], normArray[ii][3],
											--	uvs0Array[ii][1], uvs0Array[ii][2]
											--	) wvArray[faceArray[f][i]])
											local vhash = getVertexID #(
												vertArray[ii][1], vertArray[ii][2], vertArray[ii][3],
												normArray[ii][1], normArray[ii][2], normArray[ii][3],
												uvs0Array[ii][1], uvs0Array[ii][2]
												)
											
											local x = findItem vertLookup vhash
											
											if x < 1 then ( -- Not in Array, Have to add to Vertex Buffer
												nface[i] = vertLookup.count + vert_index
												append vbuf0.m_Buffer (
													Vertex_t \
													m_Position:#(vertArray[ii][1] * mscale, vertArray[ii][2] * mscale, vertArray[ii][3] * mscale, 0.0) \
													m_Normal:#(normArray[ii][1], normArray[ii][2], normArray[ii][3], 1.0) \
													m_Tangent:#(tangArray[ii][1], tangArray[ii][2], tangArray[ii][3], 1.0)
													)
												append vertLookup vhash
												append vbuf1.m_Buffer (Vertex_t m_BoneID:(join biArray[faceArray[f][i]] #(0, 0, 0)) m_Weight:(join wvArray[faceArray[f][i]] #(0.0, 0.0, 0.0)))
												append vbuf2.m_Buffer (Vertex_t m_TexCoord0:[uvs0Array[ii][1], 1.0-uvs0Array[ii][2], 0.0])
												for m = 1 to morArray.count do (
													append mBuf[m].m_Buffer (
														Vertex_t \
														m_Position:#(morArray[m][ii][1] * mscale, morArray[m][ii][2] * mscale, morArray[m][ii][3] * mscale, 1.0) \
														m_Normal:#(normArrayM[m][ii][1], normArrayM[m][ii][2], normArrayM[m][ii][3], 1.0)
														)
													)
												vpos += 1
												)
											else ( -- Duplicate, Can Reference Vertex Buffer
												nface[i] = x - 1 + vert_index
												)
											)
										)
									else (
										local nface = [1,1,1]
										for i = 1 to 3 do (
											local ii = ((f - 1) * 3) + i
											append vbuf0.m_Buffer (
												Vertex_t \
												m_Position:#(vertArray[ii][1] * mscale, vertArray[ii][2] * mscale, vertArray[ii][3] * mscale, 0.0) \
												m_Normal:#(normArray[ii][1], normArray[ii][2], normArray[ii][3], 1.0) \
												m_Tangent:#(tangArray[ii][1], tangArray[ii][2], tangArray[ii][3], 1.0)
												)
											append vbuf1.m_Buffer (Vertex_t m_BoneID:(join biArray[faceArray[f][i]] #(0, 0, 0)) m_Weight:(join wvArray[faceArray[f][i]] #(0.0, 0.0, 0.0)))
											append vbuf2.m_Buffer (Vertex_t m_TexCoord0:[uvs0Array[ii][1], 1.0-uvs0Array[ii][2], 0.0])
											for m = 1 to morArray.count do (
												append mBuf[m].m_Buffer (
													Vertex_t \
													m_Position:#(morArray[m][ii][1] * mscale, morArray[m][ii][2] * mscale, morArray[m][ii][3] * mscale, 1.0) \
													m_Normal:#(normArrayM[m][ii][1], normArrayM[m][ii][2], normArrayM[m][ii][3], 1.0)
													)
												)
											--nface[i] = ii - 1
											vpos += 1
											)
										nface = [0, 1, 2] + v
										)
									append ibuf.m_Buffer (nface[1] as integer)
									append ibuf.m_Buffer (nface[2] as integer)
									append ibuf.m_Buffer (nface[3] as integer)
									-- increment vertex index for chr buffer
									v += 3
									)
								)
							
							-- check if any faces were commited for this material index
							if commitedFaces > 0 do (
								-- add the submesh info
								mdl.m_MeshTable[m].m_IndexStart = face_index
								mdl.m_MeshTable[m].m_NumPrims = commitedFaces
								face_index += commitedFaces * 3
								vert_index += vpos
								)
							
							--print mdl.m_MeshTable[m]
							)
						
						-- Delete the mesh snap shot
						delete tmesh
						
						-- Store Buffers
						append BufferData ibuf
						append BufferData vbuf0
						append BufferData vbuf1
						append BufferData vbuf2
						
						-- Update Resource Hierarchy
						append index #(#buffer, BufferData.count - 3)
						append index #(#buffer, BufferData.count - 2)
						append index #(#buffer, BufferData.count - 1)
						append index #(#buffer, BufferData.count)
						
						-- Merge Morphs, they need to be shuffled in front of the model
						if morArray.count > 0 do (
							
							for m = 1 to mbuf.count do (
								
								
								local lpal = BonePallete_t \
									m_Resource:(ResourceData_t \
									base:(ResourceEntry_t m_TypeUID:rt.BonePalette) \
									m_ChunkUID:ri.BonePalette) \
									m_BoneIndexTable:(copy pal.m_BoneIndexTable #nomap) \
									m_BoneNameTable:(copy pal.m_BoneNameTable #nomap) \
									m_BoneUIDTable:(copy pal.m_BoneUIDTable #nomap) \
									m_BoneFullUIDTable:(copy pal.m_BoneFullUIDTable #nomap)
								lpal.m_Resource.setDebugName (model_name + " M" + ((m - 1) as string) + ".BonePalette")
								
								-- Create a new Model
								local tar                               = ModelData_t m_Resource:(ResourceData_t base:(ResourceEntry_t m_TypeUID:rt.ModelData) m_ChunkUID:ri.ModelData)
								tar.m_AABBMin                           = aabbArrayM[m][1] * mscale
								tar.m_AABBMax                           = aabbArrayM[m][2] * mscale
								tar.m_NumPrims                          = mdl.m_NumPrims
								tar.m_NumMeshes                         = mdl.m_NumMeshes
								tar.m_MeshTable                         = #()--copy mdl.m_MeshTable #nomap
								tar.m_MaterialTableHandle.m_NameUID     = mdl.m_MaterialTableHandle.m_NameUID -- always 0
								tar.m_BonePaletteHandle.m_NameUID       = lpal.m_Resource.m_NameUID -- Generate a new one
								tar.m_MorphTargetsHandle.m_NameUID      = mdl.m_MorphTargetsHandle.m_NameUID
								tar.m_LocatorsHandle.m_NameUID          = mdl.m_LocatorsHandle.m_NameUID
								
								tar.m_Resource.setDebugName (model_name + "M" + ((m - 1) as string))
								if mdl.m_MeshTable.count > 0 do (
									tar.m_MeshTable[mdl.m_MeshTable.count] = Mesh_t()
									)
								for j = 1 to mdl.m_MeshTable.count do (
									tar.m_MeshTable[j] = Mesh_t()
									tar.m_MeshTable[j].m_MaterialHandle.m_NameUID         = mdl.m_MeshTable[j].m_MaterialHandle.m_NameUID 
									tar.m_MeshTable[j].m_IndexBufferHandle.m_NameUID        = 0 -- they seem to write a hash here that isn't in the perm.bin
									tar.m_MeshTable[j].m_VertexBufferHandles[1].m_NameUID   = mBuf[m].m_Resource.m_NameUID--vbuf0.m_Resource.m_NameUID
									tar.m_MeshTable[j].m_VertexBufferHandles[2].m_NameUID   = 0
									tar.m_MeshTable[j].m_VertexBufferHandles[3].m_NameUID   = 0
									tar.m_MeshTable[j].m_VertexBufferHandles[4].m_NameUID   = 0
									tar.m_MeshTable[j].m_VertexDeclHandle.m_NameUID       = mdl.m_MeshTable[j].m_VertexDeclHandle.m_NameUID
									tar.m_MeshTable[j].m_PrimType = mdl.m_MeshTable[j].m_PrimType
									tar.m_MeshTable[j].m_IndexStart = mdl.m_MeshTable[j].m_IndexStart
									tar.m_MeshTable[j].m_NumPrims = mdl.m_MeshTable[j].m_NumPrims
									
									)
								
								
								-- Store bone Objects
								append BonePalleteData lpal
								append BufferData mBuf[m]
								append ModelData tar
								
								-- Update Resource Hierarchy
								insertItem #(#model, ModelData.count) index index_start
								insertItem #(#buffer, BufferData.count) index index_start
								insertItem #(#pallete, BonePalleteData.count) index index_start
								
								)
							
							)
						)
					
					-- Store Model
					append ModelData mdl
					
					-- Update Resource Hierarchy
					append index #(#model, ModelData.count)
					)
				
				-- Update Resource Hierarchy, Push all the materials to the top
				for i = MaterialData.count to 1 by -1 do (
					insertItem #(#material, i) index 1
					)
				
				messageBox "Done!"
				
				) else (messageBox "Nothing To Export")
			),
		fn getMeshData obj = (
			local data = #(#(), #())
			if classof obj == Editable_Poly do (
				-- Get vertices and faces
				local vertices = for v = 1 to obj.numVerts collect (polyOp.getVert obj v)
				local faces = for f = 1 to obj.numFaces collect (polyOp.getFaceVerts obj f)
				data = #(vertices, faces)
				)
			data
			),
		fn createMeshFromData vertices faces = (
			local newMesh = convertToPoly (mesh vertices:vertices faces:#())
			for f in faces do (newMesh.createFace f)
			update newMesh
			newMesh
			)
		)
	
	
	local bin = ResourceFile_t()
	local rig = ResourceFile_t()

	local resbin = #()
	local resdat = #()
	local resUndoStack = #() -- Stack to store states for undo functionality
	
	
	fn build_res_list = (
		local list = #()
		for res in resbin do (
			append list res.m_DebugName
			)
		mlb_resources.items = list
		)
	
	fn resSaveState = (
		local state = #(deepCopy resbin, deepCopy resdat)
		append resUndoStack state
		)
	
	fn undo_res = (
		if resUndoStack.count > 0 do (
			local state = resUndoStack[resUndoStack.count]
			resbin = deepCopy state[1]
			resdat = deepCopy state[2]
			deleteItem resUndoStack resUndoStack.count
			build_res_list()
			)
		)
	
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
	
	fn getSteamInstallPath = (
		-- https://forums.cgsociety.org/t/get-system-information/1376115/2
		local key1 = undefined, key2 = undefined, key3 = undefined
		local key4 = undefined, key5 = undefined, theType, theValName = "", numValues = 0
		local i = 1, j = 1, numSubKeys = 0, numSubKeys2 = 0, thename = ""
		local steamPath = ""
		registry.openKey HKEY_LOCAL_MACHINE "SOFTWARE" accessRights:#readOnly key:&key1
		if key1 != undefined do (
			registry.openKey key1 "WOW6432Node" accessRights:#readOnly key:&key2
			if key2 == undefined then (
				registry.openKey key1 "Valve" accessRights:#readOnly key:&key3
				)
			else (
				registry.openKey key2 "Valve" accessRights:#readOnly key:&key3
				)
			)
		if key3 != undefined do (
			registry.openKey key3 "Steam" accessRights:#readOnly key:&key4
			)
		if key4 != undefined do (
			registry.queryInfoKey key4 numSubKeys:&numSubKeys numValues:&numValues
			for i = 1 to numSubKeys do (
				registry.getSubKeyName key4 i name:&thename
				registry.openKey key4 thename accessRights:#readOnly key:&key5
				if key5 != undefined do (
					registry.queryInfoKey key5 numSubKeys:&numSubKeys2 numValues:&numValues
					for j = 1 to numValues do (
						registry.getValueName key5 j name:&theValName
						registry.queryValue key5 theValName type:&theType value:&theVal
						if theVal != undefined do (
							if matchpattern theValName pattern:"path" do (
								steamPath = theVal
								if steamPath.count > 1 do (
									if substring steamPath (steamPath.count - 1) 1 != "\\" do (
										steamPath += "\\"
										)
									)
								exit
								--format "% = %\n" theValName 
								)
							)
						)
					)
				)
			)
		steamPath
		)
	
	fn getSDDEInstallPath = (
		local steamLibrary = #(), bio4Folder = ""
		local steamFolder = "", gameslib = ""
		local f = undefined, str = "", ss = #(), i = 1
		steamFolder = getSteamInstallPath()
		if steamFolder != "" do (
			gameslib = steamFolder + "steamapps\\libraryfolders.vdf"
			if doesFileExist gameslib do (
				f = try(openFile gameslib mode:"rtS")catch(undefined)
				if f != undefined do (
					while eof f == false do (
						str = readline f
						ss = filterstring str "\t \""
						for i = 1 to ss.count do (
							ss[i] = substituteString ss[i] "//" "\\"
							ss[i] = substituteString ss[i] "\\\\" "\\"
							if matchpattern ss[i] pattern:"*\\*" do (
								if doesFileExist ss[i] and ss[i].count > 1 do (
									if substring ss[i] (ss[i].count - 1) 1 != "\\" do (
										ss[i] += "\\"
										)
									append steamLibrary ss[i]
									)
								)
							)
						)
					close f
					)
				)
			)
		for i = 1 to steamLibrary.count do (
			if doesFileExist (steamLibrary[i] + "steamapps\\common\\SleepingDogsDefinitiveEdition") do (
				bio4Folder = steamLibrary[i] + "steamapps\\common\\SleepingDogsDefinitiveEdition\\"
				exit
				)
			)
		bio4Folder
		)
	
	fn read file = (
		if doesFileExist file do (
			bin = ResourceFile_t()
			bin.read(file)
			bin.build mscale:spn_scale.value impNormals:chk_normals.checked impSkin:chk_weights.checked impColors:chk_colours.checked 
			
			--local sfile = (getFilenamePath file) + (getFilenameFile file) + "_edit" + (getFilenameType file)
			--bin.save(sfile)
			
			
			)
		)
	
	on sddef_mesh open do (
		local sdde_rig_file = getCustomProperty "sdde_rig_file"
		
		if sdde_rig_file != undefined and doesFileExist sdde_rig_file then (
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
		else (
			-- Load from steam folder, I don't test...
			
			sdde_rig_file = (getSDDEInstallPath()) + "characterrig.bin"
			if doesFileExist sdde_rig_file do (
				rig = ResourceFile_t()
				rig.read(sdde_rig_file)
				if rig.SkeletonData.count > 0 do (
					ddl_skeleton.items = for o in rig.SkeletonData collect o.filename
					)
				)
			
			)
		
		--"0x"+toUpper(bit.IntAsHex(bit.CharAsInt ""))
		btn_res_up.caption = bit.IntAsChar 0x25B2
		btn_res_down.caption = bit.IntAsChar 0x25BC
		btn_res_del.caption = bit.IntAsChar 0x274C
		btn_res_export.caption = bit.IntAsChar 0x2B13
		btn_res_add.caption = bit.IntAsChar 0x271A
		btn_res_undo.caption = bit.IntAsChar 0x23CE
		)
	
	on sddef_mesh close do (
		
		)
	
	on mlb_resources selectionEnd do (
		local sel = mlb_resources.selection as array
		if sel.count > 0 do (
			local i = sel[sel.count]
			edt_res_hash.text = resbin[i].base.Hash32HexString resbin[i].m_NameUID
			edt_res_type.text = resbin[i].base.Hash32HexString resbin[i].base.m_TypeUID
			edt_res_chunk.text = resbin[i].base.Hash32HexString resbin[i].m_ChunkUID
			edt_res_name.text = resbin[i].m_DebugName
			)
		)
	
	on edt_res_hash entered txt do (
		local sel = mlb_resources.selection
		if sel.count > 0 do resSaveState()
		for i in (sel as array) do (
			resbin[i].m_NameUID = try(execute edt_res_hash.text)catch(-1)
			)
		build_res_list()
		mlb_resources.selection = sel
		)
	
	on edt_res_type entered txt do (
		local sel = mlb_resources.selection
		if sel.count > 0 do resSaveState()
		for i in (sel as array) do (
			resbin[i].base.m_TypeUID = try(execute edt_res_type.text)catch(-1)
			)
		build_res_list()
		mlb_resources.selection = sel
		)
	
	on edt_res_chunk entered txt do (
		local sel = mlb_resources.selection
		if sel.count > 0 do resSaveState()
		for i in (sel as array) do (
			resbin[i].m_ChunkUID = try(execute edt_res_chunk.text)catch(-1)
			)
		build_res_list()
		mlb_resources.selection = sel
		)
	
	on edt_res_name entered txt do (
		local sel = mlb_resources.selection
		if sel.count > 0 do resSaveState()
		for i in (sel as array) do (
			resbin[i].m_DebugName = edt_res_name.text
			)
		build_res_list()
		mlb_resources.selection = sel
		)
	
	on btn_res_open pressed do (
		local file = GetOpenFileName caption:"Open PERM Model" types:"SDDE Binary Model (*.perm.bin)|*.perm.bin|All Files (*.*)|*.*|"
		if file != undefined do (
			local f = try(fopen file "rb") catch(undefined)
			if f != undefined do (
				fseek f 0 #seek_end
				local fsize = ftell f
				fseek f 0 #seek_set
				local res = ResourceData_t()
				local pos = 0
				resbin = #()
				resdat = #()
				resUndoStack = #()
				while (pos = ftell f) + 16 < fsize do (
					res = ResourceData_t()
					if not res.read(f) do (
						format "Error: Unsupported file {%}\n" file
						exit
						)
					fseek f pos #seek_set
					local dat = byteArray()
					dat.readFromStream f fsize:(res.size())
					append resdat dat
					append resbin res
					dat = undefined
					fseek f (pos + res.size()) #seek_set
					)
				fclose f
				build_res_list()
				)
			)
		)
	
	on btn_res_save pressed do (
		local file = GetSaveFileName caption:"Open PERM Model" types:"SDDE Binary Model (*.perm.bin)|*.bin|All Files (*.*)|*.*|"
		if file != undefined do (
			local s = try(fopen file "wb")catch(undefined)
			if s != undefined do (
				for dat in resdat do (
					writeToStream(&s)
					)
				fclose s
				)
			)
		)
	
	on btn_res_add pressed do (
		local file = GetOpenFileName caption:"Open File" types:"All Files (*.*)|*.*|"
		if file != undefined do (
			local f = try(fopen file "rb") catch(undefined)
			if f != undefined do (
				fseek f 0 #seek_end
				local fsize = ftell f
				fseek f 0 #seek_set
				if (ftell f) + 16 < fsize then (
					local res = ResourceData_t()
					if res.read(f) then (
						resSaveState()
						fseek f 0 #seek_set
						local dat = byteArray()
						dat.readFromStream f fsize:fsize
						append resdat dat
						append resbin res
						build_res_list()
						messageBox "File Imported"
						) else (messageBox "Failed To Read Header")
					) else (messageBox "File Invalid")
				fclose f
				)
			)
		)
	
	on btn_res_del pressed do (
		local sel = mlb_resources.selection as array
		resSaveState()
		if sel.count > 0 do (
			if queryBox "Delete Selection?" beep:false then (
				for i = sel.count to 1 by -1 do (
					deleteItem resbin sel[i]
					deleteItem resdat sel[i]
					)
				build_res_list()
				)
			)
		)
	
	on btn_res_up pressed do (
		local sel = mlb_resources.selection as array
		if sel.count > 0 do (
			resSaveState()
			for i = 1 to sel.count do (
				local idx = sel[i]
				if idx > 1 do (
					swap resbin[idx] resbin[idx-1]
					swap resdat[idx] resdat[idx-1]
					sel[i] = idx - 1
					)
				)
			build_res_list()
			mlb_resources.selection = sel
			)
		)
	
	on btn_res_down pressed do (
		local sel = mlb_resources.selection as array
		if sel.count > 0 do (
			resSaveState()
			for i = sel.count to 1 by -1 do (
				local idx = sel[i]
				if idx < resbin.count do (
					swap resbin[idx] resbin[idx+1]
					swap resdat[idx] resdat[idx+1]
					sel[i] = idx + 1
					)
				)
			build_res_list()
			mlb_resources.selection = sel
			)
		)
	
	on btn_res_export pressed do (
		local sel = mlb_resources.selection as array
		if sel.count > 1 then (
			local fpath = GetSavePath()
			if fpath != undefined do (
				for i = 1 to sel.count do (
					resdat[sel[i]].write(file)
					)
				messageBox "File Saved"
				)
			)
		else if sel.count == 1 then (
			
			local file = GetSaveFileName caption:"Save File" types:"Any File (*.*)|*.*|" filename:resbin[sel[1]].m_DebugName
			if file != undefined do (
				resdat[sel[1]].write(file)
				messageBox "File Saved"
				)
			)
		else (messageBox "Nothing Selected")
		)
	
	on btn_res_undo pressed do (undo_res())
	
	on btn_scale_reset pressed do (spn_scale.value = 39.37007874015748031496062992125984251968503937007)
	
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
			rig.SkeletonData[ddl_skeleton.selection].build mscale:spn_scale.value
			--messageBox "TaDa!"
			)
		)
	
	on btn_import pressed do (
		local file = GetOpenFileName caption:"Open PERM Model" types:"SDDE Binary Model (*.perm.bin)|*.bin|All Files (*.*)|*.*|"
		if file != undefined and file != "" do (
			
			with undo off (
				with redraw off (
					if chk_clear.checked do (
						delete (for o in objects where findItem #(BoneGeometry, Dummy) (classOf o) == 0 collect o)
						)
					read(file)
					gc light:true delayed:false 
					)
				)
			
			lbl_loaded.caption = filenameFromPath file
			)
		)
		
	on btn_export pressed do (
		
		local file = GetSaveFileName caption:"Open PERM Model" types:"SDDE Binary Model (*.perm.bin)|*.perm.bin|All Files (*.*)|*.*|"
		if file != undefined and file != "" do (
			
			local cleaned = (getFilenamePath file) + (getFilenameFile (getFilenameFile ((getFilenameFile (getFilenameFile file))))) + ".perm.bin"
			--format "Exporting: %\n" file
			--format "Cleaned: %\n" cleaned
			
			--local s = try(fopen file "wb")catch(undefined)
			--if s != undefined then (
			with undo off (
				
				with redraw off (
					--disableSceneRedraw()
					bin.export selectionOnly:chk_onlyselected.checked mscale:(1.0 / spn_scale.value) optimizeVerts:chk_optimize.checked
					bin.save(cleaned)
					--enableSceneRedraw()
					gc light:true delayed:false
					)
				
				)
			--	bin.write(&s)
			--	fclose s
			--	) else (messageBox "Failed to Write File")
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
	/*
	arr = #()
	local files = join (getFiles "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Characters\\*.perm.bin") (getFiles "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\*.perm.bin")
	local file
	for file in files do (
		sddef_mesh.read(file)
		)
	sort arr
	print arr
	*/
	
	delete $*
	--sddef_mesh.read("C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Alex_HD_Skeleton.bin")
	
	sddef_mesh.read(
-- 		"C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Alex_HD_Skeleton.bin"
		"C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\Alex_HD.perm.bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\Wei_HeadNoBones.perm.bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\NotPing_HD.perm.bin"
		"C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Characters\\AF_H_009.perm.bin" -- LOD's
		"C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Characters\\AM_H_011.perm.bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\0 WEI_HEADNO ANIM_MAT.~eadnobones.ufg (Material).bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\1 WEI_HEAD_NOANIM.BonePalette (BonePalette).bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\2 WEI_HEAD_NOANIM.IndexBuffer (Buffer).bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\3 WEI_HEAD_NOANIM.Vert~cl.Skinned.0.0 (Buffer).bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\4 WEI_HEAD_NOANIM.Vert~cl.Skinned.1.0 (Buffer).bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\5 WEI_HEAD_NOANIM.Vert~cl.Skinned.2.0 (Buffer).bin"
-- 		"C:\\Users\\Corey\\Downloads\\export\\vanilla_weihead_box_model\\6 WEI_HEAD_NOANIM (ModelData).bin"
-- 	"C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\EliteGhoul_HD.perm.bin" -- crashes
-- "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\Characters\\AM_B_003.perm.bin" -- 15728L: 	<BinStream:
-- 42432L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\AM_B_003.perm.bin>
-- 51552L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\AM_B_003.perm.bin>
-- 14576L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\AS_B_JoeyKwan.perm.bin>
-- 38464L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\AS_B_JoeyKwan.perm.bin>
-- 46640L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\AS_B_JoeyKwan.perm.bin>
-- 11328L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\P_RICO.perm.bin>
-- 46256L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\P_RICO.perm.bin>
-- 58112L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\P_RICO.perm.bin>
-- 56464L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\T_RICO.perm.bin>
-- 267680L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\T_RICO.perm.bin>
-- 338304L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\Characters\T_RICO.perm.bin>
-- "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\Duke_HD.perm.bin"-- 102752L
-- 312976L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Duke_HD.perm.bin>
-- 383264L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Duke_HD.perm.bin>
-- 95280L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\JackieSanitation_HD.perm.bin>
-- 319376L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\JackieSanitation_HD.perm.bin>
-- 394288L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\JackieSanitation_HD.perm.bin>
-- 94064L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Ponytail_HD.perm.bin>
-- 300688L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Ponytail_HD.perm.bin>
-- 369776L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Ponytail_HD.perm.bin>
-- 107808L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\TiffanyDate_HD.perm.bin>
-- 488720L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\TiffanyDate_HD.perm.bin>
-- 615904L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\TiffanyDate_HD.perm.bin>
-- 107808L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Tiffany_HD.perm.bin>
-- 488272L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\Tiffany_HD.perm.bin>
-- "C:\\Users\\Corey\\Downloads\\export\\sdde_perms\\CharactersHD\\Tiffany_HD.perm.bin"-- 615312
-- 93776L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\UnPonytail_HD.perm.bin>
-- 300400L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\UnPonytail_HD.perm.bin>
-- 369488L: 	<BinStream:C:\Users\Corey\Downloads\export\sdde_perms\CharactersHD\UnPonytail_HD.perm.bin>

		)


	)
--batch()


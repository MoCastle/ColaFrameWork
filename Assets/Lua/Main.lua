--主入口函数。从这里开始lua逻辑
local rawset = rawset

local UTL = {}

-- 全局函数
-- 用于声明全局变量
function define(name,value)
	rawset(_G,name,value)
end

-- 注册工具类
local function RegisterUtility(name)
	local result,utl = pcall(require,string.format("Utilitys.%s_Utils",name))
	if result and utl then
		UTL[name] = utl
		--执行Utility的initialize初始化方法
		if utl.initialize and "function" == type(utl.initialize) then
			utl.initialize()
		end
	end
end

-- 工具类在这里初始化
local function InitUtilitys()
	define("UTL",UTL)

	RegisterUtility("LuaCommon")
	RegisterUtility("UI")
	RegisterUtility("Table")
end

local function initialize()
	LuaLogHelper.initialize()
    ConfigMgr.Instance()
    EventMgr.Instance()
    UIManager.Instance()
	-- 模块初始化
	ModuleManager.Instance():RegisterAllModules()
	ModuleManager.Instance():InitAllModules()
end

-- 在此处定义注册一些全局变量
local function gloablDefine()
	require("Common.ECEnumType")
	-- 必须首先注册全局Class,顺序敏感
	define("Class",require("Core.middleclass"))
	define("LuaLogHelper",require("Utilitys.LuaLogHelper"))
	define("EventMgr",require("Mgrs.EventMgr"))
	require("Game.Main.Modules")
	require("Game.Main.GUICollections")
	InitUtilitys()
	define("UIManager",require("Mgrs.UIManager"))
	define("ConfigMgr",require("Mgrs.ConfigMgr"))
	define("ModuleManager",require("Mgrs.ModuleManager"))
	--控制全局变量的新建与访问
	require("Utilitys.LuaGlobalCheck")
end

-- 初始化一些参数
local function initParam()
	-- 初始化随机种子
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))

	--垃圾收集器间歇率控制着收集器需要在开启新的循环前要等待多久。 增大这个值会减少收集器的积极性。
	--当这个值比 100 小的时候，收集器在开启新的循环前不会有等待。 设置这个值为 200 就会让收集器等到总内存使用量达到之前的两倍时才开始新的循环。
	collectgarbage("setpause", 99)
	--垃圾收集器步进倍率控制着收集器运作速度相对于内存分配速度的倍率。 增大这个值不仅会让收集器更加积极，还会增加每个增量步骤的长度。
	--不要把这个值设得小于 100 ， 那样的话收集器就工作的太慢了以至于永远都干不完一个循环。 默认值是 200 ，这表示收集器以内存分配的"两倍"速工作。
	collectgarbage("setstepmul", 2000)
	--重启垃圾收集器的自动运行
	collectgarbage("restart")
end

function Main()
	gloablDefine()
	initParam()
	initialize()

	UIManager.Instance():Open(ECEnumType.UIEnum.Login)
	EventMgr.Instance():DispatchEvent(Modules.moduleId.Common,Modules.notifyId.Common.CREATE_PANEL,ECEnumType.UIEnum.Login)
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end
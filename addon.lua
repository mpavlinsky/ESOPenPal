--[[
  * PenPal
  * Author: Matthew Pavlinsky
  * Embedded: LibStub & libAddonMenu by Seerah.
]]--

local _addon = {}
_addon._v = {}
_addon._v.major		= 0
_addon._v.monthly 	= 1
_addon._v.daily 	= 1
_addon._v.minor 	= 1
_addon.Version 	= _addon._v.major
	..".".._addon._v.monthly
	..".".._addon._v.daily
	..".".._addon._v.minor
_addon.Name			= "PenPal"
_addon.MAJOR 		= _addon.Name..".".._addon._v.major
_addon.MINOR 		= string.format(".%02d%02d%03d", _addon._v.monthly, _addon._v.daily, _addon._v.minor)
_addon.DisplayName  = "PenPal"
_addon.SavedVariableVersion = 1
_addon.Player = "" -- will be set on load by LibWykkkydFactory
_addon.Settings = {} -- will be set on load by LibWykkkydFactory, if you pass in the final parameter: your global saved variable as a string
_addon.GlobalSettings = {} -- will be set on load by LibWykkkydFactory, if you pass in the final parameter: your global saved variable as a string
_addon.wykkydPreferred = nil

_addon.LoadSavedVariables = function( self )
	if self.Settings.Enabled == nil then self.Settings.Enabled = true end
end

_addon.LoadSettingsMenu = function( self )
	local panelData = self:MakeStandardSettingsPanel( "Matthew Pavlinsky", "|cFF2222" )
	local optionsTable = {
		[1] = {
			type = "description",
			text = "Adds a hotkey that automatically opens a mail to your BFF",
		},
		[2] = {
			type = "editbox",
			name = "PenPal Account Name",
			tooltip = "The mail recipient you would like prefilled",
			getFunc = function() return self:GetOrDefault( "noaccount", self.Settings[ "penpal_account_name" ] ) end,
			setFunc = function( val ) self.Settings[ "penpal_account_name" ] = val end,
      isMultiline = false,
		},
		[3] = {
			type = "editbox",
			name = "Prefilled Subject",
			tooltip = "The message subject you would like prefilled",
			getFunc = function() return self:GetOrDefault( "", self.Settings[ "prefilled_subject" ] ) end,
			setFunc = function( val ) self.Settings[ "prefilled_subject" ] = val end,
      isMultiline = false,
		},
	}
	optionsTable = self:InjectAdvancedSettings( optionsTable, 1 )
	self.LAM:RegisterAddonPanel(_addon.Name.."_LAM", panelData)
	self.LAM:RegisterOptionControls(_addon.Name.."_LAM", optionsTable)
end

_addon.Initialize = function( self )
end

if penPalGlobal == nil then penPalGlobal = {} end
LWF4.REGISTER_FACTORY(
	_addon, false, true,
	function( self ) _addon:LoadSavedVariables( self ) end,
	function( self ) _addon:LoadSettingsMenu( self ) end,
	function( self ) _addon:Initialize( self ) end,
	"penPalGlobal", true
)

_addon.ComposePenPalMail = function() 
  local subject = _addon:GetOrDefault( "", _addon.Settings[ "prefilled_subject" ])
  _addon.ComposePenPalMailWithSubject(subject)
end

_addon.ComposePenPalBounceMail = function()
  _addon.ComposePenPalMailWithSubject("BOUNCE")
end

_addon.ComposePenPalMailWithSubject = function(subject)
    local account = _addon:GetOrDefault( "noaccount", _addon.Settings[ "penpal_account_name" ])

    SCENE_MANAGER:Show('mailSend')
    ZO_MailSendToField:SetText(account)
		ZO_MailSendSubjectField:SetText(subject)
end

PenPalAddon = _addon

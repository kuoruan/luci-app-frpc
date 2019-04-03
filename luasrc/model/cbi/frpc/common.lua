-- Copyright 2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

local util = require "luci.util"

local m, s, o

m = Map("frpc", "%s - %s" % { translate("Frpc"), translate("Common Settings") },
"<p>%s</p><p>%s</p>" % {
	translate("Frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet."),
	translatef("For more information, please visit: %s",
		"<a href=\"https://github.com/fatedier/frp\" target=\"_blank\">https://github.com/fatedier/frp</a>")
})

m:append(Template("frpc/status_header"))

s = m:section(NamedSection, "main", "common")
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Options"))
s:tab("advanced", translate("Advanced Options"))
s:tab("manage", translate("Manage Options"))

o = s:taboption("general", Flag, "enabled", translate("Enabled"))

o = s:taboption("general", ListValue, "server", translate("Server"))
o:value("", "None")

o = s:taboption("general", ListValue, "run_user", tanslate("Run daemon as user"),
  translate("Leave blank to use default user"))
o:value("")
local user
for user in util.execi("cat /etc/passwd | cut -d':' -f1") do
  o:value(user)
end

o = s:taboption("general", Flag, "enable_logging", translate("Enable logging"))

o = s:taboption("general", Value, "log_file", translate("Log file"))
o:depends("enable_logging", "1")
o.placeholder = "/var/log/frpc.log"

o = s:taboption("general", ListValue, "log_level", translate("Log level"))
o:depends("enable_logging", "1")
o:value("trace", translate("Trace"))
o:value("debug", translate("Debug"))
o:value("info", translate("Info"))
o:value("warn", translate("Warn"))
o:value("error", translate("Error"))

o = s:taboption("general", Value, "log_max_days", translate("Log max days"))
o:depends("enable_logging", "1")
o.datatype = "uinteger"
o.placeholder = '3'

o = s:taboption("advanced", Value, "pool_count", translate("Pool count"),
  translate("Connections will be established in advance, default value is zero"))
o.datatype = "uinteger"
o.defalut = '0'
o.placeholder = '0'

o = s:taboption("advanced", Value, "user", translate("Proxy user"),
  translate("Your proxy name will be changed to {user}.{proxy}"))

o = s:taboption("advanced", ListValue, "protocol", translate("Protocol"),
  translate("Communication protocol used to connect to server, default is tcp"))
o:value("tcp", "TCP")
o:value("kcp", "KCP")
o:value("websocket", "Websocket")
o.default = "tcp"

o = s:taboption("advanced", Value, "http_proxy", tanslate("HTTP proxy"),
  translate("Connect frps by http proxy or socks5 proxy, format: [protocol]://[user]:[passwd]@[ip]:[port]"))

o = s:taboption("advanced", Flag, "tls_enable", translate("TLS enable"),
  translate("If true, Frpc will connect Frps by TLS"))
o.enabled = "true"
o.disabled = "false"

o = s:taboption("advanced", Value, "dns_server", translate("DNS server"))
o.datatype = "host"

o = s:taboption("advanced", Value, "heartbeat_interval", translate("Heartbeat interval"))
o.datatype = "uinteger"
o.placeholder = "30"

o = s:taboption("advanced", Value, "heartbeat_timeout", translate("Heartbeat timeout"))
o.datatype = "uinteger"
o.placeholder = "90"

o = s:taboption("manage", Value, "admin_addr", translate("Admin addr"))
o.datatype = "host"

o = s:taboption("manage", Value, "admin_port", translate("Admin port"))
o.datatype = "port"

o = s:taboption("manage", Value, "admin_user", translate("Admin user"))

o = s:taboption("manage", Value, "admin_pwd", translate("Admin password"))
o.password = true


return m

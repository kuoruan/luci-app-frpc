-- Copyright 2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

local m, s, o

local sid = arg[1]

m = Map("frpc", "%s - %s" % { translate("Frpc"), translate("Edit Proxy Rule") })
m.redirect = dsp.build_url("admin/services/frpc/rules")

if m.uci:get("frpc", sid) ~= "rules" then
	luci.http.redirect(m.redirect)
	return
end

s = m:section(NamedSection, sid, "rules")
s.anonymous = true
s.addremove = false

o = s:option(Flag, "disabled", translate("Disabled"))

o = s:option(Value, "name", translate("Proxy Name"))
o:value("ssh")
o:value("web")
o:value("dns")
o:value("range:")
o:value("plugin_")
o:value("secret_")
o:value("p2p_")
o.rmempty = false

o = s:option(ListValue, "type", translate("Type"))
o:value("tcp", "TCP")
o:value("udp", "UDP")
o:value("http", "HTTP")
o:value("https", "HTTPS")
o:value("stcp", "STCP")
o:value("xtcp", "XTCP")

o = s:option(Value, "plugin", translate("Plugin"))
o:value("", translate("None"))
o:value("unix_domain_socket")
o:value("http_proxy")
o:value("socks5")
o:value("static_file")

o = s:option(value, "plugin_unix_path", translate("Plugin unix path"))
o:depends("plugin", "unix_domain_socket")

o = s:option(value, "plugin_user", translate("Plugin user"))
o:depends("plugin", "socks5")

o = s:option(value, "plugin_passwd", translate("Plugin password"))
o:depends("plugin", "socks5")

o = s:option(value, "plugin_local_path", translate("Plugin local path"))
o:depends("plugin", "static_file")

o = s:option(value, "plugin_strip_prefix", translate("Plugin strip prefix"))
o:depends("plugin", "static_file")

o = s:option(value, "plugin_http_user", translate("Plugin http user"))
o:depends("plugin", "http_proxy")
o:depends("plugin", "static_file")

o = s:option(value, "plugin_http_passwd", translate("Plugin http password"))
o:depends("plugin", "http_proxy")
o:depends("plugin", "static_file")

o = s:option(Value, "local_ip", translate("Local IP"))
o.datatype = "host"
o:depends("plugin", "")

o = s:option(Value, "local_port", translate("Local port"))
o.datatype = "portrange"
o:depends("plugin", "")

o = s:option(Value, "remote_port", translate("Remote port"))
o.datatype = "or('0', portrange)"
o:depends("type", "tcp")
o:depends("type", "udp")

o = s:option(Flag, "use_encryption", translate("Use encryption"))
o.enabled = "true"
o.disabled = "false"
o.default = o.disabled

o = s:option(Flag, "use_compression", translate("Use compression"))
o.enabled = "true"
o.disabled = "false"
o.default = o.disabled

o = s:option(Value, "role", translate("Role"))
o:depends("type", "stcp")
o:depends("type", "xtcp")

o = s:option(Value, "server_name", translate("Server name"))
o:depends("type", "stcp")
o:depends("type", "xtcp")

o = s:option(Value, "sk", translate("SK"))
o.password = true
o:depends("type", "stcp")
o:depends("type", "xtcp")

o = s:option(Value, "bind_addr", translate("Bind addr"))
o.datatype = "host"
o:depends("type", "stcp")
o:depends("type", "xtcp")

o = s:option(Value, "bind_port", translate("Bind port"))
o.datatype = "port"
o:depends("type", "stcp")
o:depends("type", "xtcp")

o = s:option(Value, "http_user", translate("HTTP user"))
o:depends("type", "http")

o = s:option(Value, "http_pwd", translate("HTTP password"))
o:depends("type", "http")

o = s:option(Value, "subdomain", translate("Subdomain"))
o:depends("type", "http")
o:depends("type", "https")

o = s:option(Value, "custom_domains", translate("Custom domains"))
o:depends("type", "http")
o:depends("type", "https")

o = s:option(Value, "locations", translate("Locations"))
o:depends("type", "http")

o = s:option(Value, "host_header_rewrite", translate("Host header rewrite"))
o:depends("type", "http")
o:depends("type", "https")

o = s:option(Value, "group", translate("Group"))

o = s:option(Value, "group_key", translate("Group key"))

o = s:option(ListValue, "health_check_type", translate("Health check type"))
o:value("", translate("Disabled"))
o:value("tcp", "TCP")
o:value("http", "HTTP")
o:depends("type", "tcp")
o:depends("type", "http")

o = s:option(ListValue, "health_check_url", translate("Health check url"))
o:depends("health_check_type", "http")

o = s:option(Value, "health_check_timeout_s", translate("Health check connection timeout"))
o.datatype = "uinteger"
o:depends("health_check_type")
o.placeholder = "3"

o = s:option(Value, "health_check_max_failed", translate("Health check max failed"))
o.datatype = "uinteger"
o:depends("health_check_type")
o.placeholder = "3"

o = s:option(Value, "health_check_interval_s", translate("Health check interval"))
o.datatype = "uinteger"
o:depends("health_check_type")
o.placeholder = "10"

return m

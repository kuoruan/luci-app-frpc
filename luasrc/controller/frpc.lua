-- Copyright 2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

module("luci.controller.frpc", package.seeall)

local http = require "luci.http"

function index()
	if not nixio.fs.access("/etc/config/frpc") then
		return
	end

	entry({"admin", "services", "frpc"},
		firstchild(), _("Frpc")).dependent = false

	entry({"admin", "services", "frpc", "common"},
		cbi("frpc/common"), _("Settings"), 1)

	entry({"admin", "services", "frpc", "rules"},
		arcombine(cbi("frpc/rules"), cbi("frpc/rule-detail")),
		_("Rules"), 2).leaf = true

	entry({"admin", "services", "frpc", "servers"},
	 arcombine(cbi("frpc/servers"), cbi("frpc/server-detail")),
	 _("Servers"), 3).leaf = true

	entry({"admin", "services", "frpc", "status"}, call("action_status"))
end


function action_status()
	http.prepare_content("application/json")
	http.write_json({
		running = false
	})
end

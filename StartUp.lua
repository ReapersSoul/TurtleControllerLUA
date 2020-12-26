json = require "json"

function ExecFunction (string)
  local g = load("return ".. string);
  if g ~= nil then
    ret=table.pack(pcall(g))
    if ret[1] then
      index=1
      val={}
      for k,v in pairs(ret) do
        if index>1 then
          val[index-1]=v
        end
        index = index+1
      end

      return val
    else
      print(string)
      return "Error"
    end
  end
end

local ws, err = http.websocket("ws://192.168.1.145:9000")
if ws then
  ExecFunction("print('Server Connected')")
  local closed = false
  while not closed do
    msg, closed = ws.receive()
    ret = ExecFunction(msg);
    if ret ~= nil then
      if type(ret)=="function" then
        ws.send(json.encode("{function returned}"))
      else
        ws.send(json.encode(ret));
      end
    else
        ws.send(json.encode("{nil}"))
    end
  end
  ws.close()
else
  error(err)
end

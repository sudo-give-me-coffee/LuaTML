
head = html_component "head" {
    pre_childrens_data = {
      "<script>function $_$(id,campo){let e = document.getElementById(id);return e[campo];}</script>"
    }
}
  
local function processa_parametro (e)
  local valor = tostring(e)
  local teste = valor:gsub("\\\\","\\\0"):gsub("\\%$","\\\0")

  if teste:sub(1,2)=="${" and teste:sub(-1,-1) == "}" and teste:match(":") then
    valor =  valor:sub(3,-2)
    local id = valor:gsub(":.*$",""):gsub("\"","\\\"")
    local campo =valor:gsub("^.*:",""):gsub("\"","\\\"")
    valor = "$_$(\""..(id.."\",\""..campo).."\")"
  else
    if type(e) == "string" then
      valor = ("\""..(valor:gsub("\"","\\\""):gsub("^%%%$","$"):gsub("^%%%%","%%")).."\"")
    end
  end
  return valor
end

function alert(e)
  return "alert("..processa_parametro(e)..");"
end

function preventDefault()
  return 'event.preventDefault();'
end

function removeById(e)
  return 'document.getElementByID('..processa_parametro(e)..').remove();'
end

function removeByTag(e)
  return 'for (let e of document.getElementsByTagName('..processa_parametro(e)..'){e.remove();};'
end

function removeByClass(e)
  return 'for (let e of document.getElementsByClassName('..processa_parametro(e)..'){e.remove();};'
end

function removeByName(e)
  return 'for (let e of document.getElementsByClassName('..processa_parametro(e)..'){e.remove();};'
end

function setTitle(e)
  return 'document.title = '..processa_parametro(e)..';'
end

function refreshPage()
  return 'window.location.reload();'
end

function callPrint()
  return 'window.print();'
end

function backToPrevious()
  return 'history.go(-1);'
end

function gotoPage(e)
  return 'window.location.href = '..processa_parametro(e)..';'
end

function submitForm(e)
  return 'document.getElementById('..processa_parametro(e)..').submit();'
end

function resetForm(e)
  return 'document.getElementById('..processa_parametro(e)..').reset();'
end
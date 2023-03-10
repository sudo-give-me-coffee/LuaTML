setmetatable(_ENV,{
  __index =
    function (self,name)
      local content = rawget(self,name)
      if content ~= nil then
        return content
      end

      return setmetatable({tag=name},{
        __mul =
          function (self,number)
            local block = {}
            for i = 1, number do
              block[#block+1] = self
            end
            return setmetatable(block,{
              __tostring =
                function (self)
                  local result = ""
                  for i, element in ipairs(self) do
                    result = result..tostring(element)
                  end
                  return result
                end
            })
          end,

        __pow =
          function (self,items)
            local block = {}
            for i, item in ipairs(items) do
              local element = {tag = self.tag,properties = {}}
              for property, value in pairs(self.properties or {}) do
                element.properties[property] = value
              end
              element = setmetatable(element,getmetatable(self))
              element.properties[1] = tostring(item)
              block[#block+1] = element
            end
            return setmetatable(block,{
              __tostring =
                function (self)
                  local result = ""
                  for i, element in ipairs(self) do
                    result = result..tostring(element)
                  end
                  return result
                end
            })
          end,

        __tostring =
          function (self)
            local html = "<"..self.tag
            for property, value in pairs(self.properties or {}) do
              if type(property) ~= "number" then
                html = html.." "..property.."=\""..value.."\""
              end
            end

            if (#(self.properties or {}) == 0) and self.tag:lower() ~= "script" then
              return html.."/>"
            end

            html = html..">"

            for i, children in ipairs(self.properties or {}) do
              html = html..tostring(children)
            end

            return html.."</"..self.tag..">"
          end,
        __call =
          function (self,properties)
            self.properties = type(properties) == "table" and properties or {tostring(properties)}
            
            if self.tag:lower() == "html" then
              return tostring(self)
            end

            return self
          end
      })
    end
})

function html_component(tag)
  local _tag = tag
  return 
    function (desctriptor)
      return setmetatable({tag=_tag,hard_properties=desctriptor.properties or {},
                                   pre_childrens_data=desctriptor.pre_childrens_data or {},
                                   post_childrens_data=desctriptor.post_childrens_data or {}},{
        __mul  = getmetatable(template).__mul,
        __call = getmetatable(template).__call,
        __pow  = getmetatable(template).__pow,
        __tostring =
        function (self)
          local html = "<"..self.tag

          for property, value in pairs(self.hard_properties) do
            if self.properties[property] then
              self.properties[property] = self.properties[property]..tostring(value)
            else
              self.properties[property] = tostring(value)
            end
          end
  
          for property, value in pairs(self.properties or {}) do
            if type(property) ~= "number" then
              html = html.." "..property.."=\""..value.."\""
            end
          end

          html = html..">"

          for i, value in ipairs(self.pre_childrens_data) do
            html = html..tostring(value)
          end

          for i, children in ipairs(self.properties or {}) do
            html = html..tostring(children)
          end

          for i, value in ipairs(self.post_childrens_data or {}) do
            html = html..tostring(value)
          end

          return html.."</"..self.tag..">"
        end
      })
    end
end

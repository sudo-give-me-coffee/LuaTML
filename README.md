## Introdução

Lua é uma linguagem de script extremamente poderosa, utilizando as tabelas e metatabelas é possível alterar o comportamento da própria linguagem, tendo isso em mente, porque não embutir HTML dentro da linguagem?

## Como funciona?

A biblioteca funciona manipulando o metamétodo `__index` da tabela _ENV, essa tabela controla o escopo global de variáveis, a manipulação consiste em fazer ela retornar um construtor de tags HTML caso uma variável não esteja definida

## Recursos

LuaTML suporta marcações de repetição e retorna o HTML já minificado*:

* Use `*` para repetir um elemento
* Use `^` para intercalar uma lista com o conteúdo do elemento

<small>* Não afeta código Javascript</small>

## Exemplos

#### A clássica estrutura HTML:

```lua
local exemplo =
html {
    lang="pt_BR",
    head {
      title "Teste",
      meta { charset="utf8" },
      meta { name="viewport", content="width=device-width,initial-scale=1.0" }
    },
    body {
      h1 "Olá mundo"
    }
}
```

#### Repetindo Tags [Resultado](https://codepen.io/natanael-b/pen/BaOmVyx):

```lua
local exemplo =
html {
    lang="pt_BR",
    head {
      title "Teste",
      meta { charset="utf8" },
      meta { name="viewport", content="width=device-width,initial-scale=1.0" }
    },
    body {
      h1 "Olá mundo",
      h2 "Esse texto aparecerá 7x" * 7
    }
}
```


### Intercalando listas com o conteúdo [Resultado](https://codepen.io/natanael-b/pen/ExebRVj):

```lua
local exemplo =
html {
    lang="pt_BR",
    head {
      title "Teste",
      meta { charset="utf8" },
      meta { name="viewport", content="width=device-width,initial-scale=1.0" }
    },
    body {
      h1 "Olá mundo",
      h2 "Esse texto aparecerá 7x" * 7,
      ol {
        li { id="teste"} ^ { "A","B","C","D","E" }
      }
    }
}
```

### Pegando blocos avulsos [Resultado](https://codepen.io/natanael-b/pen/MWqOXaM)

```lua

local bloco = h1 "Testando" * 9

local exemplo =
html {
    lang="pt_BR",
    head {
      title "Teste",
      meta { charset="utf8" },
      meta { name="viewport", content="width=device-width,initial-scale=1.0" }
    },
    body {
      h1 "Olá mundo",
      h2 "Esse texto aparecerá 7x" * 7,
      ol {
        li { id="teste"} ^ { "A","B","C","D","E" }
      },
      bloco
    }
}
```

## Componentes customizados

Dado a forma como a biblioteca funciona é possível integrar com qualquer Framework CSS, basta criar geradores para os componentes, segue abaixo um modelo que você pode usar, substitua "custom_tag" pela sua tag e faça as modificações nos locais indicados:

```lua
custom_tag = setmetatable({tag="custom_tag",properties={}},{
  __mul  = getmetatable(template).__mul,
  __call = getmetatable(template).__call,
  __pow  = getmetatable(template).__pow,
  __tostring =
    function (self)
      local html = "<"..self.tag
      -- Trate as propriedades obrigatórias aqui
      
      for property, value in pairs(self.properties or {}) do
        if type(property) ~= "number" then
          html = html.." "..property.."=\""..value.."\" "
        end
      end
      
      -- coloque as propriedades customizadas aqui
      
      html = html..">"

      -- Coloque as suas tags customizadas que devem ficar antes
      -- das tags filhas aqui

      -- Processa as tags filhas
      for i, children in ipairs(self.properties or {}) do
        html = html..tostring(children)
      end

      -- Coloque as suas tags customizadas que devem ficar depois
      -- das tgas filhas aqui

      return html.."</"..self.tag..">"
    end
  ,
})
```

Por exemplo o section do CTA dessa demonstração oficial do Bootstrap pode ser escrita assim:

```lua
HeaderSection = setmetatable({tag="section",properties={}},{
  __mul  = getmetatable(template).__mul,
  __call = getmetatable(template).__call,
  __pow  = getmetatable(template).__pow,
  __tostring =
    function (self)
      local html = "<"..self.tag
      -- Trate as propriedades obrigatórias aqui
      self.properties.class = self.properties.class and self.properties.class.." py-5 text-center container\"" or " py-5 text-center container\""

      for property, value in pairs(self.properties or {}) do
        if type(property) ~= "number" then
          html = html.." "..property.."=\""..value.."\""
        end
      end

      -- coloque as propriedades customizadas aqui

      html = html..">"

      -- Coloque as suas tags customizadas que devem ficar antes
      -- das tags filhas aqui

      html = html..'<div class="row py-lg-5">'
      html = html..'<div class="col-lg-6 col-md-8 mx-auto">'

      -- Processa as tags filhas
      for i, children in ipairs(self.properties or {}) do
        html = html..tostring(children)
      end

      html = html..'</div>'
      html = html..'</div>'


      -- Coloque as suas tags customizadas que devem ficar depois
      -- das tgas filhas aqui

      return html.."</"..self.tag..">"
    end
  ,
})

```

O uso fica idêntico as tags HTML normais

## Coisas pra fazer:

- [ ] Facilitar a criação de componentes customizados
- [ ] Pacote LuaRocks


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


#### Intercalando listas com o conteúdo [Resultado](https://codepen.io/natanael-b/pen/ExebRVj):

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

#### Pegando blocos avulsos [Resultado](https://codepen.io/natanael-b/pen/MWqOXaM)

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
Custom = html_component "custom_tag" {
  properties = {
    -- Propriedades e seus valores, esses valores são adicionados
    -- ao final do componente
  },
  pre_childrens_data = {
    -- Elementos e/ou textos para serem adicionados antes dos componentes filhos
  },
  post_childrens_data = {
    -- Elementos e/ou textos para serem adicionados após dos componentes filhos
  }
}
```

Por exemplo o section do CTA [dessa demonstração oficial do Bootstrap](https://getbootstrap.com/docs/5.3/examples/album/) pode ser escrita assim:

```lua
HeaderSection = html_component "section" {
  properties = {
    class = "py-5 text-center container"
  },
  pre_childrens_data = {
    '<div class="row py-lg-5">','<div class="col-lg-6 col-md-8 mx-auto">'
  },
  post_childrens_data = {
    '</div>','</div>'
  }
}
```

O uso fica idêntico as tags HTML normais

## Limitação de sintaxe

Devido a sintaxe Lua algumas situações podem resultar em erros, isso acontece porque Lua utiliza [[ e ]] para delimitar strings com mais de uma linha, considere que você precisa adicionar o seguinte código Javascript em em LuaTML:

```js
const indices = [0,1,2,3,4,5];
const valores = ["zero","um","dois","três","quatro","cinco"];
alert(valores[indices[3]]);
```

Em LuaTML instintivamente:

```lua
local teste = script [[
const indices = [0,1,2,3,4,5];
const valores = ["zero","um","dois","três","quatro","cinco"];
alert(valores[indices[3]]);
]]

print(teste)
```

Porém, isso resultará em um erro, ao invés disso subsitua `]]` por `]].."]]"..[[`:

```lua
local teste = script [[
const indices = [0,1,2,3,4,5];
const valores = ["zero","um","dois","três","quatro","cinco"];
alert(valores[indices[3]].."]]"..[[);
]]

print(teste)
```

Caso seja realmente 

## Coisas pra fazer:

- [x] Facilitar a criação de componentes customizados
- [ ] Pacote LuaRocks


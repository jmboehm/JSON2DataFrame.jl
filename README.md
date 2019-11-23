[![Build Status](https://travis-ci.org/jmboehm/JSON2DataFrame.jl.svg?branch=master)](https://travis-ci.org/jmboehm/JSON2DataFrame.jl) [![Coverage Status](https://coveralls.io/repos/jmboehm/JSON2DataFrame.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jmboehm/JSON2DataFrame.jl?branch=master)

# JSON2DataFrame.jl

This package provides a few functions to conveniently flatten information stored in JSON format and convert it to `DataFrame`s.

# Installation

```
] add https://github.com/jmboehm/JSON2DataFrame.jl.git
```

# Usage

```julia
using JSON, DataFrames, JSON2DataFrame

data = JSON.parsefile("data/colbase-0.json")
data = data["results"]["bindings"]
d = deepcopy(data)

flat = JSON2DataFrame.flatten.(d)
df = JSON2DataFrame.dicts_to_df(flat)

df = JSON2DataFrame.flatten_to_df(d)

```

The `flatten` function (and `flatten_to_df`) goes through the JSON hierarchy recursively and creates new keys of the form `$(parentkey)_$(childkey)`. The `DataFrame` then inherits these keys.

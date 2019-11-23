
using JSON, DataFrames, JSON2DF, Test

data = JSON.parsefile("test/data/colbase-0.json")
data = data["results"]["bindings"]

d = deepcopy(data)
flat = JSON2DataFrame.flatten.(d)
@test flat[1]["c_type"] == "uri"
df = JSON2DataFrame.dicts_to_df(flat)
@test df[1,:c_type] == "uri"
df = JSON2DataFrame.flatten_to_df(d)
@test df[1,:c_type] == "uri"

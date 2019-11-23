
# this recursively flattens all dict's in a JSON structure
function flatten(d::Dict{String, Any}; prefix::String = "")
    d_out = Dict{String, Any}()
    for k in keys(d)
        if isa(d[k], Dict)
            merge!(d_out, flatten(d[k], prefix = "$(prefix)$(k)_"))
        else
            push!(d_out, "$(prefix)$k" => d[k])
        end
    end
    d_out
end

# flatten a vector of Dict's to a DataFrame
function flatten_to_df(dicts::Array{Dict{String,Any},1})
    flat = flatten.(dicts)
    dicts_to_df(flat)
end
function flatten_to_df(dicts::Array{Any,1})
    if any(typeof.(dicts) .!= Dict{String, Any})
        error("Vector contains Dict with non-string keys")
    end
    flat = flatten.(dicts)
    dicts_to_df(flat)
end
# flatten a vector of Dict's to a CSV file
function flatten_to_csv(dicts::Array{Dict{String,Any},1}, csvfilename::String)
    flat = flatten.(dicts)
    dicts_to_csv(flat,csvfilename)
end
function flatten_to_csv(dicts::Array{Any,1}, csvfilename::String)
    if any(typeof.(dicts) .!= Dict{String, Any})
        error("Vector contains Dict with non-string keys")
    end
    flat = flatten.(dicts)
    dicts_to_csv(flat,csvfilename)
end

# The Dict's are assumed to NOT contain any further dicts
function dicts_to_df(dicts::Array{Dict{String,Any},1})
    # get variable names
    variables = Vector{String}()
    for i = 1:length(dicts)
        for k in keys(dicts[i])
            if !any(variables .== k)
                push!(variables,k)
            end
        end
    end
    # construct DataFrame
    df = DataFrame(_row = collect(1:length(dicts)))
    for v in variables
        df[:,Symbol(v)] = [(haskey(dicts[i], v) ? dicts[i][v] : missing) for i = 1:length(dicts)]
    end
    return df
end

# write to csv
function dicts_to_csv(dicts::Array{Dict{String,Any},1}, csvfilename::String)
    df = dicts_to_df(dicts)
    CSV.write(csvfilename, df, missingstring="",quotestrings=true)
end

# Additional cleaning code

# cleanvariables = ["content", "highlight", "sgcool_label_text"]
# for v in cleanvariables
#     if (typeof(df[:,Symbol(v)]) == Array{String,1})
#         x = df[!,Symbol(v)]
#         x .= replace.(x, "\r\n" .=> " ");
#         x .= replace.(x, "\n" .=> " ");
#         x .= replace.(x, "\r" .=> " ");
#         x .= replace.(x, "\\r\\n" .=> " ");
#         x .= replace.(x, "\\n" .=> " ");
#         x .= replace.(x, "\\r" .=> " ");
#     end
#     if (typeof(df[:,Symbol(v)]) == Array{Union{Missing, String},1})
#         x = skipmissing(df[!,Symbol(v)])
#         df[.!(ismissing.(df[:,Symbol(v)])),Symbol(v)] = replace.(x, "\r\n" .=> " ");
#         df[.!(ismissing.(df[:,Symbol(v)])),Symbol(v)] = replace.(x, "\n" .=> " ");
#         df[.!(ismissing.(df[:,Symbol(v)])),Symbol(v)] = replace.(x, "\r" .=> " ");
#         df[.!(ismissing.(df[:,Symbol(v)])),Symbol(v)] = replace.(x, "\\r\\n" .=> " ");
#         df[.!(ismissing.(df[:,Symbol(v)])),Symbol(v)] = replace.(x, "\\n" .=> " ");
#         df[.!(ismissing.(df[:,Symbol(v)])),Symbol(v)] = replace.(x, "\\r" .=> " ");
#     end
# end

# CSV.write(outfilename, df, missingstring="",quotestrings=true)

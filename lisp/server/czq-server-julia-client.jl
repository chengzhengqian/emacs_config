using JuliaCommon
# pattern=evalInEmacs("(strip-font-info (thing-at-point `symbol))")
import Sockets.Sockets

function appendResult(result,i)
    if(result!="")
        result*=",$(string(i))"
    else
        result="$(string(i))"
    end            
    result
end

function autocomplete(target)
    result=""
    for i in names(Main,imported=true)
        if (startswith(string(i),target))
            result=appendResult(result,i)
        end
        if((i != :Main) && (eval(i) isa Module))
            for j in names(eval(i))
                if (startswith(string(j),target))
                    result=appendResult(result,j)
                end
            end            
        end        
    end
    result
end



function autocompleteInEmacs()
    pattern=evalInEmacs("(strip-font-info (thing-at-point `symbol))")
    pattern=replace(pattern, "\""=>"")
    results=autocomplete(pattern)
    select=evalInEmacs("(czq-autocomplete \"$(pattern)\" \"$(results)\")")
    print("you have selected $(select).")
end


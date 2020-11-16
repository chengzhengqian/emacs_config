
(* WriteString[s,"(thing-at-point `line)\n"] *)
(* WriteString[s,"teststr"] *)
(* WriteString[s,"\n"] *)
(* a=ReadLine[s] *)
(* size=ToExpression[a]; *)
(* result=ReadLine[s] *)
(* While[StringLength[result]<size,result=result<>"\n"<>ReadLine[s]] *)

evalInEmacs[str_,s_]:=Module[{size,result},WriteString[s,str<>"\n"];size=ToExpression[ReadLine[s]];result=ReadLine[s];While[StringLength[result]<size,result=result<>"\n"<>ReadLine[s]];result];

(* evalInEmacs["(format \"%s\" (thing-at-point `symbol))",s] *)
(* make this into emacs options *)
evalInEmacs[str_]:=evalInEmacs[str,czqEmacsEvalConnection]


autocompleteInEmacs[p_,r_]:=evalInEmacs["(czq-autocomplete \""<>p<>"\" \""<>r<>"\")"]

autocompleteInEmacs[]:=Module[{pattern,result,select},pattern=evalInEmacs["(strip-font-info (thing-at-point `symbol))"];pattern=StringReplace[pattern,"\""->""];result=StringRiffle[Names[pattern<>"*"],","];select=autocompleteInEmacs[pattern,result];"You have selected "<>select<>"."]



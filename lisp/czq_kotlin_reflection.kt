fun methodStartsWith(obj:Any, start:String){
	obj::class.java.methods.forEach{x->
		var n=x.name
		if(n.startsWith(start))
		println(n)
	}
}	



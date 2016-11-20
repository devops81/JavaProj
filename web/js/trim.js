	
	function trimAll(sString){
		while (sString.substring(0,1) == ' '){
			sString = sString.substring(1, sString.length);
		}
		while (sString.substring(sString.length-1, sString.length) == ' '){
			sString = sString.substring(0,sString.length-1);
		}
		return sString;
	}

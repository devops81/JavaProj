function doClock(){
	var t=new Date(),a=doClock.arguments,str="",i,a1,lang="1";
	var month=new Array('January','Jan', 'February','Feb', 'March','Mar', 'April','Apr', 'May','May', 'June','Jun', 'July','Jul', 'August','Aug', 'September','Sep', 'October','Oct', 'November','Nov', 'December','Dec');
	var tday= new Array('Sunday','Sun','Monday','Mon', 'Tuesday','Tue', 'Wednesday','Wed','Thursday','Thr','Friday','Fri','Saturday','Sat');
	for(i=0;i<a.length;i++) {a1=a[i].charAt(1);switch (a[i].charAt(0)) {
	case "M":if  ((Number(a1)==3) && ((t.getMonth()+1)<10)) str+="0";
	str+=(Number(a1)>1)?t.getMonth()+1:month[t.getMonth()*2+Number(a1)];break;
	case "D": if ((Number(a1)==1) && (t.getDate()<10)) str+="0";str+=t.getDate();break;
	case "Y": str+=(a1=='0')?t.getFullYear():t.getFullYear().toString().substring(2);break;
	case "W":str+=tday[t.getDay()*2+Number(a1)];break; default: str+=unescape(a[i]);}}return str;
}
function goToOutside(site){
	if(confirm("Please Note: You are now leaving a Boehringer Ingelheim Pharmaceuticals, Inc. site. Boehringer Ingelheim Pharmaceuticals, Inc. has not reviewed the contents of all the pages and sites that may be linked to this site. Boehringer Ingelheim Pharmaceuticals, Inc. is not responsible and disclaims any liability to the content of any other page or site or for any viruses or similar harmful programs that may be present on such pages or sites. Linking to any other page or site is at your own risk."))
	window.open(site,'','toolbar=yes,menubar=no,scrollbars=yes,resizable=yes,width=770,height=500');
}
function IEHoverPseudo() {

	var navItems = document.getElementById("primary-nav").getElementsByTagName("li");
	
	for (var i=0; i<navItems.length; i++) {
		if(navItems[i].className == "menuparent") {
			navItems[i].onmouseover=function() { this.className += " over"; }
			navItems[i].onmouseout=function() { this.className = "menuparent"; }
		}
	}

}
window.onload = IEHoverPseudo;

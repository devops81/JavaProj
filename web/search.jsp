 <%@ page language="java" %>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.forms.AdvancedSearchForm" %>
<%@page import="com.openq.eav.metadata.AttributeType"%>
<%@ page import="java.util.*"%>
<%
	String fromEventFlag = "false";
	if(session.getAttribute("fromEvent")!= null )
	{
		fromEventFlag =(String) session.getAttribute("fromEvent");
	}
	String fromOLAlignment = "false";
	if(session.getAttribute("fromOLAlignment")!= null )
	{
		fromOLAlignment =(String) session.getAttribute("fromOLAlignment");
	}  

  String eavTrial = "";
  if(session.getAttribute("eavTrial")!= null )
	{
		eavTrial =(String)session.getAttribute("eavTrial");
              
  }
%>

	<%if(fromEventFlag.equalsIgnoreCase("false") || fromOLAlignment.equalsIgnoreCase("true")){%>
	<%@ include file="header.jsp" %>
    <%} else {%>
    <script src="./js/utilityFunctions.js"></script>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
	<%}%>
<%
	



  String keyword = (String)session.getAttribute("keyword"); 
  String default_load =  request.getParameter("default"); // Page Loading for first time
  String searchBuilder = (String)session.getAttribute("searchBuilder");
  String expertCheckBox = (String)request.getParameter("expertCheckBox");
  if(searchBuilder!=null)
  default_load=searchBuilder;
  if(expertCheckBox == null) {
    expertCheckBox = (String) session.getAttribute("expertCheckBox");
  }else{
    session.setAttribute("expertCheckBox",expertCheckBox);
  }
  String orgCheckBox = null;
  if(fromEventFlag.equalsIgnoreCase("false"))
  {
    orgCheckBox = (String)request.getParameter("orgCheckBox");
    if(orgCheckBox == null) {
      orgCheckBox = (String) session.getAttribute("orgCheckBox");
    }else{
      session.setAttribute("orgCheckBox",orgCheckBox);
    }
  }
  String trialCheckBox = null;
  if(fromEventFlag.equalsIgnoreCase("false"))
  {
      trialCheckBox = (String)request.getParameter("trialCheckBox");
    if(trialCheckBox == null) {
      trialCheckBox = (String) session.getAttribute("trialCheckBox");
    }else{
      session.setAttribute("trialCheckBox",trialCheckBox);
    }
  }  
  AttributeType [] searchableAttrs = null;
  if(session.getAttribute("EXPERT_SEARCHABLE_ATTRIBUTES")!=null)
  {
    searchableAttrs= (AttributeType[])session.getAttribute("EXPERT_SEARCHABLE_ATTRIBUTES");  
   
  }
  
  String[] searchParam1=null,searchParam2=null;
  if(session.getAttribute("selectedSearchParam1")!=null)
  {
    searchParam1 = (String[])session.getAttribute("selectedSearchParam1");
    
  }
  if(session.getAttribute("selectedSearchParam2")!=null)
  {
    searchParam2 = (String[])session.getAttribute("selectedSearchParam2");
  }
  List searchParams = null;
  if(session.getAttribute("selected_searchParams")!=null)
  {
    searchParams = (List)session.getAttribute("selected_searchParams");
  }
   String selectText=null;
  if(session.getAttribute("selectText")!=null)
  {
    selectText = (String)session.getAttribute("selectText");
  }
	String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
	boolean isSAXAJVUser = false;
	if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
			isSAXAJVUser = true;
	}
	
	String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
	boolean isOTSUKAJVUser = false;
	if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
			isOTSUKAJVUser = true;
	}

%>


<html>
  <head>
    <style type='text/css'>
      @import "js/dojo-release-0.9.0/dijit/themes/tundra/tundra.css";
      @import "js/dojo-release-0.9.0/dojo/dojo.css";
    </style>
      <script language="javascript" src="js/populateChildLOV.js"></script>
      <script type="text/javascript" src="js/utilityFunctions.js"></script>
	  <script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
    <style type="text/css">
      .reset {
        padding: 0;
        margin: 0;
        font: 11px Verdana, Arial, Helvetica, sans-serif; 
        text-transform: none; 
        color: #006699; 
        text-decoration: none;
      }

      .colOuter {
        border: 1px solid #ECEADE;
        padding: 2px;
        margin: 5px;
        overflow: hidden;
      }
		tr {}
		.coloronmouseover
		{
		BACKGROUND-COLOR: #E2EAEF
		}
		
		.colorMouse
		{
		background-color: #DAD29C
		}
		.coloronmouseout
		{
		BACKGROUND-COLOR: #ffffff
		}
      .colTitle {
        background-color: #F3F0DF;
        color: #4C7398;
        padding: 7px;
        font-size: 12px;
        font-weight: bold;
      }

      .colToolbar {
        background-color: #F3F0DF;
        color: #4C7398;
        padding: 7px;
        font-weight: bold;
        margin-top: 1px;
      }

      .listHeading {
        FONT-WEIGHT: bold;
        FONT: 11px Verdana, Arial, Helvetica, sans-serif; 
        TEXT-TRANSFORM: none; 
        COLOR: #006699; 
        TEXT-DECORATION: underline;
      }

      .colContent {
        width:92%;
        padding-top:30px;
        margin-left:25px;
        color:#4c7398;
        font-size: 12px;
        padding: 5px;
      }

      .listContent {
        width:100%;
        padding: 7px;
        color:#4c7398;
        font-size: 12px;
      }

      .toggleImg {
        cursor: pointer;
      }   

      .openq .dijitSplitContainerSizerH {
        background:none;
        border:none;
        width:7px;
      }

      .openq .dijitSplitContainerSizerH .thumb {
        background:url("images/splitContainerSizerDotsH-thumb.png") no-repeat;
        left:1px;
        width:5px;
        height:36px;
      }
    </style>
    <script type="text/javascript">
    var count = 2;
      dojo.require("dojo.parser");
      dojo.require("dijit.form.CheckBox");
      dojo.require("dijit.layout.SplitContainer");
      dojo.require("dijit.layout.ContentPane");
      dojo.require("dojo.fx");
      dojo.require("dojox.fx.easing");
      dojo.require("dijit.Tooltip");
  function findPosX(obj)
  {
    var curleft = 0;
    if(obj.offsetParent)
        while(1) 
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
    return curleft;
  }

 function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }

function showGoDiv(secId){
document.getElementById("expertName"+secId).className='coloronmouseover';
//document.getElementById("quickContactDiv"+secId).style.display="block";

}
function hideGoDiv(secId){
if(secId%2==0){
 	document.getElementById("expertName"+secId).className="white";
 }else{
 	document.getElementById("expertName"+secId).className="#faf9f2";
 }
}

 function showContentDiv(secId,fromContentDiv){
 var i=0; 
 while(document.getElementById("quickContactDiv"+i)!=null){
  document.getElementById(i+"Content").style.display="none";
  i++;
 }
  var lastIndex=i-1;
  var divId=dojo.byId("quickContactDiv"+secId);
  var divIdofLastGo=dojo.byId("quickContactDiv"+lastIndex);
  var offsetY=150;
  var offsetX=250;
  var containerHeight=550;  
  var menuX=findPosX(divId);
  var menuY=findPosY(divId);
  var menuYOfLastGo=findPosY(divIdofLastGo);
  var scrollTop=document.getElementById("listContent").scrollTop;
  var hightOfContentDiv=80
  var offsetOnContentDiv=20;
   	  
	  if(fromContentDiv=="true"){
	       document.getElementById(secId+"Content").style.left=menuX-offsetX;
	       if(menuY-scrollTop+hightOfContentDiv+offsetOnContentDiv>containerHeight){
		     document.getElementById(secId+"Content").style.top=menuY-scrollTop-120-offsetY;
		   }else{
		     document.getElementById(secId+"Content").style.top=menuY-scrollTop-offsetY;
		    } 
	  }else{
	  	   
		   document.getElementById(secId+"Content").style.left=menuX-offsetX;
		   if(menuY-scrollTop+hightOfContentDiv+offsetOnContentDiv>containerHeight){
		     document.getElementById(secId+"Content").style.top=menuY-scrollTop-120-offsetY; //120 is used to change the orientation of div from bottom to top as there is no space for the dov to go from top to bottom
		   }else{
		     document.getElementById(secId+"Content").style.top=menuY-scrollTop-offsetY;
		    }
	   
	  } 
	  
  document.getElementById(secId+"Content").style.display="block";
  
}    

function hideContentDiv(secId){
  document.getElementById(secId+"Content").style.display="none";
}

function showQuickContactDiv(secId){
  showGoDiv(secId);
  showContentDiv(secId,"true");
}
function hideQuickContactDiv(secId){
  hideGoDiv(secId);
  hideContentDiv(secId);
}
	  function togglePane(event, paneID, url){
        var flag=false;
        var pane = dijit.byId(paneID);
        var splitContainer = dijit.byId("split");
        splitContainer.getChildren().forEach(
          function(child){
            if(paneID == child.id)
            flag=true;
          }
        );
        if(flag){
          animate(event,paneID, function(){
              dojo.style(document.getElementById(paneID+"Content"),"display", "none");
            }, true);
          splitContainer.removeChild(pane);
        } else {
          pane = dijit.byId(paneID);
          if(typeof pane != "undefined" && pane != null){
            splitContainer.addChild(pane);
          } else {
            var divElem = dojo.doc.createElement('div');
            divElem.id = paneID;
            var newChild = new dijit.layout.ContentPane({
                              id: paneID,
                              href:url,
                              title:paneID,
                              refreshOnShow:true,
                              onDownloadStart:getLoadingMsg
                            },divElem);
            splitContainer.addChild(newChild);
            newChild.startup();
          }
          if(document.getElementById(paneID+"Content"))
            dojo.style(document.getElementById(paneID+"Content"),"display", "none");
            animate(event,paneID, function(){
              if(document.getElementById(paneID+"Content"))
                dojo.style(document.getElementById(paneID+"Content"),"display", "block");
            });
        }
      }

      dojo.addOnLoad(function(){
        dojo.connect(
          dijit.byId("expertCheckBox"),
          "onClick",
          function(event){
            togglePane(dojo.coords(dojo.byId('expertCheckBox')),'expertPane','expert.jsp');
          }
        );
        dojo.connect(
          dijit.byId("orgCheckBox"),
          "onClick",
          function(event){
            togglePane(dojo.coords(dojo.byId('orgCheckBox')),'orgPane','org.jsp');
          }
        );
        dojo.connect(
          dijit.byId("trialCheckBox"),
          "onClick",
          function(event){
            togglePane(dojo.coords(dojo.byId('trialCheckBox')),'trialPane','trial.jsp')
          }
        );
      });
      
      function animate(event, paneID, continuationFunc, isReverse){
        var animateDiv = document.getElementById("animateDiv");

        var contentDiv = dojo.byId(paneID);
        var coords = dojo.coords(contentDiv);

        if(typeof isReverse == "undefined") isReverse = false;

        dojo.style(animateDiv,"display","block");
        dojo.animateProperty({
          node: 'animateDiv',
          duration: 1000,
          properties: {
            left: {
              start: isReverse ? coords.x : event.x,
              end: isReverse ? event.x : coords.x
            },
            top: {
              start: isReverse ? coords.y : event.y,
              end: isReverse ? event.y : coords.y
            },
            width: {
              start: isReverse ? coords.w : 20,
              end: isReverse ? 20 : coords.w
            },
            height: {
              start: isReverse ? coords.h : 10,
              end: isReverse ? 10 : coords.h
            }
          },
          easing: isReverse ? dojox.fx.easing.easeIn : dojox.fx.easing.easeIn,
          onEnd: function(){
            dojo.style(animateDiv,"display","none");
              if(!isReverse) continuationFunc();
            }
        }).play();
      }

      function showTagCloud(nodeId){
		 
        var tagCloudVisible = (dojo.style(nodeId, "display") != "none");
        if(tagCloudVisible){
          dojo.fx.wipeOut({
            node: nodeId,
            duration: 200
          }).play();
         } else {
          dojo.fx.wipeIn({
            node: nodeId,
            duration: 200
          }).play();
         }
      }

      function hideDefault(input){
        if(typeof(input.defaultValue)=="undefined"){
          input.defaultValue = input.value;
        }
        if(input.value == '<Enter Keyword>'){
          input.value = "";
        }
      }

      function showDefault(input){
        if(input.value == ""){
          input.value = '<Enter Keyword>';
        }
      }
      function checkInput() {

		if(document.advanceSearch.searchText.value == null || 
            document.advanceSearch.searchText.value == "" || 
            
            document.advanceSearch.searchText.value == '<Enter Keyword>'){
          alert('Please enter keyword');
          return;
        } else {
           openProgressBar();
          document.advanceSearch.searchText.value = checkAndReplaceApostrophe(document.advanceSearch.searchText.value);
		  document.advanceSearch.action="search.htm?fromEvent=<%=fromEventFlag%>&fromOLAlignment=<%=fromOLAlignment%>"+"&removePageSession="+"True"+"&removeAction=True";
          document.advanceSearch.submit();
          
        }
      }
      
      function runGeoMap(){
		 
      	var online = window.navigator.onLine;
      	if(online){	
		  document.advanceSearch.action = "expert_map.htm?expertsToDisplay=OLSearchResults";
		  document.advanceSearch.submit();
		  }
		 else{
		  alert("Internet Connection is not available");
		 } 
  		}
      
      function getLoadingMsg() {
		  
        return "<div class=\"text-blue-01\" style=\"padding: 3px 0px; text-align: center; vertical-align: middle;\"><img src=\"images/loading_blue.gif\"/> \&nbsp;Loading...</div>";
      }
      function addOrg()
	{
		
		document.location.href="add_org.jsp";
	}
	
	function callOnChange()
	{
	 
 	  var mydiv = document.getElementById('mydiv');
 	  var expertcheckBox = document.getElementById('expertCheckBox'); 
 	  if(expertcheckBox!=null&&expertcheckBox.checked)
 	  {
 	   mydiv.style.display = "block"; //to show it
	  }
	  else if(expertcheckBox!=null&&!expertcheckBox.checked)
      {
        mydiv.style.display = "none"; //to hide it
      }
      
	}
	
	function addrow(selectValue,textValue)//This function adds a select and a textbox dynamically.
	{
	      
            var options=document.getElementById("attributeFilter1").options;
            if(count <8)
	     {
		      var tbl = document.getElementById('mytable');
		  var lastRow = tbl.rows.length;
		  // if there's no header row in the table, then iteration = lastRow + 1
		  count = count+1;
		  var row = tbl.insertRow(lastRow);
		  
		  var cleft = row.insertCell(0);
                var labDiv = document.createElement('div');
                labDiv.className = 'leftsearchtext';
                labDiv.appendChild(document.createTextNode('Attribute'));
                cleft.appendChild(labDiv);
	          		
		  // for second column
                var cright = row.insertCell(1);
                var labDiv2 = document.createElement('div');
                labDiv2.className = 'leftsearchtext';
                labDiv2.appendChild(document.createTextNode('Value'));
                cright.appendChild(labDiv2);
		  
		  
		  lastRow = lastRow+1;
		  var rownew = tbl.insertRow(lastRow);
		  		 
		  var cellLeft = rownew.insertCell(0);
		  var sel = document.createElement('select');
		  sel.name = 'attributeFilter' + count;
                sel.id = 'attributeFilter' + count;
		  sel.style.width = "150 px"; 
                sel.className='blueTextBox';  
		  if(options!=null)
                {
                  for(var i=0;i<options.length;i++)
                        {
                             sel.options[i]= new Option(options[i].text,options[i].value);
                             sel.options[i].title=options[i].text;
                          if(selectValue!=null&&textValue!=null)
                          {
                            if(sel.options[i].value==selectValue)
                              {
                                sel.options[i].selected = true;
                                
                              }
                            }  
                        }
                        
                 }   
                cellLeft.appendChild(sel);
		  var cellRight = rownew.insertCell(1);
		  var el = document.createElement('input');
		  el.type = 'text';
		  el.name = 'searchAttributeText' + count;
		  el.id = 'searchAttributeText' + count;
		  el.size = 13;
          el.className='blueTextBox';		 
		  if(selectValue!=null&&textValue!=null)
                {
                  el.value=textValue;
                }
                cellRight.appendChild(el);
	     
		}
            else
            {
             alert("Sorry, At the maximum only 8 attributes could be added");
            }
            
	}
	
	function deleteRow(index){
			var rowStart=((index -1)*5) -1;
			if(rowStart == -1)
				rowStart =0;
			for(var j=0;j<5;j++){

				 document.getElementById('mytable').deleteRow(rowStart);
			}
			

			
			for(var j=index+1;j<=count;j++){
			
				var sel = document.getElementById('attributeFilter'+j);
				sel.name = 'attributeFilter' + (j-1);
         		sel.id = 'attributeFilter' + (j-1);
         		var el = document.getElementById('searchAttributeText'+j);
         		el.name = 'searchAttributeText' + (j-1);
		  		el.id = 'searchAttributeText' + (j-1);
			  	var attributeLOV = document.getElementById('attributeLOV'+j);
		  		attributeLOV.id = 'attributeLOV' + (j-1);
 		  		attributeLOV.name = 'attributeLOV' + (j-1);
 		  		var close = document.getElementById('closeLink'+j);
 		  		close.id = 'closeLink' + (j-1);
 		  		close.href ='Javascript:deleteRow('+(j-1)+')';
			}
			count=count -1;
		    
		    searchExpertAttributes();
			
						
	
	}
	
	function addrowNew(selectValue,textValue)//This function adds a select and a textbox dynamically.
	{
	      
            var options=document.getElementById("attributeFilter1").options;
            if(count <8)
	     {
		      var tbl = document.getElementById('mytable');
		  var lastRow = tbl.rows.length;
		  // if there's no header row in the table, then iteration = lastRow + 1
		  count = count+1;
		  var row = tbl.insertRow(lastRow);
		  var emptycol= row.insertCell(0);
		  var labDiv0= document.createElement('div');
		  labDiv0.innerText = ' ';
		  emptycol.appendChild(labDiv0);
		  lastRow = lastRow+1;
		  var rowAtt = tbl.insertRow(lastRow);
		  var cleft = rowAtt.insertCell(0);
          var labDiv = document.createElement('div');
          labDiv.className='leftsearchtext';
          var span0 = document.createElement('span');
          span0.className='leftsearchspanleft';
          span0.appendChild(document.createTextNode('Attribute'));
          labDiv.appendChild(span0);
          var span1 = document.createElement('span');
          span1.className='leftsearchspanright';

          
          var closeLink = document.createElement('a');
		  closeLink.id= 'closeLink'+count; 
 		  closeLink.href ='Javascript:deleteRow('+count+')';
          closeLink.appendChild(document.createTextNode('X')); 		  
          span1.appendChild(closeLink); 		  
          labDiv.appendChild(span1);
          cleft.appendChild(labDiv);
        		
		  // for second column
		  				  
		  lastRow = lastRow+1;
		  var rownew = tbl.insertRow(lastRow);
		  		 
		  var cellLeft = rownew.insertCell(0);
		  var sel = document.createElement('select');
		  sel.name = 'attributeFilter' + count;
          sel.id = 'attributeFilter' + count;
		  sel.style.width = "270 px"; 
          sel.className='blueTextBox';  
          sel.onchange = function(){checkAndPopulateLOV(count)};
          sel.onkeypress= function (){submitFormByEnterKey(searchExpertAttributes)};
		  if(options!=null)
          {
             for(var i=0;i<options.length;i++)
             {
                 sel.options[i]= new Option(options[i].text,options[i].value);
                 sel.options[i].title=options[i].text;
                 sel.options[i].id = options[i].id;
                 if(selectValue!=null&&textValue!=null)
                 {
	                 if(sel.options[i].value==selectValue)
                     {
                         sel.options[i].selected = true;
                     }
                 }  
             }
                  
           }   
             cellLeft.appendChild(sel);
                //right cell
                lastRow = lastRow+1;
		  		var rowc1= tbl.insertRow(lastRow);
                var cellc11 = rowc1.insertCell(0);
                var labDiv2 = document.createElement('div');
                labDiv2.className = 'leftsearchtext';
                labDiv2.appendChild(document.createTextNode('Value'));
                cellc11.appendChild(labDiv2);
          lastRow = lastRow+1;
		  var rownew2 = tbl.insertRow(lastRow);
		  var cellrown2 = rownew2.insertCell(0);
		  // add DIV for text value
		  var attributeValueDiv = document.createElement('div');
		  attributeValueDiv.id = 'attributeValueDiv' + count;
		  attributeValueDiv.style.display = 'block';
		  cellrown2.appendChild(attributeValueDiv);

		  
		  var el = document.createElement('input');
		  el.type = 'text';
		  el.name = 'searchAttributeText' + count;
		  el.id = 'searchAttributeText' + count;
		  el.size = 40;
          el.className='blueTextBox';		 
		  if(selectValue!=null&&textValue!=null){
                  el.value=textValue;
           }
		  el.onkeypress= function (){submitFormByEnterKey(searchExpertAttributes)};
		  attributeValueDiv.appendChild(el);
 		  // add DIV for LOV  value
 		  var attributeLOVDiv = document.createElement('div');
 		  attributeLOVDiv.id = 'attributeLOVDiv' + count;
 		  attributeLOVDiv.style.display = 'none';
 		  cellrown2.appendChild(attributeLOVDiv);
 		  // create the drop down
 		  var attributeLOV = document.createElement('select');
 		  attributeLOV.id = 'attributeLOV' + count;
 		  attributeLOV.name = 'attributeLOV' + count;
 		  attributeLOV.style.width = '270px';
 		  attributeLOV.className = 'blueTextBox';
 		  attributeLOV.disabled = true;
 		  attributeLOV.onchange = function(){setSearchValue(count)};
 		  attributeLOV.onkeypress= function (){submitFormByEnterKey(searchExpertAttributes)};
 		  attributeLOVDiv.appendChild(attributeLOV);
 		  // create the first option
		  var optionvalue = document.createElement("option");
		  optionvalue.setAttribute('id', '-1');
		  optionvalue.setAttribute('value', '-1');
		  optionvalue.setAttribute('selected', true); 
		  optionvalue.appendChild(document.createTextNode('Please Select'));
		  attributeLOV.appendChild(optionvalue);

		  checkAndPopulateLOV(count);
		  
		  
		}else{
             alert("Sorry, At the maximum only 8 attributes could be added");
        }
            
	}

     function searchExpertAttributes(){
 	   document.advanceSearch.searchText.value = '<Enter Keyword>';
	   var thisform = document.advanceSearch;
	   var selectElementOne = document.getElementById('attributeFilter1');
	   if(selectElementOne.disabled = 'disabled'){
		   selectElementOne.disabled=false
	   }
	   var firstSearchParametersValid = false;
       for(var i=1; i<=count; i++){
        var selectElement = document.getElementById("attributeFilter"+i);
        var searchElement = document.getElementById("searchAttributeText"+i); 
        
        if(selectElement.selectedIndex != -1 && 
                selectElement.options[selectElement.selectedIndex].text != "Please Select"){

            if(searchElement.value == null || searchElement.value == "" ||
            		searchElement.value == undefined){
              alert('Please enter valid text');
              searchElement.focus();
              return;             
            }
            firstSearchParametersValid = true;
         }else if(searchElement.value != null && searchElement.value != "" &&
         		searchElement.value != undefined){
             alert('Please select the attribute parameter');
             selectElement.focus();
             return;  
         }
         if(i == 1 && !firstSearchParametersValid){
        	 alert('Please select the attribute parameter');
             selectElement.focus();
             return;  
         }
       }

		thisform.action="search.htm?action=expertAttributeSearch&fromEvent=<%=fromEventFlag%>"+"&removePageSession="+"True"+"&fromOLAlignment=<%=fromOLAlignment%>";
		openProgressBar();
        thisform.submit();
    }
     
    function addAttendeeToEvent(){
		
		var thisform = document.advanceSearch;
		  var flag = false ;
		  var checkIds = document.getElementsByName('checkIds');
		  if (null != checkIds && checkIds.length != undefined){

		  for (var i = 0;  null != checkIds && i < checkIds.length; i++) {

            if (checkIds[i].checked) {
                    flag = true;
                    break;
                }
           }
          }
          else{
          	 if (checkIds.checked) {
                flag = true;
             }
          }

          if (!flag)
            {
                alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
                return false;
            }
		var a=new Array();
		for (var i = 0;  null != checkIds && i < checkIds.length; i++) {

            if (checkIds[i].checked) {
                   a.push(checkIds[i].value); 
                    
                }
           }
		
		
		window.opener.addAttendeeFromAdvSearch(a);	
		window.close();
	}  
	
	function addOLAlignment(){
		 var thisform = document.advanceSearch;
          var flag = false ;
		  if (null != thisform.ids && thisform.ids.length != undefined){
		  for (var i = 0;  null != thisform.ids && i < thisform.ids.length; i++) {
            if (thisform.ids[i].checked) {
                    flag = true;
                    break;
                }
           }
          }
          else{
          	 if (thisform.ids.checked) {
                flag = true;
             }
          }

          if (!flag)
            {
                alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
                return false;
            }

     document.advanceSearch.action = "OLAlignment.htm?action=<%=ActionKeys.KOL_ADD_EXPERTS%>&fromOLAlignment=true";
	 document.advanceSearch.submit();
	}  

    var checked=false;
    function checkedAll() {
    	var checkIds = document.getElementsByName('checkIds');
        if(checked == false) {
            checked = true;
        }
        else {
            checked = false;
        }
        for (var i=0; i<checkIds.length; i++) {
            checkIds[i].checked = checked;
        }
    }

    function addOLsToExpertList() {
        var button1 =document.getElementById('addExpert');
        var checkIds = document.getElementsByName('checkIds');
        var thisform = document.advanceSearch;
        var flag = false ;

        if (null != checkIds && checkIds.length != undefined) {
           // array of check boxes
           for (var i=0; i<checkIds.length; i++) {
             if (checkIds[i].checked) {
                flag = true;
                break;
             }
           }
        } 

       if (!flag) {
    	   alert("Please select at least one <%=DBUtil.getInstance().doctor%>");
       }
       else {
          if(window.confirm("Are you sure you want to add this <%=DBUtil.getInstance().doctor%> to your List ?")) {
              thisform.action="searchKol.htm?fromAdvanceSearch=true";
              thisform.submit();
          } 
       }
    }

    function resetSearch(){
       var thisform = document.advanceSearch;
       document.advanceSearch.searchText.value = '<Enter Keyword>';
       thisform.action = "search.htm?default=true&reset=<%=ActionKeys.RESET_ADVANCE_SEARCH%>";
       thisform.submit();
    }
 	function ExpertSearch(pageNumber,pageForExpert, linkClicked)
      {
      	if(pageForExpert!=null && pageForExpert=='True')
      	{
  			document.advanceSearch.action="search.htm?fromEvent=<%=fromEventFlag%>"+"&fromOLAlignment=<%=fromOLAlignment%>"+"&pageNumber="+pageNumber+"&linkClicked="+linkClicked;
  		}
  		else if(pageForExpert!=null && pageForExpert=='False')
  		{
  			document.advanceSearch.action="search.htm?fromEvent=<%=fromEventFlag%>"+"&pageNumberOrg="+pageNumber+"&linkClicked="+linkClicked;
  		}
        document.advanceSearch.submit();
      }
    
   function addPages(totalPages,pagesTable,pageForExpert)
   {
	 if(null!=totalPages && totalPages>0)
	 {
	    var table= document.getElementById(pagesTable);
		    var row = table.insertRow(0);
		    var count=0;
		    while(count<totalPages)
		    {
		    	var cell = row.insertCell(count);
		    	if(pageForExpert!=null && pageForExpert=='True')
		    	{
		    		cell.innerHTML="<a href=\"#\" onclick= \"ExpertSearch("+count+",\'True\')\">"+(count+1)+" </a>";
		    	}
		    	else if(pageForExpert!=null && pageForExpert=='False')
		    	{
		    		cell.innerHTML="<a href=\"#\" onclick= \"ExpertSearch("+count+",\'False\')\">"+(count+1)+" </a>";
		    	}
		    	count=count+1;
		    }
		}
	   
    	
   }	
function checkAndPopulateLOV(searchAttributeIndex){
	var selectedAttribute = document.getElementById('attributeFilter' + searchAttributeIndex);
	if(selectedAttribute != null && 
			selectedAttribute != undefined && selectedAttribute.id != 0){
		var textDiv = document.getElementById('attributeValueDiv'+searchAttributeIndex);
		var lovDiv = document.getElementById('attributeLOVDiv' + searchAttributeIndex);
		var LOVHTMLElementId = 'attributeLOV' + searchAttributeIndex;
		var selectedOptionId = selectedAttribute.options[selectedAttribute.selectedIndex].id;
		var searchTextbox = document.getElementById('searchAttributeText' + searchAttributeIndex);
		var lastSearchedValue = '';
		if(searchTextbox != null && searchTextbox != undefined){
			lastSearchedValue = searchTextbox.value;
		}
		if(selectedOptionId != -1 && selectedOptionId != 0){
			if(textDiv != null && lovDiv != null){
				// synchronous call
				populateLOVByOptionId(selectedOptionId, LOVHTMLElementId, false, lastSearchedValue);
				textDiv.style.display = 'none';
				lovDiv.style.display = 'block';
			}
		}else if (textDiv != null && lovDiv != null){
			textDiv.style.display = 'block';
			lovDiv.style.display = 'none';
		}
	}
}
function setSearchValue(searchAttributeIndex){
	var selectedLOV = document.getElementById('attributeLOV' + searchAttributeIndex);
	if(selectedLOV != null && selectedLOV != undefined){
		var selectedValue = selectedLOV.options[selectedLOV.selectedIndex].value;
		var searchTextbox = document.getElementById('searchAttributeText' + searchAttributeIndex);
		if(searchTextbox != null && searchTextbox != undefined){
			searchTextbox.value = selectedValue;
		}
	}
}
</script>
  </head>
  <body class="tundra">
    <form name="advanceSearch" method="post" action="search.htm" >
      <div id="animateDiv" style="display: none; border: 1px solid; position: absolute; z-index: 100;"></div>
      <div id="tagCloudDiv" style="display: none; border: 1px solid; position: absolute; z-index: 100;"></div>
      <table style="width: 100%; height: 100%;">
        <tr>
          <td style="width: 200px; vertical-align: top;">
            <!--div class="paddingdiv" style="padding: 3px"></div-->
            <div class="expertsearchdiva">
              <div class="leftsearchbgpic">
                <div class="leftsearchtext">Quick Start</div>
              </div>
              <div class="firstname">
              <input type="text" border="#c3c3c3" value="<%=(keyword==null?"<Enter Keyword>":keyword)%>" class="blueTextBox" name="searchText"  
              		 onkeypress="submitFormByEnterKey(checkInput)"
              		 onFocus="return hideDefault(this);" onBlur="return showDefault(this);" <%if(isSAXAJVUser || isOTSUKAJVUser){%> readonly
               <%}%> /></div>
              <div class="paddingdiv" style="padding: 2px"></div>
              <%
                boolean isProfVersion = false;
                String profVersionPropVal = (String) session.getAttribute("isProfVersion");
                if((profVersionPropVal != null) && ("true".equalsIgnoreCase(profVersionPropVal)))
                  isProfVersion = true;
              %>
              
              <div class="colContent">
                <div style="padding: 1px">
                  <input id="expertCheckBox" type="checkbox" name="expertCheckBox" dojoType="dijit.form.CheckBox" onchange="callOnChange()" <%if(expertCheckBox!=null||default_load!=null){ %>checked<%} %> <%if(isSAXAJVUser || isOTSUKAJVUser){%>disabled checked<%}%>> 
				  </input>
                  &nbsp;<%=DBUtil.getInstance().doctor%>
                </div>
                <div style="padding: 1px">
                  <input id="orgCheckBox" <%=(isProfVersion?"disabled":"")%> type="checkbox" name="orgCheckBox" dojoType="dijit.form.CheckBox" <%if(orgCheckBox != null){ %>checked="true"<%} %>
				  <%if(isSAXAJVUser || isOTSUKAJVUser){%> disabled<%}%>></input>
                  &nbsp;Organization
                </div>
                <%
                	
                 	if(!eavTrial.equals("false")){
                 %>
                <div style ="display:none"style="padding: 1px">
                  <input id="trialCheckBox" <%=(isProfVersion?"disabled":"")%> type="checkbox" name="trialCheckBox" dojoType="dijit.form.CheckBox" <%if(trialCheckBox != null){ %>checked="true"<%} %>
				  <%if(isSAXAJVUser || isOTSUKAJVUser){%> disabled<%}%>></input>
                  &nbsp;Trials
                </div>
                <%} %>
              </div>
              <div class="searchButton" align="left">
                 <input type="button" name="Search2" value="" onclick="javascript:checkInput();"
				 <%if(isSAXAJVUser || isOTSUKAJVUser){%> disabled
				 style="border:0;background : url(images/buttons/search_disabled.jpg);width:86px; height:26px;"  
				 <%} else{%>
				 style="border:0;background : url(images/buttons/search.jpg);width:86px; height:26px;"  
				 <%}%>
				 />
                 <input type="button" name="resetQuickSearchButton" value="" onclick="javascript:resetSearch();"
                 <%if(isSAXAJVUser || isOTSUKAJVUser){%> disabled
                 style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;"  
                 <%} else{%>
                 style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;"  
                 <%}%>
                 />  
                </div>
               <!-- <div class="leftsearchbgpic" >
                  <div class="leftsearchtext" style="color:#4c7398;text-align:right;"></div>
                 </div>
                  <div style="clear:both;"></div>
                </div>-->
           	  <div id="mydiv" >
			  	<div class="expertsearchdiva">
	              <div class="leftsearchbgpic">
	                <div class="leftsearchtext"><%=DBUtil.getInstance().doctor%> Search Builder</div>
	              </div>
	              
	                <div class="firstname">
	                
	                <input type="radio" border="#c3c3c3" value="and"  name="selectText" checked>
	                <font size="2">Match all selected Attributes</font></input>
	      			 
	              
	                <input type="radio" border="#c3c3c3" value="or"  name="selectText" 
					<%if(isSAXAJVUser || isOTSUKAJVUser){%> disabled="disabled"<%}%>
					<%if(selectText!=null&&!selectText.equals("")&&selectText.equals("or")){%>checked<%}%>>
	                <font size="2" >Match any selected Attributes</font></input>
	              </div>
	           
	          <table id="mytable" border =0>
	          <tr>
	          <td>
	          <div class='leftsearchtext'>
	          <span class='leftsearchspanleft'>Attribute:</span>
	          <span class='leftsearchspanright' >
	          <%if(!(isSAXAJVUser || isOTSUKAJVUser)){%>
	          <a href='Javascript:deleteRow(1)' id='closeLink1' >X</a>
	          <%}%>
	          </span>
	          </div>
	          
	          </td>
	          </tr>
	            <tr>
	            <td> 
	             
	            <select id="attributeFilter1" name="attributeFilter1" readonly style="width:270px;" size="1"
				 onchange="checkAndPopulateLOV(1)"
             	 onkeypress="submitFormByEnterKey(searchExpertAttributes)"
				 <%if(isSAXAJVUser || isOTSUKAJVUser){%> disabled="disabled"<%}%>> 
	              <option id="-1" value="-1"  class="blueTextBox" selected="selected" >Please Select</option>
				<%if(searchableAttrs!=null&&searchableAttrs.length>0){
                       for(int i=0;i<searchableAttrs.length;i++){  
                      %><!-- We will store the LOV optionId in the id attribute if the selected attribute is LOV type-->
                       <option title="<%=searchableAttrs[i].getDescription()%>" class="blueTextBox" value="<%=searchableAttrs[i].getAttribute_id()%>" 
                        id = '<%=(searchableAttrs[i].getType() == 5 ? searchableAttrs[i].getOptionId() : 0)%>'
                       <%if(isSAXAJVUser&&searchableAttrs[i].getName().trim().equalsIgnoreCase("Saxa Collaboration Flag")){%>
					   selected 
					   <%}%>
					   <%if(isOTSUKAJVUser&&searchableAttrs[i].getName().trim().equalsIgnoreCase("Otsuka Collaboration Flag")){%>
					   selected 
					   <%}%>
                       <%if(searchParam1 != null && !"".equals(searchParam1[0]) && 
                       (!searchParam1[0].equalsIgnoreCase("contacts(Firstname)") && !searchParam1[0].equalsIgnoreCase("contacts(Lastname)") && !searchParam1[0].equalsIgnoreCase("org")) &&
                       Long.parseLong(searchParam1[0].trim()) == searchableAttrs[i].getAttribute_id()) { %> selected <% } %>
                       ><%=searchableAttrs[i].getDescription()%></option>  
		     	 <%}
                    }%>	
                   
                  <option value="org" class="blueTextBox"  <% if (searchParam1 != null && 
				  !"".equals(searchParam1[0]) && (searchParam1[0].equalsIgnoreCase("org"))){%> selected <%}%> >Org</option>    	  
				  <option value= "contacts(Firstname)" class="blueTextBox" <% if (searchParam1 != null && 
				  !"".equals(searchParam1[0]) && (searchParam1[0].equalsIgnoreCase("contacts(Firstname)"))){%> selected <%}%> >Contacts(Firstname)</option>
				  <option value="contacts(Lastname)" class="blueTextBox"  <% if (searchParam1 != null && 
                  !"".equals(searchParam1[0]) && (searchParam1[0].equalsIgnoreCase("contacts(Lastname)"))){%> selected <%}%> >Contacts(Lastname)</option>				             
	           </select>
	           </td>
	           </tr>
				<tr>
	          
	          <!--<td>
	          <div class="leftsearchtextb">&nbsp;</div>
	          </td>-->
	          <td>
	          <div class="leftsearchtext">Value:</div>
	          </td>
	          </tr>
	           <tr>
	           <td>
	           		<div id="attributeValueDiv1" style="display:block">
		                <input type="text" size = "40" border="#c3c3c3"  class="blueTextBox" id="searchAttributeText1" name="searchAttributeText1" <%if(searchParam1!=null&&!isSAXAJVUser &&!isOTSUKAJVUser){%>value=
						"<%=searchParam1[1] %>"<%}
					    else if(isSAXAJVUser || isOTSUKAJVUser){%> value="Yes" readonly<%}%>
					    onkeypress="submitFormByEnterKey(searchExpertAttributes)"/>
					</div>
					<div id="attributeLOVDiv1" style="display:none">
						<select id="attributeLOV1" name="attributeLOV1" style="width:270px;" class="blueTextBox" disabled
							    onchange="setSearchValue(1)"
		            		    onkeypress="submitFormByEnterKey(searchExpertAttributes)">
							<option id="-1" value="-1" selected>Please Select</option>
						</select>
					</div>
						<script type="text/javascript">
							if('<%=(isSAXAJVUser || isOTSUKAJVUser)%>' != 'true'){
								checkAndPopulateLOV(1);
							}
						</script>
	           </td>
	           </tr>
	           
	        <!-- --------------- -->
	           <tr>
	             <td>
	              <div class="leftsearchtext">  </div>
	            </td>
	            </tr>
	           <tr>
	             <td>
	              <div class='leftsearchtext'>
	          		<span class='leftsearchspanleft'>Attribute:</span>
	          		<span class='leftsearchspanright'><a href='Javascript:deleteRow(2)' id='closeLink2'>X</a></span>
	          	  </div>
	          
	            </td>
	            </tr>
	            <tr>
	              <td > 
		            <select id="attributeFilter2" name="attributeFilter2" readonly style="width:270px;" size="1" 
		            	onchange="checkAndPopulateLOV(2)"
		            	onkeypress="submitFormByEnterKey(searchExpertAttributes)"> 
		              <option value="-1" class="blueTextBox"  selected="selected">Please Select</option>
				      <%if(searchableAttrs!=null&&searchableAttrs.length>0){
	                       for(int i=0;i<searchableAttrs.length;i++){ 
	                  %> 
	 	                  <option  title="<%=searchableAttrs[i].getDescription()%>" class="blueTextBox" value="<%=searchableAttrs[i].getAttribute_id()%>" 
	                       id = '<%=(searchableAttrs[i].getType() == 5 ? searchableAttrs[i].getOptionId() : 0)%>'
	                       <%if(searchParam2 != null && !"".equals(searchParam2[0]) &&
	                       (!searchParam2[0].equalsIgnoreCase("contacts(Firstname)") && !searchParam2[0].equalsIgnoreCase("contacts(Lastname)") && !searchParam2[0].equalsIgnoreCase("org")) &&
	                       Long.parseLong(searchParam2[0].trim()) == searchableAttrs[i].getAttribute_id()) { %> selected <% } %>
	                       ><%=searchableAttrs[i].getDescription()%>
	                      </option>  		      
	                 <%}}%>		  
					  <option value="org" class="bluetextbox" <% if (searchParam2 != null && 
					  !"".equals(searchParam2[0]) && (searchParam2[0].equalsIgnoreCase("org"))){%> selected <%}%> >Org</option>   
					  <option value="contacts(Firstname)" class="blueTextBox"  <% if (searchParam2 != null && 
					  !"".equals(searchParam2[0]) && (searchParam2[0].equalsIgnoreCase("contacts(Firstname)"))){%> selected <%}%> >Contacts(Firstname)</option> 
					  <option value="contacts(Lastname)" class="blueTextBox"  <% if (searchParam2 != null && 
                      !"".equals(searchParam2[0]) && (searchParam2[0].equalsIgnoreCase("contacts(Lastname)"))){%> selected <%}%> >Contacts(Lastname)</option>
		           </select>
	             </td>
	             </tr>
	              <tr>
	         
	          <td>
	          <div class="leftsearchtext">Value:</div>
	          </td>
	         </tr>
	             <tr>
	             <td>
	             	<div id="attributeValueDiv2" style="display:block">
	                	<input type="text" size = "40" border="#c3c3c3"  class="blueTextBox" name="searchAttributeText2" <%if(searchParam2!=null){ %>value="<%=searchParam2[1] %>"<%}%> 
	                		   onkeypress="submitFormByEnterKey(searchExpertAttributes)"/>
	             	</div>
					<div id="attributeLOVDiv2" style="display:none">
						<select id="attributeLOV2" name="attributeLOV2" style="width:270px;" class="blueTextBox" disabled
							    onchange="setSearchValue(2)"
							    onkeypress="submitFormByEnterKey(searchExpertAttributes)">
							<option id="-1" value="-1" selected>Please Select</option>
						</select>
					</div>
					<script type="text/javascript">
						checkAndPopulateLOV(2);
					</script>            	
	             </td>
	           </tr>
	           </table> 
	           
	           
	           </div>
	               
               
               <%if(searchParams!=null&&searchParams.size()>0)
               {   
                 for(int i=0;i<searchParams.size();i++)
                 {
                   String[] searchParamsArry = (String[])searchParams.get(i);   
 				%>
                   <script type="text/javascript">
                   var selectValue ="<%= searchParamsArry[0]%>";
                   var textValue = "<%=searchParamsArry[1]%>";
                   addrowNew(selectValue,textValue)
                   </script>
                     
              <%}
                 } %>
                 
	           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	            <a href="Javascript:addrowNew(null,null)"  align="right" ><font size="2" color="4C7398"> add..</font></a>
	           
			  <div class="searchButton" align="left">
	                <input type="button" name="Search2" value="" style="border:0;background : url(images/search.jpg);width:86px; height:26px;"  onclick="javascript:searchExpertAttributes();"/>
	                <input type="button" name="resetSearchBuilderButton" value="" onclick="javascript:resetSearch();" style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;"/>
	          </div>
	       </div>
	           
	           
	         
	          <div class="paddingdiv" style="padding: 2px"></div>
	            <div class="colContent" style="height:1em;"></div>
	            <div class="leftsearchbgpic" >
	             <div class="leftsearchtext" style="color:#4c7398;text-align:right;"></div>
	            </div>
	             <div style="clear:both;"></div>
	          </div>
	           
	           
	           
	           
	           
	           
	          <!-- This is to be displayed-->
	          

          
          </td>
		  
		  
		  
		  
		  
		  
		  
		  
		  <td>
            <div id="split"
              dojoType="dijit.layout.SplitContainer"
              orientation="horizontal"
              sizerWidth="7"
              activeSizing="true"
              persist="false"
              class="openq"
              style="height: 100%;">
                <% if(expertCheckBox!=null || default_load!=null) { %>
                  <div id="expertPane" dojoType="dijit.layout.ContentPane" href="expert.jsp" refreshOnShow="true" onDownloadStart="getLoadingMsg" ></div>
                  
                <% } %>
                <% if(orgCheckBox!=null) { %>
                  <div id="orgPane" dojoType="dijit.layout.ContentPane" href="org.jsp" refreshOnShow="true" onDownloadStart="getLoadingMsg"></div>
                <% } %>
                <% if(trialCheckBox!=null) { %>
                  <div id="trialPane" dojoType="dijit.layout.ContentPane" href="trial.jsp" refreshOnShow="true" onDownloadStart="getLoadingMsg"></div>
                <% } %>
            </div>
          </td>
		
        </tr>

      </table>
    </form>
    <%if(!fromEventFlag.equalsIgnoreCase("true")){ %>
    <div class="footer">
      <div class="copyrighttext">Copyright @ 2007 OpenQ. All Rights Reserved.  |  Contact Us  |   www.openq.com</div>
    </div>
    <%} %>
  </body>
</html>


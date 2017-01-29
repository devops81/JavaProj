/* Common DHTML JavaScript Library
** Authors: Ben Shoemate and Cody Burleson
** Version 2.2
** Last Modified: April 26, 2003
**
** Please only remove comments from production version; save a copy with comments.
*/
function redirect(URLStr) { location = URLStr; }
function setClass(elm,clss) {
	// IE 5+ and NS 6...
	if (document.getElementById) {
		// You can either call the function with setClass(this,'ruleName') or setClass('elementID','rulName').
		// Test whether it's an object (else it must be a string) to handle both types of calls
		if(typeof elm=='object') {
			// test whether the element actually exists, if it does not exist, exit gracefully
			// rather than throwing a js error
			if(document.getElementById(elm)) { // attempt only if element exists
				elm.className = clss;
			}
		} else {
			if(document.getElementById(elm)) { // attempt only if element exists
				document.getElementById(elm).className = clss;
			}
		}
	// IE 4...
	} else if (document.all) {
		document.all[elm].className = clss;
	}
}

function toggleVisibility(elm) {
		// IE 5+ and NS 6...
	if (document.getElementById) {
		// You can either call the function with toggleVisibility(this) or toggleVisibility('elementID').
		// Test whether it's an object (else it must be a string) to handle both types of calls
		if(typeof elm=='object') {
		
			if(elm.style.display != "none") {
				elm.style.display = "none";
			} else {
				elm.style.display = ""; 
			}
			
		} else {
			if(document.getElementById(elm).style.display != "none") {
				document.getElementById(elm).style.display = "none";
			} else {
				document.getElementById(elm).style.display = "block"; 
			}
		}
	
	// IE 4...

	} else if (document.all) {
		if(document.all[elm].style.display != "none") {
			document.all[elm].style.display = "none";
		} else {
			document.all[elm].style.display = "block";
		}
	}

}

function swapImage (img, imageSource) {
	// IE 5+ and NS 6...
	if (document.getElementById) {
		// You can either call the function with setClass(this,'ruleName') or setClass('elementID','rulName').
		// Test whether it's an object (else it must be a string) to handle both types of calls
		if(typeof img=='object') {
			img.src = imageSource;
		} else {
			document.getElementById(img).src = imageSource;
		}
	// IE 4...
	} else if (document.all) {
		document.all[img].src = imageSource;
	}
}

function changecss(myclass,element,value) {
	var CSSRules
	if (document.all) {
		CSSRules = 'rules'
	}
	else if (document.getElementById) {
		CSSRules = 'cssRules'
	}
	for (var i = 0; i < document.styleSheets[0][CSSRules].length; i++) {
		if (document.styleSheets[0][CSSRules][i].selectorText == myclass) {
			document.styleSheets[0][CSSRules][i].style[element] = value
		}
	}
}
// this function is needed to work around 
  // a bug in IE related to element attributes
  function hasClass(obj) {
     var result = false;
     if (obj.getAttributeNode("class") != null) {
         result = obj.getAttributeNode("class").value;
     }
     return result;
  }   

 function stripe(id) {

    // the flag we'll use to keep track of 
    // whether the current row is odd or even
    var even = false;
  
    // if arguments are provided to specify the colours
    // of the even & odd rows, then use the them;
    // otherwise use the following defaults:
    var evenColor = arguments[1] ? arguments[1] : "#FFFFFF";
    var oddColor = arguments[2] ? arguments[2] : "#ebebeb";
  
    // obtain a reference to the desired table
    // if no such table exists, abort
    var table = document.getElementById(id);
    if (! table) { return; }
    
    // by definition, tables can have more than one tbody
    // element, so we'll have to get the list of child
    // &lt;tbody&gt;s 
    var tbodies = table.getElementsByTagName("tbody");

    // and iterate through them...
    for (var h = 0; h < tbodies.length; h++) {
    
     // find all the &lt;tr&gt; elements... 
      var trs = tbodies[h].getElementsByTagName("tr");
      
      // ... and iterate through them
      for (var i = 0; i < trs.length; i++) {

        // avoid rows that have a class attribute
        // or backgroundColor style
        if (! hasClass(trs[i]) &&
            ! trs[i].style.backgroundColor) {
 		  
          // get all the cells in this row...
          var tds = trs[i].getElementsByTagName("td");
        
          // and iterate through them...
          for (var j = 0; j < tds.length; j++) {
        
            var mytd = tds[j];

            // avoid cells that have a class attribute
            // or backgroundColor style
            if (! hasClass(mytd) &&
                ! mytd.style.backgroundColor) {
        
              mytd.style.backgroundColor =
                even ? evenColor : oddColor;
            
            }
          }
        }
        // flip from odd to even, or vice-versa
        even =  ! even;
      }
    }
  }
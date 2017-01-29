dojo.require("dojo.fx");

function toggleSection(sectionId){
  if(isSectionOpen(sectionId)){
    this.closeSection(sectionId);
  } else {
    this.openSection(sectionId);
  }
}

function isSectionOpen(sectionId){
  var content = dojo.byId(sectionId + "Content");
  return !(dojo.style(content,"display") == "none");
}

function openSection(sectionId){
  var image = dojo.byId(sectionId + "Img");
  var content = dojo.byId(sectionId + "Content");
  if(content != undefined){
	  if(typeof(image) != "undefined" && 
	    image != null) {
	      image.src="images/buttons/minus.gif";
	  }
	  dojo.fx.wipeIn({
	    node: content,
	    duration: 1
	  }).play();
  }
}

function closeSection(sectionId){
  var image = dojo.byId(sectionId + "Img");
  var content = dojo.byId(sectionId + "Content");
  if(typeof(image) != "undefined" && 
    image != null) {
      image.src="images/buttons/plus.gif";
  }
  dojo.fx.wipeOut({
    node: content,
    duration: 1
  }).play();
}
 
function closeAllSections(sectionClass){
  dojo.query("."+sectionClass).forEach(
    function (contentDiv){
      var sectionId = contentDiv.id.replace("Content","");
      closeSection(sectionId);
    }
  );    
}
  
function openAllSections(sectionClass){
  dojo.query("."+sectionClass).forEach(
    function (contentDiv){
      var sectionId = contentDiv.id.replace("Content","");
      openSection(sectionId);
    }
  );    
}

function toggleAllSections(sectionClass){
  dojo.query("."+sectionClass).forEach(
    function (contentDiv){
      var sectionId = contentDiv.id.replace("Content","");
      toggleSection(sectionId);
    }
  );    
}
function showHiddenSection(sectionId){
	var section = document.getElementById(sectionId + "Content");
	if(section != null && section != undefined){
		section.style.display = "block";
		var subSectionId = sectionId.substring(0, sectionId.indexOf("Section"));
		openSection(subSectionId);
	}
}
function hideOpenSection(sectionId){
	var section = document.getElementById(sectionId + "Content");
	if(section != null && section != undefined){
		section.style.display = "none";
	}
}
function isSectionVisible(sectionId){
	var section = document.getElementById(sectionId + "Content");
	if(section != null && section != undefined && section.style.display == "block")
		return true;
}
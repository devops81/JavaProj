function getInternetExplorerVersion()
// Returns the version of Internet Explorer or a -1
// (indicating the use of another browser).
{
  var rv = -1; // Return value assumes failure.
  if (navigator.appName == 'Microsoft Internet Explorer')
  {
    var ua = navigator.userAgent;
    var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
    if (re.exec(ua) != null)
      rv = parseFloat( RegExp.$1 );
  }
  return rv;
}

function checkVersion()
{
  var msg = "Oops! Your browser is not supported. Please use Internet Explorer 6.0 for best results.";
  var ver = getInternetExplorerVersion();

  if ( ver > -1 )
  {
    if ( ver == 6.0 ) 
      msg = "";
    else
      msg = "Oops! You are using Internet Explorer " + ver + ", which has not been certified for optimal user experience on OpenQ Medical Relationship System. Please use IE 6.0 for best results.";
  }
  if (msg != "")
  {
	  alert( msg );
  }
}

function detectBrowser()
{
	var browser=navigator.appName;
	if (!(browser=="Microsoft Internet Explorer" && getInternetExplorerVersion() >= 6.0))
	{
		alert("Oops! You are using a variant of " + browser +" browser, which has not been certified for optimal user experience on OpenQ Medical Relationship System. If you would like this browser to be supported, please contact: otaviof@openq.com");
	}
}
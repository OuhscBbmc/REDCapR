<?php

/** 
* PLUGIN NAME: Insert Unit Test Cleanup 
* DESCRIPTION: delete redcap record inserted by a REDCapR unit test 
* VERSION: 1.0 
* AUTHOR: Will Beasley, OUHSC, BBMC 
*/ 

// Prevent caching; this code is copied from /redcap/api/index.php 
header("Expires: 0"); 
header("cache-control: no-store, no-cache, must-revalidate"); 
header("Pragma: no-cache"); 

// Disable REDCap's authentication 
define("NOAUTH", true); 

// Call the REDCap Connect file in the main "redcap" directory 
require_once "../../redcap_connect.php"; 

// OPTIONAL: Your custom PHP code goes here. You may use any constants/variables listed in redcap_info(). 

// OPTIONAL: Display the header 
$HtmlPage = new HtmlPage(); 
$HtmlPage->PrintHeaderExt(); 

// Your HTML page content goes here 
?> 

<h3 style="color:#800000;"> 
       DELETE Records from multiple-arm for deleting REDCapR Test Project 
</h3> 
<p> 
       This is an example plugin page that has REDCap's <b>authentication disabled</b>. 
       So no one will be forced to login to this page because it is fully public and available to the web (supposing this 
       web server isn't locked down behind a firewall). 
</p> 
<?php 

// Change '-666' to the project you want to wipe out.
db_query("DELETE FROM redcapv3.redcap_data WHERE project_id=-666;"); 
 
// OPTIONAL: Display the footer 
$HtmlPage->PrintFooterExt(); 
?>

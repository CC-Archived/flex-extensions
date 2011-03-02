package com.codecatalyst.util
{
	import mx.utils.StringUtil;
		
	/**
	 * This class trys to set parameters on an object where child/attributes of an xml document match
	 */
	public final class XMLUtil
	{	
		/**
		 * Initialize an object from xml properties
		 */
        public static function initFromXML( target:Object, src:XML = null ):Object 
        {    
        	// Try the child nodes
			toProperties(src.children(), target);
			
            // Try the attributes
			toProperties(src.attributes(), target);
			
            return target;
        }
        
        /**
        * Attempt to set properties on the target based on the xmllist passes in
        */
        public static function toProperties(nodes:XMLList, target:Object=null, create:Boolean = true):Object {
			target ||= new Object;
			
			if (nodes != null) {
	        	for each ( var node:XML in nodes ) { 
					if (node.hasSimpleContent()) {
		            	var key:String = String( node.name() );
		            	var value:String = String( node.valueOf() );
		            	
		            	if (create || target.hasOwnProperty( key ))  {
		            		target[ key ] = !isBoolean(value) ? value : (isTrue(value) ? true : false);  
		             	}
					}
	            }
			}
			
			return target;
        }
	        
		   static public function getAttribute(src:XML,searchKey:String,defaultVal:String="", caseSensitive:Boolean = true, scanContent:Boolean=false):String {
		   	 var results : String = defaultVal;
		   	 
		   	 if (src != null) {
					  var attributes : XMLList = src.attributes();
					  for each (var attribute:XML in attributes) {
					  	var name  : String = String(attribute.name());
					  	var value : String = StringUtil.trim(String(src.attribute(name)[0]));
					  	
					  	if (caseSensitive != true) {
					  		name      = name.toLowerCase();
					  		searchKey = searchKey.toLowerCase();
					  	}
					  	
					  	if (name == searchKey) {
					  		
							results = value; 		
					  		break;
							
					  	} else if (scanContent == true) {
							var contents : XMLList = src.child(searchKey);
							var content  : XML     = (contents.length() > 0) ? contents[0] as XML : null;
							
							if (content && content.hasSimpleContent()) {
								var body : XMLList= content.text(); 
								results = (body && body.length()>0) ? String(body[0]) : ""
								break;
							}
						} 
					  }
		   	 }
				  
				  return results;
		   }
		  
		   static public function isAttributeTrue(src:XML,searchKey:String,defaultVal:Boolean=false):Boolean {
		   	  return isTrue( getAttribute(src,searchKey,defaultVal ? "true" : "false") );
				}
				
		   	 static public function isBoolean(value:String):Boolean {
				 var results : Boolean = false;
				 
				 if (value && value!="") {
					 // e.g. src === "true" or "yes" or "TruE"
					 var pattern : RegExp = /^(true|yes|false|no)$/i;
					 var matches : Array  = value.match(pattern);
					 
					 results = (matches && matches.length);
				 }
				 
				 return results;				
			 }
			 
			 static public function isTrue(value:String):Boolean {
			 	 var results : Boolean = false;
			 	 
			 	  if (value && value!="") {
						// e.g. src === "true" or "1" or "yes" or "TruE"
						var pattern : RegExp = /(true|1|yes|selected)/i;
						var matches : Array  = value.match(pattern);
						
						results = (matches && matches.length);
			 	  }
					
					return results;				
			 }
        
	}
}
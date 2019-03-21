plugin.loadLang();

plugin.loadMainCSS();

plugin.checkQuota = function()
{
	jQuery.ajax(
	{
		type: "GET",
		timeout: theWebUI.settings["webui.reqtimeout"],
	        async : true,
	        cache: false,
		url : "plugins/quotaspace/action.php?cmd=stop",
		dataType : "json"
	});
}

plugin.warnUser = function()
{
	if(!theWebUI.quotaAlreadyWarn)
	{
		if(!theWebUI.settings["webui.show_dets"])
		{
			$("#tdetails").show();
     			theWebUI.settings["webui.show_dets"] = true;
      			theWebUI.resize();
      			theWebUI.save();
      		}
		logHTML(theUILang.quotaWarn,'quoteErr');
		theWebUI.quotaAlreadyWarn = true;
		plugin.checkQuota();
	}
}

plugin.setValue = function( full, free )
{
       	if(free<=0)
       	{
       		free = 0;
		plugin.warnUser();
	}
	else
	{
		if(theWebUI.quotaAlreadyWarn)
			plugin.checkQuota();
		theWebUI.quotaAlreadyWarn = false;
	}
        var percent = iv(full ? (full-free)/full*100 : 0);
       	if(percent>100)
        	percent = 100;
	$("#qmeter-disk-value").width( percent+"%" ).css( { "background-color": (new RGBackground()).setGradient(this.prgStartColor,this.prgEndColor,percent).getColor(),
		visibility: !percent ? "hidden" : "visible" } );
	$("#qmeter-disk-text").text(percent+'%');
	$("#qmeter-disk-td").attr("title", theConverter.bytes(free)+"/"+theConverter.bytes(full));
}

plugin.onLangLoaded = function()
{
	this.prgStartColor = new RGBackground("#99D699");
	this.prgEndColor = new RGBackground("#E69999");

	plugin.addPaneToStatusbar( "qmeter-disk-td", $("<div>").attr("id","qmeter-disk-holder").
		append( $("<span></span>").attr("id","qmeter-disk-text").css({overflow: "visible"}) ).
		append( $("<div>").attr("id","qmeter-disk-value").css({ visibility: "hidden", float: "left" }).width(0).html("&nbsp;") ).get(0) );

	plugin.check = function()
	{
	        if(plugin.enabled)
	        {
			var AjaxReq = jQuery.ajax(
			{
				type: "GET",
				timeout: theWebUI.settings["webui.reqtimeout"],
			        async : true,
				url : "plugins/quotaspace/action.php",
				dataType : "json",
				cache: false,
				success : function(data)
				{
					plugin.setValue( data.total, data.free );
				}
			});
		}
	};
	plugin.check();
	plugin.reqId = theRequestManager.addRequest( "ttl", null, plugin.check );
	this.markLoaded();
};

plugin.onRemove = function()
{
	plugin.removePaneFromStatusbar( "qmeter-disk-td" );
	theRequestManager.removeRequest( "ttl", plugin.reqId );
}

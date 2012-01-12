$("#resource_<%=@resource.id%>").html("<%=escape_javascript(render(:partial => "resources/resource", :locals => { :resource => @resource })) %>")


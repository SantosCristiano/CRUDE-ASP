<%@ LANGUAGE="VBSCRIPT" CODEPAGE="1255" %>
<!--#include file="dist/asp/inc_config.asp" -->
<%' use this meta tag instead of adovbs.inc%>
<!--METADATA TYPE="typelib" uuid="00000205-0000-0010-8000-00AA006D2EA4" -->
<%
Response.CodePage = 1255
Session.CodePage = 1255

' Local Constants
'=======================
Const constPageScriptName = "admin_dataviewfields.asp"
Dim constPageTitle
constPageTitle = "Manage Data View Fields"

' Init Variables
'=======================
Dim strSQL, rsItems, nItemID, strMode, nCount, nIndex

' Open DB Connection
'=======================
adoConn.Open
%><!--#include file="dist/asp/inc_crudeconstants.asp" --><%
Dim strFieldLabel, strFieldSource, strDataViewTitle, nViewID, strDefaultValue, strUriPath, strLinkedTable, strLinkedTableGroupField
Dim strLinkedTableTitleField, strLinkedTableAddition, strLinkedTableValueField, nFlags
    
strMode = Request("mode")
nItemID = Request("ItemID")
IF NOT IsNumeric(nItemID) THEN nItem = ""
nViewID = Request("ViewID")
IF NOT IsNumeric(nViewID) THEN nItem = ""

    
IF nViewID <> "" AND IsNumeric(nViewID) THEN
	strSQL = "SELECT Title FROM portal.DataView WHERE ViewID = " & nViewID
	rsItems.Open strSQL, adoConn
	IF NOT rsItems.EOF THEN
		strDataViewTitle = rsItems("Title")
	Else
		nViewID = ""
	END IF
	rsItems.Close
END IF

IF nViewID = "" OR NOT IsNumeric(nViewID) THEN Response.Redirect("admin_dataviews.asp?MSG=notfound")
constPageTitle = constPageTitle & " for " & strDataViewTitle
strFieldLabel = Request("FieldLabel")
strFieldSource = Request("FieldSource")
strDefaultValue = Request("DefaultValue")
strUriPath = Request("UriPath")
strLinkedTable = Request("LinkedTable")
strLinkedTableGroupField = Request("LinkedTableGroupField")
strLinkedTableTitleField = Request("LinkedTableTitleField")
strLinkedTableValueField = Request("LinkedTableValueField")
strLinkedTableAddition = Request("LinkedTableAddition")
nFlags = 0

For nIndex = 1 TO Request.Form("FieldFlags").Count
    nFlags= nFlags + CInt(Request.Form("FieldFlags")(nIndex))
Next

IF Request.Form("FieldLabel") <> "" THEN
	
	IF strMode = "add" THEN
		strSQL = "INSERT INTO portal.DataViewField(ViewID, [FieldLabel], [FieldSource], [DefaultValue], [UriPath], [LinkedTable], [LinkedTableGroupField], LinkedTableTitleField, [LinkedTableValueField], [LinkedTableAddition], [Flags]) VALUES(" & _
				  CStr(CInt(nViewID)) & _
				 ",'" & Replace(strFieldLabel,"'","''") & "'" & _
				 ",'" & Replace(strFieldSource,"'","''") & "'" & _
				 ",'" & Replace(strDefaultValue,"'","''") & "'" & _
				 ",'" & Replace(strUriPath, "'", "''") & "'" & _
				 ",'" & Replace(strLinkedTable, "'", "''") & "'" & _
				 ",'" & Replace(strLinkedTableGroupField, "'", "''") & "'" & _
				 ",'" & Replace(strLinkedTableTitleField,"'","''") & "'" & _
				 ",'" & Replace(strLinkedTableValueField,"'","''") & "'" & _
				 ",'" & Replace(strLinkedTableAddition,"'","''") & "'" & _
				 "," & CStr(CInt(nFlags)) & _
                 ");"
	ELSEIF strMode ="edit" AND nItemID <> "" THEN
		strSQL = "UPDATE portal.DataViewField SET " & _
				 "FieldLabel = '" & Replace(strFieldLabel,"'","''") & "'" & _
				 ", FieldSource = '" & Replace(strFieldSource,"'","''") & "'" & _
				 ", DefaultValue = '" & Replace(strDefaultValue,"'","''") & "'" & _
                 ", UriPath = '" & Replace(strUriPath, "'", "''") & "'" & _
                 ", LinkedTable = '" & Replace(strLinkedTable, "'", "''") & "'" & _
                 ", LinkedTableGroupField = '" & Replace(strLinkedTableGroupField, "'", "''") & "'" & _
				 ", LinkedTableTitleField = '" & Replace(strLinkedTableTitleField,"'","''") & "'" & _
				 ", LinkedTableValueField = '" & Replace(strLinkedTableValueField,"'","''") & "'" & _
				 ", LinkedTableAddition = '" & Replace(strLinkedTableAddition,"'","''") & "'" & _
				 ", Flags = " & CStr(CInt(nFlags)) & _
	 			 " WHERE FieldID = " & nItemID
	ELSE
		strSQL = ""
	END IF

	IF strSQL <> "" THEN
		adoConn.Execute strSQL
	END IF
	
	Response.Redirect(constPageScriptName & "?ViewID=" & nViewID & "&MSG=" & strMode)

ELSEIF strMode = "delete" AND nItemID <> "" THEN
		
	adoConn.Open
	adoConn.Execute "DELETE FROM portal.DataViewField WHERE FieldID = " & nItemID
	adoConn.Close
	
	Response.Redirect(constPageScriptName & "?ViewID=" & nViewID & "&MSG=delete")
END IF
%>
<!DOCTYPE html>
<html>
<head>
  <title><%= constPortalTitle %></title>
<!--#include file="dist/asp/inc_meta.asp" -->
</head>
<body class="hold-transition skin-blue sidebar-mini fixed">
<div class="wrapper">
<!--#include file="dist/asp/inc_header.asp" -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <%= constPageTitle %>
      </h1>

      <ol class="breadcrumb">
        <li><a href="default.asp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="admin_dataviewfields.asp?mode=edit&ItemID=<%= nViewID %>"> <%= strDataViewTitle %></a></li>
        <li class="active"><%= constPageTitle %></li>
      </ol>

    </section>

    <!-- Main content -->
    <section class="content container-fluid">

    <% SELECT CASE Request("MSG")
        CASE "edit" %>
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-check"></i> Success!</h4>
                Item has been successfully updated.
              </div>
       <% CASE "add" %>
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-check"></i> Success!</h4>
                Item has been successfully added.
              </div>
       <% CASE "delete" %>
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-check"></i> Success!</h4>
                Item has been successfully deleted.
              </div>
    <% END SELECT %>
<div class="row">
    <div class="col col-sm-12">
        <a class="btn btn-primary" role="button" href="admin_dataviews.asp?mode=edit&ItemID=<%= nViewID %>"><i class="fa fa-arrow-left"></i> Back to Data View</a>
        &nbsp;
        <a class="btn btn-primary" role="button" href="<%= constPageScriptName %>?mode=add&ViewID=<%= nViewID %>"><i class="fa fa-plus-square"></i> Add</a>
    </div>
</div>

<div class="row">
<%
SET rsItems = Server.CreateObject("ADODB.Recordset")

IF (strMode = "edit" AND nItemID <> "") OR strMode = "add" Then

IF strMode = "edit" AND nItemID <> "" Then
	strSQL = "SELECT * FROM portal.DataViewField WHERE FieldID = " & nItemID
	rsItems.Open strSQL, adoConn
	IF NOT rsItems.EOF THEN
		strFieldLabel = rsItems("FieldLabel")
		strFieldSource = rsItems("FieldSource")
		strDefaultValue = rsItems("DefaultValue")
		nFlags = rsItems("FieldFlags")
        strLinkedTable = rsItems("LinkedTable")
        strLinkedTableGroupField = rsItems("LinkedTableGroupField")
		strLinkedTableTitleField = rsItems("LinkedTableTitleField")
		strLinkedTableValueField = rsItems("LinkedTableValueField")
		strLinkedTableAddition = rsItems("LinkedTableAddition")
        strUriPath = rsItems("UriPath")
	END IF
	rsItems.Close
ELSE
	nFlags = 1
	strMode = "add"
END IF
%>

<!-- Update/Insert Form -->
<div class="col-md-6">
<div class="panel panel-primary">
<div class="box-header with-border">
    <h3 class="box-title">
        <% IF strMode = "edit" AND nItemID <> "" THEN Response.Write "Edit" ELSE Response.Write "Add" %> Data View Field

    </h3>
</div>
<form class="form-horizontal" action="<%= constPageScriptName %>" method="post">
    <div class="panel-body">
    <div class="form-group">
        <label for="inputFieldLabel" class="col-sm-2 control-label">Field Label</label>

        <div class="col-sm-10">
        <input type="text" class="form-control" id="inputFieldLabel" placeholder="FieldLabel" name="FieldLabel" value="<%= strFieldLabel %>" required="required">
        </div>
    </div>
    <div class="form-group">
        <label for="inputFieldSource" class="col-sm-2 control-label">Field Source</label>

        <div class="col-sm-10">
        <input type="text" class="form-control" id="inputFieldSource" placeholder="Field Source Column" name="FieldSource" value="<%= strFieldSource %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputDefaultValue" class="col-sm-2 control-label">Default Value</label>

        <div class="col-sm-10">
        <input type="text" class="form-control" id="inputDefaultValue" placeholder="Default Value" name="DefaultValue" value="<%= strDefaultValue %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputLinkedTable" class="col-sm-3 control-label">Linked Table</label>

        <div class="col-sm-9">
        <input type="text" class="form-control" id="inputLinkedTable" placeholder="Linked Table Name" name="LinkedTable" value="<%= strLinkedTable %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputLinkedTableGroupField" class="col-sm-3 control-label">Linked Table Group Field</label>

        <div class="col-sm-9">
        <input type="text" class="form-control" id="inputLinkedTableGroupField" placeholder="Linked Table Group Field Column" name="LinkedTableGroupField" value="<%= strLinkedTableGroupField %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputLinkedTableTitleField" class="col-sm-3 control-label">Linked Table Title Field</label>

        <div class="col-sm-9">
        <input type="text" class="form-control" id="inputLinkedTableTitleField" placeholder="Linked Table Title Field Column" name="LinkedTableTitleField" value="<%= strLinkedTableTitleField %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputLinkedTableValueField" class="col-sm-3 control-label">Linked Table Value Field</label>

        <div class="col-sm-9">
        <input type="text" class="form-control" id="inputLinkedTableValueField" placeholder="Linked Table Value Column" name="LinkedTableValueField" value="<%= strLinkedTableValueField %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputLinkedTableAddition" class="col-sm-3 control-label">Linked Table Addition</label>

        <div class="col-sm-9">
        <textarea class="form-control" id="inputLinkedTableAddition" name="LinkedTableAddition" placeholder="Linked Table Addition"><%= strLinkedTableAddition %></textarea>
        </div>
    </div>
    <div class="form-group">
        <label for="inputUriPath" class="col-sm-3 control-label">Link URI</label>

        <div class="col-sm-9">
        <input type="text" class="form-control" id="inputUriPath" placeholder="Link URI Path" name="UriPath" value="<%= strUriPath %>">
        </div>
    </div>
    <div class="form-group">
        <label for="inputFlags" class="col-sm-3 control-label">Properties</label>
        
        <div class="col-sm-9">
        <% FOR nIndex = 0 TO UBound(arrDataViewFlags, 2) %>
        <div class="checkbox">
            <label>
            <input type="checkbox" name="FieldFlags" value="<%= arrDataViewFlags(dvfValue, nIndex) %>" <% IF (arrDataViewFlags(dvfValue, nIndex) AND nFlags) > 0 THEN Response.Write "checked" %> /> <%= arrDataViewFlags(dvfLabel, nIndex) %>
            </label>
        </div>
        <% NEXT %>
        </div>
    </div>
    </div>
    <!-- /.panel-body -->
    <div class="panel-footer">
    <input type="hidden" name="ItemID" value="<%= nItemID %>" />
    <input type="hidden" name="ViewID" value="<%= nViewID %>" />
    <input type="hidden" name="mode" value="<%= strMode %>" />

    <a class="btn btn-default" role="button" href="<%= constPageScriptName %>?ViewID=<%= nViewID %>">Cancel</a>

    <button type="submit" class="btn btn-success pull-right">Submit</button>
    </div>
    <!-- /.panel-footer -->
</form>
</div>
</div>
<!-- /.update-insert-form -->
<% END IF %>
</div>
        <!-- Items List -->
        
<table class="table table-hover">
<tr>
    <th>ID</th>
    <th>Title</th>
    <th>Properties</th>
    <th>Actions</th>
</tr>
<%
Set rsItems = Server.CreateObject("ADODB.Recordset")
strSQL = "SELECT * FROM portal.DataViewField WHERE ViewID = " & nViewID & " ORDER BY FieldOrder ASC"
rsItems.Open strSQL, adoConn

WHILE NOT rsItems.EOF

%><tr>
    <td><%= rsItems("FieldID") %></td>
    <td><%= rsItems("FieldLabel") %></td>
    <td>
        <% FOR nIndex = 1 TO UBound(arrDataViewFlags, 2)
            IF (rsItems("FieldFlags") AND arrDataViewFieldFlags(dvffValue, nIndex)) THEN %>
        <b title="<%= arrDataViewFieldFlags(dvffLabel, nIndex) %>"><i class="<%= arrDataViewFieldFlags(dvffGlyph, nIndex) %>"></i></b>
        &nbsp;
        <% END IF
            NEXT %>
    </td>
    <td>
        <a title="Edit" class="btn btn-primary" href="<%= constPageScriptName %>?mode=edit&ViewID=<%= nViewID %>ItemID=<%= rsItems("FieldID") %>"><i class="fa fa-edit"></i> Edit</a>
        &nbsp;
        <a title="Delete" class="btn btn-primary" href="<%= constPageScriptName %>?mode=delete&ViewID=<%= nViewID %>&ItemID=<%= rsItems("FieldID") %>"><i class="fa fa-trash-o"></i> Delete</a>
    </td>
  </tr>
    <% 
    rsItems.MoveNext
WEND %>
</table>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

<!--#include file="dist/asp/inc_footer.asp" -->
</div>
<!-- ./wrapper -->

<!-- REQUIRED JS SCRIPTS -->
<!--#include file="dist/asp/inc_footer_jscripts.asp" -->

<!-- AdminLTE App -->
<script src="dist/js/adminlte.min.js"></script>

<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
</body>
</html>
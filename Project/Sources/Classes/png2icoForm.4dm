Class extends _Form

property targetFolder : 4D:C1709.Folder

Class constructor
	
	Super:C1705()
	
	This:C1470.targetFolder:=Folder:C1567(fk desktop folder:K87:19)
	
	$window:=Open form window:C675("png2ico")
	DIALOG:C40("png2ico"; This:C1470; *)
	
Function onLoad()
	
	Form:C1466.png2ico:=cs:C1710.png2ico.new(cs:C1710._png2icoUI_Controller)
	Form:C1466.iconutil:=cs:C1710.iconutil.new(cs:C1710._iconutilUI_Controller)
	
	Form:C1466.toggleButtons()
	
Function onUnload()
	
	Form:C1466.png2ico.terminate()
	Form:C1466.iconutil.terminate()
	
Function convert($src : Object)
	
	OBJECT SET ENABLED:C1123(*; "Convert"; False:C215)
	
	$PROJECT:=File:C1566(Structure file:C489; fk platform path:K87:2).name
	
	$src:=Form:C1466.source
	$dst:=Folder:C1567(fk desktop folder:K87:19)
	
	Form:C1466.iconutil.convert({src: $src; dst: $dst})
	Form:C1466.png2ico.convert({src: $src; dst: $dst})
	
	return Form:C1466
	
Function toggleButtons()
	
	Case of 
		: (OB Instance of:C1731(Form:C1466.source; 4D:C1709.Folder)) && (Form:C1466.source.exists)
			
			OBJECT SET ENABLED:C1123(*; "Convert"; True:C214)
			
		Else 
			
			OBJECT SET ENABLED:C1123(*; "Convert"; False:C215)
			
	End case 
	
	return Form:C1466
	
Function onSourceDragOver()
	
	$path:=Get file from pasteboard:C976(1)
	
	If ($path#"") && (Test path name:C476($path)=Is a folder:K24:2)
		$0:=0
	Else 
		$0:=-1
	End if 
	
Function onSourceDrop()
	
	$path:=Get file from pasteboard:C976(1)
	
	var $class : 4D:C1709.Class
	
	Case of 
		: (Test path name:C476($path)=Is a folder:K24:2)
			$class:=4D:C1709.Folder
	End case 
	
	If ($class#Null:C1517)
		
		Form:C1466.source:=$class.new($path; fk platform path:K87:2)
		
		If (Is macOS:C1572)
			Form:C1466.sourceIcon:=Form:C1466.source.getIcon()
		Else 
			$icon:=Form:C1466.source.getIcon(256)
			Form:C1466.sourceIcon:=$icon
		End if 
		
	End if 
	
	return Form:C1466
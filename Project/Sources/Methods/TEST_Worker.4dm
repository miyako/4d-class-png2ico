//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	$PROJECT:=File:C1566(Structure file:C489; fk platform path:K87:2).name
	
	$src:=Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.folder("Samples/windows")
	$dst:=Folder:C1567(fk desktop folder:K87:19).file($PROJECT+".ico")
	
	$png2ico:=cs:C1710.png2ico.new(cs:C1710._png2ico_Controller)
	
	$png2ico.convert({src: $src; dst: $dst})
	
End if 
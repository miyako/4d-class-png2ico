Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("go-png2ico"; $controller)
	
Function onResponse($files : Collection; $parameters : Collection)
	
	var $srcFolder; $dstFolder : 4D:C1709.Folder
	
	$srcFolder:=$parameters.at(0)
	$dstFolder:=$parameters.at(1)
	
	$dstFolder.create()
	
	$srcFolder.copyTo($dstFolder; fk overwrite:K87:5)
	
	var $src; $dst : 4D:C1709.File
	
	var $arch : Text
	$arch:=$parameters.at(2)
	
	$options:=[]
	
	$srcPath:=Split string:C1554($srcFolder.parent.path; "/"; sk ignore empty strings:K86:1)
	
	For each ($src; $files)
		
		$pathComponents:=Split string:C1554($src.path; "/"; sk ignore empty strings:K86:1)
		
		$dst:=$dstFolder.file($pathComponents.slice($srcPath.length).join("/"))
		
		$options.push(New object:C1471("src"; $src; "dst"; $dst; "arch"; $arch))
		
	End for each 
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function convert($option : Variant)->$this : cs:C1710.png2ico
	
	$this:=This:C1470
	
	var $commands; $options : Collection
	$commands:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
	End case 
	
	var $sources : Collection
	var $source : Object
	
	For each ($option; $options)
		
		$sources:=Null:C1517
		
		Case of 
			: (Value type:C1509($option.src)=Is object:K8:27)
				$source:=$option.src
				Case of 
					: (OB Instance of:C1731($source; 4D:C1709.Folder))
						var $file : 4D:C1709.File
						var $files : Collection
						$files:=[]
						For each ($file; $source.files(fk ignore invisible:K87:22))
							If (Match regex:C1019("icon_\\d+x\\d+(?:@\\dx)?"; $file.name; 1))
								If ($file.extension=".png")
									$files.push($file)
								End if 
							End if 
						End for each 
						$sources:=$files
					: (OB Instance of:C1731($source; 4D:C1709.File))
						If ($source.extension=".png")
							$sources:=[$source]
						End if 
				End case 
			: (Value type:C1509($option.src)=Is collection:K8:32)
				For each ($source; $option.src)
					If (OB Instance of:C1731($source; 4D:C1709.File))
						If ($source.extension=".png")
							If ($sources=Null:C1517)
								$sources:=[$source]
							Else 
								$sources.push($source)
							End if 
						End if 
					End if 
				End for each 
		End case 
		
		Case of 
			: ($sources#Null:C1517) && (OB Instance of:C1731($option.dst; 4D:C1709.File)) && ($option.dst.extension=".ico")
/*
resolve filesystem path
*/
				$output:=File:C1566($option.dst.platformPath; fk platform path:K87:2)
				$output.parent.create()
				
				$command:=This:C1470.escape(This:C1470.executablePath)
				
				For each ($src; $sources)
					$input:=File:C1566($src.platformPath; fk platform path:K87:2)
					$command:=$command+" "+This:C1470.quote($input.path)
				End for each 
				
				$command:=$command+" "+This:C1470.quote($output.path)
				$commands.push($command)
				
		End case 
	End for each 
	
	This:C1470.controller.execute($commands)
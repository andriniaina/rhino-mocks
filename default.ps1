properties { 
  $base_dir  = resolve-path .
  $lib_dir = "$base_dir\SharedLibs"
  $build_dir = "$base_dir\build" 
  
  $sln_file = "$base_dir\Rhino.Mocks.sln" 
  $version = "3.6.0.0"
  $humanReadableversion = "3.6"
  $tools_dir = "$base_dir\Tools"
  $release_dir = "$base_dir\Release"
  $uploadCategory = "Rhino-Mocks"
  $uploader = "..\Uploader\S3Uploader.exe"
} 

include .\psake_ext.ps1
	
task default -depends Release

task Clean { 
  remove-item -force -recurse $build_dir -ErrorAction SilentlyContinue 
  remove-item -force -recurse $release_dir -ErrorAction SilentlyContinue 
} 

task Init -depends Clean { 
	
	Generate-Assembly-Info `
		-file "$base_dir\Rhino.Mocks\Properties\AssemblyInfo.cs" `
		-title "Andri Mocks $version" `
		-description "Mocking Framework for .NET" `
		-company "Andri" `
		-product "Andri Mocks $version" `
		-version $version `
		-copyright "Hibernating Rhinos & Ayende Rahien 2004 - 2009, Andriniaina 2013" `
		-internalsVisibleTo "andri.Mocks.Tests, PublicKey=00240000048000009400000006020000002400005253413100040000010001005fb7b21de512d535a34d89bcd37d59b2be38cbe1a7b9170de93532b84d47709cc8f15e02aa7de27d1114658052af52775fd02330a38e82637dbe18c1658ff2ecbe8e3ecd4878d0f12d8fc66a6aa89501a2f2458b5d8c8f41a8f24302737c124d584e11d50c5806e5f8e7021fde9db7aabc3926b0b8d21e4c91b07ba2030dfab0"
		
	Generate-Assembly-Info `
		-file "$base_dir\Rhino.Mocks.Tests\Properties\AssemblyInfo.cs" `
		-title "Andri Mocks Tests $version" `
		-description "Mocking Framework for .NET" `
		-company "Andri" `
		-product "Andri Mocks Tests $version" `
		-version $version `
		-clsCompliant "false" `
		-copyright "Hibernating Rhinos & Ayende Rahien 2004 - 2009"
		
	Generate-Assembly-Info `
		-file "$base_dir\Rhino.Mocks.Tests.Model\Properties\AssemblyInfo.cs" `
		-title "Andri Mocks Tests Model $version" `
		-description "Mocking Framework for .NET" `
		-company "Andri" `
		-product "Andri Mocks Tests Model $version" `
		-version $version `
		-clsCompliant "false" `
		-copyright "Hibernating Rhinos & Ayende Rahien 2004 - 2009, Andriniaina 2013" `
		-internalsVisibleTo "andri.Mocks.Tests, PublicKey=00240000048000009400000006020000002400005253413100040000010001005fb7b21de512d535a34d89bcd37d59b2be38cbe1a7b9170de93532b84d47709cc8f15e02aa7de27d1114658052af52775fd02330a38e82637dbe18c1658ff2ecbe8e3ecd4878d0f12d8fc66a6aa89501a2f2458b5d8c8f41a8f24302737c124d584e11d50c5806e5f8e7021fde9db7aabc3926b0b8d21e4c91b07ba2030dfab0"
	
	Generate-Assembly-Info `
		-file "$base_dir\Rhino.Mocks.GettingStarted\Properties\AssemblyInfo.cs" `
		-title "Andri Mocks Tests $version" `
		-description "Mocking Framework for .NET" `
		-company "Andri" `
		-product "Andri Mocks Tests $version" `
		-version $version `
		-clsCompliant "false" `
		-copyright "Hibernating Rhinos & Ayende Rahien 2004 - 2009, Andriniaina 2013"
		
	new-item $release_dir -itemType directory 
	new-item $build_dir -itemType directory 
	cp $tools_dir\xUnit\*.* $build_dir
} 

task Compile -depends Init { 
  & msbuild "$sln_file" "/p:OutDir=$build_dir\\" /p:Configuration=Release
  if ($lastExitCode -ne 0) {
        throw "Error: Failed to execute msbuild"
  }
} 

task Test -depends Compile {
  $old = pwd
  cd $build_dir
  &.\Xunit.console.exe "$build_dir\andri.Mocks.Tests.dll"
  if ($lastExitCode -ne 0) {
        throw "Error: Failed to execute tests"
  }
  cd $old		
}

task Merge {
	$old = pwd
	cd $build_dir
	
	Remove-Item andri.Mocks.Partial.dll -ErrorAction SilentlyContinue 
	Rename-Item $build_dir\andri.Mocks.dll andri.Mocks.Partial.dll
	
	& $tools_dir\ILMerge.exe andri.Mocks.Partial.dll `
		Castle.DynamicProxy2.dll `
		Castle.Core.dll `
		/out:andri.Mocks.dll `
		/t:library `
		"/keyfile:$base_dir\andri.snk" `
		"/internalize:$base_dir\ilmerge.exclude"
	if ($lastExitCode -ne 0) {
        throw "Error: Failed to merge assemblies!"
    }
	cd $old
}

task Release -depends Test, Merge {
	& $tools_dir\zip.exe -9 -A -j `
		$release_dir\andri.Mocks-$humanReadableversion-Build-$env:ccnetnumericlabel.zip `
		$build_dir\andri.Mocks.dll `
		$build_dir\andri.Mocks.xml `
		license.txt `
		acknowledgements.txt
	if ($lastExitCode -ne 0) {
        throw "Error: Failed to execute ZIP command"
    }
}


task Upload -depends Release {
	Write-Host "Starting upload"
	if (Test-Path $uploader) {
		$log = $env:push_msg 
    if($log -eq $null -or $log.Length -eq 0) {
      $log = git log -n 1 --oneline		
    }
		&$uploader "$uploadCategory" "$release_dir\Rhino.Mocks-$humanReadableversion-Build-$env:ccnetnumericlabel.zip" "$log"
		
		if ($lastExitCode -ne 0) {
      write-host "Failed to upload to S3: $lastExitCode"
			throw "Error: Failed to publish build"
		}
	}
	else {
		Write-Host "could not find upload script $uploadScript, skipping upload"
	}
}

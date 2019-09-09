[cmdletbinding()]
Param(
    [parameter(Mandatory = $true,ValueFromPipeline=$True)] [string[]]$File,
    [parameter(Mandatory = $true)] [string]$ContainerName,
    [parameter(Mandatory = $true)] [string]$DestinationFolder,
    [ValidateRange(1, 20)] [int]$ConcurrentTasks = 1,
    [ValidateSet("Hot","Cool","Archive")] [string]$BlobTier = "Cool"
)

BEGIN {
	$ErrorActionPreference = "Stop"

	$StorageAccountName = "<<storage account name here>>"
	$StorageAccountKey = "<<storage account key here>>"

	$missingFiles = New-Object Collections.Generic.List[string]
	
	# make sure all files exist
	foreach ($singleFile in $File) {
		if(-not (Test-Path $singleFile)) {
			$missingFiles.Add($singleFile)
		}
	} #foreach
	
	# if files are missing, throw error
	if($missingFiles.Count -gt 0) {
		$errstr = $missingFiles | Format-List | Out-String
		Write-Error "Files to upload do not exist: `n$errstr" 
	}
	
	$StorageAccountContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
	
}
PROCESS {
	foreach ($singleFile in $File) {
		$fileName = Split-Path -Path $singleFile -Leaf
		
		$blobName = "$DestinationFolder/$fileName"
		write-host "copying $fileName to $blobName"
		
		# upload file
		$blobResult = Set-AzStorageBlobContent -File $singleFile -Container $containerName -Blob $blobName `
			-Context $storageAccountContext -ConcurrentTaskCount $ConcurrentTasks -StandardBlobTier $BlobTier
	
		if($null -ne $blobResult) {
			Get-AzStorageBlob -Container $containerName -Blob $blobName -Context $storageAccountContext | Format-List
		} else {
			# if file didn't upload, throw error
			throw "Upload of $fileName failed."
		}
	} #foreach
}

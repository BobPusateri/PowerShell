[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DateSuffix = (Get-Date).ToString("yyyyMMddHHmmss")

$downloadURI = "https://data.cityofchicago.org/api/views/ygr5-vcbg/rows.csv?accessType=DOWNLOAD"
$downloadFile = "D:\DownloadTemp\TowedVehicles_$DateSuffix.csv"

# download file
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($downloadURI, $downloadFile)


# Load from CSV into staging table
Import-DbaCsvToSql -Csv $downloadFile -SqlInstance InstanceName -Database TowedVehicles -Table TowedVehiclesSTG `
-Truncate -FirstRowColumns


# Move new rows from staging into final table
Invoke-Sqlcmd2 -ServerInstance InstanceName -Database TowedVehicles `
-Query "INSERT INTO [dbo].[TowedVehicles]
SELECT
	[ID],
	[TowDate],
	[Make],
	[Style],
	[Model],
	[Color],
	[Plate],
	[State],
	[TowedToFacility],
	[FacilityPhone]
FROM (
	SELECT
		s.*,
		ROW_NUMBER() OVER (PARTITION BY s.ID ORDER BY s.ID) AS n
	FROM [dbo].[TowedVehiclesSTG] s
	LEFT JOIN [dbo].[TowedVehicles] v ON s.ID = v.ID
	WHERE v.ID IS NULL
) a
WHERE a.n = 1"



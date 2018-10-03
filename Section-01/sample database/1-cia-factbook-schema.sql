IF EXISTS 
   (
     SELECT name FROM master.dbo.sysdatabases 
     WHERE name = N'CIA_Factbook_DB'
    )
BEGIN
USE master;
ALTER DATABASE CIA_Factbook_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE CIA_Factbook_DB;
END
GO

CREATE DATABASE CIA_Factbook_DB;
GO


USE CIA_Factbook_DB;
GO


CREATE TABLE Country (
	Name VARCHAR(50) NOT NULL UNIQUE
	,Code VARCHAR(4) CONSTRAINT CountryKey PRIMARY KEY
	,Capital VARCHAR(50)
	,Province VARCHAR(50)
	,Area FLOAT CONSTRAINT CountryArea CHECK (Area >= 0)
	,Population FLOAT CONSTRAINT CountryPop CHECK (Population >= 0)
	);

CREATE TABLE City (
	Name VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,Population FLOAT CONSTRAINT CityPop CHECK (Population >= 0)
	,Lat FLOAT CONSTRAINT CityLat CHECK (
		(Lat >= - 90)AND
		(Lat <= 90)
		)
	,Long FLOAT CONSTRAINT CityLon CHECK (
		(Long >= - 180)
		AND (Long <= 180)
		)
	,Elevation FLOAT
	,CONSTRAINT CityKey PRIMARY KEY (
		Name
		,Country
		,Province
		)
	);

CREATE TABLE Province (
	Name VARCHAR(50) CONSTRAINT PrName NOT NULL
	,Country VARCHAR(4) CONSTRAINT PrCountry NOT NULL
	,Population FLOAT CONSTRAINT PrPop CHECK (Population >= 0)
	,Area FLOAT CONSTRAINT PrAr CHECK (Area >= 0)
	,Capital VARCHAR(50)
	,CapProv VARCHAR(50)
	,CONSTRAINT PrKey PRIMARY KEY (
		Name
		,Country
		)
	);

CREATE TABLE Economy (
	Country VARCHAR(4) CONSTRAINT EconomyKey PRIMARY KEY
	,GDP FLOAT CONSTRAINT EconomyGDP CHECK (GDP >= 0)
	,Agriculture FLOAT
	,Service FLOAT
	,Industry FLOAT
	,Inflation FLOAT
	,Unemployment FLOAT
	);

CREATE TABLE Population (
	Country VARCHAR(4) CONSTRAINT PopKey PRIMARY KEY
	,Population_Growth FLOAT
	,Infant_Mortality FLOAT
	);

CREATE TABLE Politics (
	Country VARCHAR(4) CONSTRAINT PoliticsKey PRIMARY KEY
	,Independence DATE
	,WasDependent VARCHAR(50)
	,Dependent VARCHAR(4)
	,Government VARCHAR(120)
	);

CREATE TABLE LANGUAGE (
	Country VARCHAR(4)
	,Name VARCHAR(50)
	,Percentage FLOAT CONSTRAINT LanguagePercent CHECK (
		(Percentage > 0) AND
		(Percentage <= 100)
		)
	,CONSTRAINT LanguageKey PRIMARY KEY (
		Name
		,Country
		)
	);

CREATE TABLE Religion (
	Country VARCHAR(4)
	,Name VARCHAR(50)
	,Percentage FLOAT CONSTRAINT ReligionPercent CHECK (
		(Percentage > 0) AND
		(Percentage <= 100)
		)
	,CONSTRAINT ReligionKey PRIMARY KEY (
		Name
		,Country
		)
	);

CREATE TABLE EthnicGroup (
	Country VARCHAR(4)
	,Name VARCHAR(50)
	,Percentage FLOAT CONSTRAINT EthnicPercent CHECK (
		(Percentage > 0) AND
		(Percentage <= 100)
		)
	,CONSTRAINT EthnicKey PRIMARY KEY (
		Name
		,Country
		)
	);

CREATE TABLE Countrypops (
	Country VARCHAR(4)
	,Year FLOAT CONSTRAINT CountryPopsYear CHECK (Year >= 0)
	,Population FLOAT CONSTRAINT CountryPopsPop CHECK (Population >= 0)
	,CONSTRAINT CountryPopsKey PRIMARY KEY (
		Country
		,Year
		)
	);

CREATE TABLE Countryothername (
	Country VARCHAR(4)
	,othername VARCHAR(50)
	,CONSTRAINT CountryOthernameKey PRIMARY KEY (
		Country
		,othername
		)
	);

CREATE TABLE Countrylocalname (
	Country VARCHAR(4)
	,localname NVARCHAR(120)
	,CONSTRAINT CountrylocalnameKey PRIMARY KEY (Country)
	);

CREATE TABLE Provpops (
	Province VARCHAR(50)
	,Country VARCHAR(4)
	,Year FLOAT CONSTRAINT ProvPopsYear CHECK (Year >= 0)
	,Population FLOAT CONSTRAINT ProvPopsPop CHECK (Population >= 0)
	,CONSTRAINT ProvPopKey PRIMARY KEY (
		Country
		,Province
		,Year
		)
	);

CREATE TABLE Provinceothername (
	Province VARCHAR(50)
	,Country VARCHAR(4)
	,othername VARCHAR(50)
	,CONSTRAINT ProvOthernameKey PRIMARY KEY (
		Country
		,Province
		,othername
		)
	);

CREATE TABLE Provincelocalname (
	Province VARCHAR(50)
	,Country VARCHAR(4)
	,localname NVARCHAR(120)
	,CONSTRAINT ProvlocalnameKey PRIMARY KEY (
		Country
		,Province
		)
	);

CREATE TABLE Citypops (
	City VARCHAR(50)
	,Country VARCHAR(4)
	,Province NVARCHAR(50)
	,Year FLOAT CONSTRAINT CityPopsYear CHECK (Year >= 0)
	,Population FLOAT CONSTRAINT CityPopsPop CHECK (Population >= 0)
	,CONSTRAINT CityPopKey PRIMARY KEY (
		Country
		,Province
		,City
		,Year
		)
	);

CREATE TABLE Cityothername (
	City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,othername VARCHAR(50)
	,CONSTRAINT CityOthernameKey PRIMARY KEY (
		Country
		,Province
		,City
		,othername
		)
	);

CREATE TABLE Citylocalname (
	City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,localname NVARCHAR(120)
	,CONSTRAINT CitylocalnameKey PRIMARY KEY (
		Country
		,Province
		,City
		)
	);

CREATE TABLE Continent (
	Name VARCHAR(20) CONSTRAINT ContinentKey PRIMARY KEY
	,Area DECIMAL(10)
	);

CREATE TABLE borders (
	Country1 VARCHAR(4)
	,Country2 VARCHAR(4)
	,Length FLOAT CHECK (Length > 0)
	,CONSTRAINT BorderKey PRIMARY KEY (
		Country1
		,Country2
		)
	);

CREATE TABLE encompasses (
	Country VARCHAR(4) NOT NULL
	,Continent VARCHAR(20) NOT NULL
	,Percentage FLOAT
	,CHECK (
		(Percentage > 0)
		AND (Percentage <= 100)
		)
	,CONSTRAINT EncompassesKey PRIMARY KEY (
		Country
		,Continent
		)
	);

CREATE TABLE Organization (
	Abbreviation VARCHAR(12) CONSTRAINT OrgKey PRIMARY KEY
	,Name VARCHAR(100) NOT NULL
	,City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,Established DATE
	,CONSTRAINT OrgNameUnique UNIQUE (Name)
	);

CREATE TABLE isMember (
	Country VARCHAR(4)
	,Organization VARCHAR(12)
	,Type VARCHAR(60) DEFAULT 'member'
	,CONSTRAINT MemberKey PRIMARY KEY (
		Country
		,Organization
		)
	);

CREATE TABLE Mountain (
	Name VARCHAR(50) CONSTRAINT MountainKey PRIMARY KEY
	,Mountains VARCHAR(50)
	,Elevation FLOAT
	,Type VARCHAR(10)
	,Coordinates GEOGRAPHY CONSTRAINT MountainCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	);

CREATE TABLE Desert (
	Name VARCHAR(50) CONSTRAINT DesertKey PRIMARY KEY
	,Area FLOAT
	,Coordinates GEOGRAPHY CONSTRAINT DesCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	);

CREATE TABLE Island (
	Name VARCHAR(50) CONSTRAINT IslandKey PRIMARY KEY
	,Islands VARCHAR(50)
	,Area FLOAT CONSTRAINT IslandAr CHECK (Area >= 0)
	,Elevation FLOAT
	,Type VARCHAR(10)
	,Coordinates GEOGRAPHY CONSTRAINT IslandCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	);

CREATE TABLE Lake (
	Name VARCHAR(50) CONSTRAINT LakeKey PRIMARY KEY
	,River VARCHAR(50)
	,Area FLOAT CONSTRAINT LakeAr CHECK (Area >= 0)
	,Elevation FLOAT
	,Depth FLOAT CONSTRAINT LakeDpth CHECK (Depth >= 0)
	,Height FLOAT CONSTRAINT DamHeight CHECK (Height > 0)
	,Type VARCHAR(12)
	,Coordinates GEOGRAPHY CONSTRAINT LakeCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	);

CREATE TABLE Sea (
	Name VARCHAR(50) CONSTRAINT SeaKey PRIMARY KEY
	,Area FLOAT CONSTRAINT SeaAr CHECK (Area >= 0)
	,Depth FLOAT CONSTRAINT SeaDepth CHECK (Depth >= 0)
	);

CREATE TABLE River (
	Name VARCHAR(50) CONSTRAINT RiverKey PRIMARY KEY
	,River VARCHAR(50)
	,Lake VARCHAR(50)
	,Sea VARCHAR(50)
	,Length FLOAT CONSTRAINT RiverLength CHECK (Length >= 0)
	,Area FLOAT CONSTRAINT RiverArea CHECK (Area >= 0)
	,Source GEOGRAPHY CONSTRAINT SourceCoord CHECK (
		(Source.Lat >= - 90)
		AND (Source.Lat <= 90)
		AND (Source.Long > - 180)
		AND (Source.Long <= 180)
		)
	,Mountains VARCHAR(50)
	,SourceElevation FLOAT
	,Estuary GEOGRAPHY CONSTRAINT EstCoord CHECK (
		(Estuary.Lat >= - 90)
		AND (Estuary.Lat <= 90)
		AND (Estuary.Long > - 180)
		AND (Estuary.Long <= 180)
		)
	,EstuaryElevation FLOAT
	,CONSTRAINT RivFlowsInto CHECK (
		(
			River IS NULL
			AND Lake IS NULL
			)
		OR (
			River IS NULL
			AND Sea IS NULL
			)
		OR (
			Lake IS NULL
			AND Sea IS NULL
			)
		)
	);

CREATE TABLE RiverThrough (
	River VARCHAR(50)
	,Lake VARCHAR(50)
	,CONSTRAINT RThroughKey PRIMARY KEY (
		River
		,Lake
		)
	);

CREATE TABLE geo_Mountain (
	Mountain VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GMountainKey PRIMARY KEY (
		Province
		,Country
		,Mountain
		)
	);

CREATE TABLE geo_Desert (
	Desert VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GDesertKey PRIMARY KEY (
		Province
		,Country
		,Desert
		)
	);

CREATE TABLE geo_Island (
	Island VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GIslandKey PRIMARY KEY (
		Province
		,Country
		,Island
		)
	);

CREATE TABLE geo_River (
	River VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GRiverKey PRIMARY KEY (
		Province
		,Country
		,River
		)
	);

CREATE TABLE geo_Sea (
	Sea VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GSeaKey PRIMARY KEY (
		Province
		,Country
		,Sea
		)
	);

CREATE TABLE geo_Lake (
	Lake VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GLakeKey PRIMARY KEY (
		Province
		,Country
		,Lake
		)
	);

CREATE TABLE geo_Source (
	River VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GSourceKey PRIMARY KEY (
		Province
		,Country
		,River
		)
	);

CREATE TABLE geo_Estuary (
	River VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GEstuaryKey PRIMARY KEY (
		Province
		,Country
		,River
		)
	);

CREATE TABLE mergesWith (
	Sea1 VARCHAR(50)
	,Sea2 VARCHAR(50)
	,CONSTRAINT MergesWithKey PRIMARY KEY (
		Sea1
		,Sea2
		)
	);

CREATE TABLE located (
	City VARCHAR(50)
	,Province VARCHAR(50)
	,Country VARCHAR(4)
	,River VARCHAR(50)
	,Lake VARCHAR(50)
	,Sea VARCHAR(50)
	);

CREATE TABLE locatedOn (
	City VARCHAR(50)
	,Province VARCHAR(50)
	,Country VARCHAR(4)
	,Island VARCHAR(50)
	,CONSTRAINT locatedOnKey PRIMARY KEY (
		City
		,Province
		,Country
		,Island
		)
	);

CREATE TABLE islandIn (
	Island VARCHAR(50)
	,Sea VARCHAR(50)
	,Lake VARCHAR(50)
	,River VARCHAR(50)
	);

CREATE TABLE MountainOnIsland (
	Mountain VARCHAR(50)
	,Island VARCHAR(50)
	,CONSTRAINT MountainIslKey PRIMARY KEY (
		Mountain
		,Island
		)
	);

CREATE TABLE LakeOnIsland (
	Lake VARCHAR(50)
	,Island VARCHAR(50)
	,CONSTRAINT LakeIslKey PRIMARY KEY (
		Lake
		,Island
		)
	);

CREATE TABLE RiverOnIsland (
	River NVARCHAR(50)
	,Island NVARCHAR(50)
	,CONSTRAINT RiverIslKey PRIMARY KEY (
		River
		,Island
		)
	);

CREATE TABLE Airport (
	IATACode VARCHAR(3) PRIMARY KEY
	,Name VARCHAR(100)
	,Country VARCHAR(4)
	,City VARCHAR(50)
	,Province VARCHAR(50)
	,Island VARCHAR(50)
	,Lat FLOAT CONSTRAINT AirpLat CHECK (
		(Lat >= - 90) AND
		(Lat <= 90)
		)
	,Long FLOAT CONSTRAINT AirpLon CHECK (
		(Long >= - 180)AND
		(Long <= 180)
		)
	,Elevation FLOAT
	,gmtOffset FLOAT
	);

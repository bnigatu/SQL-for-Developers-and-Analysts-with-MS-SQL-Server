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
	 [Name] VARCHAR(50) NOT NULL UNIQUE
	,Code VARCHAR(4) CONSTRAINT CountryKey PRIMARY KEY
	,Capital VARCHAR(50)
	,Province VARCHAR(50)
	,Area FLOAT CONSTRAINT CountryArea CHECK (Area >= 0)
	,Population FLOAT CONSTRAINT CountryPop CHECK (Population >= 0)
	);

CREATE TABLE Province (
	[Name] VARCHAR(50) CONSTRAINT PrName NOT NULL
	,Country VARCHAR(4) CONSTRAINT PrCountry NOT NULL
	,[Population] FLOAT CONSTRAINT PrPop CHECK (Population >= 0)
	,Area FLOAT CONSTRAINT PrAr CHECK (Area >= 0)
	,Capital VARCHAR(50)
	,CapProv VARCHAR(50)
	,CONSTRAINT PrKey PRIMARY KEY (Name,Country)
	,CONSTRAINT FK_ProvinceCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE City (
	 [Name] VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,[Population] FLOAT CONSTRAINT CityPop CHECK (Population >= 0)
	,Lat FLOAT CONSTRAINT CityLat CHECK ((Lat >= - 90)AND(Lat <= 90))
	,Long FLOAT CONSTRAINT CityLon CHECK ((Long >= - 180)AND (Long <= 180))
	,Elevation FLOAT
	,CONSTRAINT CityKey PRIMARY KEY (Name,Province,Country)
	,CONSTRAINT FK_CityCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_CityProvince FOREIGN KEY (Province,Country) REFERENCES Province(Name,Country)
	);

CREATE TABLE Economy (
	Country VARCHAR(4) 
	,GDP FLOAT CONSTRAINT EconomyGDP CHECK (GDP >= 0)
	,Agriculture FLOAT
	,[Service] FLOAT
	,Industry FLOAT
	,Inflation FLOAT
	,Unemployment FLOAT
	,CONSTRAINT EconomyKey PRIMARY KEY (Country)
	,CONSTRAINT FK_EconomyCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE [Population] (
	Country VARCHAR(4)
	,Population_Growth FLOAT
	,Infant_Mortality FLOAT
	,CONSTRAINT PopKey PRIMARY KEY (Country)
	,CONSTRAINT FK_PopulationCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE Politics (
	Country VARCHAR(4)
	,Independence DATE
	,WasDependent VARCHAR(50)
	,Dependent VARCHAR(4)
	,Government VARCHAR(120)
	,CONSTRAINT PoliticsKey PRIMARY KEY (Country)
	,CONSTRAINT FK_PoliticsCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE [Language] (
	Country VARCHAR(4)
	,[Name] VARCHAR(50)
	,Percentage FLOAT CONSTRAINT LanguagePercent CHECK ((Percentage > 0) AND (Percentage <= 100))
	,CONSTRAINT LanguageKey PRIMARY KEY (Name,Country)
	,CONSTRAINT FK_LanguageCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE Religion (
	Country VARCHAR(4)
	,[Name] VARCHAR(50)
	,Percentage FLOAT CONSTRAINT ReligionPercent CHECK ((Percentage > 0) AND(Percentage <= 100))
	,CONSTRAINT ReligionKey PRIMARY KEY (Name,Country)
	,CONSTRAINT FK_ReligionCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE EthnicGroup (
	Country VARCHAR(4)
	,[Name] VARCHAR(50)
	,Percentage FLOAT CONSTRAINT EthnicPercent CHECK ((Percentage > 0) AND	(Percentage <= 100)	)
	,CONSTRAINT EthnicKey PRIMARY KEY (Name,Country)
	,CONSTRAINT FK_EthnicGroupCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE CountryPops (
	Country VARCHAR(4)
	,[Year] FLOAT CONSTRAINT CountryPopsYear CHECK ([Year] >= 0)
	,[Population] FLOAT CONSTRAINT CountryPopsPop CHECK (Population >= 0)
	,CONSTRAINT CountryPopsKey PRIMARY KEY (Country,[Year])
	,CONSTRAINT FK_CountrypopsCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE CountryOtherName (
	Country VARCHAR(4)
	,othername VARCHAR(50)
	,CONSTRAINT CountryOthernameKey PRIMARY KEY (Country,othername)
	,CONSTRAINT FK_CountryothernameCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE CountryLocalName (
	Country VARCHAR(4)
	,localname NVARCHAR(120)
	,CONSTRAINT CountrylocalnameKey PRIMARY KEY (Country)
	,CONSTRAINT FK_CountrylocalnameCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE ProvPops (
	Province VARCHAR(50)
	,Country VARCHAR(4)
	,[Year] FLOAT CONSTRAINT ProvPopsYear CHECK ([Year] >= 0)
	,[Population] FLOAT CONSTRAINT ProvPopsPop CHECK (Population >= 0)
	,CONSTRAINT ProvPopKey PRIMARY KEY (Province,Country,[Year])
	,CONSTRAINT FK_ProvpopsCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_ProvpopsProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	);

CREATE TABLE ProvinceOtherName (
	Province VARCHAR(50)
	,Country VARCHAR(4)
	,othername VARCHAR(50)
	,CONSTRAINT ProvOthernameKey PRIMARY KEY (Province,Country,othername)
	,CONSTRAINT FK_ProvinceothernameCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_ProvinceothernameProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	);

CREATE TABLE Provincelocalname (
	Province VARCHAR(50)
	,Country VARCHAR(4)
	,localname NVARCHAR(120)
	,CONSTRAINT ProvlocalnameKey PRIMARY KEY (Province,Country)
	,CONSTRAINT FK_ProvincelocalnameCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_ProvincelocalnameProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	);

CREATE TABLE CityPops (
	City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,[Year] FLOAT CONSTRAINT CityPopsYear CHECK ([Year] >= 0)
	,Population FLOAT CONSTRAINT CityPopsPop CHECK (Population >= 0)
	,CONSTRAINT CityPopKey PRIMARY KEY (City,Province,Country,[Year])
	,CONSTRAINT FK_CitypopsCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_CitypopsProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_CitypopsCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	);

CREATE TABLE CityOtherName (
	City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,othername VARCHAR(50)
	,CONSTRAINT CityOthernameKey PRIMARY KEY (City,Province,Country,othername)
	,CONSTRAINT FK_CityothernameCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_CityothernameProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_CityothernameCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	);

CREATE TABLE Citylocalname (
	City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,localname NVARCHAR(120)
	,CONSTRAINT CitylocalnameKey PRIMARY KEY (City,Province,Country)
	,CONSTRAINT FK_CitylocalnameCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_CitylocalnameProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_CitylocalnameCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	);

CREATE TABLE Continent (
	[Name] VARCHAR(20) 
	,Area DECIMAL(10)
	,CONSTRAINT ContinentKey PRIMARY KEY ([Name])
	);

CREATE TABLE Borders (
	Country1 VARCHAR(4)
	,Country2 VARCHAR(4)
	,[Length] FLOAT CHECK (Length > 0)
	,CONSTRAINT BorderKey PRIMARY KEY (Country1,Country2)
	,CONSTRAINT FK_bordersCountry1 FOREIGN KEY (Country1) REFERENCES Country(Code)
	,CONSTRAINT FK_bordersCountry2 FOREIGN KEY (Country2) REFERENCES Country(Code)
	);

CREATE TABLE Encompasses (
	 Country VARCHAR(4) NOT NULL
	,Continent VARCHAR(20) NOT NULL
	,Percentage FLOAT
	,CHECK ((Percentage > 0) AND (Percentage <= 100))
	,CONSTRAINT EncompassesKey PRIMARY KEY (Country,Continent)
	,CONSTRAINT FK_encompassesCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_encompassesContinent FOREIGN KEY (Continent) REFERENCES Continent([Name])
	);

CREATE TABLE Organization (
	Abbreviation VARCHAR(12) 
	,[Name] VARCHAR(100) NOT NULL
	,City VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,Established DATE
	,CONSTRAINT OrgNameUnique UNIQUE (Name)
	,CONSTRAINT OrgKey PRIMARY KEY (Abbreviation)
	,CONSTRAINT FK_OrganizationCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_OrganizationProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_OrganizationCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	);

CREATE TABLE IsMember (
	Country VARCHAR(4)
	,Organization VARCHAR(12)
	,Type VARCHAR(60) DEFAULT ('member')
	,CONSTRAINT MemberKey PRIMARY KEY (Country,Organization)
	,CONSTRAINT FK_IsMemberCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	);

CREATE TABLE Mountain (
	[Name] VARCHAR(50)
	,Mountains VARCHAR(50)
	,Elevation FLOAT
	,[Type] VARCHAR(10)
	,Coordinates GEOGRAPHY CONSTRAINT MountainCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	,CONSTRAINT MountainKey PRIMARY KEY([Name])
	);

CREATE TABLE Desert (
	[Name] VARCHAR(50) 
	,Area FLOAT
	,Coordinates GEOGRAPHY CONSTRAINT DesCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	,CONSTRAINT DesertKey PRIMARY KEY ([Name])
	);

CREATE TABLE Island (
	[Name] VARCHAR(50) 
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
	,CONSTRAINT IslandKey PRIMARY KEY ([Name])
	);

CREATE TABLE Lake (
	[Name] VARCHAR(50)
	,River VARCHAR(50)
	,Area FLOAT CONSTRAINT LakeAr CHECK (Area >= 0)
	,Elevation FLOAT
	,Depth FLOAT CONSTRAINT LakeDpth CHECK (Depth >= 0)
	,Height FLOAT CONSTRAINT DamHeight CHECK (Height > 0)
	,[Type] VARCHAR(12)
	,Coordinates GEOGRAPHY CONSTRAINT LakeCoord CHECK (
		(Coordinates.Lat >= - 90) AND
		(Coordinates.Lat <= 90) AND
		(Coordinates.Long > - 180) AND
		(Coordinates.Long <= 180)
		)
	,CONSTRAINT LakeKey PRIMARY KEY ([Name])
	);

CREATE TABLE Sea (
	[Name] VARCHAR(50) 
	,Area FLOAT CONSTRAINT SeaAr CHECK (Area >= 0)
	,Depth FLOAT CONSTRAINT SeaDepth CHECK (Depth >= 0)
	,CONSTRAINT SeaKey PRIMARY KEY ([Name])
	);

CREATE TABLE River (
	[Name] VARCHAR(50)
	,River VARCHAR(50)
	,Lake VARCHAR(50)
	,Sea VARCHAR(50)
	,[Length] FLOAT CONSTRAINT RiverLength CHECK (Length >= 0)
	,Area FLOAT CONSTRAINT RiverArea CHECK (Area >= 0)
	,Source GEOGRAPHY CONSTRAINT SourceCoord CHECK ((Source.Lat >= - 90)
												AND (Source.Lat <= 90)
												AND (Source.Long > - 180)
												AND (Source.Long <= 180))
	,Mountains VARCHAR(50)
	,SourceElevation FLOAT
	,Estuary GEOGRAPHY CONSTRAINT EstCoord CHECK ((Estuary.Lat >= - 90)
											  AND (Estuary.Lat <= 90)
											  AND (Estuary.Long > - 180)
											  AND (Estuary.Long <= 180))
	,EstuaryElevation FLOAT
	,CONSTRAINT RiverKey PRIMARY KEY ([Name])
	,CONSTRAINT RivFlowsInto CHECK ((River IS NULL	AND Lake IS NULL)
								 OR (River IS NULL AND Sea IS NULL)
								 OR (Lake IS NULL AND Sea IS NULL))
	,CONSTRAINT FK_RiverSea FOREIGN KEY (Sea) REFERENCES Sea(Name)
	,CONSTRAINT FK_RiverLake FOREIGN KEY (Lake) REFERENCES Lake(Name)
	);

CREATE TABLE RiverThrough (
	River VARCHAR(50)
	,Lake VARCHAR(50)
	,CONSTRAINT RThroughKey PRIMARY KEY (River,Lake)
	,CONSTRAINT FK_RiverThroughRiver FOREIGN KEY (River) REFERENCES River(Name)
	,CONSTRAINT FK_RiverThroughLake FOREIGN KEY (Lake) REFERENCES Lake(Name)
	);

CREATE TABLE geo_Mountain (
	Mountain VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GMountainKey PRIMARY KEY (Province,Country,Mountain	)
	,CONSTRAINT FK_geo_MountainCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_MountainProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_MountainMountain FOREIGN KEY (Mountain) REFERENCES Mountain(Name)
	);

CREATE TABLE geo_Desert (
	Desert VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GDesertKey PRIMARY KEY (Province,Country,Desert	)
	,CONSTRAINT FK_geo_DesertCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_DesertProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_DesertDesert FOREIGN KEY (Desert) REFERENCES Desert(Name)
	);

CREATE TABLE geo_Island (
	Island VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GIslandKey PRIMARY KEY (Province,Country,Island)
	,CONSTRAINT FK_geo_IslandCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_IslandProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_IslandIsland FOREIGN KEY (Island) REFERENCES Island(Name)
	);

CREATE TABLE geo_River (
	River VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GRiverKey PRIMARY KEY (Province,Country,River)
	,CONSTRAINT FK_geo_RiverCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_RiverProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_RiverRiver FOREIGN KEY (River) REFERENCES River(Name)
	);

CREATE TABLE geo_Sea (
	Sea VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GSeaKey PRIMARY KEY (Province,Country,Sea)
	,CONSTRAINT FK_geo_SeaCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_SeaProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_SeaSea FOREIGN KEY (Sea) REFERENCES Sea(Name)
	);

CREATE TABLE geo_Lake (
	Lake VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GLakeKey PRIMARY KEY (Province,Country,Lake)
	,CONSTRAINT FK_geo_LakeCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_LakeProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_LakeLake FOREIGN KEY (Lake) REFERENCES Lake(Name)
	);

CREATE TABLE geo_Source (
	River VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GSourceKey PRIMARY KEY (Province,Country,River)
	,CONSTRAINT FK_geo_SourceCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_SourceProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_SourceRiver FOREIGN KEY (River) REFERENCES River(Name)
	);

CREATE TABLE geo_Estuary (
	River VARCHAR(50)
	,Country VARCHAR(4)
	,Province VARCHAR(50)
	,CONSTRAINT GEstuaryKey PRIMARY KEY (Province,Country,River)
	,CONSTRAINT FK_geo_EstuaryCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_geo_EstuaryProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)	
	,CONSTRAINT FK_geo_EstuaryRiver FOREIGN KEY (River) REFERENCES River(Name)
	);

CREATE TABLE MergesWith (
	Sea1 VARCHAR(50)
	,Sea2 VARCHAR(50)
	,CONSTRAINT MergesWithKey PRIMARY KEY (Sea1,Sea2)
	,CONSTRAINT FK_mergesWithSea1 FOREIGN KEY (Sea1) REFERENCES Sea(Name)
	,CONSTRAINT FK_mergesWithSea2 FOREIGN KEY (Sea2) REFERENCES Sea(Name)
	);

CREATE TABLE Located (
	City VARCHAR(50)
	,Province VARCHAR(50)
	,Country VARCHAR(4)
	,River VARCHAR(50)
	,Lake VARCHAR(50)
	,Sea VARCHAR(50)
	,CONSTRAINT FK_locatedCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_locatedProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_locatedCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	,CONSTRAINT FK_locatedSea FOREIGN KEY (Sea) REFERENCES Sea(Name)
	,CONSTRAINT FK_locatedLake FOREIGN KEY (Lake) REFERENCES Lake(Name)
	,CONSTRAINT FK_locatedRiver FOREIGN KEY (River) REFERENCES River(Name)
	);

CREATE TABLE LocatedOn (
	City VARCHAR(50)
	,Province VARCHAR(50)
	,Country VARCHAR(4)
	,Island VARCHAR(50)
	,CONSTRAINT locatedOnKey PRIMARY KEY (City,Province,Country,Island)
	,CONSTRAINT FK_locatedOnCountry FOREIGN KEY (Country) REFERENCES Country(Code)	
	,CONSTRAINT FK_locatedOnProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_locatedOnCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	);

CREATE TABLE IslandIn (
	Island VARCHAR(50)
	,Sea VARCHAR(50)
	,Lake VARCHAR(50)
	,River VARCHAR(50)
	,CONSTRAINT FK_islandInIsland FOREIGN KEY (Island) REFERENCES Island(Name)
	,CONSTRAINT FK_islandInSea FOREIGN KEY (Sea) REFERENCES Sea(Name)
	,CONSTRAINT FK_islandInLake FOREIGN KEY (Lake) REFERENCES Lake(Name)
	,CONSTRAINT FK_islandInRiver FOREIGN KEY (River) REFERENCES River(Name)
	);

CREATE TABLE MountainOnIsland (
	Mountain VARCHAR(50)
	,Island VARCHAR(50)
	,CONSTRAINT MountainIslKey PRIMARY KEY (Mountain,Island)
	,CONSTRAINT FK_MountainOnIslandMountain FOREIGN KEY (Mountain) REFERENCES Mountain(Name)
	,CONSTRAINT FK_MountainOnIslandIsland FOREIGN KEY (Island) REFERENCES Island(Name)
	);

CREATE TABLE LakeOnIsland (
	Lake VARCHAR(50)
	,Island VARCHAR(50)
	,CONSTRAINT LakeIslKey PRIMARY KEY (Lake,Island)
	,CONSTRAINT FK_LakeOnIslandLake FOREIGN KEY (Lake) REFERENCES Lake(Name)
	,CONSTRAINT FK_LakeOnIslandIsland FOREIGN KEY (Island) REFERENCES Island(Name)
	);

CREATE TABLE RiverOnIsland (
	River VARCHAR(50)
	,Island VARCHAR(50)
	,CONSTRAINT RiverIslKey PRIMARY KEY (River,Island)
	,CONSTRAINT FK_RiverOnIslandRiver FOREIGN KEY (River) REFERENCES River(Name)
	,CONSTRAINT FK_RiverOnIslandIsland FOREIGN KEY (Island) REFERENCES Island(Name)
	);

CREATE TABLE Airport (
	IATACode VARCHAR(3) 
	,[Name] VARCHAR(100)
	,Country VARCHAR(4)
	,City VARCHAR(50)
	,Province VARCHAR(50)
	,Island VARCHAR(50)
	,Lat FLOAT CONSTRAINT AirpLat CHECK ((Lat >= - 90) AND (Lat <= 90))
	,Long FLOAT CONSTRAINT AirpLon CHECK ((Long >= - 180) AND (Long <= 180))
	,Elevation FLOAT
	,gmtOffset FLOAT
	,CONSTRAINT AirportKey PRIMARY KEY (IATACode)
	,CONSTRAINT FK_AirportCountry FOREIGN KEY (Country) REFERENCES Country(Code)
	,CONSTRAINT FK_AirportCity FOREIGN KEY (City,Province,Country) REFERENCES City(Name,Province,Country)
	,CONSTRAINT FK_AirportProvince FOREIGN KEY (Province,Country) REFERENCES Province([Name],Country)
	,CONSTRAINT FK_AirportIsland FOREIGN KEY (Island) REFERENCES Island(Name)
	);

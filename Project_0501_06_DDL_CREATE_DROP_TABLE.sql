﻿
USE BUDT703_Project_0501_06

DROP TABLE IF EXISTS [Hotspots.Review]
DROP TABLE IF EXISTS [Hotspots.OperationTime]
DROP TABLE IF EXISTS [Hotspots.RestaurantCategory]
DROP TABLE IF EXISTS [Hotspots.Source]
DROP TABLE IF EXISTS [Hotspots.Customer]
DROP TABLE IF EXISTS [Hotspots.Restaurant]

CREATE TABLE [Hotspots.Restaurant] (
	rstId CHAR (3) NOT NULL,
	rstName VARCHAR (30) NOT NULL ,
	rstStreet VARCHAR (40) ,
	rstCity VARCHAR (15) ,
	rstState CHAR (2) ,
	rstZip CHAR (10) ,
	rstPhone CHAR (10) ,
	rstStar FLOAT,
	rstPriceLevel VARCHAR (4),
	rstReviewCount INTEGER,
	CONSTRAINT pk_Restaurant_rstId PRIMARY KEY (rstId))
​​
CREATE TABLE [Hotspots.Customer] (
	cusId CHAR (3) NOT NULL,
	cusFName VARCHAR (20) ,
	cusLName VARCHAR(20) ,
	cusCity VARCHAR(20) ,
	cusState CHAR(2) ,
	CONSTRAINT pk_Customer_cusId PRIMARY KEY (cusId))

​​CREATE TABLE [Hotspots.Source] (
	srcId CHAR (3) NOT NULL,
	srcName VARCHAR (15),
	CONSTRAINT pk_Source_srcId PRIMARY KEY (srcId))

CREATE TABLE [Hotspots.RestaurantCategory] (
	rstId CHAR (3) NOT NULL,
	rstCat VARCHAR (20) NOT NULL, 
	CONSTRAINT pk_RestaurantCategory_rstId_rstCat PRIMARY KEY (rstId,rstCat),
	CONSTRAINT fk_RestaurantCategory_rstId FOREIGN KEY (rstId)
		REFERENCES [HotSpots.Restaurant] (rstId)
		ON DELETE CASCADE ON UPDATE CASCADE)

​​CREATE TABLE [Hotspots.OperationTime] (
	rstId CHAR (3) NOT NULL,
	oprDay CHAR (3) NOT NULL,
	oprStart INTEGER,
	oprEnd INTEGER,
	CONSTRAINT pk_OperationTime_rstId_oprDay PRIMARY KEY (rstId, oprDay),
	CONSTRAINT fk_OperationTime_rstId FOREIGN KEY (rstId)
		REFERENCES [Hotspots.Restaurant] (rstId)
		ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE [Hotspots.Review] (
	rvwId CHAR (3) NOT NULL,
	rstId CHAR (3),
	cusId CHAR (3),
	srcId CHAR (3), 
	rvwStar FLOAT,
	rvwDate DATE,
	rvwPhotoCount INTEGER,
	CONSTRAINT pk_Review_rvwId PRIMARY KEY (rvwId),
	CONSTRAINT fk_Review_rstId FOREIGN KEY (rstId)
		REFERENCES [Hotspots.Restaurant] (rstId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Review_cusId FOREIGN KEY (cusId)
		REFERENCES [Hotspots.Customer] (cusId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Review_srcId FOREIGN KEY (srcId)
		REFERENCES [Hotspots.Source] (srcId)
		ON DELETE CASCADE ON UPDATE CASCADE)

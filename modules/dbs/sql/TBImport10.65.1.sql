SET ARITHABORT ON
SET QUOTED_IDENTIFIER ON

-- Creating Tables and constraints 

CREATE TABLE Plum.AllergenTexts  
(  	
	AllergenTextKey	 INT IDENTITY NOT NULL ,   
	Description		 VARCHAR(256) NOT NULL,  
	ChangeFlag  SMALLINT CONSTRAINT DF_AllergenTexts_ChangeFlag  DEFAULT (0)    
 ) 
GO

ALTER TABLE Plum.AllergenTexts ADD CONSTRAINT PKey_503 PRIMARY KEY (AllergenTextKey) 
CREATE UNIQUE INDEX i_AT_DESC ON Plum.AllergenTexts (Description)

GO

CREATE TABLE Plum.ArTransactionDetail  
(  	
	storeno          INTEGER ,  
	transkey         INTEGER NOT NULL ,  
	detailsequence   INTEGER NOT NULL ,  
	errorcode        INTEGER  ,  
	errorlevel       VARCHAR(3)  ,  
	jobno            INTEGER  ,  
	subjobno         INTEGER  ,  
	deptno           INTEGER  ,  
	scaleaddr        INTEGER  ,  
	errordesc        VARCHAR(1000)  ,  
	command          VARCHAR(128)  ,  
	batchno          INTEGER  ,  
	storekey         INTEGER NOT NULL ,  
	pluingrno        INTEGER  ,  
	scalekey         INTEGER ,  
	MQTransID        INTEGER ,  
	TriggerTransId   INTEGER ,  
	LastDate         INTEGER ,  
	LastTime         INTEGER ,  
	Occurrence       INTEGER ,  
	Memo             VARCHAR(2000)   
 ) 
GO

ALTER TABLE Plum.ArTransactionDetail ADD CONSTRAINT Pkey_623 PRIMARY KEY (transkey,detailsequence,storekey) 
CREATE INDEX i_ArtrdStrKey ON Plum.ArTransactionDetail (storekey)
CREATE INDEX i_ArtrdTkSk ON Plum.ArTransactionDetail (transkey,storekey)
CREATE INDEX i_ArtrdSkBnoTrtd ON Plum.ArTransactionDetail (StoreKey,Batchno,TriggerTransId)
exec sp_indexoption 'Plum.ArTransactionDetail', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.ArTransactions  
(  	
	transdate			 INTEGER  ,  
	transtime			 INTEGER  ,  
	sequence			 INTEGER NOT NULL ,  
	type				 INTEGER  ,  
	description			 VARCHAR(500)  ,  
	storeno				 INTEGER  ,  
	item				 INTEGER  ,  
	resultcode			 INTEGER  ,  
	batchno				 INTEGER  ,  
	batcheffectivedate	 INTEGER  ,  
	batcheffectivetime	 INTEGER  ,  
	batchtype			 INTEGER  ,  
	usrname				 VARCHAR(50)  ,  
	maintenanceperiod	 INTEGER CONSTRAINT DF_ArTransactions_maintenanceperiod	 DEFAULT (0) NOT NULL,  
	storekey			 INTEGER NOT NULL ,  
	loginname			 VARCHAR(50)    
 ) 
GO

ALTER TABLE Plum.ArTransactions ADD CONSTRAINT Pkey_622 PRIMARY KEY (sequence,storekey) 
CREATE INDEX i_ArtranStrKey ON Plum.ArTransactions (storekey)
CREATE INDEX i_ArtrnSkBno ON Plum.ArTransactions (storekey, batchno)
exec sp_indexoption 'Plum.ArTransactions', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.BatchItemFailures  
(  	
	SysKey		 INT IDENTITY NOT NULL ,   
	BatchNo		 INTEGER NOT NULL,  
	StoreKey	 INTEGER NOT NULL,  
	DeptNo		 INTEGER NOT NULL,  
	ScaleAddr	 INTEGER ,  
	ScaleKey	 INTEGER ,  
	ItemNo       INTEGER ,  
	ItemType     INTEGER   
 ) 
GO

ALTER TABLE Plum.BatchItemFailures ADD CONSTRAINT Pkey_185 PRIMARY KEY (SysKey) 
CREATE INDEX i_bifBatStrkey ON Plum.BatchItemFailures (batchno, storekey)
CREATE INDEX i_bifSkDno ON Plum.BatchItemFailures (StoreKey,DeptNo)
CREATE INDEX ibif_S_B_D_S_S_I_I ON Plum.BatchItemFailures (StoreKey,BatchNo,DeptNo,ScaleAddr,ScaleKey,ItemType,ItemNo)
exec sp_indexoption 'Plum.BatchItemFailures', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.BatchRegister  
(  	
	storekey			 INTEGER NOT NULL ,  
	batchno				 INTEGER NOT NULL ,  
	batchname			 VARCHAR(32)  ,  
	noplus				 INTEGER  ,  
	batchdescription	 VARCHAR(64)  ,  
	effdate				 INTEGER NOT NULL ,  
	efftime				 INTEGER  ,  
	deptno				 INTEGER  ,  
	batchtype			 VARCHAR(10) NOT NULL ,  
	creationdate		 INTEGER  ,  
	creationtime		 INTEGER  ,  
	exportdate			 INTEGER  ,  
	exporttime			 INTEGER  ,  
	batchstatus			 INTEGER  ,  
	regionno			 INTEGER  ,  
	storeno				 INTEGER  ,  
	importdate			 INTEGER  ,  
	actualtransmitdate	 VARCHAR(10)  ,  
	actualtransmittime	 VARCHAR(10)  ,  
	nobatchretry		 INTEGER  ,  
	importtime			 INTEGER  ,  
	orgnoplus			 INTEGER  ,  
	readytoexport		 CHAR(1)  ,  
	createdby			 VARCHAR(14)  ,  
	lockflag			 INTEGER  ,  
	lockdate			 INTEGER  ,  
	locktime			 INTEGER  ,  
	batchaction			 INTEGER  ,  
	srbatchno			 INTEGER  ,  
	ChkStatus			 INTEGER  ,  
	TriggerTransId		 INTEGER  ,  
	WaitingForLock		 INTEGER  ,  
	PriceChangeFlag 	 INTEGER  ,  
	Modifydate			 INTEGER  ,  
	Modifytime			 INTEGER ,  
	BundleNo			 INTEGER   
 ) 
GO

ALTER	TABLE Plum.BatchRegister ADD CONSTRAINT Pkey_101 PRIMARY KEY (storekey,batchno) 
CREATE INDEX i_effcreatime ON Plum.BatchRegister(effdate,efftime,creationdate,creationtime)
CREATE INDEX ibatchregister ON Plum.BatchRegister(effdate,efftime,batchtype,batchno)
CREATE INDEX i_brBatSk ON Plum.BatchRegister (batchno, storekey)
CREATE INDEX i_brStrKey ON Plum.BatchRegister (storekey)
CREATE INDEX iBR_fdt_bt_cdt_b ON Plum.BatchRegister (storekey,effdate,efftime,batchtype,creationdate,creationtime,batchno,readytoexport)
exec sp_indexoption 'Plum.BatchRegister', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.COOLClass  
(  	
	COOLClassNo		 INTEGER NOT NULL,  
	ClassDesc		 VARCHAR(128)   
 ) 
GO

ALTER TABLE Plum.COOLClass ADD CONSTRAINT Pkey_198 PRIMARY KEY (COOLClassNo) 

GO

CREATE TABLE Plum.COOLCountry  
(  	
	BatchNo 		 INTEGER NOT NULL,  
	CountryNo		 INTEGER NOT NULL,  
	DeptNo			 INTEGER NOT NULL,  
	COOLClassNo		 INTEGER NOT NULL,  
	StoreKey		 INTEGER ,  
	CountryText		 VARCHAR(1024) ,  
	ActionCode		 INTEGER ,  
	ChangeDate       INTEGER ,  
	ChangeTime       INTEGER ,  
	UserId           VARCHAR(255) ,  
	MergeStatus      INTEGER ,  
	District_Key     INTEGER ,  
	DivisionKey      INTEGER   
 ) 
GO


CREATE INDEX i_ccntCcn  ON Plum.COOLCountry (COOLClassNo)
CREATE INDEX i_ccntSkBn ON Plum.COOLCountry (StoreKey,BatchNo)
CREATE INDEX i_ccntSk   ON Plum.COOLCountry (StoreKey)
CREATE INDEX i_ccntDn   ON Plum.COOLCountry (DeptNo)
exec sp_indexoption 'Plum.COOLCountry', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.COOLMaster  
(  	
	BatchNo          INTEGER NOT NULL,  
	DeptNo           INTEGER NOT NULL,  
	COOLNo           INTEGER NOT NULL,  
	TextType         INTEGER NOT NULL,  
	StoreKey         INTEGER ,  
	ActionCode       INTEGER ,  
	COOLText         VARCHAR(1024) ,  
	Csize1           INTEGER ,  
	ChangeDate       INTEGER ,  
	ChangeTime       INTEGER ,  
	UserId           VARCHAR(255) ,  
	MergeStatus      INTEGER ,  
	District_Key     INTEGER ,  
	DivisionKey      INTEGER   
 ) 
GO


CREATE INDEX i_CmSkBn ON Plum.COOLMaster (StoreKey,BatchNo)
CREATE INDEX i_CmSk ON Plum.COOLMaster (StoreKey)
CREATE INDEX i_CmDn ON Plum.COOLMaster (DeptNo)
exec sp_indexoption 'Plum.COOLMaster', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.COOLShortList  
(  	
	StoreKey         INTEGER ,  
	BatchNo          INTEGER NOT NULL,  
	DeptNo           INTEGER NOT NULL,  
	COOLSLinkNo      INTEGER NOT NULL,  
	SeqNo            INTEGER NOT NULL,  
	COOLNo           INTEGER NOT NULL,  
	TextType         INTEGER NOT NULL,  
	ActionCode       INTEGER ,  
	ChangeDate       INTEGER ,  
	ChangeTime       INTEGER ,  
	UserId           VARCHAR(255) ,  
	MergeStatus      INTEGER ,  
	District_Key     INTEGER ,  
	DivisionKey      INTEGER   
 ) 
GO


CREATE INDEX i_CslSkBn ON Plum.COOLShortList (StoreKey,BatchNo)
CREATE INDEX i_CslSk ON Plum.COOLShortList (StoreKey)
CREATE INDEX i_CslDn ON Plum.COOLShortList (DeptNo)
exec sp_indexoption 'Plum.COOLShortList', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.Departments  
(  	
	deptno			 INTEGER NOT NULL ,  
	deptname		 VARCHAR(64)  ,  
	desclines		 INTEGER  ,  
	descwidth		 INTEGER  ,  
	ingrlines		 INTEGER  ,  
	ingrwidth		 INTEGER  ,  
	scaledeptno		 INTEGER  ,  
	importtare		 CHAR(1)  ,  
	zoneno			 INTEGER  ,  
	labelctr		 CHAR(1)  ,  
	hostdept		 VARCHAR(7)  ,  
	descfontsize	 INTEGER  ,  
	ingrfontsize	 INTEGER  ,  
	labelformat		 INTEGER  ,  
	fsdisctype		 INTEGER  ,  
	userfld1		 VARCHAR(30)  ,  
	userfld2		 VARCHAR(30)  ,  
	userfld3		 INTEGER  ,  
	userfld4		 INTEGER  ,  
	disclabform		 INTEGER  ,  
	enablekiosk		 CHAR(1)  ,  
	ReferenceCode		 VARCHAR(50)  ,  
	CostConvertFactor 		 FLOAT(24)     
 ) 
GO

ALTER TABLE Plum.Departments ADD CONSTRAINT Pkey_102 PRIMARY KEY (DeptNo) 

GO

CREATE TABLE Plum.FieldCodes  
(  	
	FieldId			 VARCHAR(4) NOT NULL ,  
	UserLanguage	 VARCHAR(10) NOT NULL ,  
	FieldDesc		 VARCHAR(80)  ,  
	ShortDesc		 VARCHAR(32)  ,  
	FieldType		 VARCHAR(4) 	 ,  
	FieldLength		 INTEGER  ,  
	MinVal			 VARCHAR(20)  ,  
	MaxVal			 VARCHAR(20)  ,  
	FormatType		 VARCHAR(20)  ,  
	DefaultVal		 VARCHAR(20)  ,  
	ItemData		 INTEGER  ,  
	BatchData		 INTEGER  ,  
	ConfigData		 INTEGER  ,  
	ScaleCommands	 INTEGER  ,  
	PerRelField	     VARCHAR(3) ,  
	NutriView	     INTEGER  ,  
	UnitOfMeasure	 VARCHAR(30)  ,  
	DailyValue	     INTEGER  ,  
	PerDaily	     INTEGER    
 ) 
GO

ALTER TABLE Plum.FieldCodes ADD CONSTRAINT Pkey_186 PRIMARY KEY (FieldId,UserLanguage) 

GO

CREATE TABLE Plum.IngrMaster  
(  	
	storekey     INTEGER NOT NULL ,  
	batchno      INTEGER NOT NULL ,  
	deptno       INTEGER NOT NULL ,  
	ingrno       INTEGER NOT NULL ,  
	actioncode   INTEGER NOT NULL ,  
	ingrtext     VARCHAR(6000)  ,  
	ingrlinks    VARCHAR(100)  ,  
	isize1       INTEGER CONSTRAINT DF_IngrMaster_isize1       DEFAULT (0)  ,  
	changedate   INTEGER  ,  
	changetime   INTEGER  ,  
	username     VARCHAR(255)  ,  
	modflag      CHAR(1)  ,  
	mergestatus  INTEGER DEFAULT 0 ,  
	IngrType     INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Plum.IngrMaster ADD CONSTRAINT Pkey_114 PRIMARY KEY (storekey,batchno,deptno,ingrno,actioncode,IngrType) 
CREATE INDEX i_ingrmaster ON Plum.IngrMaster (ingrno)
CREATE INDEX i_imBno      ON Plum.IngrMaster (batchno)
CREATE INDEX i_imSkBat ON Plum.IngrMaster (StoreKey,batchno)
CREATE INDEX i_imSkDno ON Plum.IngrMaster (StoreKey,DeptNo)
exec sp_indexoption 'Plum.IngrMaster', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.NutriMaster  
(  	
	storekey		 INTEGER NOT NULL ,  
	batchno			 INTEGER NOT NULL ,  
	deptno			 INTEGER NOT NULL ,  
	nutrino			 INTEGER NOT NULL ,  
	actioncode		 INTEGER NOT NULL ,  
	storeno			 INTEGER  ,  
	zoneno			 INTEGER  ,  
	servepercon		 VARCHAR(64)  ,  
	serveuomdesc	 VARCHAR(64)  ,  
	calories		 INTEGER  ,  
	calfrmfat		 INTEGER  ,  
	totalfat		 INTEGER  ,  
	saturfat		 INTEGER  ,  
	cholesterol		 INTEGER  ,  
	sodium			 INTEGER  ,  
	totalcarb		 INTEGER  ,  
	dietfiber		 INTEGER  ,  
	sugars			 INTEGER  ,  
	protein			 INTEGER  ,  
	vitamina		 INTEGER  ,  
	vitaminb		 INTEGER  ,  
	vitaminc		 INTEGER  ,  
	vitamine		 INTEGER  ,  
	calcium			 INTEGER  ,  
	iron			 INTEGER  ,  
	totalfatper		 INTEGER  ,  
	saturfatper		 INTEGER  ,  
	cholesterolper	 INTEGER  ,  
	sodiumper		 INTEGER  ,  
	totalcarbper	 INTEGER  ,  
	dietfiberper	 INTEGER  ,  
	changedate		 INTEGER  ,  
	changetime		 INTEGER  ,  
	labelform1		 INTEGER  ,  
	potassium		 INTEGER  ,  
	vitamind		 INTEGER  ,  
	vitamink		 INTEGER  ,  
	thiamine		 INTEGER  ,  
	riboflavin		 INTEGER  ,  
	niacin			 INTEGER  ,  
	folicacid		 INTEGER  ,  
	vitaminb6		 INTEGER  ,  
	folate			 INTEGER  ,  
	vitaminb12		 INTEGER  ,  
	biotin			 INTEGER  ,  
	pantothenicacid	 INTEGER  ,  
	phosphorus		 INTEGER  ,  
	iodine			 INTEGER  ,  
	magnesium		 INTEGER  ,  
	zinc			 INTEGER  ,  
	selenium		 INTEGER  ,  
	copper			 INTEGER  ,  
	manganese		 INTEGER  ,  
	chromium		 INTEGER  ,  
	molybdenum		 INTEGER  ,  
	chloride		 INTEGER  ,  
	mergestatus		 INTEGER  ,  
	usernutrititle	 VARCHAR(20)  ,  
	useramount		 INTEGER  ,  
	useruom			 VARCHAR(2)  ,  
	transfat		 INTEGER  ,  
	betacarotene	 INTEGER  ,  
	calsatfat		 INTEGER  ,  
	othercarbs		 INTEGER  ,  
	monounsatfat	 INTEGER  ,  
	polyunsatfat	 INTEGER  ,  
	insolfiber		 INTEGER  ,  
	solfiber		 INTEGER  ,  
	sugaralco		 INTEGER  ,  
	sattranfat		 INTEGER  ,  
	calenergy		 INTEGER  ,  
	energy  		 INTEGER  ,  
	om6fatty		 INTEGER  ,  
	om3fatty		 INTEGER  ,  
	starch  		 INTEGER  ,  
	PotassiumPer	 INTEGER  ,  
	TransFatPer		 INTEGER  ,  
	SatTranFatPer	 INTEGER ,  
	AddedSugars	 INTEGER   ,  
	AddedSugarsPer	 INTEGER  ,  
	calciumper				 INTEGER ,  
	ironper				 INTEGER ,  
	vitamindper				 INTEGER ,  
	vitaminkper				 INTEGER ,  
	energyper  		 INTEGER  ,  
	proteinper			 INTEGER  ,  
	NutriType			 SMALLINT NOT NULL ,  
	sugarsper			 INTEGER  ,  
	Iodide			 INTEGER  ,  
	Choline			 INTEGER  ,  
	IodidePer			 INTEGER  ,  
	CholinePer			 INTEGER  ,  
	folatePer			 INTEGER    
 ) 
GO

ALTER TABLE Plum.NutriMaster ADD CONSTRAINT Pkey_120 PRIMARY KEY (storekey,batchno,deptno,nutrino,actioncode,NutriType) 
CREATE INDEX inutrimaster ON Plum.NutriMaster(nutrino)
CREATE INDEX i_nmBno      ON Plum.NutriMaster(batchno)
CREATE INDEX i_nmSkBat ON Plum.NutriMaster (storekey,batchno)
CREATE INDEX i_nmSkDno ON Plum.NutriMaster (StoreKey,DeptNo)
exec sp_indexoption 'Plum.NutriMaster', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.PLUMaster  
(  	
	storekey         INTEGER NOT NULL ,  
	batchno          INTEGER NOT NULL ,  
	deptno           INTEGER NOT NULL ,  
	pluno            INTEGER NOT NULL ,  
	actioncode       INTEGER NOT NULL ,  
	ingrno           INTEGER  ,  
	nutrino          INTEGER  ,  
	currup           INTEGER  ,  
	saleprice        INTEGER  ,  
	excpup           INTEGER  ,  
	pricemlt         INTEGER  ,  
	prodgrp          INTEGER  ,  
	wtare            INTEGER  ,  
	utare            INTEGER  ,  
	ptare            INTEGER  ,  
	actionno         INTEGER  ,  
	traysize         INTEGER  ,  
	shelflife        INTEGER  ,  
	grade            INTEGER  ,  
	eatby            INTEGER  ,  
	dsize1           INTEGER  ,  
	dsize2           INTEGER  ,  
	dsize3           INTEGER  ,  
	dsize4           INTEGER  ,  
	scaleup          INTEGER  ,  
	fixedwt          INTEGER  ,  
	labelform1       INTEGER  ,  
	labelform2       INTEGER  ,  
	desc1            VARCHAR(64)  ,  
	desc2            VARCHAR(64)  ,  
	desc3            VARCHAR(64)  ,  
	desc4            VARCHAR(64)  ,  
	uom              VARCHAR(2)  ,  
	upc              VARCHAR(13) NOT NULL,  
	forctare         CHAR(1)  ,  
	salestartdate    INTEGER  ,  
	saleenddate      INTEGER  ,  
	salestarttime    INTEGER  ,  
	saleendtime      INTEGER  ,  
	changedate       INTEGER  ,  
	changetime       INTEGER  ,  
	username         VARCHAR(255)  ,  
	modflag          CHAR(1)  ,  
	changetracker    VARCHAR(49)  ,  
	altwtare         INTEGER  ,  
	altutare         INTEGER  ,  
	altdesc1         VARCHAR(64)  ,  
	altdesc2         VARCHAR(64)  ,  
	altdesc3         VARCHAR(64)  ,  
	altdesc4         VARCHAR(64)  ,  
	messageno        INTEGER    ,  
	logono           INTEGER ,  
	fsdprice1        INTEGER  ,  
	fsdpercoff1      INTEGER  ,  
	fsdprice2        INTEGER  ,  
	fsdpercoff2      INTEGER  ,  
	fsdprice3        INTEGER  ,  
	fsdpercoff3      INTEGER  ,  
	fsdlabform1      INTEGER  ,  
	fsdlabform2      INTEGER  ,  
	fsdisctype       INTEGER  ,  
	fsdstatus        CHAR(1)  ,  
	portionwtare     INTEGER  ,  
	portionutare     INTEGER  ,  
	scrollmessno     INTEGER  ,  
	forctare2        CHAR(1)  ,  
	upctype          CHAR(1)  ,  
	subdeptno        INTEGER  ,  
	userfld1         VARCHAR(30)  ,  
	userfld2         VARCHAR(30)  ,  
	userfld3         VARCHAR(30)  ,  
	userfld4         VARCHAR(30)  ,  
	userfld5         INTEGER    ,  
	userfld6         INTEGER  ,  
	userfld7         INTEGER  ,  
	userfld8         INTEGER  ,  
	pricechangetype  CHAR(1)  ,  
	flags            VARCHAR(30) ,  
	mergestatus      INTEGER  ,  
	COOLClassNo      INTEGER ,  
	COOLSLinkNo      INTEGER ,  
	COOLNo           INTEGER ,  
	COOLMRUNo        INTEGER ,  
	COOLTrackNo      VARCHAR(1000) ,  
	COOLForceFlag    VARCHAR(6) ,  
	COOLPreTextNo    INTEGER ,  
	ForceShelfLife   CHAR(1) CONSTRAINT DF_PLUMaster_ForceShelfLife   DEFAULT ('N')  ,  
	ForceUseBy       CHAR(1) CONSTRAINT DF_PLUMaster_ForceUseBy       DEFAULT ('N')  ,  
	ShelfLifeType    INTEGER ,  
	Logono2          INTEGER ,  
	Logono3          INTEGER ,  
	Logono4          INTEGER ,  
	Logono5          INTEGER ,  
	GraphicNo1       INTEGER ,  
	GraphicNo2       INTEGER ,  
	GraphicNo3       INTEGER ,  
	GraphicNo4       INTEGER ,  
	GraphicNo5       INTEGER ,  
	FSDMulti         INTEGER ,  
	FSDExcp          INTEGER    ,  
	Origin           INTEGER    ,  
	Recipes1         INTEGER    ,  
	Recipes2         INTEGER    ,  
	Recipes3         INTEGER    ,  
	Recipes4         INTEGER    ,  
	Recipes5         INTEGER    ,  
	Cooking1         INTEGER    ,  
	Cooking2         INTEGER    ,  
	Cooking3         INTEGER    ,  
	Cooking4         INTEGER    ,  
	Cooking5         INTEGER    ,  
	NutriRating      INTEGER CONSTRAINT DF_PLUMaster_NutriRating      DEFAULT (0)  ,  
	Portion          INTEGER ,  
	StorageRefNo     INTEGER ,  
	AlternateUPCs    VARCHAR(8000) ,  
	AllergenTextNo   INTEGER ,  
	RestrictToScale  INTEGER ,  
	UserDefinedText1No	 INTEGER ,  
	UserDefinedText2No	 INTEGER ,  
	ProductCode				 INTEGER ,  
	ScaleRotation1	 INTEGER ,  
	ScaleRotation2   INTEGER ,  
	BcFormat 				 INTEGER ,  
	PrintPackageDate 				 CHAR(1) ,  
	PrintPackageTime 				 CHAR(1) ,  
	nutrino2          INTEGER  ,  
	ProductURL 				 VARCHAR(255)   
 ) 
GO

 
CREATE INDEX iprdgrp         ON Plum.PLUMaster (deptno,prodgrp)
CREATE INDEX i_pmBno         ON Plum.PLUMaster (batchno)
CREATE UNIQUE CLUSTERED INDEX i_PM_SBUAO ON Plum.PLUMaster (storekey,batchno,upc,actioncode,Origin)
CREATE INDEX i_pmOrgUpc ON Plum.PLUMaster (Origin,upc)
CREATE INDEX i_pmStrBat ON Plum.PLUMaster (storekey,batchno)
CREATE INDEX i_pmDno    ON Plum.PLUMaster (DeptNo)
CREATE INDEX i_pmStrKey ON Plum.PLUMaster (StoreKey)
CREATE INDEX i_pmCnSk   ON Plum.PLUMaster (COOLClassNo, StoreKey)
CREATE INDEX i_pmUserfld1  ON Plum.PLUMaster (Userfld1)
exec sp_indexoption 'Plum.PLUMaster', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.PLUPriceHistory  
(  	
	SequenceNo		 INTEGER  ,  
	RegionNo		 INTEGER  ,  
	ZoneNo			 INTEGER  ,  
	StoreNo			 INTEGER  ,  
	DeptNo			 INTEGER  ,  
	PluNo			 INTEGER  ,  
	AppliedDate		 VARCHAR(25)  ,  
	AppliedTime		 VARCHAR(10)  ,  
	Currup			 INTEGER  ,  
	PriceChangeType	 CHAR(1)    
 ) 
GO

CREATE TABLE Plum.ParmTable  
(  	
	parmkey				 VARCHAR(20) NOT NULL ,  
	uom					 VARCHAR(2)  ,  
	plunounique			 CHAR(1)  ,  
	prcchkdigit			 CHAR(1)  ,  
	csl					 CHAR(1)  ,  
	defprintq			 VARCHAR(16)  ,  
	importfile			 VARCHAR(100)  ,  
	importpath			 VARCHAR(255)  ,  
	importtype			 VARCHAR(30)  ,  
	fielddelim			 INTEGER  ,  
	recorddelim			 INTEGER  ,  
	automerge			 CHAR(1)  ,  
	batchclose			 CHAR(1)  ,  
	actlogflag			 CHAR(1)  ,  
	plufield			 CHAR(1)  ,  
	pluspos				 INTEGER  ,  
	pludigits			 INTEGER  ,  
	useeffdate			 CHAR(1)  ,  
	useefftime			 CHAR(1)  ,  
	editbybat			 INTEGER  ,  
	usealttare			 CHAR(1)  ,  
	usealtdesc			 CHAR(1)  ,  
	exportfile			 VARCHAR(100)  ,  
	exportpath			 VARCHAR(255)  ,  
	prefillupc			 CHAR(1)  ,  
	enforceregions		 CHAR(1)  ,  
	regionno			 INTEGER  ,  
	regionname			 VARCHAR(50)  ,  
	exporttype			 VARCHAR(30)  ,  
	multibatchapp		 CHAR(1)  ,  
	pricedisable		 CHAR(1)  ,  
	batchnotify			 CHAR(1)  ,  
	sendpending			 CHAR(1)  ,  
	pwdexpiry			 INTEGER  ,  
	udf					 VARCHAR(200)  ,  
	importvalidation	 CHAR(1)  ,  
	plumdb_version		 VARCHAR(50)  ,  
	flags				 VARCHAR(30)  ,  
	DelPLUFrmPendBat	 CHAR(1)    
 ) 
GO

ALTER TABLE Plum.ParmTable ADD CONSTRAINT Pkey_122 PRIMARY KEY (ParmKey) 

GO


CREATE TABLE Plum.ProductGroups  
(  	
	deptno		 INTEGER NOT NULL ,  
	prodgrp		 INTEGER NOT NULL ,  
	sprodgrp	 INTEGER  ,  
	desc1		 VARCHAR(128)  ,  
	storekey	 INTEGER  ,  
	batchno		 INTEGER NOT NULL ,  
	MergeStatus	 INTEGER    
 ) 
GO

ALTER TABLE Plum.ProductGroups ADD CONSTRAINT Pkey_134 PRIMARY KEY (batchno,deptno,prodgrp) 
CREATE INDEX iprodgrp ON Plum.ProductGroups(deptno,prodgrp)
CREATE INDEX i_pgDno ON Plum.ProductGroups (deptno)
exec sp_indexoption 'Plum.ProductGroups', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.ScaleSubJobs  
(  	
	SubJobName		 VARCHAR(50) NOT NULL ,  
	BatchNo			 INTEGER  ,  
	StoreKey		 INTEGER NOT NULL ,  
	Status			 INTEGER NOT NULL ,  
	DeptNo			 INTEGER  ,  
	ScaleAddr		 INTEGER ,  
	EffDate			 INTEGER NOT NULL ,  
	EffTime			 INTEGER NOT NULL ,  
	ScaleKey		 INTEGER ,  
	ResBatchNo		 INTEGER   
 ) 
GO

CREATE UNIQUE INDEX i_SSJ_SJN ON Plum.ScaleSubJobs (SubJobName)
CREATE INDEX i_ssjSkBat ON Plum.ScaleSubJobs (StoreKey,BatchNo)
CREATE INDEX i_ssjSkDno ON Plum.ScaleSubJobs (StoreKey,DeptNo)
exec sp_indexoption 'Plum.ScaleSubJobs', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.StoreDepartments  
(  	
	StoreKey         INTEGER NOT NULL ,  
	deptno           INTEGER NOT NULL ,  
	desclines        INTEGER  ,  
	descwidth        INTEGER  ,  
	ingrlines        INTEGER  ,  
	ingrwidth        INTEGER  ,  
	scaledeptno      INTEGER  ,  
	importtare       CHAR(1)  ,  
	zoneno           INTEGER  ,  
	labelctr         CHAR(1)  ,  
	hostdept         VARCHAR(7)  ,  
	descfontsize     INTEGER  ,  
	ingrfontsize     INTEGER  ,  
	labelformat      INTEGER  ,  
	fsdisctype       INTEGER  ,  
	userfld1         VARCHAR(30)  ,  
	userfld2         VARCHAR(30)  ,  
	userfld3         INTEGER  ,  
	userfld4         INTEGER  ,  
	disclabform      INTEGER  ,  
	enablekiosk      CHAR(1)    
 ) 
GO

ALTER TABLE Plum.StoreDepartments ADD CONSTRAINT Pkey_143 PRIMARY KEY (StoreKey,DeptNo) 
CREATE INDEX i_StrDepSK ON Plum.StoreDepartments (StoreKey)
CREATE INDEX i_StrDepDN ON Plum.StoreDepartments (DeptNo)

GO

CREATE TABLE Plum.Stores  
(  	
	store_key        INT IDENTITY NOT NULL ,   
	storeno          INTEGER NOT NULL ,  
	storename        VARCHAR(64)  ,  
	storeaddr        VARCHAR(64)  ,  
	storecity        VARCHAR(40)  ,  
	storeprov        VARCHAR(20)  ,  
	storepost        VARCHAR(16)  ,  
	storecont        VARCHAR(64)  ,  
	voicephone       VARCHAR(22)  ,  
	modemphone       VARCHAR(22)  ,  
	zoneno           INTEGER  ,  
	regionno         INTEGER  ,  
	readytransmit    CHAR(1)  ,  
	lockflag         INTEGER    ,  
	lockdate         INTEGER    ,  
	locktime         INTEGER    ,  
	autoreportsflag  INTEGER    ,  
	UnitOfMeasure    VARCHAR(2)  ,  
	Email            VARCHAR(255) ,  
	CouponSupport    INTEGER CONSTRAINT DF_Stores_CouponSupport    DEFAULT (0)  ,  
	WaitingForLock   INTEGER    ,  
	PlumLite         INTEGER ,  
	TimezoneKey      INTEGER ,  
	PreferredLanguage  		 VARCHAR(2)   
 ) 
GO

ALTER TABLE Plum.Stores ADD CONSTRAINT Pkey_139 PRIMARY KEY (store_key) 
CREATE UNIQUE INDEX i_StSno ON Plum.Stores (storeno)
exec sp_indexoption 'Plum.Stores', 'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.SystemKeys  
(  	
	tableid			 INTEGER NOT NULL ,  
	description		 VARCHAR(30)  ,  
	lastsystemkey	 INTEGER    
 ) 
GO

ALTER TABLE Plum.SystemKeys ADD CONSTRAINT Pkey_145 PRIMARY KEY (TableId) 

GO

CREATE TABLE Plum.TextTemplates  
(  	
	syskey			 INT IDENTITY NOT NULL ,   
	shortdesc		 VARCHAR(50)  ,  
	texttemplate VARCHAR(2000)    
 ) 
GO

ALTER TABLE Plum.TextTemplates ADD CONSTRAINT Pkey_179 PRIMARY KEY (SysKey) 

GO

CREATE TABLE Plum.TransactionDetail  
(  	
	storeno          INTEGER ,  
	transkey			   INTEGER NOT NULL ,  
	detailsequence   INT IDENTITY NOT NULL  ,   
	errorcode        INTEGER  ,  
	errorlevel       VARCHAR(3)  ,  
	jobno            INTEGER  ,  
	subjobno         INTEGER  ,  
	deptno           INTEGER  ,  
	scaleaddr        INTEGER  ,  
	errordesc        VARCHAR(1000)  ,  
	command          VARCHAR(128)  ,  
	batchno          INTEGER  ,  
	storekey         INTEGER NOT NULL ,  
	pluingrno        INTEGER  ,  
	scalekey         INTEGER ,  
	MQTransID        INTEGER ,  
	TriggerTransId   INTEGER ,  
	LastDate         INTEGER ,  
	LastTime         INTEGER ,  
	Occurrence       INTEGER ,  
	Memo             VARCHAR(2000)   
 ) 
GO

ALTER TABLE Plum.TransactionDetail ADD CONSTRAINT Pkey_148 PRIMARY KEY (transkey,detailsequence,storekey) 
CREATE INDEX i_trdStrKey ON Plum.TransactionDetail (storekey)
CREATE INDEX i_trdTkSk ON Plum.TransactionDetail (transkey,storekey)
CREATE INDEX i_trdSkBnoTrtd ON Plum.TransactionDetail (StoreKey,Batchno,TriggerTransId)
exec sp_indexoption 'Plum.TransactionDetail', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.Transactions  
(  	
	transdate			 INTEGER  ,  
	transtime			 INTEGER  ,  
	sequence			 INT IDENTITY NOT NULL  ,   
	type				 INTEGER  ,  
	description			 VARCHAR(500)  ,  
	storeno				 INTEGER  ,  
	item				 INTEGER  ,  
	resultcode			 INTEGER  ,  
	batchno				 INTEGER  ,  
	batcheffectivedate	 INTEGER  ,  
	batcheffectivetime	 INTEGER  ,  
	batchtype			 INTEGER  ,  
	usrname				 VARCHAR(50)  ,  
	maintenanceperiod	 INTEGER CONSTRAINT DF_Transactions_maintenanceperiod	 DEFAULT (0) NOT NULL,  
	storekey			 INTEGER NOT NULL ,  
	loginname			 VARCHAR(50)    
 ) 
GO

ALTER TABLE Plum.Transactions ADD CONSTRAINT Pkey_147 PRIMARY KEY (sequence,storekey) 
CREATE INDEX iTrn_TDT ON Plum.Transactions (transdate,transtime)
CREATE INDEX iTrn_SBTTTM ON Plum.Transactions (storekey, batchno, transdate,transtime, Type, maintenanceperiod )
 
exec sp_indexoption 'Plum.Transactions', N'disallowpagelocks', TRUE

GO

CREATE TABLE Plum.VariousNumbers  
(  	
	nextbatchno			 INTEGER  ,  
	torebuild			 CHAR(1)  ,  
	sendall				 CHAR(1)  ,  
	currentdeptno		 INTEGER  ,  
	startplu			 INTEGER  ,  
	endplu				 INTEGER  ,  
	readtype			 INTEGER  ,  
	ingrsend			 CHAR(1)  ,  
	newflag				 CHAR(1)  ,  
	salesuccessdate		 VARCHAR(10)  ,  
	printno				 INTEGER  ,  
	startdept			 INTEGER  ,  
	enddept				 INTEGER  ,  
	startdate			 VARCHAR(10)  ,  
	enddate				 VARCHAR(10)  ,  
	starttime			 INTEGER  ,  
	endtime				 INTEGER  ,  
	toprint				 CHAR(1)  ,  
	lasthostsequence	 INTEGER  ,  
	minbatchno			 INTEGER  ,  
	maxbatchno			 INTEGER  ,  
	internaldate3		 INTEGER  ,  
	internaldate2		 INTEGER  ,  
	usernum1			 INTEGER  ,  
	internaldate1		 INTEGER  ,  
	internalnum8		 INTEGER  ,  
	internalnum7		 INTEGER  ,  
	internalnum6		 INTEGER  ,  
	internalnum5		 INTEGER  ,  
	internalnum4		 INTEGER  ,  
	internalnum3		 INTEGER  ,  
	internalnum2		 INTEGER  ,  
	internalnum1		 INTEGER  ,  
	maintenanceperiod	 INTEGER  ,  
	usernum4			 INTEGER  ,  
	usernum3			 INTEGER  ,  
	usernum2			 INTEGER  ,  
	lastpricehistseq	 INTEGER    
 ) 
GO


-- Creating foreign key constraints 


-- Creating Tables and constraints 

CREATE TABLE Periscope.Ar_Sessions  
(  	
	Session_Key   BIGINT NOT NULL,  
	User_Key      INTEGER NOT NULL,  
	Login_Time    INTEGER NOT NULL,  
	Activity_Time INTEGER NOT NULL,  
	Memo          VARCHAR(130) ,  
	Profile       VARCHAR(255) ,  
	Logout        INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Ar_Sessions ADD CONSTRAINT Pkey_326 PRIMARY KEY (Session_Key) 
CREATE INDEX I_ASN_LT  ON Periscope.Ar_Sessions (Login_Time)
CREATE  INDEX i_ASN_UK  ON Periscope.Ar_Sessions (User_Key)
exec sp_indexoption 'Periscope.Ar_Sessions.I_ASN_LT', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Ar_Sessions.i_ASN_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ComponentConfigurations  
(  	
	ComponentKey  INTEGER NOT NULL,  
	ConfigName VARCHAR(128) NOT NULL,  
	ConfigValue VARCHAR(1000)   
 ) 
GO

ALTER TABLE Periscope.ComponentConfigurations ADD CONSTRAINT Pkey_678 PRIMARY KEY (ComponentKey, ConfigName) 

GO

CREATE TABLE Periscope.Components  
(  	
	ComponentKey  INT IDENTITY NOT NULL ,   
	ComponentName VARCHAR(50) COLLATE Latin1_General_CS_AI NOT NULL,  
	ComponentMemo VARCHAR(4000) ,  
	ComponentType CHAR(1)   
 ) 
GO

ALTER TABLE Periscope.Components ADD CONSTRAINT Pkey_319 PRIMARY KEY (ComponentKey) 
CREATE UNIQUE INDEX i_APP_AN ON Periscope.Components (ComponentName)

GO

CREATE TABLE Periscope.Dictionary  
(  	
	English   VARCHAR(800) COLLATE Latin1_General_CS_AI NOT NULL,  
	French    VARCHAR(800) COLLATE Latin1_General_CS_AI ,  
	Spanish   VARCHAR(800) COLLATE Latin1_General_CS_AI   
 ) 
GO

ALTER TABLE Periscope.Dictionary ADD CONSTRAINT Pkey_352 PRIMARY KEY (English) 

GO

CREATE TABLE Periscope.Districts  
(  	
	 District_Key  INT IDENTITY NOT NULL ,   
	 DivisionKey   INTEGER ,  
	 District_No   INTEGER NOT NULL,  
	 Description   VARCHAR(100)   
 ) 
GO

ALTER TABLE Periscope.Districts ADD CONSTRAINT Pkey_330 PRIMARY KEY (District_Key) 
CREATE UNIQUE INDEX i_DST_NO  ON Periscope.Districts (District_No )
CREATE INDEX i_DIST_DK  ON Periscope.Districts (DivisionKey )
exec sp_indexoption 'Periscope.Districts.i_DST_NO',  'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Districts.i_DIST_DK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Divisions  
(  	
	DivisionKey  INT IDENTITY NOT NULL ,   
	DivisionNo   INTEGER NOT NULL,  
	Description  VARCHAR(100) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Divisions ADD CONSTRAINT Pkey_336 PRIMARY KEY (DivisionKey) 
CREATE UNIQUE INDEX i_DIVI_DNO ON Periscope.Divisions (DivisionNo )
exec sp_indexoption 'Periscope.Divisions.i_DIVI_DNO', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.HostStatus  
(  	
	StatusKey  		 INT IDENTITY NOT NULL ,   
	HostKey  			 INTEGER NOT NULL,  
	Status					 SMALLINT ,  
	ChkDate 				 INTEGER ,  
	ChkTime     		 INTEGER ,  
	ChangeDate 		 INTEGER ,  
	ChangeTime 		 INTEGER   
 ) 
GO

ALTER TABLE Periscope.HostStatus ADD CONSTRAINT Pkey_683 PRIMARY KEY NONCLUSTERED (StatusKey) 
CREATE CLUSTERED INDEX i_HS_HK  ON Periscope.HostStatus (HostKey)
exec sp_indexoption 'Periscope.HostStatus', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Hosts  
(  	
	HostKey   INT IDENTITY NOT NULL ,   
	IpAddress VARCHAR(64) NOT NULL,  
	StoreKey  INTEGER NOT NULL,  
	Port      VARCHAR(10) ,  
	HostType  CHAR(1)   
 ) 
GO

ALTER TABLE Periscope.Hosts ADD CONSTRAINT Pkey_318 PRIMARY KEY (HostKey) 
CREATE INDEX i_HST_IP ON Periscope.Hosts (IpAddress )
CREATE UNIQUE INDEX i_HST_IP_SK_PRT ON Periscope.Hosts (IpAddress,StoreKey,Port,HostType )
exec sp_indexoption 'Periscope.Hosts.i_HST_IP_SK_PRT', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Hosts.i_HST_IP', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.JobList  
(  	
	JobType			 INTEGER NOT NULL ,  
	Description	 VARCHAR(256)  ,  
	FileName			 VARCHAR(512)  ,  
	Memo					 VARCHAR(2000) ,  
	Flag					 INTEGER    
 ) 
GO

ALTER TABLE Periscope.JobList ADD CONSTRAINT Pkey_684 PRIMARY KEY (JobType) 

GO

CREATE TABLE Periscope.MessageLogRules  
(  	
	MessageRuleKey   		 BIGINT IDENTITY NOT NULL ,   
	MessageKey     BIGINT ,  
	DivisionKey      INTEGER ,  
	District_Key     	 INTEGER ,  
	Store_Key       INTEGER ,  
	DeptNo   		 INTEGER ,  
	User_Key    		 INTEGER ,  
	ReadMark    		   SMALLINT CONSTRAINT DF_MessageLogRules_ReadMark    		   DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.MessageLogRules ADD CONSTRAINT Pkey_703 PRIMARY KEY (MessageRuleKey) 

GO

CREATE TABLE Periscope.MessageLogs  
(  	
	MessageKey   		 BIGINT IDENTITY NOT NULL ,   
	MessageSubject     VARCHAR(256) ,  
	MessageDetail      VARCHAR(4000) ,  
	Create_Date     	 INTEGER ,  
	Create_Time       INTEGER ,  
	ExpiryDate   		 INTEGER ,  
	ExpiryTime    		 INTEGER ,  
	User_ID    		   VARCHAR(255) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.MessageLogs ADD CONSTRAINT Pkey_702 PRIMARY KEY  (MessageKey) 

GO

CREATE TABLE Periscope.NotificationLogs  
(  	
	NotificationKey    INT IDENTITY NOT NULL ,   
	NotificationDate   INTEGER ,  
	NotificationTime   INTEGER ,  
	SeverityLevel      SMALLINT ,  
	Source             VARCHAR(50) ,  
	DestinationType    VARCHAR(50) ,  
	DestinationAddress VARCHAR(50) ,  
	MessageSubject     VARCHAR(256) ,  
	MessageDetail      VARCHAR(4000) ,  
	DeliveryStatus     VARCHAR(1000) ,  
	ReadMark           SMALLINT ,  
	ExpiryDate    INTEGER ,  
	ExpiryTime     INTEGER   
 ) 
GO

ALTER TABLE Periscope.NotificationLogs ADD CONSTRAINT Pkey_320 PRIMARY KEY NONCLUSTERED (NotificationKey) 
CREATE INDEX i_NLog_Adr_NDt ON Periscope.NotificationLogs (DestinationAddress,NotificationDate)
CREATE CLUSTERED INDEX i_NL_SDDMDT ON Periscope.NotificationLogs (Source,DestinationType,DestinationAddress,MessageSubject)

GO

CREATE TABLE Periscope.NotifyClasses  
(  	
	NotifyClassKey INT IDENTITY NOT NULL ,   
	Description    VARCHAR(50) COLLATE Latin1_General_CS_AI NOT NULL	,  
	Memo				    VARCHAR(512) 	  
 ) 
GO

ALTER TABLE Periscope.NotifyClasses ADD CONSTRAINT Pkey_322 PRIMARY KEY (NotifyClassKey) 
CREATE UNIQUE INDEX i_NFC_DE ON Periscope.NotifyClasses (Description )
exec sp_indexoption 'Periscope.NotifyClasses.i_NFC_DE', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.NotifyRoutings  
(  	
	NotifyRoutingKey INT IDENTITY NOT NULL ,   
	StoreKey         INTEGER NOT NULL,  
	NotifyClassKey   INTEGER ,  
	SeverityLevel    SMALLINT NOT NULL,  
	DeviceSequence   INTEGER NOT NULL,  
	DeviceType       VARCHAR(50) NOT NULL,  
	DeviceAddress    VARCHAR(50) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.NotifyRoutings ADD CONSTRAINT Pkey_351 PRIMARY KEY (NotifyRoutingKey) 
CREATE INDEX i_NRO_ST_SL_NC_DS ON Periscope.NotifyRoutings (StoreKey, SeverityLevel, NotifyClassKey, DeviceSequence )
CREATE INDEX i_NOTR_NCK ON Periscope.NotifyRoutings (NotifyClassKey)
exec sp_indexoption 'Periscope.NotifyRoutings.i_NRO_ST_SL_NC_DS', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.NotifyRoutings.i_NOTR_NCK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.PageGridFilters  
(  	
	User_Key				 INTEGER NOT NULL,  
	PageFileName 	 VARCHAR(100) NOT NULL,  
	PageGridName 	 VARCHAR(100) NOT NULL ,  
	GridFilter		 	 VARCHAR(2000) NOT NULL   
 ) 
GO

ALTER TABLE Periscope.PageGridFilters ADD CONSTRAINT Pkey_687 PRIMARY KEY (User_Key,PageFileName,PageGridName) 

GO

CREATE TABLE Periscope.PeriStores  
(  	
	Store_Key     INTEGER NOT NULL,  
	StoreNo       INTEGER NOT NULL,  
	District_Key  INTEGER ,  
	Active        INTEGER NOT NULL,  
	PilferageFlag INTEGER NOT NULL,  
	NoOfGrinders  INTEGER   
 ) 
GO

ALTER TABLE Periscope.PeriStores ADD CONSTRAINT Pkey_353 PRIMARY KEY (Store_Key) 
CREATE INDEX i_PST_DK ON Periscope.PeriStores (District_Key)
exec sp_indexoption 'Periscope.PeriStores.i_PST_DK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ReasonDetails  
(  	
	ReasonDetailKey            INT IDENTITY NOT NULL ,   
	ReasonTypeID   INTEGER NOT NULL,  
	Description      VARCHAR(128) NOT NULL,  
	ChangeFlag			  SMALLINT CONSTRAINT DF_ReasonDetails_ChangeFlag			  DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ReasonDetails ADD CONSTRAINT Pkey_657 PRIMARY KEY (ReasonDetailKey) 
CREATE UNIQUE INDEX i_RD_TDesc ON Periscope.ReasonDetails (ReasonTypeID,Description)

GO

CREATE TABLE Periscope.ReasonTypes  
(  	
	ReasonTypeID   INTEGER NOT NULL,  
	ReasonType      VARCHAR(128) NOT NULL,  
	IsEnabled			 SMALLINT CONSTRAINT DF_ReasonTypes_IsEnabled			 DEFAULT (0) NOT NULL,  
	DefaultReasonKey		 INTEGER   
 ) 
GO

ALTER TABLE Periscope.ReasonTypes ADD CONSTRAINT Pkey_656 PRIMARY KEY (ReasonTypeID) 
CREATE UNIQUE INDEX i_RT_Desc ON Periscope.ReasonTypes (ReasonType)

GO

CREATE TABLE Periscope.ReportDefinitions  
(  	
	SysKey				 	 INT IDENTITY NOT NULL ,   
	Name						 VARCHAR(4) NOT NULL,  
	Title           VARCHAR(64) NOT NULL,  
	BaseFileName    VARCHAR(64) NOT NULL,  
	Description     VARCHAR(256) NOT NULL ,  
	Comments	    	 VARCHAR(256) ,  
	Type						 INTEGER NOT NULL  ,  
	Sequence		     INTEGER NOT NULL  ,  
	Depth					 INTEGER CONSTRAINT DF_ReportDefinitions_Depth					 DEFAULT (0) NOT NULL,  
	Scope 					 INTEGER CONSTRAINT DF_ReportDefinitions_Scope 					 DEFAULT (0) NOT NULL,  
	SSCFlag       	 SMALLINT ,  
	Param 					 VARCHAR(256) ,  
	ChangeFlag			 SMALLINT CONSTRAINT DF_ReportDefinitions_ChangeFlag			 DEFAULT (1) NOT NULL,  
	MessageType		 VARCHAR(4) ,  
	UserTokenID						 INTEGER   
 ) 
GO

ALTER TABLE Periscope.ReportDefinitions ADD CONSTRAINT Pkey_507 PRIMARY KEY (SysKey) 
CREATE UNIQUE INDEX i_REPDEFN_SEQ ON Periscope.ReportDefinitions (Sequence)

GO

CREATE TABLE Periscope.ReportProfiles  
(  	
	Report_Key  	  INT IDENTITY NOT NULL ,   
	Description 	  VARCHAR(100) NOT NULL,  
	Type        	  VARCHAR(4) NOT NULL,  
	Message_Data	  VARCHAR(4000) NOT NULL,  
	Begin_Time  	  INTEGER ,  
	User_Key    	  INTEGER NOT NULL,  
	Exclude     	  VARCHAR(50) ,  
	SystemWide  	  SMALLINT NOT NULL,  
	DeptNo      	  INTEGER ,  
	SendCopyOrig	  SMALLINT ,  
	LeadTime    	  INTEGER ,  
	GroupByFields1  VARCHAR(4000) ,  
	GroupByFields2  VARCHAR(4000) ,  
	CriteriaFields  VARCHAR(4000) ,  
	OtherFields     VARCHAR(4000) ,  
	ReportDefnKey   INTEGER ,  
	Source          SMALLINT CONSTRAINT DF_ReportProfiles_Source          DEFAULT (0)  ,  
	OtherFields2    VARCHAR(4000) ,  
	CriteriaFields2 VARCHAR(4000)   
 ) 
GO

ALTER TABLE Periscope.ReportProfiles ADD CONSTRAINT Pkey_282 PRIMARY KEY (Report_Key) 
CREATE INDEX i_REPP_SW_UK ON Periscope.ReportProfiles (SystemWide,User_Key )
CREATE INDEX i_REPP_UK ON Periscope.ReportProfiles (User_Key)
exec sp_indexoption 'Periscope.ReportProfiles.i_REPP_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Report_Log  
(  	
	Store_Key INTEGER ,  
	User_Key  INTEGER ,  
	DeptNo    INTEGER ,  
	Post_Date INTEGER NOT NULL,  
	Post_Time INTEGER NOT NULL,  
	Type      VARCHAR(4) NOT NULL,  
	Request   VARCHAR(4000) NOT NULL  
 ) 
GO

CREATE INDEX i_RTL_PD_UK_SK  ON Periscope.Report_Log (Post_Date, Store_Key, User_Key)
CREATE INDEX i_REPL_UK ON Periscope.Report_Log (User_Key)
exec sp_indexoption 'Periscope.Report_Log.i_REPL_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ScheduledJobScopes  
(  	
	ScheduledJobScopeKey			 INT IDENTITY NOT NULL  ,   
	ScheduledJobKey								 INTEGER NOT NULL,  
	DivisionKey			 INTEGER ,  
	District_Key					 INTEGER ,  
	StoreKey					 INTEGER    
 ) 
GO

ALTER TABLE Periscope.ScheduledJobScopes ADD CONSTRAINT Pkey_685 PRIMARY KEY (ScheduledJobScopeKey) 

GO

CREATE TABLE Periscope.ScheduledJobs  
(  	
	ScheduledJobKey			 INT IDENTITY NOT NULL  ,   
	Name								 VARCHAR(512) NOT NULL,  
	JobType			 INTEGER NOT NULL,  
	IPAddress			 VARCHAR(512) ,  
	Port			 VARCHAR(256) ,  
	FileName					 VARCHAR(512) ,  
	Param					 VARCHAR(256)  ,  
	Status			 INTEGER  ,  
	ScheduleType			 INTEGER  ,  
	ScheduledAt			 INTEGER  ,  
	ScheduledEvery			 VARCHAR(256)  ,  
	Interval			 INTEGER  ,  
	Begin_Time			 INTEGER  ,  
	End_Time			 INTEGER  ,  
	NextRunDate			 INTEGER  ,  
	NextRunTime			 INTEGER  ,  
	LastRunDate			 INTEGER  ,  
	LastRunTime			 INTEGER  ,  
	LastRunResult			 INTEGER    
 ) 
GO

ALTER TABLE Periscope.ScheduledJobs ADD CONSTRAINT Pkey_686 PRIMARY KEY (ScheduledJobKey) 

GO

CREATE TABLE Periscope.Sessions  
(  	
	Session_Key   BIGINT IDENTITY NOT NULL ,   
	User_Key      INTEGER NOT NULL,  
	Login_Time    INTEGER NOT NULL,  
	Activity_Time INTEGER NOT NULL,  
	Memo          VARCHAR(130) ,  
	Profile       VARCHAR(255) ,  
	Logout        INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Sessions ADD CONSTRAINT Pkey_301 PRIMARY KEY (Session_Key) 
CREATE  INDEX I_SN_LT  ON Periscope.Sessions (Login_Time)
CREATE  INDEX i_SES_UK  ON Periscope.Sessions (User_Key)
exec sp_indexoption 'Periscope.Sessions.i_SES_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.StoreComponents  
(  	
	ComponentKey INTEGER NOT NULL,  
	HostKey      INTEGER NOT NULL,  
	Instance     INTEGER ,  
	Frequent     INTEGER ,  
	Param        VARCHAR(256)   
 ) 
GO

CREATE UNIQUE INDEX i_STC_CK_HK_IN ON Periscope.StoreComponents (ComponentKey, HostKey, Instance )
CREATE  INDEX i_STC_HK ON Periscope.StoreComponents (HostKey)
exec sp_indexoption 'Periscope.StoreComponents.i_STC_HK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.StoreGroupStores  
(  	
	StoreGroupKey INTEGER NOT NULL,  
	StoreKey      INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.StoreGroupStores ADD CONSTRAINT Pkey_235 PRIMARY KEY (StoreGroupKey,StoreKey) 

GO

CREATE TABLE Periscope.StoreGroups  
(  	
	StoreGroupKey INT IDENTITY NOT NULL ,   
	Description   VARCHAR(64) COLLATE Latin1_General_CS_AI NOT NULL  
 ) 
GO

ALTER TABLE Periscope.StoreGroups ADD CONSTRAINT Pkey_234 PRIMARY KEY (StoreGroupKey) 
CREATE UNIQUE INDEX i_SG_DES ON Periscope.StoreGroups (Description)
exec sp_indexoption 'Periscope.StoreGroups.i_SG_DES', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.SysTable  
(  	
	SysKey			 VARCHAR(128) NOT NULL,  
	Value 			 VARCHAR(4000)   
 ) 
GO

ALTER TABLE Periscope.SysTable ADD CONSTRAINT Pkey_299 PRIMARY KEY (SysKey) 

GO

CREATE TABLE Periscope.TablePurgeSettings  
(  	
	TableId				 VARCHAR(64) NOT NULL ,  
	CutOffDate			 INTEGER  ,  
	ArCutOffDate		 INTEGER  ,  
	PurgeInterval	 INTEGER NOT NULL ,  
	IntervalType		 INTEGER NOT NULL ,  
	DaysToKeepSetting	 VARCHAR(128) NOT NULL   
 ) 
GO

ALTER TABLE Periscope.TablePurgeSettings ADD CONSTRAINT Pkey_653 PRIMARY KEY (TableId) 

GO

CREATE TABLE Periscope.TimezoneDefinitions  
(  	
	TimezoneKey   INT IDENTITY NOT NULL ,   
	ID     			 VARCHAR(256) NOT NULL,  
	UtcOffset   	 INTEGER NOT NULL,  
	DstOffset		 INTEGER NOT NULL,  
	Name          VARCHAR(256) ,  
	StartMonth    INTEGER ,  
	StartWeek     INTEGER ,  
	StartTime     INTEGER ,  
	EndMonth      INTEGER ,  
	EndWeek       INTEGER ,  
	EndTime       INTEGER   
 ) 
GO

ALTER TABLE Periscope.TimezoneDefinitions ADD CONSTRAINT Pkey_520 PRIMARY KEY (TimezoneKey) 

GO

CREATE TABLE Periscope.UserDepartments  
(  	
	User_Key  INTEGER NOT NULL,  
	DeptNo	 INTEGER NOT NULL  
 ) 
GO

CREATE INDEX i_USD_UK  ON Periscope.UserDepartments (User_Key)
exec sp_indexoption 'Periscope.UserDepartments.i_USD_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.UserGroupDetail  
(  	
	GroupKey INTEGER NOT NULL,  
	User_Key INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.UserGroupDetail ADD CONSTRAINT Pkey_357 PRIMARY KEY (GroupKey,User_Key) 

GO

CREATE TABLE Periscope.UserRoleProfileDetails  
(  	
	UserRoleProfileKey     INTEGER NOT NULL,  
	UserTokenID        		 INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.UserRoleProfileDetails ADD CONSTRAINT Pkey_616 PRIMARY KEY (UserRoleProfileKey,UserTokenID) 

GO

CREATE TABLE Periscope.UserRoleProfiles  
(  	
	UserRoleProfileKey		 INTEGER  NOT NULL,  
	Description         	 VARCHAR(1024) ,  
	ChangeFlag          	 SMALLINT CONSTRAINT DF_UserRoleProfiles_ChangeFlag          	 DEFAULT (0)    
 ) 
GO

ALTER TABLE Periscope.UserRoleProfiles ADD CONSTRAINT Pkey_617 PRIMARY KEY (UserRoleProfileKey) 
CREATE UNIQUE INDEX i_URP_DES ON Periscope.UserRoleProfiles (Description)

GO

CREATE TABLE Periscope.UserRoleTokens  
(  	
	UserTokenID	 INTEGER NOT NULL ,  
	Name				 VARCHAR(255) ,  
	Description	 VARCHAR(255)  ,  
	Flag				 INTEGER  ,  
	ParentID		 INTEGER ,  
	ProductType		 SMALLINT NOT NULL  
 ) 
GO

ALTER TABLE Periscope.UserRoleTokens ADD CONSTRAINT Pkey_618 PRIMARY KEY (UserTokenID) 
CREATE TABLE Periscope.UserStores  
(  	
	User_Key  INTEGER NOT NULL,  
	Store_Key INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.UserStores ADD CONSTRAINT Pkey_655 PRIMARY KEY (User_Key, Store_Key) 

GO

CREATE TABLE Periscope.Users  
(  	
	User_Key           		 INT IDENTITY NOT NULL ,   
	Store_Key          		 INTEGER ,  
	User_ID            		 VARCHAR(255) NOT NULL,  
	Password           		 VARCHAR(40) NOT NULL,  
	ExpiryDate         		 INTEGER ,  
	FirstName          		 VARCHAR(255) ,  
	LastName           		 VARCHAR(255) ,  
	Title              		 VARCHAR(255) ,  
	PhoneNo            		 VARCHAR(255) ,  
	Extension          		 INTEGER ,  
	UserType           		 CHAR(1) ,  
	Profile            		 VARCHAR(255) ,  
	PreferredNotification 	 CHAR(1) ,  
	Email              		 VARCHAR(255) ,  
	Pager              		 VARCHAR(255) ,  
	District_Key       		 INTEGER ,  
	DivisionKey        		 INTEGER ,  
	OperatorId         		 INTEGER ,  
	UserRoleProfileKey    	 INTEGER ,  
	manufact	    					 VARCHAR(14) ,  
	PreferredLanguage  		 VARCHAR(2) ,  
	ChangeFlag			 				 SMALLINT CONSTRAINT DF_Users_ChangeFlag			 				 DEFAULT (0) NOT NULL,  
	Permission 		 				 SMALLINT CONSTRAINT DF_Users_Permission 		 				 DEFAULT (0) NOT NULL,  
	LaborRoleKey 		 				 INTEGER ,  
	LastReadDate 		 				 INTEGER ,  
	LastReadTime 		 				 INTEGER   
 ) 
ALTER TABLE Periscope.Users ADD User_ID_ AS UPPER(User_ID) PERSISTED 
CREATE UNIQUE INDEX I_USERS_UID_ ON Periscope.Users(User_ID_) 
GO

ALTER TABLE Periscope.Users ADD CONSTRAINT Pkey_302 PRIMARY KEY (User_Key) 
CREATE INDEX i_USR_DK ON Periscope.Users (District_Key)
CREATE INDEX i_USR_DVK ON Periscope.Users (DivisionKey)
exec sp_indexoption 'Periscope.Users.i_USR_DK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Users.i_USR_DVK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.WorkflowDetails  
(  	
	WorkflowDetailKey     BIGINT IDENTITY NOT NULL ,   
	WorkflowKey     BIGINT NOT NULL,  
	Sequence			 INTEGER NOT NULL,  
	Description 	  VARCHAR(256) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.WorkflowDetails ADD CONSTRAINT Pkey_695 PRIMARY KEY (WorkflowDetailKey) 

GO

CREATE TABLE Periscope.WorkflowStatus  
(  	
	WorkflowStatusKey     BIGINT IDENTITY NOT NULL ,   
	WorkflowKey     BIGINT NOT NULL,  
	Store_key		 INTEGER NOT NULL,  
	ModifyDate		 INTEGER NOT NULL,  
	ModifyTime    INTEGER ,  
	Status			 SMALLINT ,  
	User_ID 	  VARCHAR(255) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.WorkflowStatus ADD CONSTRAINT Pkey_696 PRIMARY KEY (WorkflowStatusKey) 

GO

CREATE TABLE Periscope.Workflows  
(  	
	WorkflowKey     BIGINT IDENTITY NOT NULL ,   
	DeptNo				  INTEGER NOT NULL ,  
	Description 	  VARCHAR(256) NOT NULL,  
	Create_Date		 INTEGER ,  
	Create_Time    INTEGER   
 ) 
GO

ALTER TABLE Periscope.Workflows ADD CONSTRAINT Pkey_694 PRIMARY KEY (WorkflowKey) 

GO

CREATE TABLE Periscope.ZVersionHistory  
(  	
	VerKey					 INT IDENTITY NOT NULL  ,   
	DBVersion      VARCHAR(130) ,  
	DateApplied   	 DATETIME CONSTRAINT DF_ZVersionHistory_DateApplied   	 DEFAULT CURRENT_TIMESTAMP     
 ) 
GO


GO

ALTER TABLE Periscope.Ar_Sessions ADD CONSTRAINT Fkey_292 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key) 

GO

ALTER TABLE Periscope.ComponentConfigurations ADD CONSTRAINT Fkey_850 FOREIGN KEY (ComponentKey) REFERENCES Periscope.Components (ComponentKey) 
GO

ALTER TABLE Periscope.Districts ADD CONSTRAINT Fkey_320 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 

GO

ALTER TABLE Periscope.HostStatus ADD CONSTRAINT Fkey_857 FOREIGN KEY (HostKey) REFERENCES Periscope.Hosts (HostKey)  
ALTER TABLE Periscope.MessageLogRules ADD CONSTRAINT Fkey_880 FOREIGN KEY (MessageKey) REFERENCES Periscope.MessageLogs (MessageKey)  

GO
ALTER TABLE Periscope.NotifyRoutings ADD CONSTRAINT Fkey_289 FOREIGN KEY (NotifyClassKey) REFERENCES Periscope.NotifyClasses (NotifyClassKey) 

GO

ALTER TABLE Periscope.PageGridFilters ADD CONSTRAINT Fkey_860 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key)  
GO

ALTER TABLE Periscope.PeriStores ADD CONSTRAINT Fkey_298 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts  (District_Key) 

GO

ALTER TABLE Periscope.ReasonDetails ADD CONSTRAINT Fkey_809 FOREIGN KEY (ReasonTypeID) REFERENCES Periscope.ReasonTypes (ReasonTypeID) 
GO

GO

ALTER TABLE Periscope.ReportProfiles ADD CONSTRAINT Fkey_344 FOREIGN KEY (User_Key) REFERENCES  Periscope.Users (User_Key) 
GO
ALTER TABLE Periscope.ReportProfiles ADD CONSTRAINT Fkey_615 FOREIGN KEY (ReportDefnKey) REFERENCES  Periscope.ReportDefinitions (SysKey) 

GO

ALTER TABLE Periscope.Report_Log ADD CONSTRAINT Fkey_343 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key) 

GO

ALTER TABLE Periscope.ScheduledJobScopes ADD CONSTRAINT Fkey_859 FOREIGN KEY (ScheduledJobKey) REFERENCES Periscope.ScheduledJobs (ScheduledJobKey) 
GO

ALTER TABLE Periscope.ScheduledJobs ADD CONSTRAINT Fkey_858 FOREIGN KEY (JobType) REFERENCES Periscope.JobList (JobType) 
GO

ALTER TABLE Periscope.Sessions ADD CONSTRAINT Fkey_265 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key) 

GO

ALTER TABLE Periscope.StoreComponents ADD CONSTRAINT Fkey_285 FOREIGN KEY (ComponentKey) REFERENCES Periscope.Components (ComponentKey) 
ALTER TABLE Periscope.StoreComponents ADD CONSTRAINT Fkey_286 FOREIGN KEY (HostKey) REFERENCES Periscope.Hosts (HostKey) 

GO

ALTER TABLE Periscope.StoreGroupStores ADD CONSTRAINT Fkey_544 FOREIGN KEY (StoreGroupKey) REFERENCES Periscope.StoreGroups (StoreGroupKey) 
ALTER TABLE Periscope.StoreGroupStores ADD CONSTRAINT Fkey_545 FOREIGN KEY (StoreKey) REFERENCES Periscope.PeriStores (Store_Key) 

GO

ALTER TABLE Periscope.UserDepartments ADD CONSTRAINT Fkey_290 FOREIGN KEY (User_Key) REFERENCES Periscope.Users(User_Key) 

GO

ALTER TABLE Periscope.UserGroupDetail ADD CONSTRAINT Fkey_355 FOREIGN KEY (GroupKey) REFERENCES Periscope.Users (User_Key)  
ALTER TABLE Periscope.UserGroupDetail ADD CONSTRAINT Fkey_356 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key)  

GO

ALTER TABLE Periscope.UserRoleProfileDetails ADD CONSTRAINT Fkey_723 FOREIGN KEY (UserRoleProfileKey) REFERENCES Periscope.UserRoleProfiles (UserRoleProfileKey)  
ALTER TABLE Periscope.UserRoleProfileDetails ADD CONSTRAINT Fkey_724 FOREIGN KEY (UserTokenID) REFERENCES Periscope.UserRoleTokens (UserTokenID)  

GO


GO

ALTER TABLE Periscope.UserRoleTokens ADD CONSTRAINT Fkey_725 FOREIGN KEY (ParentID) REFERENCES Periscope.UserRoleTokens (UserTokenID)  
ALTER TABLE Periscope.UserStores ADD CONSTRAINT Fkey_801 FOREIGN KEY (User_Key) REFERENCES Periscope.Users(User_Key) 
ALTER TABLE Periscope.UserStores ADD CONSTRAINT Fkey_802 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores(Store_Key) 

GO

ALTER TABLE Periscope.Users ADD CONSTRAINT Fkey_299 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.Users ADD CONSTRAINT Fkey_319 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 
ALTER TABLE Periscope.Users ADD CONSTRAINT Fkey_722 FOREIGN KEY (UserRoleProfileKey) REFERENCES Periscope.UserRoleProfiles(UserRoleProfileKey) 

GO

ALTER TABLE Periscope.WorkflowDetails ADD CONSTRAINT Fkey_873 FOREIGN KEY (WorkflowKey)    REFERENCES Periscope.Workflows (WorkflowKey) 

GO

ALTER TABLE Periscope.WorkflowStatus ADD CONSTRAINT Fkey_874 FOREIGN KEY (WorkflowKey)    REFERENCES Periscope.Workflows (WorkflowKey) 

GO


GO


-- Creating foreign key constraints 


GO

ALTER TABLE Plum.ArTransactionDetail ADD CONSTRAINT Fkey_734 FOREIGN KEY (transkey,storekey) REFERENCES Plum.ArTransactions (sequence,storekey) 
ALTER TABLE Plum.ArTransactionDetail ADD CONSTRAINT Fkey_735 FOREIGN KEY (storekey) REFERENCES Plum.Stores (store_key) 
ALTER TABLE Plum.ArTransactionDetail ADD CONSTRAINT Fkey_736 FOREIGN KEY (deptno) REFERENCES Plum.Departments (deptno) 

GO

ALTER TABLE Plum.ArTransactions ADD CONSTRAINT Fkey_733 FOREIGN KEY (storekey) REFERENCES Plum.Stores (store_key) 

GO


ALTER TABLE Plum.BatchItemFailures ADD CONSTRAINT Fkey_190 FOREIGN KEY (StoreKey, BatchNo) REFERENCES Plum.BatchRegister (StoreKey, BatchNo) 

GO

ALTER TABLE Plum.BatchRegister ADD CONSTRAINT Fkey_174 FOREIGN KEY (storekey) REFERENCES Plum.Stores (Store_Key) 

GO


ALTER TABLE Plum.COOLCountry ADD CONSTRAINT Fkey_218 FOREIGN KEY (StoreKey, BatchNo) REFERENCES Plum.BatchRegister (StoreKey, BatchNo) 
ALTER TABLE Plum.COOLCountry ADD CONSTRAINT Fkey_502 FOREIGN KEY (StoreKey) REFERENCES Plum.Stores (Store_Key) 
ALTER TABLE Plum.COOLCountry ADD CONSTRAINT Fkey_204 FOREIGN KEY (DeptNo) REFERENCES Plum.Departments (DeptNo) 
ALTER TABLE Plum.COOLCountry ADD CONSTRAINT Fkey_205 FOREIGN KEY (COOLClassNo) REFERENCES Plum.COOLClass (COOLClassNo) 

GO


ALTER TABLE Plum.COOLMaster ADD CONSTRAINT Fkey_198 FOREIGN KEY (StoreKey, BatchNo) REFERENCES Plum.BatchRegister (StoreKey, BatchNo) 
ALTER TABLE Plum.COOLMaster ADD CONSTRAINT Fkey_504 FOREIGN KEY (StoreKey) REFERENCES Plum.Stores (Store_Key) 
ALTER TABLE Plum.COOLMaster ADD CONSTRAINT Fkey_199 FOREIGN KEY (DeptNo) REFERENCES Plum.Departments (DeptNo) 

GO

ALTER TABLE Plum.COOLShortList ADD CONSTRAINT Fkey_206 FOREIGN KEY (DeptNo) REFERENCES Plum.Departments (DeptNo) 

ALTER TABLE Plum.COOLShortList ADD CONSTRAINT Fkey_213 FOREIGN KEY (StoreKey, BatchNo) REFERENCES Plum.BatchRegister (StoreKey, BatchNo) 
ALTER TABLE Plum.COOLShortList ADD CONSTRAINT Fkey_505 FOREIGN KEY (StoreKey) REFERENCES Plum.Stores (Store_Key) 

GO



GO



GO

ALTER TABLE Plum.PLUMaster ADD CONSTRAINT Fkey_117 FOREIGN KEY (DeptNo) REFERENCES Plum.Departments (DeptNo) 
ALTER TABLE Plum.PLUMaster ADD CONSTRAINT Fkey_118 FOREIGN KEY (StoreKey,BatchNo) REFERENCES Plum.BatchRegister (StoreKey,BatchNo) 
ALTER TABLE Plum.PLUMaster ADD CONSTRAINT Fkey_194 FOREIGN KEY (StoreKey) REFERENCES Plum.Stores (Store_Key) 
ALTER TABLE Plum.PLUMaster ADD CONSTRAINT Fkey_196 FOREIGN KEY (COOLClassNo) REFERENCES Plum.COOLClass (COOLClassNo) 

GO

ALTER TABLE Plum.ProductGroups ADD CONSTRAINT Fkey_125 FOREIGN KEY (deptno) REFERENCES Plum.Departments (deptno) 

GO

ALTER TABLE Plum.ScaleSubJobs ADD CONSTRAINT Fkey_180 FOREIGN KEY (StoreKey,DeptNo) REFERENCES Plum.StoreDepartments (StoreKey,DeptNo) 
ALTER TABLE Plum.ScaleSubJobs ADD CONSTRAINT Fkey_181 FOREIGN KEY (StoreKey,BatchNo) REFERENCES Plum.BatchRegister (StoreKey,BatchNo) 

GO

ALTER TABLE Plum.StoreDepartments ADD CONSTRAINT Fkey_134 FOREIGN KEY (StoreKey) REFERENCES Plum.Stores (Store_Key) 
ALTER TABLE Plum.StoreDepartments ADD CONSTRAINT Fkey_135 FOREIGN KEY (DeptNo) REFERENCES Plum.Departments (DeptNo) 

GO

ALTER TABLE Plum.TransactionDetail ADD CONSTRAINT Fkey_137 FOREIGN KEY (transkey,storekey) REFERENCES Plum.Transactions (sequence,storekey) 
ALTER TABLE Plum.TransactionDetail ADD CONSTRAINT Fkey_184 FOREIGN KEY (storekey) REFERENCES Plum.Stores (store_key) 
ALTER TABLE Plum.TransactionDetail ADD CONSTRAINT Fkey_710 FOREIGN KEY (deptno) REFERENCES Plum.Departments (deptno) 

GO

ALTER TABLE Plum.Transactions ADD CONSTRAINT Fkey_136 FOREIGN KEY (storekey) REFERENCES Plum.Stores (store_key) 

GO


-- Creating Tables and constraints 

CREATE TABLE Periscope.Alt_Product_Lookup  
(  	
	AltProductKey    INT IDENTITY NOT NULL ,   
	MasterProductKey INTEGER NOT NULL,  
	UPC 			     	 VARCHAR(13) NOT NULL,  
	Desc1			     	 VARCHAR(64) ,  
	Desc2			     	 VARCHAR(64) ,  
	ProductionQty    FLOAT(24) ,   
	Flag    SMALLINT ,  
	Uom         VARCHAR(10) COLLATE Latin1_General_CS_AI NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Alt_Product_Lookup ADD CONSTRAINT Pkey_511 PRIMARY KEY (AltProductKey) 
CREATE UNIQUE INDEX i_APL_MPK_UPC ON Periscope.Alt_Product_Lookup(MasterProductKey,UPC)

GO

CREATE TABLE Periscope.ArAuditLog  
(  	
	AuditKey					 BIGINT NOT NULL ,  
	EntityType				 VARCHAR(200) NOT NULL ,  
	EntityId		 		 	 INTEGER ,  
	ReferenceType	 	 VARCHAR(200) ,  
	ReferenceId 		 	 INTEGER ,  
	ChangeType 		 	 INTEGER ,  
	FieldName  		 	 VARCHAR(200) ,  
	OldValue   		 	 VARCHAR(4000) ,  
	NewValue    		 	 VARCHAR(4000) ,  
	ChangeDate    		 INTEGER ,  
	ChangeTime    		 INTEGER ,  
	User_ID           VARCHAR(255) NOT NULL ,  
	Memo						 	 VARCHAR(400)  ,  
	StoreKey	    		 INTEGER   
 ) 
GO

ALTER TABLE Periscope.ArAuditLog ADD CONSTRAINT Pkey_644 PRIMARY KEY (AuditKey) 

GO

CREATE TABLE Periscope.ArBr_Inventory  
(  	
	Store_Key     INTEGER NOT NULL ,  
	BrProductKey  INTEGER NOT NULL ,  
	Business_Date INTEGER NOT NULL ,  
	Qty           FLOAT(24) NOT NULL ,   
	Weight        FLOAT(24) NOT NULL ,   
	Amount        INTEGER NOT NULL ,  
	InvDeptNo		 INTEGER CONSTRAINT DF_ArBr_Inventory_InvDeptNo		 DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ArBr_Inventory ADD CONSTRAINT Pkey_344 PRIMARY KEY (Store_Key, BRProductKey, Business_Date,InvDeptNo) 
CREATE INDEX i_ABRI_BD ON Periscope.ArBr_Inventory(Business_Date)

GO

CREATE TABLE Periscope.ArBr_RetailPrice  
(  	
	Store_Key    INTEGER NOT NULL ,  
	BrProductKey INTEGER NOT NULL ,  
	Begin_Date   INTEGER NOT NULL ,  
	End_Date     INTEGER NOT NULL ,  
	Amount       INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.ArBr_RetailPrice ADD CONSTRAINT Pkey_341 PRIMARY KEY (Store_key, BRProductKey, Begin_Date) 
CREATE INDEX i_ABRRP_ED ON Periscope.ArBr_RetailPrice(End_Date)

GO

CREATE TABLE Periscope.ArBr_Transactions  
(  	
	ID           INTEGER NOT NULL ,  
	Store_Key    INTEGER NOT NULL ,  
	BrProductKey INTEGER NOT NULL ,  
	Post_Date    INTEGER NOT NULL ,  
	Post_Time    INTEGER NOT NULL ,  
	Tran_Date    INTEGER NOT NULL ,  
	Tran_Time    INTEGER NOT NULL ,  
	Tran_Type    VARCHAR(4) NOT NULL ,  
	Qty          FLOAT(24) NOT NULL ,   
	Weight       FLOAT(24)  ,   
	Amount       INTEGER NOT NULL ,  
	Memo         VARCHAR(256) ,  
	InvDeptNo	 INTEGER CONSTRAINT DF_ArBr_Transactions_InvDeptNo	 DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ArBr_Transactions ADD CONSTRAINT Pkey_346 PRIMARY KEY (ID) 
CREATE INDEX i_ABRTR_TD ON Periscope.ArBr_Transactions(Tran_Date)

GO

CREATE TABLE Periscope.ArBr_UnitCostsHistory  
(  	
	BrProductKey	 INTEGER NOT NULL ,  
	StoreKey    	 INTEGER  ,  
	Begin_Date  	 INTEGER NOT NULL ,  
	End_Date  		 INTEGER NOT NULL ,  
	UnitCost    	 FLOAT(24) NOT NULL    
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_ABUCH_BPK_SK  ON Periscope.ArBr_UnitCostsHistory(BrProductKey,StoreKey)
exec sp_indexoption 'Periscope.ArBr_UnitCostsHistory.i_ABUCH_BPK_SK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ArConsolidValues  
(  	
	Store_Key            INTEGER NOT NULL ,  
	Product_Key          INTEGER NOT NULL ,  
	Start_Date           INTEGER NOT NULL ,  
	Promotion            CHAR(1) NOT NULL ,  
	Price                INTEGER NOT NULL   ,  
	Sales_Qty            FLOAT(24)  ,   
	Sales_Amount         INTEGER ,  
	Scale_Prod_Qty       FLOAT(24)  ,   
	Scale_Prod_Amount    INTEGER ,  
	Discard_Qty          FLOAT(24)  ,   
	Discard_Amount       INTEGER ,  
	Rework_Qty           FLOAT(24)  ,   
	Rework_Amount        INTEGER ,  
	Rewrap_Out_Qty       FLOAT(24)  ,   
	Rewrap_Out_Amount    INTEGER ,  
	Markdown_Qty         FLOAT(24)  ,   
	Markdown_Amount      INTEGER ,  
	Markdown_FS_Amount   INTEGER ,  
	Rewrap_In_Qty        FLOAT(24)  ,   
	Rewrap_In_Amount     INTEGER ,  
	Case_Prod_Qty        FLOAT(24)  ,   
	Case_Prod_Amount     INTEGER ,  
	Transfer_Qty         FLOAT(24)  ,   
	Transfer_Amount      INTEGER ,  
	On_Hand_Qty          FLOAT(24)  ,   
	Start_Of_Day_Qty     FLOAT(24)  ,   
	Normal_Adj_Qty       FLOAT(24)  ,   
	Normal_Adj_Amount    INTEGER ,  
	Pilferage_Adj_Qty    FLOAT(24)  ,   
	Pilferage_Adj_Amount INTEGER ,  
	Other_Adj_Qty        FLOAT(24)  ,   
	Other_Adj_Amount     INTEGER ,  
	Minimum				      INTEGER  ,  
	On_Hand_SpotChecked     FLOAT(24)  ,   
	MerchType     	      SMALLINT CONSTRAINT DF_ArConsolidValues_MerchType     	      DEFAULT (2) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ArConsolidValues ADD CONSTRAINT Pkey_325 PRIMARY KEY (Store_Key, Product_Key, Start_Date) 
CREATE INDEX i_ACV_SD_SK  ON Periscope.ArConsolidValues (Start_Date, Store_Key )

GO

CREATE TABLE Periscope.ArConsolidValuesEx  
(  	
	Store_Key      INTEGER NOT NULL ,  
	Product_Key    INTEGER NOT NULL ,  
	Start_Date     INTEGER NOT NULL ,  
	Markup_Qty     FLOAT(24) ,   
	Markup_Amount  INTEGER ,  
	New_Upr_Qty    FLOAT(24) ,   
	New_Upr_Amount INTEGER ,  
	Other_Adj_Qty     FLOAT(24)  ,   
	Other_Adj_Amount  INTEGER  ,  
	Bad_Label_Qty     FLOAT(24)  ,   
	Spot_Check_Qty    FLOAT(24)  ,   
	LastSpotCheckTime INTEGER    
 ) 
GO

ALTER TABLE Periscope.ArConsolidValuesEx ADD CONSTRAINT Pkey_359 PRIMARY KEY (Store_Key, Product_Key, Start_Date) 
CREATE INDEX i_ACVx_SD_SK   ON Periscope.ArConsolidValuesEx (Start_Date, Store_Key)

GO

CREATE TABLE Periscope.ArDSS2_Forecast  
(  	
	Store_Key   INTEGER NOT NULL ,  
	Product_Key INTEGER  ,  
	EffDate     INTEGER NOT NULL ,  
	Updated     INTEGER NOT NULL ,  
	Value       FLOAT(24) NOT NULL ,   
	Variance    FLOAT(24)  ,   
	Warning     INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_ArDS2FC_SK_ED_PK ON Periscope.ArDSS2_Forecast (Store_Key, EffDate, Product_Key)
CREATE        INDEX i_ArDS2FC_PK ON Periscope.ArDSS2_Forecast (Product_Key)
CREATE        INDEX i_ArDS2FC_ED ON Periscope.ArDSS2_Forecast (EffDate)
exec sp_indexoption 'Periscope.ArDSS2_Forecast.i_ArDS2FC_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.ArDSS2_Forecast.i_ArDS2FC_ED', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.ArDSS2_Forecast.i_ArDS2FC_SK_ED_PK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ArInStoreExecutions  
(  	
	Store_key    					 INTEGER ,  
	Product_Key    				 INTEGER ,  
	ExecutionKey    				 INTEGER ,  
	Begin_Date    					 INTEGER ,  
	End_Date    						 INTEGER   
 ) 
GO

CREATE UNIQUE INDEX i_AISE_SK_PK_EK_BD ON Periscope.ArInStoreExecutions (Store_key,Product_Key,ExecutionKey,Begin_Date)
exec sp_indexoption 'Periscope.ArInStoreExecutions.i_AISE_SK_PK_EK_BD', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ArProductTransLog  
(  	
	ID          BIGINT NOT NULL,  
	Post_Date   INTEGER NOT NULL,  
	Post_Time   INTEGER NOT NULL,  
	Tran_Date   INTEGER ,  
	Tran_Time   INTEGER ,  
	Tran_Type   VARCHAR(4) NOT NULL,  
	Product_Key INTEGER NOT NULL,  
	QTY         FLOAT(24) NOT NULL,   
	Amount      INTEGER ,  
	Store_Key   INTEGER NOT NULL,  
	Memo        VARCHAR(256) 			   
 ) 
GO

ALTER TABLE Periscope.ArProductTransLog ADD CONSTRAINT Pkey_327 PRIMARY KEY (ID) 
CREATE INDEX i_APT_TD_SK_PK  ON Periscope.ArProductTransLog (Tran_Date, Store_Key, Product_Key)
CREATE INDEX i_APT_PK_SK_TD  ON Periscope.ArProductTransLog (Product_Key, Store_Key, Tran_Date)
CREATE INDEX i_APT_SK_TD_TT  ON Periscope.ArProductTransLog (Store_Key, tran_date, tran_time)

GO

CREATE TABLE Periscope.Ar_CaseLayouts_V4  
(  	
	CaseLayout_Key INTEGER NOT NULL ,  
	Description    VARCHAR(50) NOT NULL ,  
	Begin_Date     INTEGER NOT NULL ,  
	CaseType_Key   INTEGER  ,  
	End_Date       INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Ar_CaseLayouts_V4 ADD CONSTRAINT Pkey_369 PRIMARY KEY (Caselayout_Key) 
CREATE UNIQUE INDEX i_ACL4_CK_BD  ON Periscope.Ar_CaseLayouts_V4 (CaseType_Key, Begin_Date )
CREATE INDEX i_ACL4_DE  ON Periscope.Ar_CaseLayouts_V4 (Description)

GO

CREATE TABLE Periscope.Ar_FacingMinMax_V4  
(  	
	DOW        SMALLINT NOT NULL ,  
	Facing_Key INTEGER NOT NULL ,  
	Minimum    INTEGER NOT NULL ,  
	Maximum    INTEGER NOT NULL ,  
	Store_Key  INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Ar_FacingMinMax_V4 ADD CONSTRAINT Pkey_370 PRIMARY KEY (Facing_Key,Store_Key,DOW) 

GO

CREATE TABLE Periscope.Ar_Facings_V4  
(  	
	Facing_Key     INTEGER NOT NULL ,  
	CaseLayout_Key INTEGER NOT NULL ,  
	Product_Key    INTEGER NOT NULL 			,  
	Description    VARCHAR(50) COLLATE Latin1_General_CS_AI ,  
	Width          DECIMAL(7,2) ,   
	Height         DECIMAL(7,2) ,   
	Length         DECIMAL(7,2) ,   
	OverfillFactor INTEGER ,  
	OverfillType   SMALLINT ,  
	FacingType     INTEGER NOT NULL,  
	Promotion      CHAR(1) ,  
	ItemLocation      VARCHAR(64)   
 ) 
GO

ALTER TABLE Periscope.Ar_Facings_V4 ADD CONSTRAINT Pkey_371 PRIMARY KEY (Facing_Key) 
CREATE UNIQUE INDEX i_AFA4_CK_PK_Des ON Periscope.Ar_Facings_V4 (CaseLayout_Key,Product_Key,Description )

GO

CREATE TABLE Periscope.Ar_PeriPriceHistory  
(  	
	Product_key INTEGER NOT NULL ,  
	SourceLevel INTEGER  ,  
	Source      INTEGER  ,  
	Begin_Date  INTEGER NOT NULL ,  
	Begin_Time  INTEGER  ,  
	End_Date    INTEGER NOT NULL ,  
	End_Time    INTEGER  ,  
	Amount      INTEGER NOT NULL ,  
	Promotion   CHAR(1) NOT NULL ,  
	FSDPrice1   INTEGER    
 ) 
GO

CREATE INDEX i_APP_P_S_S_B_B  ON Periscope.Ar_PeriPriceHistory (Product_Key,SourceLevel DESC,Source,Begin_Date,Begin_Time)
CREATE INDEX i_APP_S_S_B_B   ON Periscope.Ar_PeriPriceHistory (SourceLevel DESC,Source,Begin_Date,Begin_Time)

GO

CREATE TABLE Periscope.AuditLog  
(  	
	AuditKey					 BIGINT IDENTITY NOT NULL  ,   
	EntityType				 VARCHAR(200) NOT NULL ,  
	EntityId		 		 	 INTEGER ,  
	ReferenceType	 	 VARCHAR(200) ,  
	ReferenceId 		 	 INTEGER ,  
	ChangeType 		 	 INTEGER ,  
	FieldName  		 	 VARCHAR(200) ,  
	OldValue   		 	 VARCHAR(4000) ,  
	NewValue    		 	 VARCHAR(4000) ,  
	ChangeDate    		 INTEGER ,  
	ChangeTime    		 INTEGER ,  
	User_ID           VARCHAR(255) NOT NULL ,  
	Memo						 	 VARCHAR(400)  ,  
	StoreKey	    		 INTEGER   
 ) 
GO

ALTER TABLE Periscope.AuditLog ADD CONSTRAINT Pkey_626 PRIMARY KEY (AuditKey) 
exec sp_indexoption 'Periscope.AuditLog', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.BackroomProducts  
(  	
	BRProductKey 	 INT IDENTITY NOT NULL ,   
	Description		 VARCHAR(50) NOT NULL ,  
	Sku          	 VARCHAR(20)  ,  
	PrimarySku   	 INTEGER  ,  
	Quantity	    	 FLOAT(24)  ,   
	OrderingCat		 INTEGER  ,  
	Uom		    		 VARCHAR(10) NOT NULL ,  
	DeptNo					 INTEGER NOT NULL ,  
	LastExported 	 INTEGER ,  
	Origin       	 INTEGER ,  
	ProductClass 	 INTEGER ,  
	OrderSafetyLift   FLOAT(24) ,   
	USDAFlag          SMALLINT ,  
	COOLForceFlag 	 SMALLINT ,  
	TrackableItemFlag SMALLINT ,  
	GrindTranTypes    INTEGER ,  
	ExternalItemNo    VARCHAR(20) ,  
	IMPSProductNo     VARCHAR(10) ,  
	ExternalItemKey	 VARCHAR(20) ,  
	DisplayName 			 VARCHAR(50) ,  
	ExternalItemName	 VARCHAR(255)   
 ) 

GO

ALTER TABLE Periscope.BackroomProducts ADD CONSTRAINT Pkey_331 PRIMARY KEY (BRProductKey) 
CREATE INDEX i_Bp_Sku  ON Periscope.BackroomProducts (Sku)
exec sp_indexoption 'Periscope.BackroomProducts.i_Bp_Sku', 'disallowpagelocks', TRUE
CREATE INDEX i_BRP_OC  ON Periscope.BackroomProducts (OrderingCat)
exec sp_indexoption 'Periscope.BackroomProducts.i_BRP_OC', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.BackroomProducts', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_Allergen  
(  	
	BrProductKey					 INTEGER NOT NULL ,  
	AllergenTextKey			 INTEGER NOT NULL ,  
	Value								 INTEGER  ,  
	AdditionalValue			 INTEGER   
 ) 
GO

ALTER TABLE Periscope.Br_Allergen ADD CONSTRAINT Pkey_638 PRIMARY KEY (BrProductKey, AllergenTextKey) 

GO

CREATE TABLE Periscope.Br_CountAreas  
(  	
	CountAreaKey   INT IDENTITY NOT NULL ,   
	Description    VARCHAR(50) COLLATE Latin1_General_CS_AI NOT NULL ,  
	IngredientSupp INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Br_CountAreas ADD CONSTRAINT Pkey_355 PRIMARY KEY (CountAreaKey) 
CREATE UNIQUE INDEX i_BRCA_Des ON Periscope.Br_CountAreas (Description)

GO

CREATE TABLE Periscope.Br_InvCountAreas  
(  	
	StoreKey     INTEGER NOT NULL ,  
	Generation   SMALLINT NOT NULL ,  
	CountAreaKey INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Br_InvCountAreas ADD CONSTRAINT Pkey_356 PRIMARY KEY (StoreKey,Generation,CountAreaKey) 
CREATE INDEX i_BICA_CAK ON Periscope.Br_InvCountAreas (CountAreaKey)
exec sp_indexoption 'Periscope.Br_InvCountAreas.i_BICA_CAK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_Inventory  
(  	
	Store_Key     INTEGER NOT NULL ,  
	BrProductKey  INTEGER NOT NULL ,  
	Business_Date INTEGER NOT NULL ,  
	Qty           FLOAT(24) NOT NULL ,   
	Weight        FLOAT(24) ,   
	Amount        INTEGER NOT NULL ,  
	InvDeptNo		 INTEGER CONSTRAINT DF_Br_Inventory_InvDeptNo		 DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Br_Inventory ADD CONSTRAINT Pkey_343 PRIMARY KEY (Store_Key, BRProductKey, Business_Date, InvDeptNo) 
CREATE INDEX i_BRI_BD  ON Periscope.Br_Inventory (Business_Date)
CREATE INDEX i_BRI_BPK ON Periscope.Br_Inventory (BRProductKey)
exec sp_indexoption 'Periscope.Br_Inventory.i_BRI_BPK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_InvnCount  
(  	
	InvnCountKey  				 BIGINT IDENTITY NOT NULL ,   
	Store_Key   			 INTEGER NOT NULL  ,  
	DeptNo		   			 INTEGER NOT NULL ,  
	ApplyDate		 		 INTEGER  ,  
	ApplyTime		 		 INTEGER  ,  
	Generation    		 SMALLINT NOT NULL   ,  
	Validated    		 SMALLINT ,  
	ValidatedBy    	 INTEGER   ,  
	ValidatedDate   	 INTEGER       ,  
	ValidatedTime   	 INTEGER    ,  
	IsFinancialCnt  	 SMALLINT   ,  
	ExportDate    		 INTEGER   ,  
	ExportTime    		 INTEGER   ,  
	Create_Date    		 INTEGER   ,  
	Create_Time    		 INTEGER   ,  
	ModifyDate   	 INTEGER   ,  
	ModifyTime   	 INTEGER   ,  
	StartDate 	 INTEGER  ,  
	StartTime 	 INTEGER    ,  
	IsDefault  	 SMALLINT   ,  
	TotalCount  			 INTEGER      
 ) 
GO

ALTER TABLE Periscope.Br_InvnCount ADD CONSTRAINT Pkey_666 PRIMARY KEY NONCLUSTERED (InvnCountKey) 
CREATE UNIQUE CLUSTERED INDEX i_BrInvnC_SDPPGI ON Periscope.Br_InvnCount (Store_Key,DeptNo, Generation, IsFinancialCnt,IsDefault)
exec sp_indexoption 'Periscope.Br_InvnCount', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_InvnCountDetails  
(  	
	InvnCountDetailKey  	 BIGINT IDENTITY NOT NULL ,   
	InvnCountKey  				 BIGINT NOT NULL  ,  
	BrProductKey   		 INTEGER NOT NULL  ,  
	CountDeptNo   		 INTEGER NOT NULL  ,  
	CountAreaKey  			 INTEGER ,  
	Qty							 FLOAT(24) NOT NULL ,   
	Amount          FLOAT(24) NOT NULL ,   
	Weight           FLOAT(24)  ,   
	Post_Date        INTEGER NOT NULL ,  
	Post_Time        INTEGER NOT NULL ,  
	System_Qty  			 INTEGER ,  
	System_Weight  			 INTEGER ,  
	System_Amount  			 INTEGER ,  
	AdjustmentReasonKey     INTEGER    
 ) 
GO

ALTER TABLE Periscope.Br_InvnCountDetails ADD CONSTRAINT Pkey_667 PRIMARY KEY NONCLUSTERED (InvnCountDetailKey) 
CREATE UNIQUE CLUSTERED INDEX i_BrInvnCD_PC ON Periscope.Br_InvnCountDetails (BrProductKey,CountDeptNo, CountAreaKey,InvnCountKey)
CREATE INDEX i_BrInvnCD_Inv ON Periscope.Br_InvnCountDetails (InvnCountKey)
exec sp_indexoption 'Periscope.Br_InvnCountDetails', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_RetailPrice  
(  	
	Store_Key    INTEGER NOT NULL ,  
	BrProductKey INTEGER NOT NULL ,  
	Begin_Date   INTEGER NOT NULL ,  
	End_Date     INTEGER NOT NULL ,  
	Amount       INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Br_RetailPrice ADD CONSTRAINT Pkey_340 PRIMARY KEY (Store_key, BRProductKey, Begin_Date) 
CREATE INDEX i_BRRP_ED  ON Periscope.Br_RetailPrice(End_Date)
CREATE INDEX i_BRRP_BPK ON Periscope.Br_RetailPrice(BRProductKey)
exec sp_indexoption 'Periscope.Br_RetailPrice.i_BRRP_BPK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_Transactions  
(  	
	ID           INT IDENTITY NOT NULL  ,   
	Store_Key    INTEGER NOT NULL ,  
	BrProductKey INTEGER NOT NULL ,  
	Post_Date    INTEGER NOT NULL ,  
	Post_Time    INTEGER NOT NULL ,  
	Tran_Date    INTEGER NOT NULL ,  
	Tran_Time    INTEGER NOT NULL ,  
	Tran_Type    VARCHAR(4) NOT NULL ,  
	Qty          FLOAT(24) NOT NULL ,   
	Weight       FLOAT(24)  ,   
	Amount       INTEGER NOT NULL ,  
	Memo         VARCHAR(256) ,  
	InvDeptNo  	 INTEGER CONSTRAINT DF_Br_Transactions_InvDeptNo  	 DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Br_Transactions ADD CONSTRAINT Pkey_332 PRIMARY KEY (ID) 
CREATE INDEX i_BRTR_SK_BP_TD        ON Periscope.Br_Transactions(Store_key, BRProductKey, Tran_Date)
CREATE INDEX i_BRTR_TD_SK_BP        ON Periscope.Br_Transactions(Tran_Date, Store_key, BRProductKey)
CREATE INDEX i_BRTR_TD_TT_BR_SK_TT  ON Periscope.Br_Transactions(tran_date, tran_time, BRProductKey,Store_Key,Tran_Type)
CREATE INDEX i_BRT_BPK              ON Periscope.Br_Transactions(BRProductKey)
exec sp_indexoption 'Periscope.Br_Transactions.i_BRT_BPK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_UnitCostsCache  
(  	
	BrProductKey INTEGER NOT NULL ,  
	StoreKey     INTEGER  ,  
	LastUpdate   INTEGER NOT NULL ,  
	UnitCost     FLOAT(24) NOT NULL    
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_BUCC_BPK_SK  ON Periscope.Br_UnitCostsCache(BrProductKey,StoreKey)
exec sp_indexoption 'Periscope.Br_UnitCostsCache', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Br_UnitCostsHistory  
(  	
	SysKey        INT IDENTITY NOT NULL  ,   
	BrProductKey	 INTEGER NOT NULL ,  
	StoreKey    	 INTEGER  ,  
	Begin_Date  	 INTEGER NOT NULL ,  
	End_Date  		 INTEGER NOT NULL ,  
	UnitCost    	 FLOAT(24) NOT NULL    
 ) 
GO

ALTER TABLE Periscope.Br_UnitCostsHistory ADD CONSTRAINT Pkey_528 PRIMARY KEY (SysKey) 
CREATE INDEX i_BUCH_BPK_SK_BD  ON Periscope.Br_UnitCostsHistory(BrProductKey,StoreKey,Begin_Date)
exec sp_indexoption 'Periscope.Br_UnitCostsHistory.i_BUCH_BPK_SK_BD', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.CannibGroupProducts  
(  	
	CannibGroupKey     	 INTEGER NOT NULL,  
	Product_Key      		 INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.CannibGroupProducts ADD CONSTRAINT Pkey_515 PRIMARY KEY (CannibGroupKey, Product_Key) 
CREATE UNIQUE INDEX i_CGP_PK ON Periscope.CannibGroupProducts(Product_Key)

GO

CREATE TABLE Periscope.CannibGroups  
(  	
	CannibGroupKey      INT IDENTITY NOT NULL ,   
	Description 			  VARCHAR(64)   
 ) 
GO

ALTER TABLE Periscope.CannibGroups ADD CONSTRAINT Pkey_516 PRIMARY KEY (CannibGroupKey) 

GO

CREATE TABLE Periscope.CaseLayouts_V4  
(  	
	CaseLayout_Key INT IDENTITY NOT NULL ,   
	Description    VARCHAR(100) COLLATE Latin1_General_CS_AI NOT NULL ,  
	Begin_Date     INTEGER NOT NULL ,  
	CaseType_Key   INTEGER  ,  
	End_Date       INTEGER CONSTRAINT DF_CaseLayouts_V4_End_Date       DEFAULT (21000101) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.CaseLayouts_V4 ADD CONSTRAINT Pkey_366 PRIMARY KEY (Caselayout_Key) 
CREATE UNIQUE INDEX i_CaT4_BeD ON Periscope.CaseLayouts_V4 (CaseType_Key,Begin_Date)

GO

CREATE TABLE Periscope.CaseOrders  
(  	
	CaseOrder_key    INT IDENTITY NOT NULL  ,   
	Store_Key        INTEGER NOT NULL ,  
	OrderTemplateKey INTEGER  ,  
	DeptNo           INTEGER NOT NULL ,  
	EffDate          INTEGER NOT NULL ,  
	EffTime          INTEGER NOT NULL ,  
	ExternalOrderNum VARCHAR(64)  ,  
	Reference        VARCHAR(64)  ,  
	CreationDate     INTEGER NOT NULL ,  
	CreationTime     INTEGER NOT NULL ,  
	ApprovedDate     INTEGER ,  
	ApprovedTime     INTEGER ,  
	InventoryDate    INTEGER ,  
	InventoryTime    INTEGER ,  
	User_Key         INTEGER ,  
	Post_Date        INTEGER  ,  
	Post_Time        INTEGER  ,  
	ClosedDate       INTEGER  ,  
	ClosedTime       INTEGER  ,  
	ExportParts      INTEGER  ,  
	ReceiveParts     INTEGER    
 ) 
GO

ALTER TABLE Periscope.CaseOrders ADD CONSTRAINT Pkey_333 PRIMARY KEY (CaseOrder_Key) 
CREATE INDEX i_CSOR_UK ON Periscope.CaseOrders (User_Key)
CREATE INDEX i_CSOR_SK_ED ON Periscope.CaseOrders(Store_Key, EffDate)
CREATE INDEX i_CSOR_REF   ON Periscope.CaseOrders(Reference)
CREATE INDEX i_CSOR_OTK   ON Periscope.CaseOrders(OrderTemplateKey)
exec sp_indexoption 'Periscope.CaseOrders.i_CSOR_OTK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.CaseOrders.i_CSOR_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.CaseOrdersBrp  
(  	
	CaseOrder_Key    INTEGER NOT NULL ,  
	BrProductKey     INTEGER NOT NULL ,  
	Recommended_Qty  FLOAT(24) ,   
	Ordered_Qty      FLOAT(24) ,   
	Received_Qty     FLOAT(24) ,   
	Demand           FLOAT(24) ,   
	MinEffectiveInvt FLOAT(24) ,   
	ExcessInvt       FLOAT(24) ,   
	Warning          VARCHAR(256)  ,  
	ForecastOrder    FLOAT(24) ,   
	ExpectedBrInv    FLOAT(24) ,   
	MerchandisingMin FLOAT(24) ,   
	OutstandingOrder FLOAT(24) ,   
	UpcList   	    VARCHAR(256) ,  
	ProductClass     INTEGER ,  
	Promotion   	    CHAR(1)  ,  
	AdjustmentReasonKey  INTEGER  ,  
	Recommended_Dev  FLOAT(24) CONSTRAINT DF_CaseOrdersBrp_Recommended_Dev  DEFAULT (0) NOT NULL,   
	Reference 			  VARCHAR(64)  ,  
	System_Recomm 	  INTEGER  ,  
	DemandVariance   FLOAT(24) ,   
	ForecastVariance FLOAT(24) ,   
	AdjInvQty  		  FLOAT(24) ,   
	BrpSafetyLiftQty  		  INTEGER ,  
	BrpSafetyStockQty  		  INTEGER     
 ) 
GO

ALTER TABLE Periscope.CaseOrdersBrp ADD CONSTRAINT Pkey_342 PRIMARY KEY (CaseOrder_Key, BRProductKey) 
CREATE INDEX i_COBR_BPK ON Periscope.CaseOrdersBrp (BRProductKey)
CREATE INDEX i_COBR_COK ON Periscope.CaseOrdersBrp (CaseOrder_Key)
exec sp_indexoption 'Periscope.CaseOrdersBrp.i_COBR_BPK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.CaseOrdersBrp.i_COBR_COK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.CaseOrdersBrpFilter  
(  	
	CaseOrderBrpFilterKey   INT IDENTITY NOT NULL ,   
	Store_key    					 INTEGER ,  
	DeptNo   							 INTEGER NOT NULL,  
	FilterName							 VARCHAR(20) NOT NULL,  
	FilterValue         		 VARCHAR(20) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.CaseOrdersBrpFilter ADD CONSTRAINT Pkey_519 PRIMARY KEY (CaseOrderBrpFilterKey) 

GO

CREATE TABLE Periscope.CaseOrdersBrpSeq  
(  	
	CaseOrderBrpSeqKey  	 INT IDENTITY NOT NULL ,   
	Store_key    					 INTEGER NOT NULL,  
	BrProductKey						 INTEGER NOT NULL,  
	SequenceNo							 INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.CaseOrdersBrpSeq ADD CONSTRAINT Pkey_517 PRIMARY KEY (CaseOrderBrpSeqKey) 

GO

CREATE TABLE Periscope.CaseOrdersBrp_V4  
(  	
	CaseOrder_Key    INTEGER NOT NULL ,  
	BrProductKey     INTEGER NOT NULL ,  
	Recommended_Qty  FLOAT(24) ,   
	Ordered_Qty      FLOAT(24) ,   
	Received_Qty     FLOAT(24) ,   
	Demand           FLOAT(24) ,   
	MinEffectiveInvt FLOAT(24) ,   
	ExcessInvt       FLOAT(24) ,   
	Warning          VARCHAR(256)  ,  
	ForecastOrder    FLOAT(24) ,   
	ExpectedBrInv    FLOAT(24) ,   
	MerchandisingMin FLOAT(24) ,   
	OutstandingOrder FLOAT(24) ,   
	UpcList   	    VARCHAR(256) ,  
	ProductClass     INTEGER ,  
	Promotion   	    CHAR(1)  ,  
	AdjustmentReasonKey  INTEGER  ,  
	Recommended_Dev  FLOAT(24) CONSTRAINT DF_CaseOrdersBrp_V4_Recommended_Dev  DEFAULT (0) NOT NULL,   
	Reference 			  VARCHAR(64)  ,  
	System_Recomm 	  INTEGER  ,  
	DemandVariance   FLOAT(24) ,   
	ForecastVariance FLOAT(24) ,   
	AdjInvQty  		  FLOAT(24) ,   
	BrpSafetyLiftQty  		  INTEGER ,  
	BrpSafetyStockQty  		  INTEGER ,  
	Reviewed  		  INTEGER CONSTRAINT DF_CaseOrdersBrp_V4_Reviewed  		  DEFAULT (0) NOT NULL,  
	ReceivedDate     INTEGER ,  
	ReceivedTime     INTEGER ,  
	ManualClosed     INTEGER   
 ) 
GO

ALTER TABLE Periscope.CaseOrdersBrp_V4 ADD CONSTRAINT Pkey_674 PRIMARY KEY (CaseOrder_Key, BRProductKey) 
CREATE INDEX i_COBRV4_BPK ON Periscope.CaseOrdersBrp_V4 (BRProductKey)
CREATE INDEX i_COBRV4_COK ON Periscope.CaseOrdersBrp_V4 (CaseOrder_Key)
exec sp_indexoption 'Periscope.CaseOrdersBrp_V4.i_COBRV4_BPK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.CaseOrdersBrp_V4.i_COBRV4_COK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.CaseOrdersExternal  
(  	
	CaseOrder_Key      INTEGER NOT NULL,  
	ExternalOrderNum   VARCHAR(64) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.CaseOrdersExternal ADD CONSTRAINT Pkey_510 PRIMARY KEY (CaseOrder_Key, ExternalOrderNum)  

GO

CREATE TABLE Periscope.CaseOrdersExternal_V4  
(  	
	CaseOrder_Key      INTEGER NOT NULL,  
	ExternalOrderNum   VARCHAR(64) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.CaseOrdersExternal_V4 ADD CONSTRAINT Pkey_673 PRIMARY KEY (CaseOrder_Key, ExternalOrderNum)  

GO

CREATE TABLE Periscope.CaseOrders_V4  
(  	
	CaseOrder_key    INT IDENTITY NOT NULL  ,   
	Store_Key        INTEGER NOT NULL ,  
	OrderTemplateKey INTEGER  ,  
	DeptNo           INTEGER NOT NULL ,  
	EffDate          INTEGER NOT NULL ,  
	EffTime          INTEGER NOT NULL ,  
	ExternalOrderNum VARCHAR(64)  ,  
	Reference        VARCHAR(64)  ,  
	CreationDate     INTEGER NOT NULL ,  
	CreationTime     INTEGER NOT NULL ,  
	ApprovedDate     INTEGER ,  
	ApprovedTime     INTEGER ,  
	InventoryDate    INTEGER ,  
	InventoryTime    INTEGER ,  
	User_Key         INTEGER ,  
	Post_Date        INTEGER  ,  
	Post_Time        INTEGER  ,  
	ClosedDate       INTEGER  ,  
	ClosedTime       INTEGER  ,  
	ExportParts      INTEGER  ,  
	ReceiveParts     INTEGER  ,  
	OrderDate      INTEGER  ,  
	OrderTime     INTEGER  ,  
	CaseOrderType       SMALLINT  ,  
	OrgCaseOrderKey      INTEGER ,  
	ExportedItems     INTEGER ,  
	ReceivedItems     INTEGER ,  
	ClosedReasonKey     INTEGER    
 ) 
GO

ALTER TABLE Periscope.CaseOrders_V4 ADD CONSTRAINT Pkey_672 PRIMARY KEY (CaseOrder_Key) 
CREATE INDEX i_CSORV4_UK ON Periscope.CaseOrders_V4 (User_Key)
CREATE INDEX i_CSORV4_SK_ED ON Periscope.CaseOrders_V4(Store_Key, EffDate)
CREATE INDEX i_CSORV4_REF   ON Periscope.CaseOrders_V4(Reference)
CREATE INDEX i_CSORV4_OTK   ON Periscope.CaseOrders_V4(OrderTemplateKey)
exec sp_indexoption 'Periscope.CaseOrders_V4.i_CSORV4_OTK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.CaseOrders_V4.i_CSORV4_UK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.CaseTypes_V4  
(  	
	CaseType_Key INT IDENTITY NOT NULL ,   
	Description  VARCHAR(100) COLLATE Latin1_General_CS_AI  ,  
	DeptNo       INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.CaseTypes_V4 ADD CONSTRAINT Pkey_364 PRIMARY KEY (CaseType_Key) 
CREATE UNIQUE INDEX i_CaTy4_Des_Dno ON Periscope.CaseTypes_V4 (Description,DeptNo)

GO

CREATE TABLE Periscope.ComplianceRuleSetProducts  
(  	
	ComplianceRuleSetKey 		 INTEGER NOT NULL,  
	Product_Key           		 INTEGER ,  
	BrProductKey           		 INTEGER   
 ) 
GO

CREATE UNIQUE INDEX i_CRSP_CPB ON Periscope.ComplianceRuleSetProducts (ComplianceRuleSetKey,Product_Key,BrProductKey)

GO

CREATE TABLE Periscope.ComplianceRuleSets  
(  	
	ComplianceRuleSetKey 		 INT IDENTITY NOT NULL ,   
	Description  						 VARCHAR(50) NOT NULL,  
	EntityType       				 CHAR(1) NOT NULL  ,  
	EntityKey     		   			 INTEGER NOT NULL ,  
	ThresholdComp    			 	 INTEGER NOT NULL ,  
	ThresholdNotComp			 		 INTEGER NOT NULL ,  
	ActualsBeforeStart			 	 INTEGER  ,  
	ActualsAfterLeadTime 		 INTEGER  ,  
	SetBeforeStart                INTEGER ,  
	SetAfterStart                INTEGER ,  
	ModifyDate                    INTEGER NOT NULL,  
	ApproveBeforeStart                INTEGER ,  
	ApproveAfterStart                INTEGER ,  
	ActualsDays                     INTEGER ,  
	ActualsBegTime_CRS                  INTEGER ,  
	ActualsEndTime_CRS                  INTEGER   
 ) 
GO

ALTER TABLE Periscope.ComplianceRuleSets ADD CONSTRAINT Pkey_679 PRIMARY KEY (ComplianceRuleSetKey) 
CREATE UNIQUE INDEX i_CRS_ETEK ON Periscope.ComplianceRuleSets (EntityType,EntityKey)

GO

CREATE TABLE Periscope.ComplianceRules  
(  	
	ComplianceRuleKey 				 INT IDENTITY NOT NULL ,   
	ComplianceRuleSetKey 		 INTEGER NOT NULL,  
	Sequence      						 INTEGER NOT NULL,  
	Description      		  	 VARCHAR(50) NOT NULL ,  
	ComplianceRule        		 VARCHAR(4000) NOT NULL ,  
	FacingMin        		 INTEGER  ,  
	FacingType        		 INTEGER  ,  
	MaxOrderSequence        		 INTEGER    
 ) 
GO

ALTER TABLE Periscope.ComplianceRules ADD CONSTRAINT Pkey_680 PRIMARY KEY (ComplianceRuleKey) 
CREATE UNIQUE INDEX i_CR_CD ON Periscope.ComplianceRules (ComplianceRuleSetKey,Description)

GO

CREATE TABLE Periscope.Consolid_Values  
(  	
	Store_Key            INTEGER NOT NULL ,  
	Product_Key          INTEGER NOT NULL ,  
	Start_Date           INTEGER NOT NULL ,  
	Promotion            CHAR(1) NOT NULL ,  
	Price                INTEGER NOT NULL ,  
	Sales_Qty            FLOAT(24)  ,   
	Sales_Amount         INTEGER  ,  
	Scale_Prod_Qty       FLOAT(24)  ,   
	Scale_Prod_Amount    INTEGER  ,  
	Discard_Qty          FLOAT(24)  ,   
	Discard_Amount       INTEGER  ,  
	Rework_Qty           FLOAT(24)  ,   
	Rework_Amount        INTEGER  ,  
	Rewrap_Out_Qty       FLOAT(24)  ,   
	Rewrap_Out_Amount    INTEGER  ,  
	Markdown_Qty         FLOAT(24)  ,   
	Markdown_Amount      INTEGER  ,  
	Markdown_FS_Amount   INTEGER  ,  
	Rewrap_In_Qty        FLOAT(24)  ,   
	Rewrap_In_Amount     INTEGER  ,  
	Case_Prod_Qty        FLOAT(24)  ,   
	Case_Prod_Amount     INTEGER  ,  
	Transfer_Qty         FLOAT(24)  ,   
	Transfer_Amount      INTEGER  ,  
	On_Hand_Qty          FLOAT(24)  ,   
	Start_Of_Day_Qty     FLOAT(24)  ,   
	Normal_Adj_Qty       FLOAT(24)  ,   
	Normal_Adj_Amount    INTEGER  ,  
	Pilferage_Adj_Qty    FLOAT(24)  ,   
	Pilferage_Adj_Amount INTEGER  ,  
	Other_Adj_Qty        FLOAT(24)  ,   
	Other_Adj_Amount     INTEGER  ,  
	Minimum				      INTEGER  ,  
	On_Hand_SpotChecked     FLOAT(24) ,   
	MerchType     	      SMALLINT CONSTRAINT DF_Consolid_Values_MerchType     	      DEFAULT (2)    
 ) 
GO

ALTER TABLE Periscope.Consolid_Values ADD CONSTRAINT Pkey_323 PRIMARY KEY (Store_Key, Product_Key, Start_Date) 
CREATE INDEX i_CV_SD_SK ON Periscope.Consolid_Values (Start_Date, Store_Key)
CREATE INDEX i_CV_PK    ON Periscope.Consolid_Values (Product_Key)
exec sp_indexoption 'Periscope.Consolid_Values.i_CV_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Consolid_Values', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Consolid_Values_Ex  
(  	
	Store_Key      INTEGER NOT NULL ,  
	Product_Key    INTEGER NOT NULL ,  
	Start_Date     INTEGER NOT NULL ,  
	Markup_Qty     FLOAT(24) ,   
	Markup_Amount  INTEGER ,  
	New_Upr_Qty    FLOAT(24) ,   
	New_Upr_Amount INTEGER ,  
	Other_Adj_Qty     FLOAT(24)  ,   
	Other_Adj_Amount  INTEGER  ,  
	Bad_Label_Qty     FLOAT(24)  ,   
	Spot_Check_Qty    FLOAT(24)  ,   
	LastSpotCheckTime INTEGER    
 ) 
GO

ALTER TABLE Periscope.Consolid_Values_Ex ADD CONSTRAINT Pkey_358 PRIMARY KEY (Store_Key, Product_Key, Start_Date) 
CREATE INDEX i_CVx_SD_SK  ON Periscope.Consolid_Values_Ex (Start_Date, Store_Key)
CREATE INDEX i_CVx_PK  ON Periscope.Consolid_Values_Ex (Product_Key)
exec sp_indexoption 'Periscope.Consolid_Values_Ex.i_CVx_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Consolid_Values_Ex', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ConversionProfiles  
(  	
	DeptNo           INTEGER ,  
	ProdGrp          INTEGER ,  
	ConversionShrink INTEGER NOT NULL  
 ) 
GO

CREATE UNIQUE INDEX i_CP_Dno_Pgr ON Periscope.ConversionProfiles(DeptNo,ProdGrp)

GO

CREATE TABLE Periscope.CountAreaRules  
(  	
	CountAreaRuleKey  			 INT IDENTITY NOT NULL ,   
	CountAreaKey  			 INTEGER NOT NULL,  
	DivisionKey							 INTEGER  ,  
	District_Key							 INTEGER  ,  
	Store_Key							 INTEGER ,  
	DeptNo							 INTEGER   
 ) 
GO

ALTER TABLE Periscope.CountAreaRules ADD CONSTRAINT Pkey_659 PRIMARY KEY (CountAreaRuleKey) 

GO

CREATE TABLE Periscope.CountAreas  
(  	
	CountAreaKey  			 INT IDENTITY NOT NULL ,   
	Description   			 VARCHAR(50) COLLATE Latin1_General_CS_AI NOT NULL ,  
	ReferenceCode 			 VARCHAR(50) ,  
	Type								 SMALLINT CONSTRAINT DF_CountAreas_Type								 DEFAULT (1) NOT NULL,  
	Active							 INTEGER NOT NULL ,  
	CostConvertFactor 							 FLOAT(24) ,   
	GrandTotalOper 						 SMALLINT   
 ) 
GO

ALTER TABLE Periscope.CountAreas ADD CONSTRAINT Pkey_658 PRIMARY KEY (CountAreaKey) 
CREATE UNIQUE INDEX i_CountArea_DTD ON Periscope.CountAreas (Description, Type)

GO

CREATE TABLE Periscope.CouponProfiles  
(  	
	CpProfile_Key INT IDENTITY NOT NULL 	 ,   
	DeptNo        INTEGER NOT NULL ,  
	Coupon_PluNo  INTEGER ,  
	Coupon_Upc    VARCHAR(12) ,  
	Value         INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.CouponProfiles ADD CONSTRAINT Pkey_311 PRIMARY KEY (CpProfile_Key) 

GO

CREATE TABLE Periscope.CutThickness  
(  	
	CutThicknessKey		  INT IDENTITY NOT NULL ,   
	Description 		  VARCHAR(10)    
 ) 
GO

ALTER TABLE Periscope.CutThickness ADD CONSTRAINT Pkey_609 PRIMARY KEY (CutThicknessKey) 

GO

CREATE TABLE Periscope.CuttingCategory  
(  	
	CuttingCat_Key  INT IDENTITY NOT NULL ,   
	Description     VARCHAR(50) NOT NULL 			   
 ) 
GO

ALTER TABLE Periscope.CuttingCategory ADD CONSTRAINT Pkey_287 PRIMARY KEY (CuttingCat_Key) 

GO

CREATE TABLE Periscope.CuttingTestProducts  
(  	
	CuttingTestKey INTEGER NOT NULL ,  
	IMPSProductNo  VARCHAR(10) NOT NULL ,  
	CutType        SMALLINT NOT NULL ,  
	Yield          INTEGER NOT NULL			   
 ) 
GO


GO

CREATE TABLE Periscope.CuttingTests  
(  	
	Product_Key  INTEGER ,  
	BRProductKey INTEGER NOT NULL ,  
	Yield        INTEGER NOT NULL ,  
	FamilyName   VARCHAR(50) NOT NULL   
 ) 
GO

CREATE INDEX i_CUTT_PK  ON Periscope.CuttingTests (Product_Key)
CREATE INDEX i_CUTT_BPK ON Periscope.CuttingTests (BRProductKey)
exec sp_indexoption 'Periscope.CuttingTests.i_CUTT_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.CuttingTests.i_CUTT_BPK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.DSS2_ExcludePeriods  
(  	
	StoreKey 	 INTEGER  ,  
	Begin_Date	 INTEGER NOT NULL ,  
	End_Date 	 INTEGER NOT NULL   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_EP_SK_BD ON Periscope.DSS2_ExcludePeriods(StoreKey, Begin_Date)
exec sp_indexoption 'Periscope.DSS2_ExcludePeriods', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.DSS2_Seasons  
(  	
	Season_Key 	 INT IDENTITY NOT NULL  ,   
	Description	 VARCHAR(50) NOT NULL ,  
	DivisionKey	 INTEGER ,  
	District_Key	 INTEGER ,  
	Store_Key		 INTEGER   
 ) 
GO

ALTER TABLE Periscope.DSS2_Seasons ADD CONSTRAINT Pkey_310 PRIMARY KEY (Season_Key) 

GO

CREATE TABLE Periscope.DSS2_SeasonsDates  
(  	
	Season_Key INTEGER NOT NULL ,  
	Begin_Date INTEGER NOT NULL ,  
	End_Date   INTEGER NOT NULL   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_DS2SD_SK  ON Periscope.DSS2_SeasonsDates (Season_Key,Begin_Date)
exec sp_indexoption 'Periscope.DSS2_SeasonsDates', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.DailyComplianceCache  
(  	
	Store_Key  	 INTEGER NOT NULL ,  
	DeptNo      	 INTEGER NOT NULL ,  
	Tran_Date		 INTEGER NOT NULL ,  
	MerchNum 		 INTEGER NOT NULL ,  
	MerchSpotcheck 		 INTEGER NOT NULL ,  
	MerchSetProd 		 INTEGER NOT NULL ,  
	MerchProduced 		 INTEGER NOT NULL ,  
	MerchNegInvt 		 INTEGER NOT NULL ,  
	TopNum 		 INTEGER NOT NULL ,  
	TopSpotcheck 		 INTEGER NOT NULL ,  
	TopSetProd  		 INTEGER NOT NULL ,  
	TopProduced  		 INTEGER NOT NULL ,  
	TopNegInvt  		 INTEGER NOT NULL ,  
	ShrinkAsPerc  	 FLOAT(24) NOT NULL ,   
	ReportUsage   	 FLOAT(24) NOT NULL ,   
	MerchSetProdNonZero 	 INTEGER CONSTRAINT DF_DailyComplianceCache_MerchSetProdNonZero 	 DEFAULT (0) NOT NULL,  
	TopSetProdNonZero   	 INTEGER CONSTRAINT DF_DailyComplianceCache_TopSetProdNonZero   	 DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.DailyComplianceCache ADD CONSTRAINT Pkey_373 PRIMARY KEY (Store_Key, Deptno, Tran_Date) 

GO

CREATE TABLE Periscope.EstimationEngines  
(  	
	Store_Key   INTEGER  ,  
	Product_Key INTEGER  ,  
	Engine     INTEGER NOT NULL ,  
	UpdateDate     INTEGER NOT NULL   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_EE_SK_PK_EN ON Periscope.EstimationEngines (Store_Key, Product_Key, Engine)
CREATE        INDEX i_EE_PK ON Periscope.EstimationEngines (Product_Key)
exec sp_indexoption 'Periscope.EstimationEngines', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ExecutionTypes  
(  	
	ExecutionKey  		 INT IDENTITY NOT NULL ,   
	Description			 VARCHAR(64) ,  
	Memo							 VARCHAR(64) ,  
	ChangeFlag			  SMALLINT CONSTRAINT DF_ExecutionTypes_ChangeFlag			  DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ExecutionTypes ADD CONSTRAINT Pkey_518 PRIMARY KEY (ExecutionKey) 

GO

CREATE TABLE Periscope.ExternalIngredients  
(  	
	ExternalIngredientKey          		 INT IDENTITY NOT NULL  ,   
	Name                       			 VARCHAR(128) NOT NULL ,  
	GramWeight                 			 FLOAT(24) NOT NULL ,   
	CommonName                 			 VARCHAR(128)  ,  
	AlternateName              		 VARCHAR(128)  ,  
	IngredientStmt              VARCHAR(4000) ,  
	IsSugar                     INTEGER ,  
	ModifyDate                  INTEGER ,  
	Notes1                      VARCHAR(128) ,  
	ProductName                 VARCHAR(128) ,  
	SupplierName                VARCHAR(128) ,  
	UserCode                    VARCHAR(128) ,  
	AddedSugars                 FLOAT(24) ,   
	Alcohol                     FLOAT(24) ,   
	Biotin                      FLOAT(24) ,   
	Calcium                     FLOAT(24) ,   
	Calories                    FLOAT(24) ,   
	CalFrmFat	          			  FLOAT(24) ,   
	CalSatFat                   FLOAT(24) ,   
	CalTransFat                 FLOAT(24) ,   
	TotalCarb                   FLOAT(24) ,   
	Chloride                    FLOAT(24) ,   
	Cholesterol                 FLOAT(24) ,   
	Choline                     FLOAT(24) ,   
	Chromium                    FLOAT(24) ,   
	Copper                      FLOAT(24) ,   
	DietFiber                   FLOAT(24) ,   
	TotalFat                    FLOAT(24) ,   
	Folate                      FLOAT(24) ,   
	FolicAcid                   FLOAT(24) ,   
	InsolFiber                  FLOAT(24) ,   
	Iodine                      FLOAT(24) ,   
	Iron                        FLOAT(24) ,   
	Magnesium                   FLOAT(24) ,   
	Manganese                   FLOAT(24) ,   
	Molybdenum                  FLOAT(24) ,   
	MonoUnsatFat                FLOAT(24) ,   
	Om3Fatty                    FLOAT(24) ,   
	Om6Fatty                    FLOAT(24) ,   
	OtherCarbs                  FLOAT(24) ,   
	PantothenicAcid             FLOAT(24) ,   
	Phosphorus                  FLOAT(24) ,   
	PolyUnsatFat                FLOAT(24) ,   
	Potassium                   FLOAT(24) ,   
	Protein                     FLOAT(24) ,   
	SaturFat                    FLOAT(24) ,   
	Selenium                    FLOAT(24) ,   
	Sodium                      FLOAT(24) ,   
	SolFiber                    FLOAT(24) ,   
	Starch                      FLOAT(24) ,   
	SugarAlco                   FLOAT(24) ,   
	TotalDietaryFiber           FLOAT(24) ,   
	TotalInsolubleFiber         FLOAT(24) ,   
	TotalSolubleFiber           FLOAT(24) ,   
	Sugars                      FLOAT(24) ,   
	TransFat                    FLOAT(24) ,   
	VitaminA_IU                 FLOAT(24) ,   
	VitaminA_RE                 FLOAT(24) ,   
	Thiamine                    FLOAT(24) ,   
	VitaminB12                  FLOAT(24) ,   
	Riboflavin                  FLOAT(24) ,   
	Niacin                      FLOAT(24) ,   
	NiacinEquiv                 FLOAT(24) ,   
	VitaminB6                   FLOAT(24) ,   
	VitaminC                    FLOAT(24) ,   
	VitaminD_IU                 FLOAT(24) ,   
	VitaminD                    FLOAT(24) ,   
	VitaminE_IU                 FLOAT(24) ,   
	VitaminE                    FLOAT(24) ,   
	VitaminK                    FLOAT(24) ,   
	Zinc                        FLOAT(24) ,   
	Bioengineered               INTEGER 	,  
	ModifyTime               INTEGER ,  
	ExportDate               INTEGER ,  
	ExportTime               INTEGER   
 ) 
GO

ALTER TABLE Periscope.ExternalIngredients ADD CONSTRAINT Pkey_704 PRIMARY KEY (ExternalIngredientKey) 
CREATE UNIQUE INDEX i_EIName ON Periscope.ExternalIngredients(Name)

GO

CREATE TABLE Periscope.FacingMinMaxOverrides  
(  	
	FacingMinMaxOverrideKey INT IDENTITY NOT NULL ,   
	Begin_Date   			 INTEGER NOT NULL ,  
	End_Date						 INTEGER NOT NULL ,  
	Description				 VARCHAR(50) COLLATE Latin1_General_CS_AI NOT NULL   
 ) 
GO

ALTER TABLE Periscope.FacingMinMaxOverrides ADD CONSTRAINT Pkey_514 PRIMARY KEY (FacingMinMaxOverrideKey) 

GO

CREATE TABLE Periscope.FacingMinMax_V4  
(  	
	DOW        SMALLINT NOT NULL ,  
	Facing_Key INTEGER NOT NULL ,  
	Minimum    INTEGER NOT NULL ,  
	Maximum    INTEGER NOT NULL ,  
	Store_Key  INTEGER NOT NULL ,  
	FacingMinMaxOverrideKey  INTEGER     
 ) 
GO

ALTER TABLE Periscope.FacingMinMax_V4 ADD CONSTRAINT Pkey_368 PRIMARY KEY (Facing_Key,Store_Key,DOW) 
CREATE INDEX i_FMX4_FK  ON Periscope.FacingMinMax_V4 (Facing_Key)
exec sp_indexoption 'Periscope.FacingMinMax_V4.i_FMX4_FK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Facings_V4  
(  	
	Facing_Key     INT IDENTITY NOT NULL ,   
	CaseLayout_Key INTEGER NOT NULL ,  
	Product_Key    INTEGER NOT NULL ,  
	Description 	  VARCHAR(50) COLLATE Latin1_General_CS_AI ,  
	Width          DECIMAL(7,2)  ,   
	Height         DECIMAL(7,2)  ,   
	Length         DECIMAL(7,2)  ,   
	OverfillFactor INTEGER ,  
	OverfillType   SMALLINT ,  
	FacingType     INTEGER NOT NULL,  
	Promotion      CHAR(1) ,  
	ItemLocation      VARCHAR(64)   
 ) 
GO

ALTER TABLE Periscope.Facings_V4 ADD CONSTRAINT Pkey_367 PRIMARY KEY (Facing_Key) 
CREATE UNIQUE INDEX i_FA4_CK_PK_Des ON Periscope.Facings_V4 (CaseLayout_Key,Product_Key,Description)
CREATE INDEX i_FA4_PK  ON Periscope.Facings_V4 (Product_Key)
CREATE INDEX i_FA4_CLK  ON Periscope.Facings_V4 (CaseLayout_Key)
exec sp_indexoption 'Periscope.Facings_V4.i_FA4_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Facings_V4.i_FA4_CLK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Forecast  
(  	
	Store_Key   INTEGER NOT NULL ,  
	Product_Key INTEGER  ,  
	EffDate     INTEGER NOT NULL ,  
	Updated     INTEGER NOT NULL ,  
	Value       FLOAT(24) NOT NULL ,   
	Variance    FLOAT(24)  ,   
	Warning     INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_FC_SK_ED_PK ON Periscope.Forecast (Store_Key, EffDate, Product_Key)
CREATE        INDEX i_FC_PK ON Periscope.Forecast (Product_Key)
CREATE        INDEX i_FC_ED ON Periscope.Forecast (EffDate)
exec sp_indexoption 'Periscope.Forecast', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.IMPSProducts  
(  	
	IMPSProductNo   VARCHAR(10) NOT NULL,  
	Description     VARCHAR(100) NOT NULL 		 ,  
	IMPSProductType INTEGER NOT NULL ,  
	ChangeFlag      SMALLINT DEFAULT 0 NOT NULL			   
 ) 
GO

ALTER TABLE Periscope.IMPSProducts ADD CONSTRAINT Pkey_600 PRIMARY KEY (IMPSProductNo) 

GO

CREATE TABLE Periscope.InStoreExecutions  
(  	
	Store_key    					 INTEGER ,  
	Product_Key    					 INTEGER ,  
	ExecutionKey    					 INTEGER ,  
	Begin_Date    					 INTEGER ,  
	End_Date    					 INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_ISE_SK_PK_EK_BD ON Periscope.InStoreExecutions (Store_key,Product_Key,ExecutionKey,Begin_Date)
exec sp_indexoption 'Periscope.InStoreExecutions.i_ISE_SK_PK_EK_BD', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.IntelliCountCache  
(  	
	CountSessionKey INT IDENTITY NOT NULL ,   
	User_Key INTEGER NOT NULL ,  
	Store_Key INTEGER NOT NULL ,  
	DeptNo INTEGER NOT NULL ,  
	CreationDate INTEGER NOT NULL ,  
	Status  SMALLINT CONSTRAINT DF_IntelliCountCache_Status  DEFAULT (0)  ,  
	CreationTime INTEGER   
 ) 
GO

ALTER TABLE Periscope.IntelliCountCache ADD CONSTRAINT Pkey_698 PRIMARY KEY (CountSessionKey) 
CREATE INDEX i_ITCC_PK ON Periscope.IntelliCountCache (User_Key,Store_Key,DeptNo, CreationDate,Status)
exec sp_indexoption 'Periscope.IntelliCountCache', N'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.IntelliCountCacheDetails  
(  	
	CountSessionDetailKey INT IDENTITY NOT NULL ,   
	CountSessionKey INTEGER ,  
	CountGroup SMALLINT NOT NULL ,  
	Product_Key INTEGER NOT NULL ,  
	BRProductKey INTEGER  ,  
	FacingDescription VARCHAR(50) COLLATE Latin1_General_CS_AI  ,  
	ItemLocation  VARCHAR(64) ,  
	On_Hand_Qty    FLOAT(24) ,   
	LastSpotCheckDate  INTEGER ,  
	LastSpotCheckTime  INTEGER ,  
	ClassType  CHAR(1) ,  
	InNextIntelliCount  SMALLINT CONSTRAINT DF_IntelliCountCacheDetails_InNextIntelliCount  DEFAULT (0)  ,  
	Spot_Check_Qty   FLOAT(24) ,   
	SpotCheckTime     INTEGER   
 ) 
GO

ALTER TABLE Periscope.IntelliCountCacheDetails ADD CONSTRAINT Pkey_699 PRIMARY KEY NONCLUSTERED (CountSessionDetailKey) 
CREATE CLUSTERED INDEX i_ICCD_CPB ON Periscope.IntelliCountCacheDetails (CountSessionKey,Product_Key,BRProductKey)
exec sp_indexoption 'Periscope.IntelliCountCacheDetails', N'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Interval_Lookup  
(  	
	Interval_Key INT IDENTITY NOT NULL  ,   
	Period_Key   INTEGER NOT NULL ,  
	Begin_Time   INTEGER NOT NULL ,  
	End_Time     INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Interval_Lookup ADD CONSTRAINT Pkey_290 PRIMARY KEY (Interval_Key) 
CREATE INDEX i_IVL_PEK ON Periscope.Interval_Lookup (Period_Key)
exec sp_indexoption 'Periscope.Interval_Lookup.i_IVL_PEK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.InventoryClass  
(  	
	Store_Key INTEGER NOT NULL ,  
	DeptNo INTEGER NOT NULL ,  
	EffDate INTEGER NOT NULL ,  
	Product_Key INTEGER NOT NULL ,  
	ClassType CHAR(1) CONSTRAINT DF_InventoryClass_ClassType DEFAULT ('C')  ,  
	AverageSales INTEGER CONSTRAINT DF_InventoryClass_AverageSales DEFAULT (0)  ,  
	AverageQty FLOAT(24) CONSTRAINT DF_InventoryClass_AverageQty DEFAULT (0)     
 ) 
GO

ALTER TABLE Periscope.InventoryClass ADD CONSTRAINT Pkey_697 PRIMARY KEY (Store_Key, DeptNo, EffDate, Product_Key) 

GO

CREATE TABLE Periscope.InvnCount  
(  	
	InvnCountKey  				 BIGINT IDENTITY NOT NULL ,   
	Store_Key   			 INTEGER NOT NULL  ,  
	DeptNo		   			 INTEGER NOT NULL ,  
	ProdGrp		 			 INTEGER  ,  
	ProductType_Key	 INTEGER  ,  
	ApplyDate		 		 INTEGER  ,  
	ApplyTime		 		 INTEGER  ,  
	Generation    		 SMALLINT NOT NULL   ,  
	Validated    		 SMALLINT ,  
	ValidatedBy    	 INTEGER   ,  
	ValidatedDate   	 INTEGER       ,  
	ValidatedTime   	 INTEGER    ,  
	IsFinancialCnt  	 SMALLINT   ,  
	ExportDate    		 INTEGER   ,  
	ExportTime    		 INTEGER   ,  
	Create_Date    		 INTEGER   ,  
	Create_Time    		 INTEGER   ,  
	ModifyDate   	 INTEGER   ,  
	ModifyTime   	 INTEGER   ,  
	StartDate 	 INTEGER  ,  
	StartTime 	 INTEGER    ,  
	IsDefault  	 SMALLINT   ,  
	TotalCount  			 INTEGER      
 ) 
GO

ALTER TABLE Periscope.InvnCount ADD CONSTRAINT Pkey_664 PRIMARY KEY NONCLUSTERED (InvnCountKey) 
CREATE UNIQUE CLUSTERED INDEX i_InvnC_SDPPGI ON Periscope.InvnCount (Store_Key,DeptNo, ProdGrp, ProductType_Key, Generation, IsFinancialCnt,IsDefault)
exec sp_indexoption 'Periscope.InvnCount', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.InvnCountDetails  
(  	
	InvnCountDetailKey  	 BIGINT IDENTITY NOT NULL ,   
	InvnCountKey  				 BIGINT NOT NULL  ,  
	Product_Key   		 INTEGER NOT NULL  ,  
	Quantity_Counted FLOAT(24) NOT NULL ,   
	On_Hand          FLOAT(24) NOT NULL ,   
	Post_Date        INTEGER NOT NULL ,  
	Post_Time        INTEGER NOT NULL ,  
	Dollar_Counted   INTEGER  ,  
	Weight           FLOAT(24)  ,   
	CountAreaKey  			 INTEGER ,  
	AdjustmentReasonKey     INTEGER    
 ) 
GO

ALTER TABLE Periscope.InvnCountDetails ADD CONSTRAINT Pkey_665 PRIMARY KEY NONCLUSTERED (InvnCountDetailKey) 
CREATE UNIQUE CLUSTERED INDEX i_InvnCD_PC ON Periscope.InvnCountDetails (InvnCountKey,Product_Key,CountAreaKey)
CREATE INDEX i_InvnCD_PDK_CAK_INV  ON Periscope.InvnCountDetails (Product_Key,CountAreaKey,InvnCountKey)
exec sp_indexoption 'Periscope.InvnCountDetails', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.LaborEfficiencies  
(  	
	LaborEffiKey					 INT IDENTITY NOT NULL  ,   
	RecipeKey		 				 INTEGER NOT NULL ,  
	LaborEffiDescription  VARCHAR(50) NOT NULL ,  
	LaborEfficiency       INTEGER NOT NULL ,  
	ThresholdUnits        INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.LaborEfficiencies ADD CONSTRAINT Pkey_625 PRIMARY KEY (LaborEffiKey) 

GO

CREATE TABLE Periscope.LaborGroupProducts  
(  	
	Product_Key   INTEGER NOT NULL ,  
	LaborGroupKey INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.LaborGroupProducts ADD CONSTRAINT Pkey_350 PRIMARY KEY (Product_Key,LaborGroupKey) 
CREATE INDEX i_LGRP_PK ON Periscope.LaborGroupProducts (Product_Key)
CREATE INDEX i_LGRP_LGK ON Periscope.LaborGroupProducts (LaborGroupKey)
exec sp_indexoption 'Periscope.LaborGroupProducts.i_LGRP_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.LaborGroupProducts.i_LGRP_LGK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.LaborGroups  
(  	
	LaborGroupKey INT IDENTITY NOT NULL  ,   
	LaborGroupNo  INTEGER NOT NULL ,  
	Description   VARCHAR(64) NOT NULL   
 ) 
GO

ALTER TABLE Periscope.LaborGroups ADD CONSTRAINT Pkey_349 PRIMARY KEY (LaborGroupKey) 
CREATE UNIQUE INDEX i_LGR_GN ON Periscope.LaborGroups (LaborGroupNo)

GO

CREATE TABLE Periscope.LaborRolesEx  
(  	
	LaborRoleKey 		 				 INTEGER NOT NULL,  
	CostClass  	 		 				 INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.LaborRolesEx ADD CONSTRAINT Pkey_692 PRIMARY KEY (LaborRoleKey) 

GO

CREATE TABLE Periscope.LaborShiftRules  
(  	
	LaborShiftRuleKey	 INT IDENTITY NOT NULL ,   
	LaborShiftKey			 INTEGER NOT NULL ,  
	DivisionKey				 INTEGER ,  
	District_Key				 INTEGER ,  
	Store_Key					 INTEGER ,  
	DeptNo							 INTEGER   
 ) 
GO

ALTER TABLE Periscope.LaborShiftRules ADD CONSTRAINT Pkey_633 PRIMARY KEY (LaborShiftRuleKey) 
CREATE UNIQUE INDEX i_LSR_LDDSD ON Periscope.LaborShiftRules (DivisionKey,District_Key,Store_Key,DeptNo)

GO

CREATE TABLE Periscope.LaborShiftTimes  
(  	
	LaborShiftTimeKey	 INT IDENTITY NOT NULL  ,   
	LaborShiftKey			 INTEGER NOT NULL ,  
	Description				 VARCHAR(50) NOT NULL ,  
	StartTime     			 INTEGER NOT NULL ,  
	End_Time     			 INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.LaborShiftTimes ADD CONSTRAINT Pkey_632 PRIMARY KEY (LaborShiftTimeKey) 

GO

CREATE TABLE Periscope.LaborShifts  
(  	
	LaborShiftKey	 INT IDENTITY NOT NULL ,   
	Description		 VARCHAR(100) NOT NULL   
 ) 
GO

ALTER TABLE Periscope.LaborShifts ADD CONSTRAINT Pkey_631 PRIMARY KEY (LaborShiftKey) 
CREATE UNIQUE INDEX i_LS_Des ON Periscope.LaborShifts (Description)

GO

CREATE TABLE Periscope.Locations  
(  	
	LocationKey 					 INT IDENTITY NOT NULL ,   
	LocationID    				 VARCHAR(20) ,  
	EntityType  					 CHAR(1) NOT NULL,  
	EntityKey						 INTEGER NOT NULL,  
	USDANo								 VARCHAR(20) ,  
	Name									 VARCHAR(50) ,  
	Address1							 VARCHAR(32) ,  
	Address2							 VARCHAR(32) ,  
	City									 VARCHAR(20) ,  
	State								 VARCHAR(20) ,  
	Zip									 VARCHAR(8) ,  
	Postal								 VARCHAR(8) ,  
	Phone								 VARCHAR(22) ,  
	Fax									 VARCHAR(22) ,  
	Country							 VARCHAR(100) ,  
	CountryNo						 INTEGER ,  
	Email									 VARCHAR(50)   
 ) 
GO

ALTER TABLE Periscope.Locations ADD CONSTRAINT Pkey_606 PRIMARY KEY (LocationKey) 

GO

CREATE TABLE Periscope.MarkdownProfiles  
(  	
	MdProfile_Key INT IDENTITY NOT NULL  ,   
	Description   VARCHAR(50)  ,  
	Method        VARCHAR(50)  ,  
	Type          VARCHAR(10)  ,  
	Value         INTEGER  ,  
	LabelMessage1 VARCHAR(40)  ,  
	LabelMessage2 VARCHAR(40)  ,  
	LabelMessage3 VARCHAR(40)  ,  
	LabelFontNo1		 INTEGER CONSTRAINT DF_MarkdownProfiles_LabelFontNo1		 DEFAULT (0)  ,  
	LabelFontSize1	 INTEGER CONSTRAINT DF_MarkdownProfiles_LabelFontSize1	 DEFAULT (0)  ,  
	LabelFontNo2		 INTEGER CONSTRAINT DF_MarkdownProfiles_LabelFontNo2		 DEFAULT (0)  ,  
	LabelFontSize2	 INTEGER CONSTRAINT DF_MarkdownProfiles_LabelFontSize2	 DEFAULT (0)  ,  
	LabelFontNo3		 INTEGER CONSTRAINT DF_MarkdownProfiles_LabelFontNo3		 DEFAULT (0)  ,  
	LabelFontSize3	 INTEGER CONSTRAINT DF_MarkdownProfiles_LabelFontSize3	 DEFAULT (0)    
 ) 
GO

ALTER TABLE Periscope.MarkdownProfiles ADD CONSTRAINT Pkey_313 PRIMARY KEY (MdProfile_Key) 

GO

CREATE TABLE Periscope.MarkdownProfiles_V4  
(  	
	MdProfile_Key INT IDENTITY NOT NULL  ,   
	Description   VARCHAR(50)  ,  
	Method        VARCHAR(50)  ,  
	Type          VARCHAR(10)  ,  
	Value         INTEGER  ,  
	LabelMessage1 VARCHAR(40)  ,  
	LabelMessage2 VARCHAR(40)  ,  
	LabelMessage3 VARCHAR(40)  ,  
	LabelFontNo1		 INTEGER CONSTRAINT DF_MarkdownProfiles_V4_LabelFontNo1		 DEFAULT (0)  ,  
	LabelFontSize1	 INTEGER CONSTRAINT DF_MarkdownProfiles_V4_LabelFontSize1	 DEFAULT (0)  ,  
	LabelFontNo2		 INTEGER CONSTRAINT DF_MarkdownProfiles_V4_LabelFontNo2		 DEFAULT (0)  ,  
	LabelFontSize2	 INTEGER CONSTRAINT DF_MarkdownProfiles_V4_LabelFontSize2	 DEFAULT (0)  ,  
	LabelFontNo3		 INTEGER CONSTRAINT DF_MarkdownProfiles_V4_LabelFontNo3		 DEFAULT (0)  ,  
	LabelFontSize3	 INTEGER CONSTRAINT DF_MarkdownProfiles_V4_LabelFontSize3	 DEFAULT (0)    
 ) 
GO

ALTER TABLE Periscope.MarkdownProfiles_V4 ADD CONSTRAINT Pkey_675 PRIMARY KEY (MdProfile_Key) 

GO

CREATE TABLE Periscope.MarkdownReasons  
(  	
	MdReason_Key INT IDENTITY NOT NULL ,   
	Description  VARCHAR(50)  ,  
	Memo         VARCHAR(32)    
 ) 
GO

ALTER TABLE Periscope.MarkdownReasons ADD CONSTRAINT Pkey_314 PRIMARY KEY (MdReason_Key) 

GO

CREATE TABLE Periscope.MarkdownRules  
(  	
	MdRule_Key    INT IDENTITY NOT NULL  ,   
	Store_Key     INTEGER NOT NULL ,  
	DeptNo        INTEGER NOT NULL ,  
	ProdGrp       INTEGER NOT NULL ,  
	MdProfile_Key INTEGER NOT NULL ,  
	District_Key  INTEGER  ,  
	DivisionKey   INTEGER  ,  
	ItemType      SMALLINT NOT NULL   
 ) 
GO

ALTER TABLE Periscope.MarkdownRules ADD CONSTRAINT Pkey_315 PRIMARY KEY (MdRule_Key) 
CREATE UNIQUE INDEX iMDR_SK_D_G_D_D_I  ON Periscope.MarkdownRules (Store_Key,DeptNo,ProdGrp,District_key,DivisionKey,ItemType)
CREATE INDEX i_MDR_MK   ON Periscope.MarkdownRules (MdProfile_Key)
CREATE INDEX i_MDR_DK   ON Periscope.MarkdownRules (District_Key)
CREATE INDEX i_MDR_DVK  ON Periscope.MarkdownRules (DivisionKey)
exec sp_indexoption 'Periscope.MarkdownRules.i_MDR_MK ', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.MarkdownRules.i_MDR_DK ', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.MarkdownRules.i_MDR_DVK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.MarkdownRules_V4  
(  	
	MdRule_Key    INT IDENTITY NOT NULL  ,   
	Store_Key     INTEGER NOT NULL ,  
	DeptNo        INTEGER NOT NULL ,  
	ProdGrp       INTEGER NOT NULL ,  
	MdProfile_Key INTEGER NOT NULL ,  
	District_Key  INTEGER  ,  
	DivisionKey   INTEGER  ,  
	ItemType      SMALLINT NOT NULL ,  
	Product_Key      INTEGER  ,  
	StoreOverride    SMALLINT   
 ) 
GO

ALTER TABLE Periscope.MarkdownRules_V4 ADD CONSTRAINT Pkey_676 PRIMARY KEY (MdRule_Key) 
CREATE UNIQUE INDEX iV4MDR_SK_D_G_D_D_I  ON Periscope.MarkdownRules_V4 (Store_Key,DeptNo,ProdGrp,District_key,DivisionKey,ItemType,Product_Key,StoreOverride)
CREATE INDEX iV4_MDR_MK   ON Periscope.MarkdownRules_V4 (MdProfile_Key)
CREATE INDEX iV4_MDR_DK   ON Periscope.MarkdownRules_V4 (District_Key)
CREATE INDEX iV4_MDR_DVK  ON Periscope.MarkdownRules_V4 (DivisionKey)
CREATE INDEX iV4_MDR_PK  ON Periscope.MarkdownRules_V4 (Product_Key)
exec sp_indexoption 'Periscope.MarkdownRules_V4.iV4_MDR_MK ', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.MarkdownRules_V4.iV4_MDR_DK ', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.MarkdownRules_V4.iV4_MDR_DVK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.MarkdownRules_V4.iV4_MDR_PK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.OrderComplEntities  
(  	
	OrderComplEntityKey INT IDENTITY NOT NULL ,   
	VendorKey INTEGER NOT NULL ,  
	DeptNo INTEGER   
 ) 
GO

ALTER TABLE Periscope.OrderComplEntities ADD CONSTRAINT Pkey_690 PRIMARY KEY (OrderComplEntityKey) 
CREATE UNIQUE INDEX i_OCE_DV ON Periscope.OrderComplEntities (DeptNo,VendorKey) 

GO

CREATE TABLE Periscope.OrderComplianceCache  
(  	
	CaseOrder_key  INTEGER NOT NULL ,  
	BRProductKey     INTEGER NOT NULL,  
	ComplianceRuleSetKey   INTEGER NOT NULL,  
	IsWithinApprRange    INTEGER NOT NULL,  
	ComplianceRuleKey            INTEGER ,  
	CreationDate                   INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.OrderComplianceCache ADD CONSTRAINT Pkey_691 PRIMARY KEY (CaseOrder_key,BRProductKey) 

GO

CREATE TABLE Periscope.OrderGroupItems  
(  	
	OrderGroupKey      INTEGER NOT NULL,  
	BrProductKey       INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.OrderGroupItems ADD CONSTRAINT Pkey_505 PRIMARY KEY (OrderGroupKey, BrProductKey) 
CREATE UNIQUE INDEX i_OGI_BPK ON Periscope.OrderGroupItems(BrProductKey)

GO

CREATE TABLE Periscope.OrderGroups  
(  	
	OrderGroupKey      INT IDENTITY NOT NULL ,   
	OrderGroupCode     VARCHAR(24) NOT NULL,  
	Description 			 VARCHAR(256)   
 ) 
GO

ALTER TABLE Periscope.OrderGroups ADD CONSTRAINT Pkey_504 PRIMARY KEY (OrderGroupKey) 
CREATE UNIQUE INDEX i_OG_OGC ON Periscope.OrderGroups (OrderGroupCode)
exec sp_indexoption 'Periscope.OrderGroups.i_OG_OGC', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.OrderSchedules  
(  	
	DivisionKey      INTEGER ,  
	District_Key     INTEGER ,  
	Store_Key        INTEGER ,  
	DeptNo           INTEGER ,  
	BrProductKey     INTEGER ,  
	OrderTemplateKey INTEGER NOT NULL,  
	ChangeFlag			  SMALLINT CONSTRAINT DF_OrderSchedules_ChangeFlag			  DEFAULT (0) NOT NULL,  
	OrderGroupKey    INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_OrdSh_DK_SK_D_BP ON Periscope.OrderSchedules (DivisionKey,District_Key,Store_Key,DeptNo,BrProductKey,OrderGroupKey)
CREATE INDEX i_ORSC_DIK ON Periscope.OrderSchedules (District_Key)
CREATE INDEX i_ORSC_BPK ON Periscope.OrderSchedules (BrProductKey)
CREATE INDEX i_ORSC_OTK ON Periscope.OrderSchedules (OrderTemplateKey)
exec sp_indexoption 'Periscope.OrderSchedules.i_ORSC_DIK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.OrderSchedules.i_ORSC_BPK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.OrderSchedules.i_ORSC_OTK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.OrderSchedules_V4  
(  	
	DivisionKey      INTEGER ,  
	District_Key     INTEGER ,  
	Store_Key        INTEGER ,  
	DeptNo           INTEGER ,  
	BrProductKey     INTEGER ,  
	OrderTemplateKey INTEGER NOT NULL,  
	ChangeFlag			  SMALLINT CONSTRAINT DF_OrderSchedules_V4_ChangeFlag			  DEFAULT (0) NOT NULL,  
	OrderGroupKey    INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_OrdShV4_DK_SK_D_BP ON Periscope.OrderSchedules_V4 (DivisionKey,District_Key,Store_Key,DeptNo,BrProductKey,OrderGroupKey,OrderTemplateKey)
CREATE INDEX i_ORSCV4_DIK ON Periscope.OrderSchedules_V4 (District_Key)
CREATE INDEX i_ORSCV4_BPK ON Periscope.OrderSchedules_V4 (BrProductKey)
CREATE INDEX i_ORSCV4_OTK ON Periscope.OrderSchedules_V4 (OrderTemplateKey)
exec sp_indexoption 'Periscope.OrderSchedules_V4', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.OrderTemplateTimes  
(  	
	OrderTemplateKey INTEGER NOT NULL ,  
	OrderDay         INTEGER NOT NULL ,  
	OrderTime        INTEGER NOT NULL ,  
	DeliveryDay      INTEGER NOT NULL ,  
	DeliveryTime     INTEGER NOT NULL ,  
	OrderTempTimeKey INT IDENTITY NOT NULL 	   
 ) 

GO

ALTER TABLE Periscope.OrderTemplateTimes ADD CONSTRAINT Pkey_338 PRIMARY KEY (OrderTempTimeKey) 
CREATE INDEX i_OTT_OTK ON Periscope.OrderTemplateTimes (OrderTemplateKey)
CREATE UNIQUE INDEX i_OTT_OTK_DD ON Periscope.OrderTemplateTimes (OrderTemplateKey,DeliveryDay)
exec sp_indexoption 'Periscope.OrderTemplateTimes', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.OrderTemplateTimes_V4  
(  	
	OrderTemplateKey INTEGER NOT NULL ,  
	OrderDay         INTEGER NOT NULL ,  
	OrderTime        INTEGER NOT NULL ,  
	DeliveryDay      INTEGER NOT NULL ,  
	DeliveryTime     INTEGER NOT NULL ,  
	OrderTempTimeKey INT IDENTITY NOT NULL 	   
 ) 

GO

ALTER TABLE Periscope.OrderTemplateTimes_V4 ADD CONSTRAINT Pkey_671 PRIMARY KEY (OrderTempTimeKey) 
CREATE INDEX i_OTTV4_OTK ON Periscope.OrderTemplateTimes_V4 (OrderTemplateKey)
CREATE UNIQUE INDEX i_OTTV4_OTK_DD ON Periscope.OrderTemplateTimes_V4 (OrderTemplateKey,DeliveryDay)
exec sp_indexoption 'Periscope.OrderTemplateTimes_V4', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.OrderTemplates  
(  	
	OrderTemplateKey INT IDENTITY NOT NULL  ,   
	Description      VARCHAR(50) NOT NULL ,  
	ChangeFlag			  SMALLINT CONSTRAINT DF_OrderTemplates_ChangeFlag			  DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.OrderTemplates ADD CONSTRAINT Pkey_339 PRIMARY KEY (OrderTemplateKey) 

GO

CREATE TABLE Periscope.OrderTemplates_V4  
(  	
	OrderTemplateKey INT IDENTITY NOT NULL  ,   
	Description      VARCHAR(50) NOT NULL ,  
	ChangeFlag			  SMALLINT CONSTRAINT DF_OrderTemplates_V4_ChangeFlag			  DEFAULT (0) NOT NULL,  
	Origin		     INTEGER ,  
	LocationKey      INTEGER NOT NULL ,  
	OrderGenerationType 		     SMALLINT CONSTRAINT DF_OrderTemplates_V4_OrderGenerationType 		     DEFAULT (1) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.OrderTemplates_V4 ADD CONSTRAINT Pkey_670 PRIMARY KEY (OrderTemplateKey) 

GO

CREATE TABLE Periscope.OrderingCatExceptions  
(  	
	BrProductKey INTEGER NOT NULL ,  
	StoreKey     INTEGER  ,  
	OrderingCat  INTEGER   
 ) 
GO

CREATE UNIQUE INDEX i_ORCE_BK_SK ON Periscope.OrderingCatExceptions (BrProductKey,StoreKey)
CREATE INDEX i_ORCE_OC ON Periscope.OrderingCatExceptions (OrderingCat)
exec sp_indexoption 'Periscope.OrderingCatExceptions.i_ORCE_OC', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.PeriPriceHistory  
(  	
	Product_key INTEGER NOT NULL ,  
	SourceLevel INTEGER ,  
	Source      INTEGER ,  
	Begin_Date  INTEGER NOT NULL ,  
	Begin_Time  INTEGER ,  
	End_Date    INTEGER NOT NULL ,  
	End_Time    INTEGER  ,  
	Amount      INTEGER  ,  
	Promotion   CHAR(1) NOT NULL ,  
	FSDPrice1   INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_PPH_P_S_S_B_B  ON Periscope.PeriPriceHistory (Product_Key,SourceLevel DESC,Source,Begin_Date,Begin_Time)
CREATE INDEX        i_PPH_S_S_B_B_E     ON Periscope.PeriPriceHistory (SourceLevel DESC,Source,Begin_Date,Begin_Time, End_Date)
CREATE INDEX        i_PPH_PK         ON Periscope.PeriPriceHistory (Product_Key)
exec sp_indexoption 'Periscope.PeriPriceHistory.i_PPH_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.PeriPriceHistory', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Period_Lookup  
(  	
	Period_Key  INT IDENTITY NOT NULL  ,   
	Begin_Date  INTEGER NOT NULL ,  
	Period_ID   SMALLINT NOT NULL ,  
	End_Date    INTEGER NOT NULL ,  
	Fiscal_Year INTEGER NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Period_Lookup ADD CONSTRAINT Pkey_289 PRIMARY KEY (Period_Key) 
CREATE INDEX i_PEL_PID ON Periscope.Period_Lookup (Period_ID)
exec sp_indexoption 'Periscope.Period_Lookup.i_PEL_PID', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Periods  
(  	
	Period_ID   SMALLINT NOT NULL ,  
	Description VARCHAR(50) NOT NULL   
 ) 
GO

ALTER TABLE Periscope.Periods ADD CONSTRAINT Pkey_281 PRIMARY KEY (Period_ID) 

GO

CREATE TABLE Periscope.PrepDetails2  
(  	
	WorksheetKey  INTEGER NOT NULL ,  
	Store_Key     INTEGER NOT NULL,  
	RecipeKey     INTEGER NOT NULL,  
	Begin_Date 	 INTEGER NOT NULL ,  
	Begin_Time 	 INTEGER NOT NULL ,  
	Quantity			 FLOAT(53) NOT NULL,   
	Status				 INTEGER ,  
	StageNum			 INTEGER   
 ) 
GO

ALTER TABLE Periscope.PrepDetails2 ADD CONSTRAINT Pkey_654 PRIMARY KEY (WorksheetKey, Store_key, RecipeKey, Begin_Date, Begin_Time) 

GO

CREATE TABLE Periscope.ProdComplianceCache  
(  	
	WorksheetKey  INTEGER NOT NULL ,  
	Store_Key     INTEGER NOT NULL,  
	Product_Key   INTEGER NOT NULL,  
	Begin_Date    INTEGER NOT NULL,  
	Begin_Time    INTEGER NOT NULL,  
	ComplianceRuleSetKey      INTEGER NOT NULL ,  
	ComplianceRuleKey            INTEGER ,  
	Sales_Qty           FLOAT(24) NOT NULL,   
	Scale_Prod_Qty           FLOAT(24) NOT NULL,   
	SetBeforeCycle             INTEGER NOT NULL,  
	SpotcheckBeforeCycle           INTEGER NOT NULL,  
	SpotcheckBeforeSet          INTEGER NOT NULL,  
	SpotcheckDate               INTEGER ,  
	SpotcheckTime               INTEGER ,  
	ActualsBegDate               INTEGER ,  
	ActualsBegTime                   INTEGER ,  
	ActualsEndDate               INTEGER ,  
	ActualsEndTime               INTEGER ,  
	CreationDate                   INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ProdComplianceCache ADD CONSTRAINT Pkey_682 PRIMARY KEY (WorksheetKey, Store_key,Product_key,Begin_Date,Begin_Time) 

GO

CREATE TABLE Periscope.ProdCycleRules_V4  
(  	
	DivisionKey  		 INTEGER  ,  
	District_Key 		 INTEGER  ,  
	Store_Key    		 INTEGER  ,  
	DeptNo       		 INTEGER  ,  
	Prodgrp      		 INTEGER  ,  
	Product_Key  		 INTEGER  ,  
	ProdCycle_Key		 INTEGER NOT NULL ,  
	SysKey						 INT IDENTITY NOT NULL    
 ) 
GO

ALTER TABLE Periscope.ProdCycleRules_V4 ADD CONSTRAINT PKEY_362 PRIMARY KEY (SysKey) 
CREATE UNIQUE INDEX iPCR4_DK_SK_D_PG_PK ON Periscope.ProdCycleRules_V4(DivisionKey,District_Key,Store_Key,DeptNo,Prodgrp,Product_Key)
CREATE INDEX i_PRCYR4_PCK ON Periscope.ProdCycleRules_V4 (ProdCycle_Key)
CREATE INDEX i_PRCYR4_PK  ON Periscope.ProdCycleRules_V4 (Product_Key)
CREATE INDEX i_PRCYR4_DK  ON Periscope.ProdCycleRules_V4 (District_Key)
exec sp_indexoption 'Periscope.ProdCycleRules_V4', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ProdCycleTimes_V4  
(  	
	ProdCycle_Key		 INTEGER NOT NULL ,  
	DOW          		 INTEGER NOT NULL ,  
	Begin_Time   		 INTEGER NOT NULL ,  
	SysKey						 INT IDENTITY NOT NULL    
 ) 

GO

ALTER TABLE Periscope.ProdCycleTimes_V4 ADD CONSTRAINT Pkey_363 PRIMARY KEY (SysKey) 
CREATE INDEX i_PRCYT4_PCK ON Periscope.ProdCycleTimes_V4 (ProdCycle_Key)
exec sp_indexoption 'Periscope.ProdCycleTimes_V4', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ProdGroupRules  
(  	
	ProdGroupRuleKey	 INT IDENTITY NOT NULL ,   
	ProdGroupKey 		 INTEGER  ,  
	DivisionKey  		 INTEGER  ,  
	District_Key 		 INTEGER  ,  
	Store_Key    		 INTEGER  ,  
	Product_Key  		 INTEGER    
 ) 
GO

ALTER TABLE Periscope.ProdGroupRules ADD CONSTRAINT Pkey_669 PRIMARY KEY (ProdGroupRuleKey) 

GO

CREATE TABLE Periscope.ProdNotSetComplCache  
(  	
	Store_Key    						 INTEGER NOT NULL,  
	Product_Key  						 INTEGER NOT NULL,  
	Begin_Date   						 INTEGER NOT NULL,  
	Begin_Time   						 INTEGER NOT NULL,  
	ProdCycle_Key           	 INTEGER NOT NULL,  
	Demand_Beg_Date           INTEGER NOT NULL,  
	Demand_Beg_Time           INTEGER NOT NULL,  
	Demand_End_Date           INTEGER NOT NULL,  
	Demand_End_Time           INTEGER NOT NULL,  
	ComplianceRuleSetKey      INTEGER  ,  
	CreationDate                   INTEGER NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ProdNotSetComplCache ADD CONSTRAINT Pkey_689 PRIMARY KEY (Store_key,Product_key,Begin_Date,Begin_Time) 

GO

CREATE TABLE Periscope.ProductType  
(  	
	ProductType_Key INT IDENTITY NOT NULL  ,   
	Description     VARCHAR(50) NOT NULL,  
	ChangeFlag			 SMALLINT CONSTRAINT DF_ProductType_ChangeFlag			 DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.ProductType ADD CONSTRAINT Pkey_280 PRIMARY KEY (ProductType_Key) 

GO

CREATE TABLE Periscope.Product_Lookup  
(  	
	Product_Key      INT IDENTITY NOT NULL  ,   
	PrimalCat_Key    INTEGER  ,  
	CuttingCat_key   INTEGER  ,  
	TrayType_Key     INTEGER  ,  
	ProductType_Key  INTEGER  ,  
	PluNo            INTEGER NOT NULL ,  
	DeptNo           INTEGER NOT NULL ,  
	UPC              VARCHAR(13) NOT NULL ,  
	LeadTime         INTEGER NOT NULL ,  
	PackagedHeight   DECIMAL(7,2)  ,   
	desc1            VARCHAR(64)  ,  
	desc2            VARCHAR(64)  ,  
	Prodgrp          INTEGER  ,  
	ProductionQty    FLOAT(24)  ,   
	Origin           INTEGER  ,  
	ConversionShrink INTEGER  ,  
	InventoryItem    INTEGER NOT NULL ,  
	Uom              VARCHAR(2) ,  
	AverageWeight    FLOAT(24) ,   
	UomOfAvgWeight   VARCHAR(2) ,  
	ForecastProdKey  INTEGER ,  
	ServePerCon      SMALLINT ,  
	ServeUomDesc     VARCHAR(64) ,  
	ShelfLife        INTEGER ,  
	ShelfLifeType    INTEGER ,  
	IMPSProductNo    VARCHAR(10) ,  
	ServingSizeDesc  VARCHAR(100) ,  
	NetWeight        INTEGER ,  
	NetWeightUom 	  VARCHAR(2) 	,  
	ServingSize      INTEGER ,  
	ServingPerContainer      VARCHAR(64) ,  
	SpotCheckMethod       SMALLINT   
 ) 
GO

ALTER TABLE Periscope.Product_Lookup ADD CONSTRAINT Pkey_288 PRIMARY KEY (Product_Key) 
CREATE UNIQUE INDEX i_PL_UPC_Orgn ON Periscope.Product_Lookup (upc,Origin)
CREATE INDEX i_PL_DeptPluno ON Periscope.Product_Lookup (Deptno, PluNo)
CREATE INDEX i_PL_TTK ON Periscope.Product_Lookup (TrayType_Key)
CREATE INDEX i_PL_PCK ON Periscope.Product_Lookup (PrimalCat_key)
CREATE INDEX i_PL_CCK ON Periscope.Product_Lookup (CuttingCat_Key)
CREATE INDEX i_PL_PTK ON Periscope.Product_Lookup (ProductType_Key)
CREATE INDEX i_PL_PGP ON Periscope.Product_Lookup (Prodgrp)
exec sp_indexoption 'Periscope.Product_Lookup.i_PL_TTK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Product_Lookup.i_PL_PCK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Product_Lookup.i_PL_CCK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Product_Lookup.i_PL_PTK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Product_Lookup.i_PL_PGP', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Product_Lookup', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Product_Trans_Log  
(  	
	ID          BIGINT IDENTITY NOT NULL  ,   
	Post_Date   INTEGER NOT NULL ,  
	Post_Time   INTEGER NOT NULL ,  
	Tran_Date   INTEGER  ,  
	Tran_Time   INTEGER  ,  
	Tran_Type   VARCHAR(4) NOT NULL ,  
	Product_Key INTEGER NOT NULL ,  
	QTY         FLOAT(24) NOT NULL ,   
	Amount      INTEGER ,  
	Store_Key   INTEGER NOT NULL ,  
	Memo        VARCHAR(256)    
 ) 
GO

ALTER TABLE Periscope.Product_Trans_Log ADD CONSTRAINT Pkey_200 PRIMARY KEY (ID) 
CREATE INDEX i_PTL_TD_SK_PK ON Periscope.Product_Trans_Log (Tran_Date, Store_Key, Product_Key)
CREATE INDEX i_PTL_PK_SK_TD ON Periscope.Product_Trans_Log (Product_Key, Store_Key, Tran_Date)
CREATE INDEX i_PTL_SK_TD_TT ON Periscope.Product_Trans_Log (Store_Key, tran_date, tran_time)
CREATE INDEX i_PTL_TD_TT ON Periscope.Product_Trans_Log (Tran_Date, Tran_Time)
exec sp_indexoption 'Periscope.Product_Trans_Log.i_PTL_PK_SK_TD', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.Product_Trans_Log', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.ProductionCycles_V4  
(  	
	ProdCycle_Key INT IDENTITY NOT NULL   ,   
	Description   VARCHAR(100) COLLATE Latin1_General_CS_AI NOT NULL,  
	ChangeFlag		 SMALLINT CONSTRAINT DF_ProductionCycles_V4_ChangeFlag		 DEFAULT (0) NOT NULL,  
	Origin		     INTEGER   
 ) 
GO

ALTER TABLE Periscope.ProductionCycles_V4 ADD CONSTRAINT Pkey_361 PRIMARY KEY (ProdCycle_Key) 
CREATE UNIQUE INDEX i_PRCY4_Des  ON Periscope.ProductionCycles_V4 (Description)

GO

CREATE TABLE Periscope.ProductionGroups  
(  	
	ProdGroupKey 					 INT IDENTITY NOT NULL  ,   
	Description		   			 VARCHAR(50) NOT NULL  ,  
	ChangeFlag 						 SMALLINT CONSTRAINT DF_ProductionGroups_ChangeFlag 						 DEFAULT (0)  ,  
	Active		 							 SMALLINT CONSTRAINT DF_ProductionGroups_Active		 							 DEFAULT (1)  ,  
	DeptNo		   						 INTEGER NOT NULL    
 ) 
GO

ALTER TABLE Periscope.ProductionGroups ADD CONSTRAINT Pkey_668 PRIMARY KEY (ProdGroupKey) 
CREATE UNIQUE INDEX i_ProdGroup_DD ON Periscope.ProductionGroups (Description, DeptNo)

GO

CREATE TABLE Periscope.ProductionOverrides  
(  	
	WorksheetKey  INTEGER NOT NULL ,  
	Store_Key     INTEGER NOT NULL,  
	Product_Key   INTEGER NOT NULL,  
	System_Recomm INTEGER ,  
	Recomm_Over   INTEGER ,  
	On_Hand       INTEGER ,  
	Begin_Date    INTEGER NOT NULL,  
	Begin_Time    INTEGER NOT NULL,  
	Promotion     CHAR(1) ,  
	SubRecipeCoef FLOAT(24) ,   
	SubRecipeDescription     VARCHAR(256) ,  
	SubRecipeUom  VARCHAR(2) ,  
	ProductionQty   INTEGER ,  
	ProdCycle_Key   INTEGER ,  
	Demand_Beg_Date INTEGER CONSTRAINT DF_ProductionOverrides_Demand_Beg_Date DEFAULT (0) NOT NULL,  
	Demand_Beg_Time INTEGER CONSTRAINT DF_ProductionOverrides_Demand_Beg_Time DEFAULT (0) NOT NULL,  
	Demand_End_Date INTEGER CONSTRAINT DF_ProductionOverrides_Demand_End_Date DEFAULT (0) NOT NULL,  
	Demand_End_Time INTEGER CONSTRAINT DF_ProductionOverrides_Demand_End_Time DEFAULT (0) NOT NULL,  
	Status				   INTEGER ,  
	SortFlag			   INTEGER ,  
	Minimum 			   INTEGER ,  
	FacingType		   INTEGER ,  
	SellableToBrpCoef FLOAT(24) ,   
	TopUp					 INTEGER CONSTRAINT DF_ProductionOverrides_TopUp					 DEFAULT (0) NOT NULL,  
	ProduceAheadQty  					 FLOAT(24) 						,   
	SafetyStockQty   					 INTEGER 						  
 ) 
GO

ALTER TABLE Periscope.ProductionOverrides ADD CONSTRAINT Pkey_508 PRIMARY KEY NONCLUSTERED (WorksheetKey, Store_key,Product_key,Begin_Date,Begin_Time) 
CREATE INDEX i_ProdOver_SK_BD ON Periscope.ProductionOverrides (Store_Key,Begin_Date)
exec sp_indexoption 'Periscope.ProductionOverrides', 'disallowpagelocks', TRUE
GO

GO

CREATE TABLE Periscope.ProductionWorksheets  
(  	
	SysKey 			 INT IDENTITY NOT NULL   ,   
	Description   VARCHAR(256) ,  
	Recomm_Date   INTEGER NOT NULL,  
	Recomm_Time   INTEGER NOT NULL,  
	Sequence    INTEGER CONSTRAINT DF_ProductionWorksheets_Sequence    DEFAULT (0)    
 ) 
GO

ALTER TABLE Periscope.ProductionWorksheets ADD CONSTRAINT Pkey_509 PRIMARY KEY (SysKey) 
CREATE UNIQUE INDEX i_PW_DTS ON Periscope.ProductionWorksheets (Recomm_Date,Recomm_Time,Sequence)

GO

CREATE TABLE Periscope.PromotionTypes  
(  	
	Promotion      CHAR(1) COLLATE Latin1_General_CS_AI NOT NULL ,  
	Store_flag     INTEGER NOT NULL ,  
	Description    VARCHAR(50)  ,  
	Promotion_Code VARCHAR(64)    
 ) 
GO

ALTER TABLE Periscope.PromotionTypes ADD CONSTRAINT Pkey_688 PRIMARY KEY (Promotion) 
CREATE TABLE Periscope.RecipeAllergen  
(  	
	RecipeKey				 INTEGER NOT NULL ,  
	AllergenTextKey	 INTEGER NOT NULL  ,  
	Value						 INTEGER CONSTRAINT DF_RecipeAllergen_Value						 DEFAULT (0)  ,  
	AdditionalValue						 INTEGER CONSTRAINT DF_RecipeAllergen_AdditionalValue						 DEFAULT (0)    
 ) 
GO

ALTER TABLE Periscope.RecipeAllergen ADD CONSTRAINT Pkey_613 PRIMARY KEY (RecipeKey, AllergenTextKey) 

GO

CREATE TABLE Periscope.RecipeDocuments  
(  	
	RecipeDocumentsKey		 INT IDENTITY NOT NULL  ,   
	RecipeKey           	 INTEGER NOT NULL  ,  
	User_ID          		 VARCHAR(255) NOT NULL ,  
	DocName           		 VARCHAR(100) NOT NULL,  
	Description         	 VARCHAR(600) ,  
	UploadedDate        	 INTEGER ,  
	UploadedTime        	 INTEGER   
 ) 
GO

ALTER TABLE Periscope.RecipeDocuments ADD CONSTRAINT Pkey_640 PRIMARY KEY (RecipeDocumentsKey) 
CREATE UNIQUE INDEX i_RecipeDocuments_RD  ON Periscope.RecipeDocuments (RecipeKey, DocName)
exec sp_indexoption 'Periscope.RecipeDocuments.i_RecipeDocuments_RD', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.RecipeIngredients  
(  	
	RecipeKey    INTEGER NOT NULL ,  
	BrProductKey INTEGER  ,  
	Quantity     FLOAT(53) NOT NULL ,   
	Uom          VARCHAR(10) NOT NULL ,  
	Memo         VARCHAR(50)  ,  
	Addon			  SMALLINT CONSTRAINT DF_RecipeIngredients_Addon			  DEFAULT (0) NOT NULL  
 ) 
GO

CREATE INDEX i_RECPI_RK ON Periscope.RecipeIngredients (RecipeKey)
CREATE INDEX i_RECPI_BPK ON Periscope.RecipeIngredients (BRProductKey)
exec sp_indexoption 'Periscope.RecipeIngredients.i_RECPI_RK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.RecipeIngredients.i_RECPI_BPK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.RecipeInstructions  
(  	
	RecipeKey   	 INTEGER NOT NULL,  
	Instructions  IMAGE ,  
	Instruction1  VARCHAR(4000) ,  
	Instruction2  VARCHAR(4000) ,  
	Instruction3  VARCHAR(4000) ,  
	Instruction4  VARCHAR(4000) ,  
	Instruction5  VARCHAR(4000)   
 ) 
GO

ALTER TABLE Periscope.RecipeInstructions ADD CONSTRAINT Pkey_643 PRIMARY KEY (RecipeKey) 

GO

CREATE TABLE Periscope.RecipeNotes  
(  	
	RecipeNotesKey  	 INT IDENTITY NOT NULL  ,   
	RecipeKey 				 INTEGER NOT NULL ,  
	User_ID           VARCHAR(255) NOT NULL ,  
	Comments		 		 	 VARCHAR(600) ,  
	ChangeDate    		 INTEGER ,  
	ChangeTime    		 INTEGER   
 ) 
GO

ALTER TABLE Periscope.RecipeNotes ADD CONSTRAINT Pkey_639 PRIMARY KEY (RecipeNotesKey) 

GO

CREATE TABLE Periscope.RecipeScenario  
(  	
	ScenarioKey			  INT IDENTITY NOT NULL ,   
	BrProductKey 		  INTEGER NOT NULL,  
	Product_Key	 		  INTEGER NOT NULL,  
	RegularPrice 		  INTEGER  ,  
	PromoPrice	  		  INTEGER  ,  
	RegularMargin 		  INTEGER  ,  
	PromoMargin	 		  INTEGER    
 ) 
GO

ALTER TABLE Periscope.RecipeScenario ADD CONSTRAINT Pkey_608 PRIMARY KEY (ScenarioKey) 

GO

CREATE TABLE Periscope.RecipeSellable  
(  	
	RecipeSellableKey INT IDENTITY NOT NULL ,   
	BrProductKey 		 INTEGER NOT NULL ,  
	Product_Key       INTEGER NOT NULL ,  
	ProductionQty     FLOAT(24) ,   
	ServePerCon       SMALLINT ,  
	ServeUomDesc      VARCHAR(64) ,  
	ServingSizeDesc   VARCHAR(100) ,  
	NetWeight        INTEGER ,  
	NetWeightUom 	  VARCHAR(2)   ,  
	ServingSize      INTEGER ,  
	ServingPerContainer      VARCHAR(64)   
 ) 
GO

ALTER TABLE Periscope.RecipeSellable ADD CONSTRAINT Pkey_607 PRIMARY KEY (RecipeSellableKey) 
CREATE  INDEX i_RcpSell_BkPk ON Periscope.RecipeSellable (Product_Key,BrProductKey)

GO

CREATE TABLE Periscope.RecipeSubTypes  
(  	
	RecipeSubTypeKey INT IDENTITY NOT NULL ,   
	Description 		  VARCHAR(64)    
 ) 
GO

ALTER TABLE Periscope.RecipeSubTypes ADD CONSTRAINT Pkey_522 PRIMARY KEY (RecipeSubTypeKey) 

GO

CREATE TABLE Periscope.Recipes  
(  	
	RecipeKey    INT IDENTITY NOT NULL  ,   
	Name         VARCHAR(50) NOT NULL ,  
	Id           VARCHAR(20) COLLATE Latin1_General_CS_AI  ,  
	Type         VARCHAR(10) NOT NULL ,  
	SubType      INTEGER  ,  
	BrProductKey INTEGER NOT NULL ,  
	Instructions VARCHAR(4000)  ,  
	Sub_SubType  VARCHAR(20)  ,  
	ProdGrp      INTEGER  ,  
	LaborCost    FLOAT(24)  ,   
	ChangeDate   INTEGER  ,  
	ChangeTime   INTEGER  ,  
	ExportDate   INTEGER  ,  
	ExportTime   INTEGER  ,  
	User_Key      INTEGER  ,  
	CookingMethod	 VARCHAR(4000)  ,  
	PackagingMethod VARCHAR(4000)  ,  
	SysGenAddtnlAllergenStmt    SMALLINT CONSTRAINT DF_Recipes_SysGenAddtnlAllergenStmt    DEFAULT (0)  ,  
	ReadyPlumExport     SMALLINT ,  
	Weight		    FLOAT(24)  ,   
	SentToScaleDate   INTEGER  ,  
	SentToScaleTime   INTEGER  ,  
	Status    SMALLINT CONSTRAINT DF_Recipes_Status    DEFAULT (0)  ,  
	FatAdjMeasure          VARCHAR(10)  ,  
	FatAdjValue            FLOAT(24) ,   
	MoistureAdjMeasure     VARCHAR(10)  ,  
	MoistureAdjValue       FLOAT(24) ,   
	NutritionChangeDate    INTEGER  ,  
	NutritionChangeTime    INTEGER    
 ) 
GO

ALTER TABLE Periscope.Recipes ADD CONSTRAINT Pkey_337 PRIMARY KEY (RecipeKey) 
CREATE UNIQUE INDEX i_RCP_ID ON Periscope.Recipes (Id)
CREATE INDEX i_RECP_BPK ON Periscope.Recipes (BRProductKey)
exec sp_indexoption 'Periscope.Recipes.i_RECP_BPK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.RecommendOver  
(  	
	Store_Key     INTEGER NOT NULL ,  
	Product_Key   INTEGER NOT NULL ,  
	Recomm_Date   INTEGER NOT NULL ,  
	Recomm_Time   INTEGER NOT NULL ,  
	System_Recomm INTEGER  ,  
	Recomm_Over   INTEGER  ,  
	On_Hand       INTEGER  ,  
	Begin_Date    INTEGER NOT NULL ,  
	Begin_Time    INTEGER NOT NULL ,  
	FacingType    INTEGER   
 ) 
GO

ALTER TABLE Periscope.RecommendOver ADD CONSTRAINT Pkey_321 PRIMARY KEY (Store_Key,Recomm_Date,Recomm_Time,Product_Key,Begin_Date,Begin_Time) 
CREATE INDEX i_ROVR_PK ON Periscope.RecommendOver (Product_Key)
exec sp_indexoption 'Periscope.RecommendOver.i_ROVR_PK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.RetailUnitCostsCache  
(  	
	Product_Key INTEGER NOT NULL ,  
	StoreKey     INTEGER  ,  
	LastUpdate   INTEGER NOT NULL ,  
	UnitCost     FLOAT(24) NOT NULL    
 ) 
GO

CREATE UNIQUE INDEX i_RUCC_PK_SK  ON Periscope.RetailUnitCostsCache(Product_Key,StoreKey)

GO

CREATE TABLE Periscope.RetailUnitCostsHistory  
(  	
	SysKey        INT IDENTITY NOT NULL  ,   
	Product_Key	 INTEGER NOT NULL ,  
	StoreKey    	 INTEGER  ,  
	Begin_Date  	 INTEGER NOT NULL ,  
	End_Date  		 INTEGER NOT NULL ,  
	UnitCost    	 FLOAT(24) NOT NULL    
 ) 
GO

ALTER TABLE Periscope.RetailUnitCostsHistory ADD CONSTRAINT Pkey_693 PRIMARY KEY (SysKey) 
CREATE INDEX i_RUCH_PK_SK_BD  ON Periscope.RetailUnitCostsHistory(Product_Key,StoreKey,Begin_Date)
exec sp_indexoption 'Periscope.RetailUnitCostsHistory.i_RUCH_PK_SK_BD', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.SalesTransHistory  
(  	
	Sales_Trans_History_Id INT IDENTITY NOT NULL  ,   
	UPC_Code 		 			 VARCHAR(13) NOT NULL ,  
	Unit_Num         	  INTEGER NOT NULL ,  
	Corp_Dept_Num    	  INTEGER NOT NULL ,  
	Trans_End_Dt     	  INTEGER  ,  
	Trans_End_Tm     	  INTEGER  ,  
	Adj_Non_Wgt_Sales_Qty  INTEGER NOT NULL ,  
	Net_Sales_Amt     	  INTEGER  ,  
	Data_Posted_Code  	  BIGINT  ,  
	Error_Text       	  VARCHAR(256) ,  
	Trans_Id   		 	  INTEGER  ,  
	Weight           	  FLOAT(24)     
 ) 
GO

ALTER TABLE Periscope.SalesTransHistory ADD CONSTRAINT Pkey_611 PRIMARY KEY (Sales_Trans_History_Id) 
CREATE TABLE Periscope.ShrinkTargetRules  
(  	
	DivisionKey  INTEGER  ,  
	District_Key INTEGER  ,  
	Store_Key    INTEGER  ,  
	DeptNo		    INTEGER  ,  
	MinVal 	    FLOAT(24)  NOT NULL ,   
	MaxVal 	    FLOAT(24)  NOT NULL ,   
	Prodgrp      INTEGER    
 ) 
GO

CREATE UNIQUE INDEX i_SHTR_DV_DTR_STK_DNO ON Periscope.ShrinkTargetRules (DivisionKey, District_Key, Store_Key, Deptno,Prodgrp)

GO

CREATE TABLE Periscope.SkewFactors  
(  	
	DivisionKey  		 INTEGER  ,  
	District_Key 		 INTEGER  ,  
	Store_Key    		 INTEGER  ,  
	DeptNo       		 INTEGER  ,  
	Prodgrp      		 INTEGER  ,  
	Product_Key  		 INTEGER  ,  
	SkewConfidenceLevel		 INTEGER NOT NULL ,  
	SkewConfidenceLevel0		 INTEGER NOT NULL ,  
	SysKey						 INT IDENTITY NOT NULL    
 ) 

GO

ALTER TABLE Periscope.SkewFactors ADD CONSTRAINT Pkey_612 PRIMARY KEY (SysKey) 
CREATE UNIQUE INDEX iSF_DK_SK_D_PG_PK ON Periscope.SkewFactors(DivisionKey,District_Key,Store_Key,DeptNo,Prodgrp,Product_Key)

GO

CREATE TABLE Periscope.SpotCheckMaster  
(  	
	SpotCheckMasterKey  INT IDENTITY NOT NULL ,   
	StoreKey       INTEGER NOT NULL,  
	DeptNo  		   INTEGER NOT NULL,  
	CreationDate   INTEGER NOT NULL,  
	CreationTime   INTEGER NOT NULL,  
	Source  			 SMALLINT CONSTRAINT DF_SpotCheckMaster_Source  			 DEFAULT (1) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.SpotCheckMaster ADD CONSTRAINT Pkey_512 PRIMARY KEY (SpotCheckMasterKey) 
CREATE UNIQUE INDEX i_SCM_SK_DNo_CD ON Periscope.SpotCheckMaster(StoreKey,DeptNo,CreationDate)

GO

CREATE TABLE Periscope.SpotCheckProducts  
(  	
	SpotCheckMasterKey INTEGER NOT NULL,  
	SeqNo					     INTEGER ,  
	Product_Key        INTEGER NOT NULL,  
	User_ID  		       VARCHAR(255) ,  
	Post_Time      		 INTEGER NOT NULL,  
	On_Hand_Qty      	 FLOAT(24) NOT NULL,   
	Quantity_Counted   FLOAT(24)    
 ) 
GO

ALTER TABLE Periscope.SpotCheckProducts ADD CONSTRAINT Pkey_513 PRIMARY KEY NONCLUSTERED (SpotCheckMasterKey, Product_Key, Post_Time) 
exec sp_indexoption 'Periscope.SpotCheckProducts', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.StoreCases_V4  
(  	
	StoreCaseKey INT IDENTITY NOT NULL ,   
	Store_Key    INTEGER  ,  
	DeptNo		    INTEGER  ,  
	CaseType_Key INTEGER NOT NULL ,  
	District_Key INTEGER  ,  
	DivisionKey  INTEGER  ,  
	StoreGroupKey INTEGER    
 ) 
GO

ALTER TABLE Periscope.StoreCases_V4 ADD CONSTRAINT Pkey_365 PRIMARY KEY (StoreCaseKey) 
CREATE UNIQUE INDEX i_STRC4_SK_CTK ON Periscope.StoreCases_V4(Store_Key, CaseType_Key)
CREATE INDEX i_STRC4_CTK ON Periscope.StoreCases_V4 (CaseType_Key)
exec sp_indexoption 'Periscope.StoreCases_V4.i_STRC4_CTK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.StoreProducts  
(  	
	StoreProduct_Key INT IDENTITY NOT NULL ,   
	Product_Key      INTEGER NOT NULL ,  
	Store_Key        INTEGER NOT NULL ,  
	Active           SMALLINT NOT NULL ,  
	MdProfile_Key    INTEGER  ,  
	PrimalCat_Key_S     INTEGER  ,  
	ProductionQty_S    FLOAT(24)  ,   
	InNextIntelliCount            SMALLINT CONSTRAINT DF_StoreProducts_InNextIntelliCount            DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.StoreProducts ADD CONSTRAINT Pkey_303 PRIMARY KEY NONCLUSTERED (StoreProduct_Key) 
CREATE UNIQUE CLUSTERED INDEX i_StrPrd ON Periscope.StoreProducts(Store_Key, Product_Key)
CREATE INDEX i_STP_PK ON Periscope.StoreProducts (Product_Key)
CREATE INDEX i_STP_MK ON Periscope.StoreProducts (MdProfile_Key)
exec sp_indexoption 'Periscope.StoreProducts.i_STP_PK', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.StoreProducts.i_STP_MK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.TieredMarkdowns  
(  	
	MdProfile_Key INTEGER NOT NULL ,  
	Max_Price     INTEGER NOT NULL ,  
	Value         INTEGER    
 ) 
GO

ALTER TABLE Periscope.TieredMarkdowns ADD CONSTRAINT Pkey_312 PRIMARY KEY (MdProfile_Key,Max_Price) 
CREATE INDEX i_TMD_MK ON Periscope.TieredMarkdowns (MdProfile_Key)
exec sp_indexoption 'Periscope.TieredMarkdowns.i_TMD_MK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.TieredMarkdowns_V4  
(  	
	MdProfile_Key INTEGER NOT NULL ,  
	Max_Price     INTEGER NOT NULL ,  
	Value         INTEGER    
 ) 
GO

ALTER TABLE Periscope.TieredMarkdowns_V4 ADD CONSTRAINT Pkey_677 PRIMARY KEY (MdProfile_Key,Max_Price) 
CREATE INDEX iV4_TMD_MK ON Periscope.TieredMarkdowns_V4 (MdProfile_Key)
exec sp_indexoption 'Periscope.TieredMarkdowns_V4.iV4_TMD_MK', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.TraySize  
(  	
	TraySizeKey		  INT IDENTITY NOT NULL ,   
	Description 		  VARCHAR(10)  ,  
	DeptNo			 		  SMALLINT    
 ) 
GO

ALTER TABLE Periscope.TraySize ADD CONSTRAINT Pkey_610 PRIMARY KEY (TraySizeKey) 

GO

CREATE TABLE Periscope.TrayType  
(  	
	TrayType_Key INT IDENTITY NOT NULL  ,   
	Description  VARCHAR(50) NOT NULL ,  
	Width        DECIMAL(7,2) NOT NULL ,   
	Length       DECIMAL(7,2) NOT NULL ,   
	Color        VARCHAR(20)    
 ) 
GO

ALTER TABLE Periscope.TrayType ADD CONSTRAINT Pkey_285 PRIMARY KEY (TrayType_Key) 

GO

CREATE TABLE Periscope.UnitsOfMeasure  
(  	
	Uom         VARCHAR(10) COLLATE Latin1_General_CS_AI NOT NULL ,  
	Description VARCHAR(64) NOT NULL ,  
	ReadOnly    INTEGER CONSTRAINT DF_UnitsOfMeasure_ReadOnly    DEFAULT (0) NOT NULL,  
	Type        CHAR(1) ,  
	ChangeFlag  SMALLINT CONSTRAINT DF_UnitsOfMeasure_ChangeFlag  DEFAULT (0) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.UnitsOfMeasure ADD CONSTRAINT Pkey_347 PRIMARY KEY (Uom) 

GO

CREATE TABLE Periscope.UomConversions  
(  	
	BrProductKey INTEGER ,  
	ToUom        VARCHAR(10) COLLATE Latin1_General_CS_AI NOT NULL ,  
	Yield        FLOAT(24) NOT NULL ,   
	FromUom      VARCHAR(10) COLLATE Latin1_General_CS_AI NOT NULL ,  
	ReadOnly     INTEGER CONSTRAINT DF_UomConversions_ReadOnly     DEFAULT (0) NOT NULL,  
	ChangeFlag   SMALLINT CONSTRAINT DF_UomConversions_ChangeFlag   DEFAULT (0) NOT NULL  
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_UOMC_BPK_TOU ON Periscope.UomConversions(BrProductKey,ToUom)
CREATE INDEX i_UOMC_TU ON Periscope.UomConversions (ToUom, BRProductKey, FromUOM, Yield, ChangeFlag) 
CREATE INDEX i_UOMC_FU ON Periscope.UomConversions (FromUom)
exec sp_indexoption 'Periscope.UomConversions.i_UOMC_TU', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.UomConversions.i_UOMC_FU', 'disallowpagelocks', TRUE
exec sp_indexoption 'Periscope.UomConversions', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.VendorProducts  
(  	
	BrProductKey INTEGER NOT NULL ,  
	ManfProdCode VARCHAR(20) NOT NULL ,  
	VendorFlag   SMALLINT ,  
	VendorKey INTEGER    
 ) 
GO

ALTER TABLE Periscope.VendorProducts ADD CONSTRAINT Pkey_354 PRIMARY KEY (BrProductKey,ManfProdCode) 
CREATE UNIQUE INDEX i_Vp_vpc ON Periscope.VendorProducts (ManfProdCode)
CREATE INDEX i_Vp_brp ON Periscope.VendorProducts (BrProductKey)
exec sp_indexoption 'Periscope.VendorProducts.i_Vp_brp', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.VendorRules  
(  	
	VendorKey INTEGER NOT NULL ,  
	DeptNo INTEGER ,  
	BrProductKey INTEGER   
 ) 
GO

CREATE UNIQUE CLUSTERED INDEX i_VR_VDB ON Periscope.VendorRules (VendorKey,DeptNo,BrProductKey)
exec sp_indexoption 'Periscope.VendorRules.i_VR_VDB', 'disallowpagelocks', TRUE

GO

CREATE TABLE Periscope.Vendors  
(  	
	VendorKey 					 INT IDENTITY NOT NULL ,   
	Name    						 VARCHAR(50) NOT NULL,  
	GS1CompanyPrefix  	 INTEGER NOT NULL,  
	GS1SerialLocIDStart INTEGER ,  
	GS1SerialLocIDLen	 INTEGER ,  
	VendorNo						 VARCHAR(32) NOT NULL  
 ) 
GO

ALTER TABLE Periscope.Vendors ADD CONSTRAINT Pkey_605 PRIMARY KEY (VendorKey) 
CREATE UNIQUE INDEX i_VDR_CmpPrfx ON Periscope.Vendors(GS1CompanyPrefix)

GO

ALTER TABLE Periscope.ArBr_Inventory ADD CONSTRAINT Fkey_309 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.ArBr_RetailPrice ADD CONSTRAINT Fkey_314 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.ArBr_Transactions ADD CONSTRAINT Fkey_307 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO


GO

ALTER TABLE Periscope.ArConsolidValues ADD CONSTRAINT Fkey_304 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.ArConsolidValuesEx ADD CONSTRAINT Fkey_358 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.ArDSS2_Forecast ADD CONSTRAINT Fkey_652 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.ArInStoreExecutions ADD CONSTRAINT Fkey_648 FOREIGN KEY (ExecutionKey) REFERENCES Periscope.ExecutionTypes(ExecutionKey) 
GO
ALTER TABLE Periscope.ArProductTransLog ADD CONSTRAINT Fkey_294 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.Ar_CaseLayouts_V4 ADD CONSTRAINT Fkey_638 FOREIGN KEY (CaseType_Key) REFERENCES Periscope.CaseTypes_V4 (CaseType_Key) 

GO

ALTER TABLE Periscope.Ar_FacingMinMax_V4 ADD CONSTRAINT Fkey_639 FOREIGN KEY (Facing_Key) REFERENCES Periscope.Ar_Facings_V4 (Facing_Key)  

GO

ALTER TABLE Periscope.Ar_Facings_V4 ADD CONSTRAINT Fkey_640 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  
ALTER TABLE Periscope.Ar_Facings_V4 ADD CONSTRAINT Fkey_641 FOREIGN KEY (CaseLayout_Key) REFERENCES Periscope.Ar_CaseLayouts_V4 (CaseLayout_Key) 

GO

ALTER TABLE Periscope.Ar_PeriPriceHistory ADD CONSTRAINT Fkey_293 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.BackroomProducts ADD CONSTRAINT Fkey_302 FOREIGN KEY (OrderingCat) REFERENCES Periscope.BackroomProducts (BRProductKey)  
ALTER TABLE Periscope.BackroomProducts ADD CONSTRAINT Fkey_349 FOREIGN KEY (Origin) REFERENCES Periscope.PeriStores (Store_Key)  
ALTER TABLE Periscope.BackroomProducts ADD CONSTRAINT Fkey_701 FOREIGN KEY (IMPSProductNo) REFERENCES Periscope.IMPSProducts (IMPSProductNo) 

GO

ALTER TABLE Periscope.Br_Allergen ADD CONSTRAINT Fkey_763 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey)  

GO

ALTER TABLE Periscope.Br_InvCountAreas ADD CONSTRAINT Fkey_353 FOREIGN KEY (CountAreaKey) REFERENCES Periscope.Br_CountAreas (CountAreaKey) 
ALTER TABLE Periscope.Br_InvCountAreas ADD CONSTRAINT Fkey_354 FOREIGN KEY (StoreKey) REFERENCES Periscope.PeriStores (Store_Key) 

GO

ALTER TABLE Periscope.Br_Inventory ADD CONSTRAINT Fkey_308 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.Br_InvnCountDetails ADD CONSTRAINT Fkey_824 FOREIGN KEY (InvnCountKey) REFERENCES Periscope.Br_InvnCount (InvnCountKey)  
ALTER TABLE Periscope.Br_InvnCountDetails ADD CONSTRAINT Fkey_825 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BrProductKey) 
ALTER TABLE Periscope.Br_InvnCountDetails ADD CONSTRAINT Fkey_826 FOREIGN KEY (CountAreaKey) REFERENCES Periscope.CountAreas (CountAreaKey) 

GO

ALTER TABLE Periscope.Br_RetailPrice ADD CONSTRAINT Fkey_313 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.Br_Transactions ADD CONSTRAINT Fkey_306 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.Br_UnitCostsCache ADD CONSTRAINT Fkey_326 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.CannibGroupProducts ADD CONSTRAINT Fkey_645 FOREIGN KEY (CannibGroupKey) REFERENCES  Periscope.CannibGroups(CannibGroupKey)  
ALTER TABLE Periscope.CannibGroupProducts ADD CONSTRAINT Fkey_646 FOREIGN KEY (Product_Key) REFERENCES  Periscope.Product_Lookup(Product_Key)  
ALTER TABLE Periscope.CaseLayouts_V4 ADD CONSTRAINT Fkey_628 FOREIGN KEY (CaseType_Key) REFERENCES Periscope.CaseTypes_V4 (CaseType_Key) 

GO

ALTER TABLE Periscope.CaseOrders ADD CONSTRAINT Fkey_327 FOREIGN KEY (OrderTemplateKey) REFERENCES Periscope.OrderTemplates (OrderTemplateKey) 
ALTER TABLE Periscope.CaseOrders ADD CONSTRAINT Fkey_330 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key) 

GO

ALTER TABLE Periscope.CaseOrdersBrp ADD CONSTRAINT Fkey_311 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 
ALTER TABLE Periscope.CaseOrdersBrp ADD CONSTRAINT Fkey_312 FOREIGN KEY (CaseOrder_Key) REFERENCES Periscope.CaseOrders (CaseOrder_Key) 

GO

ALTER TABLE Periscope.CaseOrdersBrp_V4 ADD CONSTRAINT Fkey_843 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 
ALTER TABLE Periscope.CaseOrdersBrp_V4 ADD CONSTRAINT Fkey_844 FOREIGN KEY (CaseOrder_Key) REFERENCES Periscope.CaseOrders_V4 (CaseOrder_Key) 

GO

ALTER TABLE Periscope.CaseOrdersExternal ADD CONSTRAINT Fkey_617 FOREIGN KEY (CaseOrder_Key) REFERENCES Periscope.CaseOrders(CaseOrder_Key) 
GO
ALTER TABLE Periscope.CaseOrdersExternal_V4 ADD CONSTRAINT Fkey_842 FOREIGN KEY (CaseOrder_Key) REFERENCES Periscope.CaseOrders_V4(CaseOrder_Key) 
GO
ALTER TABLE Periscope.CaseOrders_V4 ADD CONSTRAINT Fkey_840 FOREIGN KEY (OrderTemplateKey) REFERENCES Periscope.OrderTemplates_V4 (OrderTemplateKey) 
ALTER TABLE Periscope.CaseOrders_V4 ADD CONSTRAINT Fkey_841 FOREIGN KEY (User_Key) REFERENCES Periscope.Users (User_Key) 

GO

ALTER TABLE Periscope.ComplianceRuleSetProducts ADD CONSTRAINT Fkey_852 FOREIGN KEY (ComplianceRuleSetKey) REFERENCES Periscope.ComplianceRuleSets (ComplianceRuleSetKey) 
ALTER TABLE Periscope.ComplianceRuleSetProducts ADD CONSTRAINT Fkey_853 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.ComplianceRuleSetProducts ADD CONSTRAINT Fkey_870 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BrProductKey) 


GO

ALTER TABLE Periscope.ComplianceRules ADD CONSTRAINT Fkey_851 FOREIGN KEY (ComplianceRuleSetKey) REFERENCES Periscope.ComplianceRuleSets (ComplianceRuleSetKey) 

GO

ALTER TABLE Periscope.Consolid_Values ADD CONSTRAINT Fkey_303 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.Consolid_Values_Ex ADD CONSTRAINT Fkey_357 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.CountAreaRules ADD CONSTRAINT Fkey_810 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 
ALTER TABLE Periscope.CountAreaRules ADD CONSTRAINT Fkey_811 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.CountAreaRules ADD CONSTRAINT Fkey_812 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores (Store_Key) 
ALTER TABLE Periscope.CountAreaRules ADD CONSTRAINT Fkey_813 FOREIGN KEY (CountAreaKey) REFERENCES Periscope.CountAreas (CountAreaKey) 
ALTER TABLE Periscope.CuttingTests ADD CONSTRAINT Fkey_300 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.CuttingTests ADD CONSTRAINT Fkey_301 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey)  

GO

ALTER TABLE Periscope.DSS2_Seasons ADD CONSTRAINT Fkey_611 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey)  
ALTER TABLE Periscope.DSS2_Seasons ADD CONSTRAINT Fkey_612 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key)  
ALTER TABLE Periscope.DSS2_Seasons ADD CONSTRAINT Fkey_613 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores (Store_Key)  
ALTER TABLE Periscope.DSS2_SeasonsDates ADD CONSTRAINT Fkey_273 FOREIGN KEY (Season_Key) REFERENCES Periscope.DSS2_Seasons (Season_Key)  

GO

ALTER TABLE Periscope.EstimationEngines ADD CONSTRAINT Fkey_862 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.FacingMinMax_V4 ADD CONSTRAINT Fkey_624 FOREIGN KEY (Facing_Key) REFERENCES Periscope.Facings_V4 (Facing_Key) 
ALTER TABLE Periscope.FacingMinMax_V4 ADD CONSTRAINT Fkey_625 FOREIGN KEY (FacingMinMaxOverrideKey) REFERENCES  Periscope.FacingMinMaxOverrides(FacingMinMaxOverrideKey) 

GO

ALTER TABLE Periscope.Facings_V4 ADD CONSTRAINT Fkey_626 FOREIGN KEY (Product_Key)    REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.Facings_V4 ADD CONSTRAINT Fkey_627 FOREIGN KEY (CaseLayout_Key) REFERENCES Periscope.CaseLayouts_V4 (CaseLayout_Key) 

GO

ALTER TABLE Periscope.Forecast ADD CONSTRAINT Fkey_861 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.InStoreExecutions ADD CONSTRAINT Fkey_647 FOREIGN KEY (ExecutionKey) REFERENCES Periscope.ExecutionTypes(ExecutionKey) 
GO
ALTER TABLE Periscope.IntelliCountCache ADD CONSTRAINT Fkey_877 FOREIGN KEY (Store_key) REFERENCES Periscope.PeriStores (Store_key)  

GO

ALTER TABLE Periscope.IntelliCountCacheDetails ADD CONSTRAINT Fkey_878 FOREIGN KEY (CountSessionKey) REFERENCES Periscope.intelliCountCache (CountSessionKey)  

GO

ALTER TABLE Periscope.Interval_Lookup ADD CONSTRAINT Fkey_255 FOREIGN KEY (Period_Key) REFERENCES Periscope.Period_Lookup (Period_Key) 

GO

ALTER TABLE Periscope.InventoryClass ADD CONSTRAINT Fkey_875 FOREIGN KEY (Store_key) REFERENCES Periscope.PeriStores (Store_key)  
ALTER TABLE Periscope.InventoryClass ADD CONSTRAINT Fkey_876 FOREIGN KEY (Product_key) REFERENCES Periscope.Product_Lookup (Product_key)  

GO

ALTER TABLE Periscope.InvnCountDetails ADD CONSTRAINT Fkey_821 FOREIGN KEY (InvnCountKey) REFERENCES Periscope.InvnCount (InvnCountKey)  
ALTER TABLE Periscope.InvnCountDetails ADD CONSTRAINT Fkey_822 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.InvnCountDetails ADD CONSTRAINT Fkey_823 FOREIGN KEY (CountAreaKey) REFERENCES Periscope.CountAreas (CountAreaKey) 

GO

ALTER TABLE Periscope.LaborEfficiencies ADD CONSTRAINT Fkey_737 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes (RecipeKey)  

GO

ALTER TABLE Periscope.LaborGroupProducts ADD CONSTRAINT Fkey_341 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.LaborGroupProducts ADD CONSTRAINT Fkey_342 FOREIGN KEY (LaborGroupKey) REFERENCES Periscope.LaborGroups (LaborGroupKey) 

GO

ALTER TABLE Periscope.LaborRolesEx ADD CONSTRAINT Fkey_871 FOREIGN KEY (LaborRoleKey) REFERENCES Periscope.BackroomProducts (BrProductKey)   

GO

ALTER TABLE Periscope.LaborShiftRules ADD CONSTRAINT Fkey_748 FOREIGN KEY (LaborShiftKey) REFERENCES Periscope.LaborShifts (LaborShiftKey)  
ALTER TABLE Periscope.LaborShiftRules ADD CONSTRAINT Fkey_749 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey)   
ALTER TABLE Periscope.LaborShiftRules ADD CONSTRAINT Fkey_750 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key)  
ALTER TABLE Periscope.LaborShiftRules ADD CONSTRAINT Fkey_751 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores (Store_Key)   

GO

ALTER TABLE Periscope.LaborShiftTimes ADD CONSTRAINT Fkey_747 FOREIGN KEY (LaborShiftKey) REFERENCES Periscope.LaborShifts (LaborShiftKey)  

GO

ALTER TABLE Periscope.MarkdownRules ADD CONSTRAINT Fkey_278 FOREIGN KEY (MdProfile_Key) REFERENCES Periscope.MarkdownProfiles (MdProfile_Key) 
ALTER TABLE Periscope.MarkdownRules ADD CONSTRAINT Fkey_346 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.MarkdownRules ADD CONSTRAINT Fkey_347 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 

GO

ALTER TABLE Periscope.MarkdownRules_V4 ADD CONSTRAINT Fkey_845 FOREIGN KEY (MdProfile_Key) REFERENCES Periscope.MarkdownProfiles_V4 (MdProfile_Key) 
ALTER TABLE Periscope.MarkdownRules_V4 ADD CONSTRAINT Fkey_846 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.MarkdownRules_V4 ADD CONSTRAINT Fkey_847 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 
ALTER TABLE Periscope.MarkdownRules_V4 ADD CONSTRAINT Fkey_848 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.OrderComplEntities ADD CONSTRAINT Fkey_865 FOREIGN KEY (VendorKey) REFERENCES Periscope.Vendors (VendorKey) 

GO

ALTER TABLE Periscope.OrderComplianceCache ADD CONSTRAINT Fkey_866 FOREIGN KEY (ComplianceRuleSetKey) REFERENCES Periscope.ComplianceRuleSets (ComplianceRuleSetKey) 
ALTER TABLE Periscope.OrderComplianceCache ADD CONSTRAINT Fkey_867 FOREIGN KEY (ComplianceRuleKey) REFERENCES Periscope.ComplianceRules (ComplianceRuleKey) 
ALTER TABLE Periscope.OrderComplianceCache ADD CONSTRAINT Fkey_868 FOREIGN KEY (CaseOrder_key) REFERENCES Periscope.CaseOrders_V4 (CaseOrder_key) 
ALTER TABLE Periscope.OrderComplianceCache ADD CONSTRAINT Fkey_869 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.OrderGroupItems ADD CONSTRAINT Fkey_607 FOREIGN KEY (OrderGroupKey) REFERENCES  Periscope.OrderGroups(OrderGroupKey)  
ALTER TABLE Periscope.OrderGroupItems ADD CONSTRAINT Fkey_608 FOREIGN KEY (BRProductKey) REFERENCES  Periscope.BackroomProducts(BRProductKey)  
ALTER TABLE Periscope.OrderSchedules ADD CONSTRAINT Fkey_333 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 
ALTER TABLE Periscope.OrderSchedules ADD CONSTRAINT Fkey_334 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.OrderSchedules ADD CONSTRAINT Fkey_335 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 
ALTER TABLE Periscope.OrderSchedules ADD CONSTRAINT Fkey_336 FOREIGN KEY (OrderTemplateKey) REFERENCES Periscope.OrderTemplates (OrderTemplateKey) 
ALTER TABLE Periscope.OrderSchedules ADD CONSTRAINT Fkey_609 FOREIGN KEY (OrderGroupKey) REFERENCES Periscope.OrderGroups(OrderGroupKey)

GO

ALTER TABLE Periscope.OrderSchedules_V4 ADD CONSTRAINT Fkey_832 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 
ALTER TABLE Periscope.OrderSchedules_V4 ADD CONSTRAINT Fkey_833 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.OrderSchedules_V4 ADD CONSTRAINT Fkey_834 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 
ALTER TABLE Periscope.OrderSchedules_V4 ADD CONSTRAINT Fkey_835 FOREIGN KEY (OrderTemplateKey) REFERENCES Periscope.OrderTemplates_V4 (OrderTemplateKey) 
ALTER TABLE Periscope.OrderSchedules_V4 ADD CONSTRAINT Fkey_836 FOREIGN KEY (OrderGroupKey) REFERENCES Periscope.OrderGroups(OrderGroupKey)

GO

ALTER TABLE Periscope.OrderTemplateTimes ADD CONSTRAINT Fkey_328 FOREIGN KEY (OrderTemplateKey) REFERENCES Periscope.OrderTemplates (OrderTemplateKey) 

GO

ALTER TABLE Periscope.OrderTemplateTimes_V4 ADD CONSTRAINT Fkey_839 FOREIGN KEY (OrderTemplateKey) REFERENCES Periscope.OrderTemplates_V4 (OrderTemplateKey) 

GO


GO

ALTER TABLE Periscope.OrderTemplates_V4 ADD CONSTRAINT Fkey_838 FOREIGN KEY (LocationKey) REFERENCES Periscope.Locations(LocationKey)

GO

ALTER TABLE Periscope.OrderingCatExceptions ADD CONSTRAINT Fkey_350 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BrProductKey) 
ALTER TABLE Periscope.OrderingCatExceptions ADD CONSTRAINT Fkey_351 FOREIGN KEY (StoreKey) REFERENCES Periscope.PeriStores (Store_Key) 
ALTER TABLE Periscope.OrderingCatExceptions ADD CONSTRAINT Fkey_352 FOREIGN KEY (OrderingCat) REFERENCES Periscope.BackroomProducts (BrProductKey) 

GO

ALTER TABLE Periscope.PeriPriceHistory ADD CONSTRAINT Fkey_288 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.Period_Lookup ADD CONSTRAINT Fkey_254 FOREIGN KEY (Period_ID) REFERENCES Periscope.Periods (Period_ID)  

GO

ALTER TABLE Periscope.PrepDetails2 ADD CONSTRAINT Fkey_800 FOREIGN KEY (WorksheetKey) REFERENCES Periscope.ProductionWorksheets (SysKey) 
ALTER TABLE Periscope.PrepDetails2 ADD CONSTRAINT Fkey_798 FOREIGN KEY (Store_key) REFERENCES Periscope.PeriStores (Store_Key) 
ALTER TABLE Periscope.PrepDetails2 ADD CONSTRAINT Fkey_799 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes (RecipeKey) 

GO

ALTER TABLE Periscope.ProdComplianceCache ADD CONSTRAINT Fkey_854 FOREIGN KEY (ComplianceRuleSetKey) REFERENCES Periscope.ComplianceRuleSets (ComplianceRuleSetKey) 
ALTER TABLE Periscope.ProdComplianceCache ADD CONSTRAINT Fkey_855 FOREIGN KEY (ComplianceRuleKey) REFERENCES Periscope.ComplianceRules (ComplianceRuleKey) 
ALTER TABLE Periscope.ProdComplianceCache ADD CONSTRAINT Fkey_856 FOREIGN KEY (WorksheetKey) REFERENCES Periscope.ProductionWorksheets (SysKey) 

GO

ALTER TABLE Periscope.ProdCycleRules_V4 ADD CONSTRAINT Fkey_633 FOREIGN KEY (ProdCycle_Key) REFERENCES Periscope.ProductionCycles_V4 (ProdCycle_Key) 
ALTER TABLE Periscope.ProdCycleRules_V4 ADD CONSTRAINT Fkey_634 FOREIGN KEY (Product_Key)  REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.ProdCycleRules_V4 ADD CONSTRAINT Fkey_635 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.ProdCycleRules_V4 ADD CONSTRAINT Fkey_636 FOREIGN KEY (DivisionKey)  REFERENCES Periscope.Divisions (DivisionKey) 

GO

ALTER TABLE Periscope.ProdCycleTimes_V4 ADD CONSTRAINT Fkey_637 FOREIGN KEY (ProdCycle_Key) REFERENCES Periscope.ProductionCycles_V4 (ProdCycle_Key) 

GO

ALTER TABLE Periscope.ProdGroupRules ADD CONSTRAINT Fkey_827 FOREIGN KEY (ProdGroupKey) REFERENCES Periscope.ProductionGroups (ProdGroupKey)  
ALTER TABLE Periscope.ProdGroupRules ADD CONSTRAINT Fkey_828 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey)  
ALTER TABLE Periscope.ProdGroupRules ADD CONSTRAINT Fkey_829 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key)  
ALTER TABLE Periscope.ProdGroupRules ADD CONSTRAINT Fkey_830 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores (Store_Key)  
ALTER TABLE Periscope.ProdGroupRules ADD CONSTRAINT Fkey_831 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.ProdNotSetComplCache ADD CONSTRAINT Fkey_863 FOREIGN KEY (ComplianceRuleSetKey) REFERENCES Periscope.ComplianceRuleSets (ComplianceRuleSetKey) 
ALTER TABLE Periscope.ProdNotSetComplCache ADD CONSTRAINT Fkey_864 FOREIGN KEY (ProdCycle_Key) REFERENCES Periscope.ProductionCycles_V4 (ProdCycle_Key) 
GO

ALTER TABLE Periscope.Product_Lookup ADD CONSTRAINT Fkey_248 FOREIGN KEY (TrayType_Key) REFERENCES Periscope.TrayType (TrayType_Key) 
ALTER TABLE Periscope.Product_Lookup ADD CONSTRAINT Fkey_250 FOREIGN KEY (PrimalCat_key) REFERENCES Periscope.BackroomProducts (BRProductKey) 
ALTER TABLE Periscope.Product_Lookup ADD CONSTRAINT Fkey_251 FOREIGN KEY (CuttingCat_key) REFERENCES Periscope.CuttingCategory (CuttingCat_Key) 
ALTER TABLE Periscope.Product_Lookup ADD CONSTRAINT Fkey_252 FOREIGN KEY (ProductType_Key) REFERENCES Periscope.ProductType (ProductType_Key) 

ALTER TABLE Periscope.Product_Lookup ADD CONSTRAINT Fkey_700 FOREIGN KEY (IMPSProductNo) REFERENCES Periscope.IMPSProducts (IMPSProductNo) 
GO

ALTER TABLE Periscope.Product_Trans_Log ADD CONSTRAINT Fkey_253 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 

GO

ALTER TABLE Periscope.ProductionCycles_V4 ADD CONSTRAINT Fkey_704 FOREIGN KEY (Origin) REFERENCES Periscope.PeriStores (Store_Key) 

GO
ALTER TABLE Periscope.ProductionOverrides ADD CONSTRAINT Fkey_616 FOREIGN KEY (WorksheetKey) REFERENCES Periscope.ProductionWorksheets (SysKey) 

GO

ALTER TABLE Periscope.RecipeAllergen ADD CONSTRAINT Fkey_714 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes(RecipeKey)  

GO

ALTER TABLE Periscope.RecipeDocuments ADD CONSTRAINT Fkey_777 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes (RecipeKey)  

GO

ALTER TABLE Periscope.RecipeIngredients ADD CONSTRAINT Fkey_324 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes (RecipeKey) 
ALTER TABLE Periscope.RecipeIngredients ADD CONSTRAINT Fkey_325 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.RecipeInstructions ADD CONSTRAINT Fkey_778 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes (RecipeKey) 

GO

ALTER TABLE Periscope.RecipeNotes ADD CONSTRAINT Fkey_775 FOREIGN KEY (RecipeKey) REFERENCES Periscope.Recipes (RecipeKey)  

GO

ALTER TABLE Periscope.Recipes ADD CONSTRAINT Fkey_323 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 

GO

ALTER TABLE Periscope.RecommendOver ADD CONSTRAINT Fkey_287 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key)  

GO

ALTER TABLE Periscope.RetailUnitCostsCache ADD CONSTRAINT Fkey_872 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_lookup (Product_Key) 

GO

ALTER TABLE Periscope.ShrinkTargetRules ADD CONSTRAINT Fkey_642 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores (Store_Key) 
ALTER TABLE Periscope.ShrinkTargetRules ADD CONSTRAINT Fkey_643 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.ShrinkTargetRules ADD CONSTRAINT Fkey_644 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 

GO

ALTER TABLE Periscope.SkewFactors ADD CONSTRAINT Fkey_711 FOREIGN KEY (Product_Key)  REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.SkewFactors ADD CONSTRAINT Fkey_712 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.SkewFactors ADD CONSTRAINT Fkey_713 FOREIGN KEY (DivisionKey)  REFERENCES Periscope.Divisions (DivisionKey) 

GO

ALTER TABLE Periscope.SpotCheckProducts ADD CONSTRAINT Fkey_618 FOREIGN KEY (SpotCheckMasterKey) REFERENCES  Periscope.SpotCheckMaster  (SpotCheckMasterKey)  
ALTER TABLE Periscope.SpotCheckProducts ADD CONSTRAINT Fkey_619 FOREIGN KEY (Product_Key) REFERENCES  Periscope.Product_Lookup(Product_Key)  
ALTER TABLE Periscope.StoreCases_V4 ADD CONSTRAINT Fkey_629 FOREIGN KEY (CaseType_Key) REFERENCES Periscope.CaseTypes_V4 (CaseType_Key) 
ALTER TABLE Periscope.StoreCases_V4 ADD CONSTRAINT Fkey_630 FOREIGN KEY (Store_Key) REFERENCES Periscope.PeriStores (Store_Key) 
ALTER TABLE Periscope.StoreCases_V4 ADD CONSTRAINT Fkey_631 FOREIGN KEY (District_Key) REFERENCES Periscope.Districts (District_Key) 
ALTER TABLE Periscope.StoreCases_V4 ADD CONSTRAINT Fkey_632 FOREIGN KEY (DivisionKey) REFERENCES Periscope.Divisions (DivisionKey) 

GO

ALTER TABLE Periscope.StoreProducts ADD CONSTRAINT Fkey_267 FOREIGN KEY (Product_Key) REFERENCES Periscope.Product_Lookup (Product_Key) 
ALTER TABLE Periscope.StoreProducts ADD CONSTRAINT Fkey_345 FOREIGN KEY (MdProfile_Key) REFERENCES Periscope.MarkdownProfiles (MdProfile_Key) 

GO

ALTER TABLE Periscope.TieredMarkdowns ADD CONSTRAINT Fkey_281 FOREIGN KEY (MdProfile_Key) REFERENCES Periscope.MarkdownProfiles (MdProfile_Key) 

GO

ALTER TABLE Periscope.TieredMarkdowns_V4 ADD CONSTRAINT Fkey_849 FOREIGN KEY (MdProfile_Key) REFERENCES Periscope.MarkdownProfiles_V4 (MdProfile_Key) 

GO

ALTER TABLE Periscope.UomConversions ADD CONSTRAINT Fkey_322 FOREIGN KEY (BRProductKey) REFERENCES Periscope.BackroomProducts (BRProductKey) 
ALTER TABLE Periscope.UomConversions ADD CONSTRAINT Fkey_331 FOREIGN KEY (ToUom) REFERENCES Periscope.UnitsOfMeasure (Uom) 
ALTER TABLE Periscope.UomConversions ADD CONSTRAINT Fkey_332 FOREIGN KEY (FromUom) REFERENCES Periscope.UnitsOfMeasure (Uom) 

GO

ALTER TABLE Periscope.VendorProducts ADD CONSTRAINT Fkey_348 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BrProductKey) 
ALTER TABLE Periscope.VendorProducts ADD CONSTRAINT Fkey_805 FOREIGN KEY (VendorKey) REFERENCES Periscope.Vendors (VendorKey) 

GO

ALTER TABLE Periscope.VendorRules ADD CONSTRAINT Fkey_807 FOREIGN KEY (BrProductKey) REFERENCES Periscope.BackroomProducts (BrProductKey) 
ALTER TABLE Periscope.VendorRules ADD CONSTRAINT Fkey_808 FOREIGN KEY (VendorKey) REFERENCES Periscope.Vendors (VendorKey) 

GO

GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.PLUMaster to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.Departments to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.ProductGroups to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.Stores to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.PLUPriceHistory to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.FieldCodes to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.NutriMaster to Periscope
GRANT SELECT,INSERT,DELETE,UPDATE ON Plum.IngrMaster to Periscope
GO

CREATE VIEW Periscope.vBackrmProd_Sku WITH SCHEMABINDING AS SELECT Sku FROM Periscope.BackroomProducts WHERE Sku IS NOT NULL
GO
CREATE UNIQUE CLUSTERED INDEX i_vBp_Sku ON Periscope.vBackrmProd_Sku (Sku)

GO

CREATE VIEW Periscope.vPLUMaster AS SELECT * FROM  Plum.PLUMaster WHERE BatchNo = 0

GO

CREATE VIEW Periscope.vDepartments AS SELECT * FROM Plum.Departments

GO

CREATE VIEW Periscope.vProductGroups AS SELECT * FROM  Plum.ProductGroups

GO

CREATE VIEW Periscope.vStores AS SELECT * FROM Plum.Stores

GO

CREATE VIEW Periscope.vPLUPriceHistory AS SELECT * FROM Plum.PLUPriceHistory

GO


-- Creating Tables and constraints 

CREATE TABLE FreshTrax.Ar_GrindEndProducts  
(  	
	GrindEndProductKey  INTEGER NOT NULL,  
	GrindTransactionKey INTEGER NOT NULL,  
	Product_Key 	   	  INTEGER NOT NULL,  
	Amount 	            INTEGER ,  
	CurrUp 	            INTEGER ,  
	ActionCode          CHAR(1) CONSTRAINT DF_Ar_GrindEndProducts_ActionCode          DEFAULT ('a')  ,  
	Initials            VARCHAR(10) ,  
	User_Key            INTEGER ,  
	Tran_Date           INTEGER NOT NULL,  
	Tran_Time           FLOAT(24) NOT NULL,   
	PkgWeight           FLOAT(53) ,   
	UPC								  VARCHAR(13) ,  
	PluNo							  INTEGER ,  
	Reference           INTEGER   
 ) 
GO


GO

CREATE TABLE FreshTrax.Ar_GrindSource  
(  	
	GrindSourceKey      INTEGER NOT NULL,  
	GrindTransactionKey INTEGER NOT NULL,  
	BRProductKey        INTEGER ,  
	TranOrigin          INTEGER ,  
	ActionCode          CHAR(1) CONSTRAINT DF_Ar_GrindSource_ActionCode          DEFAULT ('a')  ,  
	BoxWeight           FLOAT(53) ,   
	BoxWeightUom        VARCHAR(2) ,  
	ApprWeight          FLOAT(53) ,   
	ApprWeightUom       VARCHAR(2) ,  
	ManfProdCode        VARCHAR(13) ,  
	LotNo               VARCHAR(20) ,  
	SerialNo            VARCHAR(20) ,  
	USDANo              VARCHAR(20) ,  
	COOLNo              INTEGER ,  
	Initials            VARCHAR(10) ,  
	User_Key            INTEGER ,  
	ProductionDate      INTEGER ,  
	SellByDate          INTEGER ,  
	PackagingDate       INTEGER ,  
	ExpiryDate          INTEGER ,  
	Tran_Date           INTEGER NOT NULL,  
	Tran_Time           FLOAT(24) NOT NULL,   
	PurgeWeight         FLOAT(53) ,   
	PurgeWeightUom      VARCHAR(2) ,  
	MarketTrimWeight    FLOAT(53) ,   
	MarketTrimWeightUom VARCHAR(2) ,  
	FatWeight  				  FLOAT(53) ,   
	FatWeightUom  		  VARCHAR(2) ,  
	BoneWeight  			  FLOAT(53) ,   
	BoneWeightUom 		  VARCHAR(2) ,  
	Reference           INTEGER ,  
	VendorKey           INTEGER ,  
	SourceKey           INTEGER   
 ) 
GO

ALTER TABLE FreshTrax.Ar_GrindSource ADD CONSTRAINT Pkey_604 PRIMARY KEY (GrindSourceKey) 

GO

CREATE TABLE FreshTrax.Ar_GrindTransactions  
(  	
	GrindTransactionKey	 INTEGER NOT NULL			,  
	StoreKey						 INTEGER NOT NULL			,  
	Deptno 			    		 INTEGER 			,  
	LineNumber       		 INTEGER 			,  
	Tran_Date  	  			 INTEGER NOT NULL			,  
	Tran_Time        		 FLOAT(24) NOT NULL			,   
	Tran_Type      			 INTEGER 			,  
	GrindNo  	  				 INTEGER 			,  
	BinNo   						 VARCHAR(10) 			,  
	BinWeight     			 FLOAT(53) 			,   
	BinWeightUom         VARCHAR(2) 			,  
	ReadMark      			 SMALLINT NOT NULL			,  
	FirstScanFlag   		 SMALLINT 			,  
	ManualEntryFlag      SMALLINT 			,  
	ConfirmedCleanFlag   SMALLINT 			,  
	CatchupFlag   			 SMALLINT 			,  
	TransferDestinationNo INTEGER 			,  
	Initials          	  VARCHAR(10) 			,  
	User_Key              INTEGER 			,  
	Status            	  INTEGER CONSTRAINT DF_Ar_GrindTransactions_Status            	  DEFAULT (0)  ,  
	ActionCode         	  CHAR(1) CONSTRAINT DF_Ar_GrindTransactions_ActionCode         	  DEFAULT ('a')  ,  
	LastSeqNo				  	  SMALLINT 			,  
	FatPercent  					 INTEGER 			,  
	MainKey	    				  INTEGER 			,  
	PartialGrind       	  INTEGER CONSTRAINT DF_Ar_GrindTransactions_PartialGrind       	  DEFAULT (0)    
 ) 
GO

ALTER TABLE FreshTrax.Ar_GrindTransactions ADD CONSTRAINT Pkey_502 PRIMARY KEY (GrindTransactionKey) 

GO

CREATE TABLE FreshTrax.GrindEndProducts  
(  	
	GrindEndProductKey 	 INT IDENTITY NOT NULL ,   
	GrindTransactionKey	 INTEGER NOT NULL,  
	Product_Key					 INTEGER NOT NULL,  
	Amount							 INTEGER ,  
	CurrUp							 INTEGER ,  
	ActionCode					 CHAR(1) CONSTRAINT DF_GrindEndProducts_ActionCode					 DEFAULT ('a')  ,  
	Initials						 VARCHAR(10) ,  
	User_Key						 INTEGER ,  
	Tran_Date						 INTEGER NOT NULL,  
	Tran_Time						 FLOAT(24) NOT NULL,   
	PkgWeight						 FLOAT(53) ,   
	UPC									 VARCHAR(13) ,  
	PluNo								 INTEGER ,  
	Reference            INTEGER   
 ) 
GO

ALTER TABLE FreshTrax.GrindEndProducts ADD CONSTRAINT Pkey_661 PRIMARY KEY (GrindEndProductKey) 

GO

CREATE TABLE FreshTrax.GrindSource  
(  	
	GrindSourceKey      INT IDENTITY NOT NULL ,   
	GrindTransactionKey INTEGER NOT NULL,  
	BRProductKey        INTEGER ,  
	TranOrigin          INTEGER ,  
	ActionCode          CHAR(1) CONSTRAINT DF_GrindSource_ActionCode          DEFAULT ('a')  ,  
	BoxWeight           FLOAT(53) ,   
	BoxWeightUom        VARCHAR(2) ,  
	ApprWeight          FLOAT(53) ,   
	ApprWeightUom       VARCHAR(2) ,  
	ManfProdCode        VARCHAR(13) ,  
	LotNo               VARCHAR(20) ,  
	SerialNo            VARCHAR(20) ,  
	USDANo              VARCHAR(20) ,  
	COOLNo              INTEGER ,  
	Initials            VARCHAR(10) ,  
	User_Key            INTEGER ,  
	ProductionDate      INTEGER ,  
	SellByDate          INTEGER ,  
	PackagingDate       INTEGER ,  
	ExpiryDate          INTEGER ,  
	Tran_Date           INTEGER NOT NULL,  
	Tran_Time           FLOAT(24) NOT NULL,   
	PurgeWeight         FLOAT(53) ,   
	PurgeWeightUom      VARCHAR(2) ,  
	MarketTrimWeight    FLOAT(53) ,   
	MarketTrimWeightUom VARCHAR(2) ,  
	FatWeight  				  FLOAT(53) ,   
	FatWeightUom  		  VARCHAR(2) ,  
	BoneWeight  			  FLOAT(53) ,   
	BoneWeightUom 		  VARCHAR(2) ,  
	Reference           INTEGER ,  
	VendorKey           INTEGER ,  
	SourceKey           INTEGER   
 ) 
GO

ALTER TABLE FreshTrax.GrindSource ADD CONSTRAINT Pkey_603 PRIMARY KEY (GrindSourceKey) 

GO

CREATE TABLE FreshTrax.GrindTransactions  
(  	
	GrindTransactionKey	 INT IDENTITY NOT NULL 			,   
	StoreKey						 INTEGER NOT NULL			,  
	Deptno 			    		 INTEGER 			,  
	LineNumber       		 INTEGER 			,  
	Tran_Date  	  			 INTEGER NOT NULL			,  
	Tran_Time        		 FLOAT(24) NOT NULL			,   
	Tran_Type      			 INTEGER 			,  
	GrindNo  	  				 INTEGER 			,  
	BinNo   						 VARCHAR(10) 			,  
	BinWeight     			 FLOAT(53) 			,   
	BinWeightUom         VARCHAR(2) 			,  
	ReadMark      			 SMALLINT NOT NULL			,  
	FirstScanFlag   		 SMALLINT 			,  
	ManualEntryFlag      SMALLINT 			,  
	ConfirmedCleanFlag   SMALLINT 			,  
	CatchupFlag   			 SMALLINT 			,  
	TransferDestinationNo INTEGER 			,  
	Initials          	  VARCHAR(10) 			,  
	User_Key              INTEGER 			,  
	Status            	  INTEGER CONSTRAINT DF_GrindTransactions_Status            	  DEFAULT (0)  ,  
	ActionCode         	  CHAR(1) CONSTRAINT DF_GrindTransactions_ActionCode         	  DEFAULT ('a')  ,  
	LastSeqNo				  	  SMALLINT 			,  
	FatPercent  				  INTEGER 			,  
	MainKey	    				  INTEGER 			,  
	PartialGrind       	  INTEGER CONSTRAINT DF_GrindTransactions_PartialGrind       	  DEFAULT (0)    
 ) 
GO

ALTER TABLE FreshTrax.GrindTransactions ADD CONSTRAINT Pkey_501 PRIMARY KEY (GrindTransactionKey) 

GO

ALTER TABLE FreshTrax.Ar_GrindEndProducts ADD CONSTRAINT Fkey_604 FOREIGN KEY (GrindTransactionKey) REFERENCES FreshTrax.Ar_GrindTransactions (GrindTransactionKey)  

GO

ALTER TABLE FreshTrax.GrindEndProducts ADD CONSTRAINT Fkey_601 FOREIGN KEY (GrindTransactionKey) REFERENCES FreshTrax.GrindTransactions (GrindTransactionKey)  

GO

ALTER TABLE FreshTrax.GrindSource ADD CONSTRAINT Fkey_605 FOREIGN KEY (GrindTransactionKey) REFERENCES FreshTrax.GrindTransactions (GrindTransactionKey)  
GO
ALTER TABLE FreshTrax.GrindSource ADD CONSTRAINT Fkey_705 FOREIGN KEY (VendorKey) REFERENCES Periscope.Vendors (VendorKey)  
GO
ALTER TABLE FreshTrax.GrindSource ADD CONSTRAINT Fkey_707 FOREIGN KEY (SourceKey) REFERENCES FreshTrax.GrindTransactions (GrindTransactionKey)  

GO

ALTER TABLE FreshTrax.GrindTransactions ADD CONSTRAINT Fkey_706 FOREIGN KEY (MainKey) REFERENCES FreshTrax.GrindTransactions (GrindTransactionKey)  
GO

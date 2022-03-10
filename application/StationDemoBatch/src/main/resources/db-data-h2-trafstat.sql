DROP TABLE IF EXISTS TRAF_STAT;
CREATE TABLE TRAF_STAT (
	TRAF_IDEN integer primary key auto_increment not null,
	TRAF_RESE varchar(16) not null ,
	TRAF_STAT varchar(128) not null ,
	TRAF_TRAF bigint not null ,
	TRAF_CORR varchar(128),
	TRAF_VILL varchar(128) not null,
	TRAF_ARRO integer
);
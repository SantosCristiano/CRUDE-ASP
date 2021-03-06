﻿CREATE TABLE [portal].[DataViewField] (
    [ViewID]                INT             NOT NULL,
    [FieldID]               INT             IDENTITY (1, 1) NOT NULL,
    [FieldLabel]            NVARCHAR (300)  NOT NULL,
    [FieldSource]           NVARCHAR (300)  NULL,
    [FieldType]             NVARCHAR (50)   NOT NULL,
    [FieldFlags]            INT             CONSTRAINT [DF_DataViewField_FieldFlags] DEFAULT ((1)) NOT NULL,
    [FieldOrder]            INT             CONSTRAINT [DF_DataViewField_FieldOrder] DEFAULT ((1)) NOT NULL,
    [DefaultValue]          NVARCHAR (1000) NULL,
    [MaxLength]             INT             NULL,
    [UriPath]               NVARCHAR (1000) NULL,
    [UriStyle]              INT             CONSTRAINT [DF_DataViewField_UriStyle] DEFAULT ((1)) NULL,
    [LinkedTable]           NVARCHAR (300)  NULL,
    [LinkedTableGroupField] NVARCHAR (300)  NULL,
    [LinkedTableTitleField] NVARCHAR (300)  NULL,
    [LinkedTableValueField] NVARCHAR (300)  NULL,
    [LinkedTableAddition]   NVARCHAR (1000) NULL,
    [Width]                 INT             NULL,
    [Height]                INT             NULL,
	[FieldDescription]		NVARCHAR (4000) NULL,
    CONSTRAINT [PK_DataViewField] PRIMARY KEY CLUSTERED ([ViewID] ASC, [FieldID] ASC),
    CONSTRAINT [FK_DataViewField_DataView] FOREIGN KEY ([ViewID]) REFERENCES [portal].[DataView] ([ViewID]) ON DELETE CASCADE
);


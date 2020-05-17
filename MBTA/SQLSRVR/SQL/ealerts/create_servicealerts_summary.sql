USE [thetweb]
GO
/****** Object:  Table [dbo].[ServiceAlerts_Summary]    Script Date: 02/01/2011 11:57:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServiceAlerts_Summary](
	[Mode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Route] [nvarchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Alert_Count] [int] NULL,
	[Advisory_Count] [int] NULL,
	[Snow_Route] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
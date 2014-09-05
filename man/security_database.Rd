\name{security_database}
\title{Create an auxiliary database that handles sensitive values.}

\description{
The SQL code below adds schemas, a table and two stored procedures to an existing Microsoft SQL Database. 
}
\details{
This database contains the tokens and other sensitive content (such as passwords, API tokens, and file paths) that cannot be stored in a Git repository (even a private Git repository).  These passwords can be retrieved by \code{\link{retrieve_token_mssql}}.

After executing the SQL code in an existing database, create an ODBC DSN (data source name) to \emph{each} client machine that calls the database.  Download the most recent drivers, then run the wizard.  Many values will remain at the default values.  Here are the important ones to change.
\enumerate{
  \item Set the DSN's \code{name} to whatever is used in the repository's R code.
  \item Set the authenicity method to \code{Inegrated Windows authentication}.
  \item Set the \code{default database} to the name of the database that you just executed the SQL code in.
}

We use Microsoft SQL Server, because that fits our University's infrastructure the easiest.  But this approach theoretically can work with any LDAP-enabled database server.  If your institution is using something else, and would like help adapting this approach to your infrastructure, please contact us.
}
\examples{
\dontrun{
------- SQL code to create necessary components in a Microsoft SQL Sever database -------
--
-- Create two schemas.  
-- The first scehma is accessible by all REDCap API users. 
-- The second scehma is restricted to administrators.
--
CREATE SCHEMA [Redcap]
CREATE SCHEMA [RedcapPrivate]
GO

--
-- Create a table to contain the token
--
CREATE TABLE [RedcapPrivate].[tblToken](
  [ID] [smallint] IDENTITY(1,1) NOT NULL,
  [Username] [varchar](30) NOT NULL,
  [RedcapProjectName] [varchar](90) NOT NULL,
  [RedcapProjectID] [smallint] NOT NULL,
  [Token] [char](32) NOT NULL,
 CONSTRAINT [PK_RedcapApiTokens] PRIMARY KEY CLUSTERED(
  [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tblToken_UniqueUsernameProjectID] ON [RedcapPrivate].[tblToken](
  [Username] ASC,
  [RedcapProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, 
  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_tblToken_UniqueUsernameProjectName] ON [RedcapPrivate].[tblToken](
  [Username] ASC,
  [RedcapProjectName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, 
  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--
-- Create a stored procedure for users to call to retrieve the token.
-- Notice it has a different (and more permissive) schema than the table.
--
CREATE PROCEDURE [Redcap].[prcToken]
  @RedcapProjectName varchar(30) -- Add the parameters for the stored procedure here
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
  SET NOCOUNT ON; 

  SELECT Token FROM [RedcapPrivate].[tblToken]
  WHERE Username=system_user AND RedcapProjectName=@RedcapProjectName
END
}
}
\author{
Will Beasley
}

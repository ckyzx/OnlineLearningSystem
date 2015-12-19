/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2015/12/3 10:02:24                           */
/*==============================================================*/

USE OLS;

GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Department_Role') and o.name = 'FK_DEPARTME_DR_D_DEPARTME')
alter table Department_Role
   drop constraint FK_DEPARTME_DR_D_DEPARTME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Department_Role') and o.name = 'FK_DEPARTME_DR_R_ROLES')
alter table Department_Role
   drop constraint FK_DEPARTME_DR_R_ROLES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperQuestions') and o.name = 'FK_EXAMINAT_EQ_EP_EXAMINAT')
alter table ExaminationPaperQuestions
   drop constraint FK_EXAMINAT_EQ_EP_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperTemplateQuestions') and o.name = 'FK_EXAMINAT_EPTQ_EPT_EXAMINAT')
alter table ExaminationPaperTemplateQuestions
   drop constraint FK_EXAMINAT_EPTQ_EPT_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperTemplates') and o.name = 'FK_EXAMINAT_EPT_ET_EXAMINAT')
alter table ExaminationPaperTemplates
   drop constraint FK_EXAMINAT_EPT_ET_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPapers') and o.name = 'FK_EXAMINAT_EP_EPT_EXAMINAT')
alter table ExaminationPapers
   drop constraint FK_EXAMINAT_EP_EPT_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Permissions') and o.name = 'FK_PERMISSI_P_PC_PERMISSI')
alter table Permissions
   drop constraint FK_PERMISSI_P_PC_PERMISSI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Questions') and o.name = 'FK_QUESTION_Q_QC_QUESTION')
alter table Questions
   drop constraint FK_QUESTION_Q_QC_QUESTION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Role_Permission') and o.name = 'FK_ROLE_PER_RP_P_PERMISSI')
alter table Role_Permission
   drop constraint FK_ROLE_PER_RP_P_PERMISSI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Role_Permission') and o.name = 'FK_ROLE_PER_RP_R_ROLES')
alter table Role_Permission
   drop constraint FK_ROLE_PER_RP_R_ROLES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Department') and o.name = 'FK_USER_DEP_UD_D_DEPARTME')
alter table User_Department
   drop constraint FK_USER_DEP_UD_D_DEPARTME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Department') and o.name = 'FK_USER_DEP_UD_U_USERS')
alter table User_Department
   drop constraint FK_USER_DEP_UD_U_USERS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Role') and o.name = 'FK_USER_ROL_UR_R_ROLES')
alter table User_Role
   drop constraint FK_USER_ROL_UR_R_ROLES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Role') and o.name = 'FK_USER_ROL_UR_U_USERS')
alter table User_Role
   drop constraint FK_USER_ROL_UR_U_USERS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Users') and o.name = 'FK_USERS_U_DU_DUTIES')
alter table Users
   drop constraint FK_USERS_U_DU_DUTIES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Department_Role')
            and   type = 'U')
   drop table Department_Role
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Departments')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Departments.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Departments')
            and   type = 'U')
   drop table Departments
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Duties')
            and   type = 'U')
   drop table Duties
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPaperQuestions')
            and   type = 'U')
   drop table ExaminationPaperQuestions
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPaperTemplateQuestions')
            and   type = 'U')
   drop table ExaminationPaperTemplateQuestions
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPaperTemplates')
            and   type = 'U')
   drop table ExaminationPaperTemplates
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPapers')
            and   type = 'U')
   drop table ExaminationPapers
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationTaskTemplates')
            and   type = 'U')
   drop table ExaminationTaskTemplates
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ExaminationTasks')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index ExaminationTasks.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationTasks')
            and   type = 'U')
   drop table ExaminationTasks
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PermissionCategories')
            and   type = 'U')
   drop table PermissionCategories
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Permissions')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Permissions.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Permissions')
            and   type = 'U')
   drop table Permissions
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('QuestionClassifies')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index QuestionClassifies.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('QuestionClassifies')
            and   type = 'U')
   drop table QuestionClassifies
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Questions')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Questions.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Questions')
            and   type = 'U')
   drop table Questions
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Role_Permission')
            and   type = 'U')
   drop table Role_Permission
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Roles')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Roles.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Roles')
            and   type = 'U')
   drop table Roles
go

if exists (select 1
            from  sysobjects
           where  id = object_id('User_Department')
            and   type = 'U')
   drop table User_Department
go

if exists (select 1
            from  sysobjects
           where  id = object_id('User_Role')
            and   type = 'U')
   drop table User_Role
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Users')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Users.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Users')
            and   type = 'U')
   drop table Users
go

/*==============================================================*/
/* Table: Department_Role                                       */
/*==============================================================*/
create table Department_Role (
   D_Id                 int                  null,
   R_Id                 int                  null
)
go

/*==============================================================*/
/* Table: Departments                                           */
/*==============================================================*/
create table Departments (
   D_Id                 int                  not null,
   D_AutoId             int                  identity,
   D_Name               varchar(50)          not null,
   D_Roles              text                 null,
   D_Level              varchar(50)          not null,
   D_Remark             varchar(200)         null,
   D_AddTime            DateTime2            not null,
   D_Status             tinyint              not null,
   constraint PK_DEPARTMENTS primary key (D_Id)
)
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Departments (
D_Name ASC
)
go

/*==============================================================*/
/* Table: Duties                                                */
/*==============================================================*/
create table Duties (
   Du_Id                int                  not null,
   Du_AutoId            int                  identity,
   Du_Name              varchar(50)          not null,
   Du_Remark            varchar(200)         null,
   Du_AddTime           datetime2            not null,
   Du_Status            tinyint              not null,
   constraint PK_DUTIES primary key (Du_Id)
)
go

/*==============================================================*/
/* Table: ExaminationPaperQuestions                             */
/*==============================================================*/
create table ExaminationPaperQuestions (
   EPQ_Id               int                  not null,
   EPQ_AutoId           int                  identity,
   EPTQ_Id              int                  null,
   EP_Id                int                  null,
   EPQ_Answer           text                 not null,
   EPQ_Exactness        tinyint              not null,
   EPQ_Critique         varchar(200)         null,
   EPQ_AddTime          datetime2            not null,
   constraint PK_EXAMINATIONPAPERQUESTIONS primary key (EPQ_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EP_Id')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EP_Id'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '试卷',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EP_Id'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPQ_Answer')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Answer'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '答案',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Answer'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPQ_Exactness')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Exactness'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '是否正确',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Exactness'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPQ_Critique')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Critique'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '点评',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Critique'
go

/*==============================================================*/
/* Table: ExaminationPaperTemplateQuestions                     */
/*==============================================================*/
create table ExaminationPaperTemplateQuestions (
   EPTQ_Id              int                  not null,
   EPTQ_AutoId          int                  identity,
   EPT_Id               int                  null,
   EPTQ_Type            varchar(20)          not null,
   EPTQ_Classify        int                  not null,
   EPTQ_DifficultyCoefficient tinyint              not null,
   EPTQ_Content         text                 not null,
   EPTQ_OptionalAnswer  text                 null,
   EPTQ_ModelAnswer     text                 not null,
   EPTQ_Remark          varchar(200)         null,
   EPTQ_AddTime         datetime2            not null,
   EPTQ_Status          tinyint              null,
   constraint PK_EXAMINATIONPAPERTEMPLATEQUE primary key (EPTQ_Id)
)
go

/*==============================================================*/
/* Table: ExaminationPaperTemplates                             */
/*==============================================================*/
create table ExaminationPaperTemplates (
   EPT_Id               int                  not null,
   EPT_AutoId           int                  identity,
   ET_Id                int                  null,
   ET_Type              tinyint              null,
   EPT_PaperTemplateStatus tinyint              null,
   EPT_StartTime        datetime2            not null,
   EPT_EndTime          datetime2            null,
   EPT_TimeSpan         int                  not null,
   EPT_Questions        text                 null,
   EPT_Remark           varchar(200)         null,
   EPT_AddTime          datetime2            not null,
   EPT_Status           tinyint              not null,
   constraint PK_EXAMINATIONPAPERTEMPLATES primary key (EPT_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPT_PaperTemplateStatus')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperTemplates', 'column', 'EPT_PaperTemplateStatus'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 进行中
   1 已结束',
   'user', @CurrentUser, 'table', 'ExaminationPaperTemplates', 'column', 'EPT_PaperTemplateStatus'
go

/*==============================================================*/
/* Table: ExaminationPapers                                     */
/*==============================================================*/
create table ExaminationPapers (
   EP_Id                int                  not null,
   EP_AutoId            int                  identity,
   EPT_Id               int                  null,
   EP_PaperStatus       tinyint              null,
   EP_UserId            int                  not null,
   EP_UserName          varchar(10)          null,
   EP_Score             int                  not null,
   EP_Remark            varchar(200)         null,
   EP_AddTime           DateTime2            not null,
   EP_Status            tinyint              not null,
   constraint PK_EXAMINATIONPAPERS primary key (EP_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPapers')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EP_PaperStatus')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_PaperStatus'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 进行中
   1 已结束',
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_PaperStatus'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPapers')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EP_Status')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_Status'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 删除
   1 可见',
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_Status'
go

/*==============================================================*/
/* Table: ExaminationTaskTemplates                              */
/*==============================================================*/
create table ExaminationTaskTemplates (
   ETT_Id               int                  not null,
   ETT_AutoId           int                  identity,
   ETT_Name             varchar(50)          not null,
   ETT_Type             tinyint              not null,
   ETT_Mode             tinyint              not null,
   ETT_DifficultyCoefficient tinyint              not null,
   ETT_ParticipatingDepartment text                 null,
   ETT_Attendee         text                 null,
   ETT_AutoType         tinyint              not null,
   ETT_AutoOffsetDay    tinyint              null,
   ETT_StartTime        DateTime2            not null,
   ETT_EndTime          DateTime2            not null,
   ETT_TimeSpan         int                  not null,
   ETT_Remark           varchar(200)         null,
   ETT_AddTime          DateTime2            not null,
   ETT_Status           tinyint              not null,
   constraint PK_EXAMINATIONTASKTEMPLATES primary key (ETT_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTaskTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ETT_Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 考试
   1 练习',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Type'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTaskTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ETT_Mode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Mode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 手动
   1 自动',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Mode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTaskTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ETT_AutoType')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_AutoType'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 关闭
   1 每日
   2 每星期
   3 每月',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_AutoType'
go

/*==============================================================*/
/* Table: ExaminationTasks                                      */
/*==============================================================*/
create table ExaminationTasks (
   ET_Id                int                  not null,
   ET_AutoId            int                  identity,
   ET_Name              varchar(50)          not null,
   ET_Type              tinyint              not null,
   ET_Mode              tinyint              not null,
   ET_DifficultyCoefficient tinyint              not null,
   ET_ParticipatingDepartment text                 null,
   ET_Attendee          text                 null,
   ET_AutoType          tinyint              not null,
   ET_AutoOffsetDay     tinyint              null,
   ET_StartTime         DateTime2            not null,
   ET_EndTime           DateTime2            not null,
   ET_TimeSpan          int                  not null,
   ET_PaperTemplates    text                 null,
   ET_Questions         text                 null,
   ET_Remark            varchar(200)         null,
   ET_AddTime           DateTime2            not null,
   ET_Status            tinyint              not null,
   constraint PK_EXAMINATIONTASKS primary key (ET_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 考试
   1 练习',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Type'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_Mode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Mode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 手动
   1 自动',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Mode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_AutoType')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoType'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 关闭
   1 每日
   2 每星期
   3 每月
   4 按时，单位为分钟',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoType'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on ExaminationTasks (
ET_Name ASC
)
go

/*==============================================================*/
/* Table: PermissionCategories                                  */
/*==============================================================*/
create table PermissionCategories (
   PC_Id                int                  not null,
   PC_AutoId            int                  identity,
   PC_Name              varchar(20)          not null,
   PC_Level             varchar(50)          not null,
   PC_Remark            varchar(200)         null,
   PC_AddTime           datetime2            not null,
   PC_Status            tinyint              not null,
   constraint PK_PERMISSIONCATEGORIES primary key (PC_Id)
)
go

/*==============================================================*/
/* Table: Permissions                                           */
/*==============================================================*/
create table Permissions (
   P_Id                 int                  not null,
   P_AutoId             int                  identity,
   PC_Id                int                  null,
   P_Name               varchar(50)          not null,
   P_Controller         varchar(50)          not null,
   P_Action             varchar(50)          not null,
   P_Remark             varchar(200)         null,
   P_AddTime            DateTime2            not null,
   constraint PK_PERMISSIONS primary key (P_Id)
)
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Permissions (
P_Name ASC
)
go

/*==============================================================*/
/* Table: QuestionClassifies                                    */
/*==============================================================*/
create table QuestionClassifies (
   QC_Id                int                  not null,
   QC_AutoId            int                  identity,
   QC_Name              varchar(100)         not null,
   QC_Level             varchar(50)          not null,
   QC_Remark            varchar(200)         null,
   QC_AddTime           DateTime2            not null,
   QC_Status            tinyint              not null,
   constraint PK_QUESTIONCLASSIFIES primary key (QC_Id)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('QuestionClassifies') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'QuestionClassifies' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '分类示例：
   2014梅州市局
   信息技术练习题库
   2012梅州市局信息技术岗位练兵', 
   'user', @CurrentUser, 'table', 'QuestionClassifies'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on QuestionClassifies (
QC_Name ASC
)
go

/*==============================================================*/
/* Table: Questions                                             */
/*==============================================================*/
create table Questions (
   Q_Id                 int                  not null,
   Q_AutoId             int                  identity,
   Q_Type               varchar(20)          not null,
   QC_Id                int                  null,
   Q_DifficultyCoefficient tinyint              not null,
   Q_Content            text                 not null,
   Q_OptionalAnswer     text                 null,
   Q_ModelAnswer        text                 not null,
   Q_Remark             varchar(200)         null,
   Q_AddTime            DateTime2            not null,
   Q_Status             tinyint              not null,
   constraint PK_QUESTIONS primary key (Q_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Questions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Q_Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Questions', 'column', 'Q_Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '题目类型。
   0 单项选择题
   1 多项选择题
   2 判断题
   3 公文改错题
   4 计算题
   5 案例分析题
   6 问答题',
   'user', @CurrentUser, 'table', 'Questions', 'column', 'Q_Type'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Questions (
Q_Type ASC,
Q_DifficultyCoefficient ASC
)
go

/*==============================================================*/
/* Table: Role_Permission                                       */
/*==============================================================*/
create table Role_Permission (
   R_Id                 int                  not null,
   P_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: Roles                                                 */
/*==============================================================*/
create table Roles (
   R_Id                 int                  not null,
   R_AutoId             int                  identity,
   R_Name               varchar(50)          not null,
   R_Permissions        text                 null,
   R_PermissionCategories text                 null,
   R_Remark             varchar(200)         null,
   R_AddTime            DateTime2            not null,
   R_Status             tinyint              not null,
   constraint PK_ROLES primary key (R_Id)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Roles') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Roles' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '角色表/职务表', 
   'user', @CurrentUser, 'table', 'Roles'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Roles (
R_Name ASC
)
go

/*==============================================================*/
/* Table: User_Department                                       */
/*==============================================================*/
create table User_Department (
   U_Id                 int                  not null,
   D_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: User_Role                                             */
/*==============================================================*/
create table User_Role (
   U_Id                 int                  not null,
   R_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: Users                                                 */
/*==============================================================*/
create table Users (
   U_Id                 int                  not null,
   U_AutoId             int                  identity,
   Du_Id                int                  null,
   U_Name               varchar(10)          not null,
   U_LoginName          varchar(50)          not null,
   U_Password           varchar(200)         not null,
   U_Departments        text                 null,
   U_Roles              text                 null,
   U_Remark             varchar(200)         null,
   U_AddTime            DateTime2            not null,
   U_Status             tinyint              not null,
   constraint PK_USERS primary key (U_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Users')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'U_Status')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Users', 'column', 'U_Status'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 删除
   1 启用',
   'user', @CurrentUser, 'table', 'Users', 'column', 'U_Status'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Users (
U_Name ASC,
U_LoginName ASC
)
go

alter table Department_Role
   add constraint FK_DEPARTME_DR_D_DEPARTME foreign key (D_Id)
      references Departments (D_Id)
go

alter table Department_Role
   add constraint FK_DEPARTME_DR_R_ROLES foreign key (R_Id)
      references Roles (R_Id)
go

alter table ExaminationPaperQuestions
   add constraint FK_EXAMINAT_EQ_EP_EXAMINAT foreign key (EP_Id)
      references ExaminationPapers (EP_Id)
go

alter table ExaminationPaperTemplateQuestions
   add constraint FK_EXAMINAT_EPTQ_EPT_EXAMINAT foreign key (EPT_Id)
      references ExaminationPaperTemplates (EPT_Id)
go

alter table ExaminationPaperTemplates
   add constraint FK_EXAMINAT_EPT_ET_EXAMINAT foreign key (ET_Id)
      references ExaminationTasks (ET_Id)
go

alter table ExaminationPapers
   add constraint FK_EXAMINAT_EP_EPT_EXAMINAT foreign key (EPT_Id)
      references ExaminationPaperTemplates (EPT_Id)
go

alter table Permissions
   add constraint FK_PERMISSI_P_PC_PERMISSI foreign key (PC_Id)
      references PermissionCategories (PC_Id)
go

alter table Questions
   add constraint FK_QUESTION_Q_QC_QUESTION foreign key (QC_Id)
      references QuestionClassifies (QC_Id)
go

alter table Role_Permission
   add constraint FK_ROLE_PER_RP_P_PERMISSI foreign key (P_Id)
      references Permissions (P_Id)
go

alter table Role_Permission
   add constraint FK_ROLE_PER_RP_R_ROLES foreign key (R_Id)
      references Roles (R_Id)
go

alter table User_Department
   add constraint FK_USER_DEP_UD_D_DEPARTME foreign key (D_Id)
      references Departments (D_Id)
go

alter table User_Department
   add constraint FK_USER_DEP_UD_U_USERS foreign key (U_Id)
      references Users (U_Id)
go

alter table User_Role
   add constraint FK_USER_ROL_UR_R_ROLES foreign key (R_Id)
      references Roles (R_Id)
go

alter table User_Role
   add constraint FK_USER_ROL_UR_U_USERS foreign key (U_Id)
      references Users (U_Id)
go

alter table Users
   add constraint FK_USERS_U_DU_DUTIES foreign key (Du_Id)
      references Duties (Du_Id)
go


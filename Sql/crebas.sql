/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2016/1/27 11:49:39                           */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Department_Role') and o.name = 'FK_DR_D')
alter table Department_Role
   drop constraint FK_DR_D
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Department_Role') and o.name = 'FK_DR_R')
alter table Department_Role
   drop constraint FK_DR_R
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperQuestions') and o.name = 'FK_EQ_EP')
alter table ExaminationPaperQuestions
   drop constraint FK_EQ_EP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperTemplateQuestions') and o.name = 'FK_EPTQ_EPT')
alter table ExaminationPaperTemplateQuestions
   drop constraint FK_EPTQ_EPT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperTemplates') and o.name = 'FK_EPT_ET')
alter table ExaminationPaperTemplates
   drop constraint FK_EPT_ET
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPapers') and o.name = 'FK_EP_EPT')
alter table ExaminationPapers
   drop constraint FK_EP_EPT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPapers') and o.name = 'FK_EP_ET')
alter table ExaminationPapers
   drop constraint FK_EP_ET
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationTaskAttendees') and o.name = 'FK_ETA_ET')
alter table ExaminationTaskAttendees
   drop constraint FK_ETA_ET
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LearningDatas') and o.name = 'FK_LD_LDC')
alter table LearningDatas
   drop constraint FK_LD_LDC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Permissions') and o.name = 'FK_P_PC')
alter table Permissions
   drop constraint FK_P_PC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Questions') and o.name = 'FK_Q_QC')
alter table Questions
   drop constraint FK_Q_QC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Role_Permission') and o.name = 'FK_RP_P')
alter table Role_Permission
   drop constraint FK_RP_P
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Role_Permission') and o.name = 'FK_RP_R')
alter table Role_Permission
   drop constraint FK_RP_R
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Department') and o.name = 'FK_UD_D')
alter table User_Department
   drop constraint FK_UD_D
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Department') and o.name = 'FK_UD_U')
alter table User_Department
   drop constraint FK_UD_U
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Role') and o.name = 'FK_UR_R')
alter table User_Role
   drop constraint FK_UR_R
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Role') and o.name = 'FK_UR_U')
alter table User_Role
   drop constraint FK_UR_U
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Users') and o.name = 'FK_U_DU')
alter table Users
   drop constraint FK_U_DU
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
           where  id = object_id('ExaminationTaskAttendees')
            and   type = 'U')
   drop table ExaminationTaskAttendees
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
           where  id = object_id('LearningDataClassify')
            and   type = 'U')
   drop table LearningDataClassify
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LearningDatas')
            and   type = 'U')
   drop table LearningDatas
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
           where  id = object_id('SystemLogs')
            and   type = 'U')
   drop table SystemLogs
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
   D_Sort               float                not null,
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
   Du_Sort              float                not null,
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
   '�Ծ�',
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
   '��',
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
   '�Ƿ���ȷ',
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
   '����',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Critique'
go

/*==============================================================*/
/* Table: ExaminationPaperTemplateQuestions                     */
/*==============================================================*/
create table ExaminationPaperTemplateQuestions (
   EPTQ_Id              int                  not null,
   EPTQ_AutoId          int                  identity,
   EPT_Id               int                  not null,
   EPTQ_Type            varchar(20)          not null,
   EPTQ_Classify        int                  not null,
   EPTQ_DifficultyCoefficient tinyint              not null,
   EPTQ_Score           int                  not null,
   EPTQ_Content         text                 not null,
   EPTQ_OptionalAnswer  text                 null,
   EPTQ_ModelAnswer     text                 not null,
   EPTQ_Remark          varchar(200)         null,
   EPTQ_AddTime         datetime2            not null,
   EPTQ_Status          tinyint              not null,
   constraint PK_EXAMINATIONPAPERTEMPLATEQUE primary key (EPTQ_Id)
)
go

/*==============================================================*/
/* Table: ExaminationPaperTemplates                             */
/*==============================================================*/
create table ExaminationPaperTemplates (
   EPT_Id               int                  not null,
   EPT_AutoId           int                  identity,
   ET_Id                int                  not null,
   ET_Type              tinyint              not null,
   EPT_PaperTemplateStatus tinyint              not null,
   EPT_StartDate        datetime2            not null,
   EPT_StartTime        datetime2            not null,
   EPT_EndTime          datetime2            not null,
   EPT_TimeSpan         int                  not null,
   EPT_Questions        text                 not null,
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
   '0 δ��ʼ
   1 ������
   2 �ѽ���',
   'user', @CurrentUser, 'table', 'ExaminationPaperTemplates', 'column', 'EPT_PaperTemplateStatus'
go

/*==============================================================*/
/* Table: ExaminationPapers                                     */
/*==============================================================*/
create table ExaminationPapers (
   EP_Id                int                  not null,
   EP_AutoId            int                  identity,
   ET_Id                int                  null,
   EPT_Id               int                  null,
   EP_PaperStatus       tinyint              not null,
   EP_EndTime           DateTIme2            not null,
   EP_TimeSpan          int                  not null,
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
   '0 ������
   1 �ѽ���',
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
   '0 ɾ��
   1 �ɼ�',
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_Status'
go

/*==============================================================*/
/* Table: ExaminationTaskAttendees                              */
/*==============================================================*/
create table ExaminationTaskAttendees (
   ET_Id                int                  null,
   U_Id                 int                  not null,
   D_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: ExaminationTaskTemplates                              */
/*==============================================================*/
create table ExaminationTaskTemplates (
   ETT_Id               int                  not null,
   ETT_AutoId           int                  identity,
   ETT_Name             varchar(50)          not null,
   ETT_Type             tinyint              not null,
   ETT_ParticipatingDepartment text                 null,
   ETT_Attendee         text                 null,
   ETT_StatisticType    tinyint              not null,
   ETT_TotalScore       int                  not null,
   ETT_TotalNumber      int                  not null,
   ETT_Mode             tinyint              not null,
   ETT_AutoType         tinyint              not null,
   ETT_AutoOffsetDay    tinyint              not null,
   ETT_DifficultyCoefficient tinyint              not null,
   ETT_AutoClassifies   text                 not null,
   ETT_AutoRatio        varchar(500)         not null,
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
   '0 ����
   1 ��ϰ',
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
   '0 �ֶ�
   1 �Զ�',
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
   '0 �ر�
   1 ÿ��
   2 ÿ����
   3 ÿ��',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_AutoType'
go

/*==============================================================*/
/* Table: ExaminationTasks                                      */
/*==============================================================*/
create table ExaminationTasks (
   ET_Id                int                  not null,
   ET_AutoId            int                  identity,
   ET_Name              varchar(50)          not null,
   ET_Enabled           tinyint              not null,
   ET_Type              tinyint              not null,
   ET_ParticipatingDepartment text                 not null,
   ET_Attendee          text                 not null,
   ET_StatisticType     tinyint              not null,
   ET_TotalScore        int                  not null,
   ET_TotalNumber       int                  not null,
   ET_Mode              tinyint              not null,
   ET_AutoType          tinyint              not null,
   ET_AutoOffsetDay     tinyint              not null,
   ET_DifficultyCoefficient tinyint              not null,
   ET_AutoClassifies    text                 not null,
   ET_AutoRatio         varchar(500)         not null,
   ET_StartTime         DateTime2            not null,
   ET_EndTime           DateTime2            not null,
   ET_TimeSpan          int                  not null,
   ET_PaperTemplates    text                 not null,
   ET_Questions         text                 not null,
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
   '0 ����
   1 ��ϰ',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Type'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_StatisticType')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_StatisticType'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 [δ����]
   1 �÷�
   2 ��ȷ��',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_StatisticType'
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
   '0 �ֶ�
   1 �Զ�',
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
   '0 �ֶ�
   1 ÿ��
   2 ÿ��
   3 ÿ��',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoType'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_AutoRatio')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoRatio'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ʽΪ [{type: ''��ѡ��'', percent: 0.2}, {type: ''��ѡ��'', precent: 0.2}, ...]',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoRatio'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on ExaminationTasks (
ET_Name ASC
)
go

/*==============================================================*/
/* Table: LearningDataClassify                                  */
/*==============================================================*/
create table LearningDataClassify (
   LDC_Id               int                  identity,
   LDC_AutoId           int                  not null,
   LDC_Name             varchar(200)         not null,
   LDC_Remark           varchar(200)         null,
   LDC_AddTime          datetime2            not null,
   constraint PK_LEARNINGDATACLASSIFY primary key (LDC_Id)
)
go

/*==============================================================*/
/* Table: LearningDatas                                         */
/*==============================================================*/
create table LearningDatas (
   LD_Id                int                  not null,
   LD_AutoId            int                  identity,
   LD_Title             varchar(200)         not null,
   LDC_Id               int                  null,
   LD_Content           text                 not null,
   LD_Remark            varchar(200)         null,
   LD_AddTime           datetime2            not null,
   constraint PK_LEARNINGDATAS primary key (LD_Id)
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
   '����ʾ����
   2014÷���о�
   ��Ϣ������ϰ���
   2012÷���о���Ϣ������λ����', 
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
   Q_Score              int                  not null,
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
   '��Ŀ���͡�
   0 ����ѡ����
   1 ����ѡ����
   2 �ж���
   3 ���ĸĴ���
   4 ������
   5 ����������
   6 �ʴ���',
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
   '��ɫ��/ְ���', 
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
/* Table: SystemLogs                                            */
/*==============================================================*/
create table SystemLogs (
   SL_Id                int                  identity,
   SL_Name              varchar(500)         not null,
   SL_Type              tinyint              not null,
   SL_Content           text                 not null,
   SL_Remark            varchar(500)         null,
   SL_Status            tinyint              not null,
   SL_AddTime           datetime2            not null,
   constraint PK_SYSTEMLOGS primary key (SL_Id)
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
   U_Sort               float                not null,
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
   '0 ɾ��
   1 ����',
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
   add constraint FK_DR_D foreign key (D_Id)
      references Departments (D_Id)
go

alter table Department_Role
   add constraint FK_DR_R foreign key (R_Id)
      references Roles (R_Id)
go

alter table ExaminationPaperQuestions
   add constraint FK_EQ_EP foreign key (EP_Id)
      references ExaminationPapers (EP_Id)
go

alter table ExaminationPaperTemplateQuestions
   add constraint FK_EPTQ_EPT foreign key (EPT_Id)
      references ExaminationPaperTemplates (EPT_Id)
go

alter table ExaminationPaperTemplates
   add constraint FK_EPT_ET foreign key (ET_Id)
      references ExaminationTasks (ET_Id)
go

alter table ExaminationPapers
   add constraint FK_EP_EPT foreign key (EPT_Id)
      references ExaminationPaperTemplates (EPT_Id)
go

alter table ExaminationPapers
   add constraint FK_EP_ET foreign key (ET_Id)
      references ExaminationTasks (ET_Id)
go

alter table ExaminationTaskAttendees
   add constraint FK_ETA_ET foreign key (ET_Id)
      references ExaminationTasks (ET_Id)
go

alter table LearningDatas
   add constraint FK_LD_LDC foreign key (LDC_Id)
      references LearningDataClassify (LDC_Id)
go

alter table Permissions
   add constraint FK_P_PC foreign key (PC_Id)
      references PermissionCategories (PC_Id)
go

alter table Questions
   add constraint FK_Q_QC foreign key (QC_Id)
      references QuestionClassifies (QC_Id)
go

alter table Role_Permission
   add constraint FK_RP_P foreign key (P_Id)
      references Permissions (P_Id)
go

alter table Role_Permission
   add constraint FK_RP_R foreign key (R_Id)
      references Roles (R_Id)
go

alter table User_Department
   add constraint FK_UD_D foreign key (D_Id)
      references Departments (D_Id)
go

alter table User_Department
   add constraint FK_UD_U foreign key (U_Id)
      references Users (U_Id)
go

alter table User_Role
   add constraint FK_UR_R foreign key (R_Id)
      references Roles (R_Id)
go

alter table User_Role
   add constraint FK_UR_U foreign key (U_Id)
      references Users (U_Id)
go

alter table Users
   add constraint FK_U_DU foreign key (Du_Id)
      references Duties (Du_Id)
go


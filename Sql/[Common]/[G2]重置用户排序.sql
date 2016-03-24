USE OLS;

--UPDATE  dbo.Users
--SET     U_Sort = U_Id;
--UPDATE  dbo.Departments
--SET     D_Sort = D_Id;

SELECT  u.U_Id ,
        U_Name ,
        U_Sort ,
        d.D_Id ,
        D_Name ,
        D_Sort
FROM    dbo.Users u
        LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
        LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
ORDER BY d.D_Sort ASC ,
        u.U_Sort ASC;
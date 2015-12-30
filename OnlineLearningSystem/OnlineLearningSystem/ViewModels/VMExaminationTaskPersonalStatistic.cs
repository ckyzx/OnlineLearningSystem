using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace OnlineLearningSystem.ViewModels
{
    public class VMExaminationTaskPersonalStatistic
    {
        [DisplayName("用户编号")]
        public Int32 ETPS_UserId { get; set; }

        [DisplayName("用户名称")]
        public String ETPS_UserName { get; set; }

        [DisplayName("部门编号")]
        public Int32 ETPS_DepartmentId { get; set; }

        [DisplayName("部门名称")]
        public String ETPS_DepartmentName { get; set; }

        [DisplayName("职务编号")]
        public Int32 ETPS_DutyId { get; set; }

        [DisplayName("职务名称")]
        public String ETPS_DutyName { get; set; }

        [DisplayName("考试总数")]
        public Double ETPS_ExaminationTotalNumber { get; set; }

        [DisplayName("未考次数")]
        public Double ETPS_UnexamineNumber { get; set; }

        [DisplayName("已考次数")]
        public Double ETPS_ExaminedNumber { get; set; }

        [DisplayName("合格比率")]
        public Double ETPS_ExaminationPassRatio { get; set; }

        [DisplayName("练习总数")]
        public Double ETPS_ExerciseTotalNumber { get; set; }

        [DisplayName("未练次数")]
        public Double ETPS_UnexerciseNumber { get; set; }

        [DisplayName("已练次数")]
        public Double ETPS_ExercisedNumber { get; set; }

        [DisplayName("合格比率")]
        public Double ETPS_ExercisePassRatio { get; set; }

    }
}

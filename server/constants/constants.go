package constants

// 评估状态常量
const (
	EvaluationStatusPending          = "pending"           // 待自评
	EvaluationStatusSelfEvaluated    = "self_evaluated"    // 已自评
	EvaluationStatusManagerEvaluated = "manager_evaluated" // 上级已评
	EvaluationStatusPendingConfirm   = "pending_confirm"   // 待确认
	EvaluationStatusCompleted        = "completed"         // 已完成
)

// 邀请状态常量
const (
	InvitationStatusPending   = "pending"   // 待处理
	InvitationStatusAccepted  = "accepted"  // 已接受
	InvitationStatusDeclined  = "declined"  // 已拒绝
	InvitationStatusCompleted = "completed" // 已完成
)

// 用户角色常量
const (
	RoleEmployee = "employee" // 普通员工
	RoleManager  = "manager"  // 经理
	RoleHR       = "hr"       // HR
)

// 考核周期常量
const (
	PeriodMonthly   = "monthly"   // 月度
	PeriodQuarterly = "quarterly" // 季度
	PeriodYearly    = "yearly"    // 年度
)

// 系统设置类型常量
const (
	SettingTypeString  = "string"  // 字符串
	SettingTypeBoolean = "boolean" // 布尔值
	SettingTypeNumber  = "number"  // 数字
	SettingTypeJSON    = "json"    // JSON对象
)

// 系统设置键名常量
const (
	SettingKeyAllowRegistration = "allow_registration" // 是否允许注册
)

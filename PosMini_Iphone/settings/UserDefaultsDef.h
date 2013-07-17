//
//  UserDefaultsDef.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#ifndef PosMini_Iphone_UserDefaultsDef_h
#define PosMini_Iphone_UserDefaultsDef_h

#define POSMINI_DEFAULT_VALUE @"#"

//是否阅读了用户协议
#define POSMINI_HAVE_READ_LICENSE @"POSMINI_HAVE_READ_LICENSE"
//keychain 服务
#define KEYCHAIN_SFHF_SERVICE @"KEYCHAIN_SFHF_SERVICE"

//登录相关信息　
#define POSMINI_LOGIN_ACCOUNT @"POSMINI_LOGIN_ACCOUNT"
#define POSMINI_LOGIN_PASSWORD @"POSMINI_LOGIN_PASSWORD"
#define POSMINI_LOGIN_USERNAME @"POSMINI_LOGIN_USERNAME"
#define POSMINI_LOGIN_DATE @"POSMINI_LOGIN_DATE"
#define POSMINI_LOGIN @"POSMINI_LOGIN"

#define POSMINI_CUSTOMER_ID @"POSMINI_CUSTOMER_ID"

#define POSMINI_ACCOUNT_NEED_REFRESH @"POSMINI_ACCOUNT_NEED_REFRESH"
#define POSMINI_ORDER_NEED_REFRESH @"POSMINI_ORDER_NEED_REFRESH"

#define POSMINI_DEVICE_ID @"POSMINI_DEVICE_ID"

#define POSMINI_DELIVERSIGN @"POSMINI_DELIVERSIGN"

//登录 选中定义
#define ACCOUNT_CHECK_BOX @"ACCOUNT_CHECK_BOX"
#define SECRET_CHECK_BOX @"SECRET_CHECK_BOX"

#define NSSTRING_YES @"YES"
#define NSSTRING_NO @"NO"

#define PARAM_CUSTOMER_ID @"CustId"
//DefaultOrderController
#define PARAM_ORDER_TRANS_STATUS @"TransStat"
#define PARAM_ORDER_BEGIN_DATE @"BeginDate"
#define PARAM_ORDER_END_DATE @"EndDate"
#define PARAM_ORDER_PAGE_NUMBER @"PageNum"
#define PARAM_ORDER_PAGE_SIZE @"PageSize"
#define PARAM_ORDER_PAGE_SIZE_VALUE @"30"

//DefaultAccountController
//单笔交易限额
#define POSMINI_ONE_LIMIT_AMOUNT @"POSMINI_ONE_LIMIT_AMOUNT"
//每日交易限额
#define POSMINI_SUM_LIMIT_AMOUNT @"POSMINI_SUM_LIMIT_AMOUNT"

//累计收款笔数
#define ACCOUNT_TOTAL_ORDER_COUNT @"TotalOrdCnt"
//累计收款金额
#define ACCOUNT_TOTAL_ORDER_AMOUNT @"TotalOrdAmt"
//自动取现银行卡
#define ACCOUNT_CASHCARD_NUMBER @"CashCardNo"
//绑定的设备编号
#define ACCOUNT_BINDED_MOUNT_ID @"BindedMtId"
//可取现金额
#define ACCOUNT_AVAILIABLE_CASH_AMOUNT @"AvailCashAmt"
//待计算金额
#define ACCOUNT_NEED_LIQ_AMOUNT @"NeedLiqAmt"

#endif

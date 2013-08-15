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
#define POSMINI_LOGIN_ACCOUNT @"POSMINI_LOGIN_ACCOUNT"      //账号
#define POSMINI_LOGIN_PASSWORD @"POSMINI_LOGIN_PASSWORD"    //密码
#define POSMINI_LOGIN_USERNAME @"POSMINI_LOGIN_USERNAME"    //用户名
#define POSMINI_LOGIN_DATE @"POSMINI_LOGIN_DATE"            //登录时间
#define POSMINI_LOGIN @"POSMINI_LOGIN"                      //是否登录

#define POSMINI_CUSTOMER_ID @"POSMINI_CUSTOMER_ID"          //用户ID

#define POSMINI_SHOW_USER_LOGIN @"POSMINI_SHOW_USER_LOGIN"  //是否在展示重新登录页面

//显示用户签名
#define POSMINI_SHOW_USER_SIGN @"POSMINI_SHOW_USER_SIGN"

//交易限额
#define POSMINI_ONE_LIMIT_AMOUNT @"POSMINI_ONE_LIMIT_AMOUNT"    //单笔交易限额
#define POSMINI_SUM_LIMIT_AMOUNT @"POSMINI_SUM_LIMIT_AMOUNT"    //每日交易限额

//POS mini设备相关
#define POSMINI_MTP_BINDED_DEVICE_ID @"POSMINI_MTP_BINDED_DEVICE_ID" //服务端绑定的设备号
#define POSMINI_DEVICE_ID @"POSMINI_DEVICE_ID"                       //POSmini的序列号
#define POSMINI_CONNECTION_STATUS @"POSMINI_CONNECTION_STATUS"       //POSmini的连接状态

//登录 选中定义
#define ACCOUNT_CHECK_BOX @"ACCOUNT_CHECK_BOX"
#define SECRET_CHECK_BOX @"SECRET_CHECK_BOX"

#define NSSTRING_YES @"YES"
#define NSSTRING_NO @"NO"



//controller　table　是否要刷新
#define POSMINI_ACCOUNT_NEED_REFRESH @"POSMINI_ACCOUNT_NEED_REFRESH"   //账户信息需要刷新
#define POSMINI_ORDER_NEED_REFRESH @"POSMINI_ORDER_NEED_REFRESH"       //查询交易信息需要刷新


//param 请求参数定义
#define PARAM_CUSTOMER_ID @"CustId"
//DefaultOrderController
#define PARAM_ORDER_TRANS_STATUS @"TransStat"
#define PARAM_ORDER_BEGIN_DATE @"BeginDate"
#define PARAM_ORDER_END_DATE @"EndDate"
#define PARAM_ORDER_PAGE_NUMBER @"PageNum"
#define PARAM_ORDER_PAGE_SIZE @"PageSize"

#define PARAM_ORDER_PAGE_SIZE_VALUE @"20"

//DefaultAccountController

#define ACCOUNT_TOTAL_ORDER_COUNT @"TotalOrdCnt"                //累计收款笔数
#define ACCOUNT_TOTAL_ORDER_AMOUNT @"TotalOrdAmt"               //累计收款金额
#define ACCOUNT_CASHCARD_NUMBER @"CashCardNo"                   //自动取现银行卡
#define ACCOUNT_BINDED_MOUNT_ID @"BindedMtId"                   //绑定的设备编号
#define ACCOUNT_AVAILIABLE_CASH_AMOUNT @"AvailCashAmt"          //可取现金额
#define ACCOUNT_NEED_LIQ_AMOUNT @"NeedLiqAmt"                   //待计算金额

#endif

#ifndef __ms_security_h__
#define __ms_security_h__

#include <cstdlib>
#include <cstdio>
#include <string>

using namespace std;

/** 客户端使用方法:
 ## 以下项保存到配置文件中:
 - 用户单位组织
 - 用户名称
 - 激活码

 ## 以下项也保存到配置文件中,但配置项的名称用get_reg_item_name函数来获取
 - 加密后的激活日期
 - 加密后的上次使用日期
 - 加密后的已使用次数
 */

namespace yflib {

// s_sys_name: 系统名称, s_sys_ver: 系统版本, s_user_org: 用户单位组织,
// s_user_name: 用户单位名称, s_proposer_org:申请人单位, s_proposer_name：申请人名称, s_serial_code: 电脑序列号, s_region_limit: 限制使用的区域,
// s_station_limit: 限制使用的变电站
typedef struct _activate_code_params {
        wstring s_sys_name;
        wstring s_sys_ver;
        wstring s_user_org;
        wstring s_user_name;
        wstring s_proposer_org;
        wstring s_proposer_name;
        wstring s_serial_code;
        wstring s_region_limit;
        wstring s_station_limit;
} activate_code_params_t;

// --- user api ------------------------------------------------
//获取设备序列号
wstring get_serial_code();

// 在激活时,验证用户输入的激活码是否有效.
// s_activate_code: 激活码
bool validate_on_activating( const activate_code_params_t& params,
                                                                                                                 const wstring& s_activate_code );

// 验证激活码. 返回0, 表示有效; 返回-1, 表示无效激活码; 返回1, 表示超过了使用次数; 返回2,表示超过了过期日期.
// s_activate_code: 激活码,
// l_cur_date: 当前日期(121015代表2012年10月15日),　s_encrypted_used_count: 已加密的已使用次数,
// s_encrypted_prev_date: 已加密的上次使用的日期
 int validate_activate_code( const activate_code_params_t& params,	const wstring& s_activate_code,
                                                                                                                long l_cur_date, const wstring& s_crypted_used_count,
                                                                                                                const wstring& s_crypted_prev_date );
// 增加使用次数(当天使用多次只算一次)
wstring increase_encrypted_count_limit( const wstring& s_crypted_used_count );
// 加密一个日期
wstring encrypt_a_date( long l_date );
// --------------------------------------------------------------

// 在线申请激活码. 失败返回0, 成功返回1, 激活码已存在则返回2
int request_activate_code_online( const activate_code_params_t& params );
// 在线获取激活码
wstring get_activate_code_online( const activate_code_params_t& params );

// 获取激活码当前状态. 0: 锁定; 1: 已激活; 2: 未知
int get_activate_code_status( const activate_code_params_t& params );
int get_activate_code_status( const wstring& s_activate_code );

// 获取注册表的保存项的名字
wstring get_reg_item_name( const wstring& s_activate_code, const wstring& s_activate_date );

} // end of namespace yflib

#endif

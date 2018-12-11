{
    "touser": "${data.openId}",<#-- openid -->
    "template_id": "pZb7s5_-StQ7S0_z-LSFszNGGSCPd67GeTAGjU51za8",<#-- 模板id，固定不变 -->
    "data": {
        "first":  {
                       "value":"尊敬的车主，您的宝驾已成功完成本次充电",
                       "color":"#173177"
                   }, 
        "keyword1": {
                       "value":"${data.logid}",<#-- 订单号 -->
                       "color":"#173177"
                   },  
        "keyword2": {
                       "value":"${data.pileSn}",<#-- 桩序列号 -->
                       "color":"#173177"
                   }, 
        "keyword3": {
                       "value":"${data.timeSpend}",<#-- 充电时长 -->
                       "color":"#173177"
                   }, 
        "keyword4": {
                       "value":"${data.money}",<#-- 充电费用 -->
                       "color":"#173177"
                   }, 
        "keyword5": {
                       "value":"${data.finishTime}",<#-- 完成时间 -->
                       "color":"#173177"
                   },            
        "remark":{
                       "value":"感谢你的使用！",
                       "color":"#173177"
                 }          
        
    }
}
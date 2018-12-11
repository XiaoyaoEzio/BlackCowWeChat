<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*" %>

<%
	/*
		********** 表格界面通用逻辑  **********
		本文件为包含文件，不能独立工作
		本文件主要功能为：提供一个通用的表格显示逻辑和UI
		本文件依赖：weui相关的css和js，依赖zepto
		本文件位置：包含在body当中	
	*/
%>

<!-- 表格容器 -->
<div class="weui-cells">

</div>
   
<!-- 加载更多按钮 -->
<div id="btLoadMore" class="weui-btn-area">
	<a href="javascript:;" class="weui-btn weui-btn_default">加载更多</a>
</div> 

<!-- 加载更多相关 -->
<div class="page__bd">
    <div class="weui-loadmore">
        <i class="weui-loading"></i>
        <span class="weui-loadmore__tips">正在加载</span>
    </div>
    <div class="weui-loadmore weui-loadmore_line">
        <span class="weui-loadmore__tips">暂无数据</span>
    </div>
    <div class="weui-loadmore weui-loadmore_line weui-loadmore_dot">
        <span class="weui-loadmore__tips"></span>
    </div>
</div>

<script type="text/javascript">
		
	$(function(){
		var myList = {
			_list : null,
			STATE_HAS_DATA: 0, //状态：表示还有数据可以查询
			STATE_NO_DATA: 1, //状态：表示当前没有任何数据
			STATE_LOADING: 2, //状态：表示正在读取数据			
			STATE_ALL_DATA: 4,//状态：表示已经读取所有数据（区别于状态1）
			_uiLoading: null,
			_uiLoadingNoData: null,
			_uiLoadingAllData: null,
			_btnLoadMore: null,
			_pageIndex: 1, 
			_pageSize: 10,
			_dataInvoke: null,
			_args: [],
			init: function(){
				_list = $('.weui-cells');
				_uiLoading = $('.weui-loadmore').not('.weui-loadmore_line');
				_uiLoadingNoData = $('.weui-loadmore_line').not('.weui-loadmore_dot');
				_uiLoadingAllData = $('.weui-loadmore_dot');
				_btnLoadMore = $('#btLoadMore');
				
				var _context = this;
				//绑定事件
				_btnLoadMore.on("click",function(e){
					_context._doRequest();
				});
			},
			_doRequest: function(){
				if(this._dataInvoke != null){
					this._dataInvoke.call(
							this,
							this._pageIndex,
							this._pageSize);
				}				
			},
			setPageSize: function(pageSize){
				this._pageSize = pageSize;
				return this;
			},
			setState: function(state){
				//0:数据加载完毕
				//1:暂无数据
				//2:加载数据中
				//4:没有更多数据了
				_btnLoadMore.hide();
				if(state == this.STATE_HAS_DATA){
					_btnLoadMore.show();
				} else {
					_btnLoadMore.hide();					
				}		
				//----
				if((state&0x01) == this.STATE_NO_DATA){
					_uiLoadingNoData.show();
				} else {
					_uiLoadingNoData.hide();
				}
				if((state&0x02) == this.STATE_LOADING){
					_uiLoading.show();
				} else {
					_uiLoading.hide();
				}
				if((state&0x04) == this.STATE_ALL_DATA){
					_uiLoadingAllData.show();
				} else {
					_uiLoadingAllData.hide();
				}
			},
			addItem: function(html){
				_list.append(html);
			},
			requestFinish: function(result,count){
				if(result){
					if(count == 0 && this._pageIndex == 1){
						this.setState(this.STATE_NO_DATA);
					} else if(count < this._pageSize){
						this.setState(this.STATE_ALL_DATA);
					} else {
						this._pageIndex++;
						this.setState(this.STATE_HAS_DATA);
					}
				} else {
					
				}
			},
			setDataInvoker: function(invoke){
				this._dataInvoke = invoke;
				return this;
			},
			begin: function(){
				this.setState(this.STATE_LOADING);
				this._doRequest();
			}
		};
		
		myList.init();
		window.myList = myList;
	});

</script>
// ActionScript file
import control.CBorderContainer;
import control.window.GroupMemberPanel;
import control.window.GroupPanel;
import control.window.PersonPanel;

import events.ChangeUserEvent;
import events.ChatTimelineEvent;
import events.ListClickEvent;
import events.UploadFileEvent;

import httpcontrol.HttpServiceUtil;

import json.JParser;

import model.ChatChannel;
import model.Schedule;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Menu;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import org.idream.pomelo.Pomelo;
import org.idream.pomelo.PomeloEvent;

import spark.components.VScrollBar;

import util.ChatManager;
import util.DateUtil;
import util.RightClickManager;
import util.ScheduleUtil;
import util.ToolUtil;
import util.UUIDUtil;

[Bindable]
public var bigPanel:Boolean = true;
[Bindable]
private var chatsArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var chatUser:ChatChannel;



override public function changeCurrentUser(e:ChangeUserEvent):void {
	Pomelo.getIns().addEventListener('onChat', chatHandler);
}
override public function init(e:FlexEvent):void {
	if (chatUser == null) {
		return;
	}
	
	if (chatUser.members == null) {
		horGroup.validateNow();
		addressList.visible = false;
		horGroup.removeElement(addressList);
	} else {
		addressList.visible = true;
	}
	if (chatUser) {
		head.source = chatUser.icon;
		nameLabel.text = chatUser.name;
	}
	var pids:Array = chatUser.getPids();
	if (chatUser.type == "p") {
		head.isPerson = true;
		if (pids[0] == pids[1]) {
			closeContainer(null);
			return;
		}
		
		Pomelo.getIns().request("connector.entryHandler.createChannel", {
			channel: chatUser.channel,
			users: pids
		}, function (data:Object):void {
			if (data.code == 500) {
				Alert.show("即时通信服务器异常，请稍后再试。");
			}
		});
	}
	if (chatUser.type != 'g') {
		quiteButton.visible = false;
		
	}
	if (chatUser.type == 't') {
		scheduleButton.visible = true;
		
	} else {
		scheduleButton.visible = false;
	}
	memberButton.visible = false;
	if (chatUser.type == 'g' && chatUser.author == ToolUtil.sessionUser.pid) {
		memberButton.visible = true;
	}
	
	Pomelo.getIns().addEventListener('onChat', chatHandler);
	getHistoryChat();
	flagTimeline();
	Pomelo.getIns().addEventListener('quiteChannel', quiteChannelHandler);
	Pomelo.getIns().addEventListener('joinChannel', joinChannelHandler);
	
	this.addEventListener(FocusEvent.FOCUS_IN, function (e:FocusEvent):void {
		flagCurrentChannel();
	});
	flagCurrentChannel();
	
	//            chatList.addEventListener(Flex)
	chatList.scroller.verticalScrollBar.addEventListener(Event.CHANGE, list_verticalScrollBar_change);
	
	init_owner();
	
//	this.title = chatUser.name;
}

private function flagTimeline():void {
	if (this.visible) {
		var event:ChatTimelineEvent = new ChatTimelineEvent(ChatTimelineEvent.Channel, true);
		event.channel = chatUser.channel;
		event.flag = this.flag;
		dispatchEvent(event);
	}
}






private var hashistory:Boolean = true;
private var isloading:Boolean = false;

private function list_verticalScrollBar_change(evt:Event):void {
	if (!hashistory || isloading) {
		return;
	}
	//            var vsb:VScrollBar = evt.currentTarget as VScrollBar;
	//            var obj:Object = {};
	//            obj.type = evt.type;
	//            obj.val = vsb.value;
	//            obj.max = vsb.maximum;
	if (evt.currentTarget is VScrollBar && evt.currentTarget.value == 0) {
		isloading = true;
		callLater(getHistoryChat);
	}
	//            callLater(dgScroll);
}

private function flagCurrentChannel():void {
	ToolUtil.currentChannel = chatUser.channel;
}

//        private var chatindex:int= -1;
public function getHistoryChat():void {
	var timeline:String;
	if (chatsArr.length > 0) {
		timeline = chatsArr.getItemAt(0)._id;
	}
	Pomelo.getIns().request("connector.entryHandler.history", {
		channel: chatUser.channel,
		id: timeline
	}, function (data:Object):void {
		if (data.code == 200) {
			var chats:ArrayCollection = new ArrayCollection(data.chats as Array);
			if (chats.length == 0) {
				hashistory = false;
				return;
			}
			
			if (chatsArr.length == 0) {
				chatsArr.addAll(chats);
			} else {
				chatsArr.addAllAt(chats, 0);
			}
			setPreDate(chatsArr);
			//                    chatindex = chats.length-1;
			//                    showLastMsg();
			callLater(showLastMsg, [chats.length - 1]);
		}
	})
}


private function setPreDate(list:ArrayCollection):void {
	var pre:Object;
	for each(var item:Object in list) {
		if (pre != null) {
			item.predate = pre.d;
		}
		pre = item;
	}
}

public function showLastMsg(index:Number = -1):void {
	if (index < 0) {
		if (chatsArr.length > 0) {
			chatList.validateNow();
			chatList.ensureIndexIsVisible(chatsArr.length - 1);
			chatList.validateNow();
			chatList.ensureIndexIsVisible(chatsArr.length - 1);
			
		}
	} else {
		chatList.validateNow();
		chatList.ensureIndexIsVisible(index);
		chatList.validateNow();
		chatList.ensureIndexIsVisible(index);
	}
	isloading = false;
}


public function quiteChannelHandler(event:PomeloEvent):void {
	if (chatUser.channel != event.message.channel) {
		return;
	}
	chatUser.members.refresh();
	for each(var person:Object in chatUser.members) {
		if (person.id == event.message.pid) {
			var i:int = chatUser.members.getItemIndex(person);
			if (i > -1) {
				chatUser.members.removeItemAt(i);
			}
			return;
		}
	}
	
}

public function joinChannelHandler(event:PomeloEvent):void {
	if (chatUser.channel != event.message.channel) {
		return;
	}
	chatUser.members.refresh();
	for each(var p:Object in chatUser.members) {
		if (p.id == event.message.pid) {
			return;
		}
	}
	for each(var person:Object in ToolUtil.memberList) {
		if (person.id == event.message.pid) {
			chatUser.members.addItem(person);
			return;
		}
	}
}

private function chatHandler(event:PomeloEvent):void {
	if (event.message.msg.channel != chatUser.channel) {
		return;
	}
	chatsArr.addItem(event.message.msg);
	setPreDate(chatsArr);
	showLastMsg();
	if (event.message.msg.channel == ToolUtil.currentChannel && event.message.msg.hasOwnProperty('f') && event.message.msg.f != ToolUtil.sessionUser.pid) {
		flagTimeline();
	}
	
}

private var contextMenuItems:ArrayCollection;

private function listItemClick_handler(e:ListClickEvent):void {
	contextMenuItems = new ArrayCollection([
		{"icon": CBorderContainer.wximg, "text": "发送消息", "mode": "chat", "selectedUser": e.data},
		{
			"icon": CBorderContainer.wximg,
			"text": "把'" + e.data.name + "'加入常用联系人",
			"mode": "addcontact",
			"selectedUser": e.data
		},
		{
			"icon": CBorderContainer.saveimg,
			"text": "查看'" + e.data.name + "'的信息",
			"mode": "show",
			"selectedUser": e.data
		}
	]);
	for each(var contact:Object in ToolUtil.contactsList) {
		if (e.data.id == contact.id) {
			contextMenuItems = new ArrayCollection([
				{"icon": CBorderContainer.wximg, "text": "发送消息", "mode": "chat", "selectedUser": e.data},
				{
					"icon": CBorderContainer.saveimg,
					"text": "查看'" + e.data.name + "'信息",
					"mode": "show",
					"selectedUser": e.data
				}
			]);
		}
	}
	if (e.data.id == ToolUtil.sessionUser.pid) {
		contextMenuItems = new ArrayCollection([
			{
				"icon": CBorderContainer.saveimg,
				"text": "查看'" + e.data.name + "'信息",
				"mode": "show",
				"selectedUser": e.data
			}
		]);
	}
	
	
	var menu:Menu = RightClickManager.getMenu(this, contextMenuItems, false);
	
	menu.labelField = "text";
	menu.iconField = "icon";
	menu.variableRowHeight = true;
	menu.rowHeight = 35;
	menu.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
	
	//              var point:Point = new Point(mouseX,mouseY);
	//              point = localToGlobal(point);
	menu.show(stage.mouseX - 120, stage.mouseY);
}

private function menuItemClickHandler(e:MenuEvent):void {
	var item:Object = e.item;
	var mod:String = item.mode;
	switch (mod) {
		case 'chat':
			var chatevent:ListClickEvent = new ListClickEvent("ChatUser",  new ChatChannel(e.item.selectedUser));
			dispatchEvent(chatevent);
			break;
		case 'addcontact':
			var param:Object = new Object();
			param["pid"] = e.item.selectedUser.id;
			HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/addPersonContact", function (result:Object, event:ResultEvent):void {
				ToolUtil.contactsRefresh();
			}, "POST").send(param);
			break;
		case 'show':
			var p:PersonPanel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, PersonPanel, true) as PersonPanel;
			p.personData = e.item.selectedUser;
			break;
		
	}
	
}

private function chatUserPanel():void {
	if (addressList.selectedItem == null) {
		return;
	}
	if (addressList.selectedItem.id == ToolUtil.sessionUser.pid) {
		Alert.show("不可以和自己聊天", "提示", 4, this);
		return;
	}
	var chat:ChatChannel = new ChatChannel(addressList.selectedItem);
	var chatevent:ListClickEvent = new ListClickEvent("ChatUser", chat);
	dispatchEvent(chatevent);
}

private function chatItemClick_handler(e:ListClickEvent):void {
	
}

private function createGroup():void {
	var gp:GroupPanel = PopUpManager.createPopUp(this, GroupPanel, true) as GroupPanel;
	gp.isEffect = false;
	if (chatUser.members == null) {
		var m:ArrayCollection = new ArrayCollection();
		for each(var p:Object in ToolUtil.memberList) {
			if (ToolUtil.sessionUser.pid == p.id || chatUser.id == p.id) {
				m.addItem(p);
			}
		}
		gp.chatmember = m;
	} else {
		gp.chatmember = chatUser.members;
	}
	gp.addEventListener("ChatUser", function (e:ListClickEvent):void {
		dispatchEvent(e);
	});
	
}

protected function sendBTN_clickHandler(event:MouseEvent = null):void {
	trace("//****TextInputer.sendBTN_clickHandler 执行****//");
	var _re:RegExp = /^\s*$/;
	var __msg:String = ti.text;
	if (_re.test(__msg))
		//如果输入的字符串仅包含空格、回车或者空，就不能发送信息
	{
		ti.setFocus();
		return;
	}
	var chat:Object = new Object();
	
	chat['id'] = UUIDUtil.create();
	chat['te'] = __msg;
	chat['co'] = cp.selectedColor;
	//            chat['we'] = bBTN.selected?'bold':'normal';
	//            chat['st'] = iBTN.selected?'italic':'normal';
	//            chat['de'] = uBTN.selected?'underline':'none';
	//            chat['si'] =ns.value ;
	chat['d'] = DateUtil.dateLblChat(new Date());
	
	sendChat(chat);
	
	
	ti.text = '';
	ti.setFocus();
}

private function sendChat(chat:Object):void{
	if (chatUser.members == null) {
		ChatManager.sendMessageToPerson(Number(chatUser.id), chat, function (data:Object):void {
			al(data, chat);
		});
	} else {
		if (chatUser.channel) {
			ChatManager.sendMessageToChannel(chatUser.channel, chat, function (data:Object):void {
				al(data, chat);
			});
		} else {
			ChatManager.sendMessageToDeparment(Number(chatUser.id), chatUser.type, chat, function (data:Object):void {
				al(data, chat);
			});
		}
		
	}
}

private function al(data:Object, chat:Object):void {
	trace("chat:" + JParser.encode(data));
}

private function pressEnter(event:FlexEvent):void {
	sendBTN_clickHandler();
}


private function quiteGroup():void {
	Pomelo.getIns().notify("connector.entryHandler.quiteChannel", {
		pid: ToolUtil.sessionUser.pid,
		channel: chatUser.channel
	});
}


private function memberGroup():void {
	var gp:GroupMemberPanel = PopUpManager.createPopUp(this, GroupMemberPanel, true) as GroupMemberPanel;
	gp.isEffect = false;
	gp.chatmember = chatUser.members;
	gp.channel = chatUser.channel;
}

private function showSchedule():void {
	var obj:Object = new Object();
	obj['id'] = chatUser.channel.substr(1);
	HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleById", function (result:Object, e:ResultEvent):void {
		if (result.success) {
			var schedulData:Schedule = new Schedule(result.result);
			ToolUtil.updateSchedul(schedulData.id, schedulData);
			ScheduleUtil.showSchedulePanel(schedulData.id);
			closeContainer(null);
		}
	}, "POST").send(obj);
}

private function uploadResult(result:Object):void{
	var chat:Object = new Object();
	
	chat['id'] = UUIDUtil.create();
	chat['te'] = ToolUtil.sessionUser.name+"上传文件："+result.result.name;
	chat['co'] = 0x000000;
	chat['filetype'] = result.result.filetype;
	chat['shareurl'] = result.result.shareurl;
	if(result.result.hasOwnProperty("height")){
		chat["height"]=result.result.height;
	}
	chat['d'] = DateUtil.dateLblChat(new Date());
	sendChat(chat);
	closeImage();
}
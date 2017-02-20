﻿package yr.mx.snax.pcq{    import flash.display.MovieClip;	import flash.display.Loader;	import flash.events.MouseEvent;    import flash.events.Event;    import flash.net.URLLoader;    import flash.net.URLRequest;	import flash.system.Security;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.geom.Rectangle;     public class VideoInteractiveClass extends MovieClip {        //add variables        private var urlLoader:URLLoader;        private var urlRequest:URLRequest;        private const XML_PATH:String = "./common/data/file.xml";        private var xml:XML;		private var videos_arr:Array=new Array()		private var player:Object;		private var loader:Loader = new Loader();		var containerButtons:MovieClip = new MovieClip();		var mc_Controller:mcController = new mcController();				var miMask:mask_mc = new mask_mc();												private var bLoaded:Number =0;		private var bTotal:Number=0;		private var bar:MovieClip;				private var currentTime:Number;		private var duration:Number;						private var IsPlayVideo:Boolean = false;		private var starDrag:Boolean = false;		private var starDragVolume:Boolean = false;						private var currentIdVideo:String = "";				private var currentSegIni:Number = 0;		private var currentSegFin:Number = 0;				         public function VideoInteractiveClass() {						Security.allowInsecureDomain("*");			Security.allowDomain("*");			            //load XML file            urlLoader = new URLLoader();            urlLoader.load(new URLRequest(XML_PATH));            urlLoader.addEventListener(Event.COMPLETE, xmlLoaded);														   //trace('Load Init');        }         private function xmlLoaded(e:Event):void        {            xml = new XML(e.target.data);			//trace('Load XML')            //we call each time when we create a button, the Buttons.as class             var inc:int = 0;			for each(var nodo:XML in xml.elements()){				//trace(1)				//Devuelve el atributo puntuacion				//trace('ID='+nodo.@id);				//trace('segundo='+nodo.segundo);				//trace('Total de HotSpots='+nodo.elementos.@total);								videos_arr[inc] = new Array();				videos_arr[inc]['idVideo'] = nodo.@id.toString();								//trace(videos_arr[0]['idVideo'] + ' --- ' + inc)								videos_arr[inc]['TotalBotones'] = nodo.elementos.@total;				videos_arr[inc]['segundoIni'] = nodo.segundoIni				videos_arr[inc]['segundoEnd'] = nodo.segundoEnd												 videos_arr[inc]['botones'] = new Array();				 for (var i:int = 0; i < nodo.elementos.@total; i++) {					//trace('Elemento '+i+' X= '+nodo.elementos.nextVideo[i].@gotoID) 					videos_arr[inc]['botones'][i] = new Array();					videos_arr[inc]['botones'][i]['x'] = nodo.elementos.nextVideo[i].@val_x;					videos_arr[inc]['botones'][i]['y'] = nodo.elementos.nextVideo[i].@val_y;					videos_arr[inc]['botones'][i]['widht'] = nodo.elementos.nextVideo[i].@val_w;					videos_arr[inc]['botones'][i]['height'] = nodo.elementos.nextVideo[i].@val_h;					videos_arr[inc]['botones'][i]['gotoVideo'] = nodo.elementos.nextVideo[i].@gotoID.toString();				 }								inc++;			}			creaPlayer();			        }						private function listenersController():void		{			mc_Controller.btn_play.addEventListener(MouseEvent.CLICK, ControllerClick);			mc_Controller.btn_pause.addEventListener(MouseEvent.CLICK, ControllerClick);			mc_Controller.main_btn_play.addEventListener(MouseEvent.CLICK, ControllerClick);			mc_Controller.btn_mute.addEventListener(MouseEvent.CLICK, ControllerClick);			mc_Controller.btn_volumen.addEventListener(MouseEvent.CLICK, ControllerClick);			mc_Controller.VideoMoveBar.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,startCurrentSlideDrag);			mc_Controller.VideoMoveBar.drag_mc.addEventListener(MouseEvent.MOUSE_UP,stopCurrentSlideDrag);						mc_Controller.VideoMoveBar.marcabar.addEventListener(MouseEvent.CLICK, setCurrentSlideDrag);									mc_Controller.VideoVoumeBar.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,startCurrentVolumeDrag);			mc_Controller.VideoVoumeBar.drag_mc.addEventListener(MouseEvent.MOUSE_UP,stopCurrentVolumeDrag);			mc_Controller.VideoVoumeBar.marcabar.addEventListener(MouseEvent.CLICK, setCurrentVolumeDrag);												mc_Controller.btn_pause.visible = false;			mc_Controller.btn_mute.visible = false;						mc_Controller.VideoProgressBar.pBar.width=0;			mc_Controller.VideoMoveBar.pBar.width=0;					}						private function setCurrentVolumeDrag (e:MouseEvent):void		{			var pcent = ((e.target.x - e.target.mouseX)*-1) / (e.target.width);						var ActualVolumeDrag:Number = pcent*100;						trace('---'+ActualVolumeDrag)											}				private function startCurrentVolumeDrag (e:MouseEvent):void		{			starDragVolume = true			//volumeBarDragging = true;			e.target.startDrag(false,new Rectangle(0,-6,95,0));			removeEventListener(Event.ENTER_FRAME,AdjustVolume);			addEventListener(Event.ENTER_FRAME,MueveBarraVolumen);					}				private function stopCurrentVolumeDrag (e:MouseEvent):void		{			starDragVolume = false			e.target.stopDrag();			removeEventListener(Event.ENTER_FRAME,MueveBarraVolumen);			addEventListener(Event.ENTER_FRAME,AdjustVolume);			//var segundoInStart:Number = (player.getDuration()*Math.floor((e.target.x / 415)*100))/100;			//trace('soltar en ' + Math.floor((e.target.x / 415)*100)+ ' en el segundo '+segundoInStart)					}				private function MueveBarraVolumen(e:Event) { 											var pcent2:Number = (mc_Controller.VideoVoumeBar.drag_mc.x*100)/95;			var sc2:Number = (100*pcent2)/100;			//trace('pcent2' + pcent2)			mc_Controller.VideoVoumeBar.pBar.width = sc2;			player.setVolume(pcent2)						if(pcent2<=0)			{				mc_Controller.btn_mute.visible = true;					mc_Controller.btn_volumen.visible = false;			}			else			{				mc_Controller.btn_mute.visible = false;					mc_Controller.btn_volumen.visible = true;			}																	}												private function setCurrentSlideDrag (e:MouseEvent):void		{			var pcent = ((e.target.x - e.target.mouseX)*-1) / (e.target.width + 20);									var segundoInStart:Number = pcent*player.getDuration();;									//starDrag = true			//volumeBarDragging = true;			//e.target.startDrag(false,new Rectangle(0,-6,415,0));			//removeEventListener(Event.ENTER_FRAME,trackProgress);			player.loadVideoById(currentIdVideo, segundoInStart)			mc_Controller.main_btn_play.visible = false;					mc_Controller.btn_pause.visible = true;					mc_Controller.btn_play.visible = false;		}				private function startCurrentSlideDrag (e:MouseEvent):void		{			starDrag = true			//volumeBarDragging = true;			e.target.startDrag(false,new Rectangle(0,-6,415,0));			removeEventListener(Event.ENTER_FRAME,trackProgress);			//marker.addEventListener(Event.ENTER_FRAME,adjustVolume);		}				private function stopCurrentSlideDrag (e:MouseEvent):void		{			starDrag = false			e.target.stopDrag();			//volumeBarDragging = true;			//mc_Controller.VideoMoveBar.drag_mc.startDrag(false,new Rectangle(0,-6,415,15));			//marker.addEventListener(Event.ENTER_FRAME,adjustVolume);									var segundoInStart:Number = (player.getDuration()*Math.floor((e.target.x / 415)*100))/100;			//trace('soltar en ' + Math.floor((e.target.x / 415)*100)+ ' en el segundo '+segundoInStart)			player.loadVideoById(currentIdVideo, segundoInStart)			addEventListener(Event.ENTER_FRAME,trackProgress);		}						private function ControllerClick (e:MouseEvent):void{			//trace("Click Button " + e.target.name);						switch(e.target.name)			{				case 'btn_play':					player.playVideo();					mc_Controller.main_btn_play.visible = false;					mc_Controller.btn_pause.visible = true;					mc_Controller.btn_play.visible = false;														break;								case 'btn_pause':					player.pauseVideo();					mc_Controller.main_btn_play.visible = true;					mc_Controller.btn_pause.visible = false;					mc_Controller.btn_play.visible = true;				break;								case 'main_btn_play':					player.playVideo();					mc_Controller.main_btn_play.visible = false;					mc_Controller.btn_pause.visible = true;					mc_Controller.btn_play.visible = false;				break;								case 'btn_mute':					player.unMute();					mc_Controller.btn_mute.visible = false;					mc_Controller.btn_volumen.visible = true;								break;								case 'btn_volumen':															player.mute();					mc_Controller.btn_mute.visible = true;					mc_Controller.btn_volumen.visible = false;								break;							}								}												private function creaPlayer():void        {			//trace('crea player')			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));			currentIdVideo = videos_arr[0]['idVideo']		}						private function onLoaderInit(event:Event):void {			addChild(loader);			loader.content.addEventListener("onReady", onPlayerReady);			loader.content.addEventListener("onError", onPlayerError);			loader.content.addEventListener("onStateChange", onPlayerStateChange);			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);		}						private function onPlayerReady(event:Event):void {						// Event.data contains the event parameter, which is the Player API ID 			//trace("player ready:", Object(event).data);						// Once this event has been dispatched by the player, we can use			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl			// to load a particular YouTube video.			player = loader.content;			player.loadVideoById(currentIdVideo);			//trace(videos_arr[0]['idVideo'])			player.setSize(980,501);						player.x = 0;  			player.y = -10;			addChild(containerButtons);			addChild(mc_Controller);			addChild(miMask);			player.mask = miMask			miMask.x = (stage.stageWidth / 2) - (miMask.width / 2) +5;			listenersController();			player.pauseVideo();												//player.setSize(640, 360);			//addEventListener(Event.ENTER_FRAME, loaded);			/*/ AS3			var mc:MovieClip = new MovieClip();			mc.graphics.beginFill(0xFF0000);			mc.graphics.drawRect(0, 0, 100, 80);			mc.graphics.endFill();			mc.x = 80;			mc.y = 60;			addChild(mc);*/				}						private function onPlayerError(event:Event):void {			// Event.data contains the event parameter, which is the error code			//trace("player error:", Object(event).data);		}				private function onPlayerStateChange(event:Event):void {			// Event.data contains the event parameter, which is the new player state			//trace("player state:", Object(event).data);						if(Object(event).data==3)			{				creaBotones(currentIdVideo);				creaListenerSegundos(currentIdVideo);				mc_Controller.visible=true;							}					}				private function onVideoPlaybackQualityChange(event:Event):void {			// Event.data contains the event parameter, which is the new video quality			trace("video quality:", Object(event).data);			mc_Controller.visible=true;		}				private function creaListenerSegundos(idVideo:String):void {			addEventListener(Event.ENTER_FRAME, loaded);			addEventListener(Event.ENTER_FRAME,trackProgress);			addEventListener(Event.ENTER_FRAME,AdjustVolume);			containerButtons.visible = false;		}						private function AdjustVolume(event:Event) {  						var volumeCurrent = player.getVolume();			//trace('currentVolume' + volumeCurrent)						var pcent:Number = volumeCurrent;			var sc:Number = (95*pcent)/100;												mc_Controller.VideoVoumeBar.pBar.width = sc;			mc_Controller.VideoVoumeBar.drag_mc.x = mc_Controller.VideoVoumeBar.pBar.width - 4					}  						private function loaded(event:Event) {  			//trace(player.getCurrentTime())						if(player.getCurrentTime()>=currentSegIni)			{				containerButtons.visible = true;			}			else			{				containerButtons.visible = false;			}		}  						private function creaBotones(idVideo:String):void {						trace('genera Botones Para:'+idVideo)						 for (var i:int = 0; i < videos_arr.length; i++) {				 if(videos_arr[i]['idVideo']==idVideo)				 {					 trace('Traemos datos del nodo '+ i);					 break;				 }			 }			 			 			 			 			 for (var j:int = 0; j < videos_arr[i]['TotalBotones']; j++) {				trace('Cuantas veces')								var mc:MovieClip = new MovieClip();				mc.name = videos_arr[i]['botones'][j]['gotoVideo']				mc.addEventListener(MouseEvent.CLICK, myClickGoto);				mc.useHandCursor = true;				mc.buttonMode = true;				mc.alpha = .2				mc.graphics.beginFill(0xFF0000);				mc.graphics.drawRect(0, 0, videos_arr[i]['botones'][j]['widht'], videos_arr[i]['botones'][j]['height']);				mc.graphics.endFill();				mc.x = videos_arr[i]['botones'][j]['x'];				mc.y = videos_arr[i]['botones'][j]['y'];				containerButtons.addChild(mc);			 }			 			 			 currentSegIni = videos_arr[i]['segundoIni']			 currentSegFin = videos_arr[i]['segundoEnd']					}						private function myClickGoto (e:MouseEvent):void{			mc_Controller.visible=false;			trace("I was clicked! " + e.target.name + ' y mi padre es '+e.target.parent.name);			removeBotones(e.target.parent);			player.loadVideoById(e.target.name);			currentIdVideo = e.target.name								}										private function removeBotones(container:MovieClip):void		{			while (container.numChildren > 0) {				container.removeChildAt(0);			}				}						private function setTextTime(currentTime:Number, duration:Number):void		{			mc_Controller.counterTime_txt.text = seg2min(currentTime) + " / " + seg2min(duration);								}				private function seg2min(num:Number) {		   var min:Number = Math.floor(num/60);		   var seg = Math.floor(num%60);		   if (seg<10) {			  seg = "0"+seg;		   }		   return "00 ."+seg;		}				private function trackProgress(event:Event):void {			var bLoaded = player.getVideoBytesLoaded();			var bTotal = player.getVideoBytesTotal();			var currentTime = player.getCurrentTime();			var duration = player.getDuration();			//trace('currentTime' + currentTime)						var pcent:Number = Math.floor((bLoaded / bTotal)*100);			var sc:Number = (420*pcent)/100;						mc_Controller.VideoProgressBar.pBar.width = sc;												   			var pcent2:Number = Math.floor((currentTime / duration)*100);			var sc2:Number = (415*pcent2)/100;			//trace('pcent2' + pcent2)			mc_Controller.VideoMoveBar.pBar.width = sc2;			if(!starDrag)			{				mc_Controller.VideoMoveBar.drag_mc.x = mc_Controller.VideoMoveBar.pBar.width - 4			}			//if(pcent2 > 0){    		//		mc_Controller.VideoMoveBar.pBar.width = mc_Controller.VideoProgressBar.pBar.width * pcent;    		//	}   			   					setTextTime(currentTime,duration)			//updateProgress();					//videoPlayerControls.setLoadingProgress({bytes:_bytesLoaded,total:_bytesTotal});			//videoPlayerControls.setSeekCurrentTime(youTubePlayer.CurrentTime);		}														    }}
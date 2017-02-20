﻿package yr.mx.snax.pcq.video {	import flash.display.*;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.geom.Rectangle;	public class VolumeBarControl extends MovieClip {		private var currentVolume:Number = 0;		private var volumeline:MovieClip;		private var volumebar:MovieClip;		public function set curVolume(inNum:Number):void {			currentVolume = inNum;			adjustVolumeBar();		}		public function get curVolume():Number {			return currentVolume;		}		public function VolumeBarControl() {			initVolumeBar();		}		/*		Method:initVolumeBar		Parameters:		Returns:		 */		private function initVolumeBar():void {			volumeline = line;			volumebar = bar;			volumebar.scaleX = currentVolume;			volumeline.buttonMode = true;			volumeline.addEventListener(MouseEvent.MOUSE_DOWN, adjustVolume);		}		/*		Method:adjustVolumeBar		Parameters:		Returns:		 */		private function adjustVolumeBar():void {			var sc:Number = currentVolume / 100;			volumebar.scaleX = sc;		}		/*		Method:adjustVolume		Parameters:		event:Event		Returns:		 */		private function adjustVolume(event:Event):void {			currentVolume = Math.floor(event.localX / volumeline.width * 100);			var sc:Number = event.localX / volumeline.width;			volumebar.scaleX = sc;			dispatchEvent(new Event(Event.CHANGE));		}	}}
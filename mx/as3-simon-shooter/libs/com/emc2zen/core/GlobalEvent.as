/**
* @private
* @license	GNU GPLv2
*
* Copyright (C) 2007  Polly Jex.
* 
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, 
* MA  02110-1301, USA.
*
* @see	http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
*/

package com.emc2zen.core {

	/**
	* @import
	*/

	import com.emc2zen.core.CoreEvent;

	/**
	* Capa de dato del modelo de implementacion de EVENTOS para el entorno GLOBAL.
	* @author	PollyJex
	*/
	public class GlobalEvent extends CoreEvent {
		
		/**
		* Evento REMOVE.
		*/
		public static const REMOVE:String = "onGlobalRemove";
		
		/**
		* Evento CHANGED.
		*/
		public static const CHANGED:String = "onGlobalChanged";
		
		
		
		/**
		* Constructor.
		* @param	type			Nombre del evento.
		* @param	property		Argumentos opcionales.
		* @param	bubbles			Indica si un evento es un evento de propagacion.
		* @param	cancelable		Indica si se puede evitar el comportamiento asociado al evento.
		* @return	GlobalEvent
		*/
		public function GlobalEvent( type:String, property:* = null, bubbles:Boolean = false, cancelable:Boolean = false ) {
			
			super( type, property, bubbles, cancelable );
			
		}
		
	}
	
}

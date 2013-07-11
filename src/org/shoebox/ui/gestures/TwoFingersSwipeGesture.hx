/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.shoebox.ui.gestures;

import flash.Lib;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.TouchEvent;
import flash.system.Capabilities;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.utils.system.Signal2;

using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */
class TwoFingersSwipeGesture extends GestureBase  implements ICommand{

	public var minVelocity( default , default ) : Float;
	public var mode( default , default )        : Mode2;

	public var onSwipe : Signal2<Float,Float>;

	private var _bActive     : Bool;
	private var _bNeedChange : Bool;
	private var _oTarget     : InteractiveObject;
	private var _fStartTime  : Int;
	private var _fDiff       : FPoint;
	private var _fVel        : FPoint;
	private var _fPrevCenter : FPoint;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( target : InteractiveObject ) {
			super( );
			minVelocity  = 0.2  / 254 * Capabilities.screenDPI;

			mode     = BOTH;
			onSwipe  = new Signal2<Float,Float>( );
			
			_oTarget     = target;
			_fPrevCenter = { x : 0.0 , y : 0.0 };
			_fDiff       = { x : 0.0 , y : 0.0 };
			_fVel        = { x : 0.0 , y : 0.0 };
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ) : Void {
			trace('onExecute');
			#if !mobile
			trace('TwoFingersSwipeGesture is Mobile mode only');
			#else
			if( Multitouch.inputMode != MultitouchInputMode.TOUCH_POINT )
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

			_oTarget.touchBegin( ).connect( _onTouchBegin );
			_oTarget.touchMove( ).connect( _onTouchMove );
			_oTarget.touchEnd( ).connect( _onTouchEnd );
			#end
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ) : Void {
			#if mobile
			_oTarget.touchBegin( ).disconnect( _onTouchBegin );
			_oTarget.touchMove( ).disconnect( _onTouchMove );
			_oTarget.touchEnd( ).disconnect( _onTouchEnd );			
			#end
		}	

	// -------o protected
		
		#if mobile

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchBegin( e : TouchEvent ) : Void{
			#if debug
			_debug( );
			#end
			_bNeedChange = false;
			addTouchPoint( e.touchPointID , e.stageX , e.stageY , Lib.getTimer( ) );
			_testActive( );			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchMove( e : TouchEvent ) : Void{
			if( _bNeedChange )
				return;

			var prev = _hPoints.get( e.touchPointID );
			var len = BoxMath.length( e.stageX - prev.x , e.stageY - prev.y );

			trace('_onTouchMove ::: '+len);
			//If length > Minimal movement
			if( len > MIN_MOVE ){

				var time = Lib.getTimer( );

				//Update coordinate of the touchPointId
					updateTouchPoint( e.touchPointID , e.stageX , e.stageY , time );
				
				// Update Central Point
					var bOn : Bool = _fCentral != null;
					if( bOn ){
						_fPrevCenter.x = _fCentral.x;
						_fPrevCenter.y = _fCentral.y;
					}
					updateCenter( );

				//Velocity calc
					if( bOn && _iCount == 2 ){
						_fDiff.x = _fCentral.x - _fPrevCenter.x;
						_fDiff.y = _fCentral.y - _fPrevCenter.y;
						var l : Float = BoxMath.length( _fDiff.x , _fDiff.y );
						var t : Float = time - _fStartTime;
						_fVel.x = _fDiff.x / t;
						_fVel.y = _fDiff.y / t;
						
						var b : Bool = false;
						trace('_onTouchMove ::: '+_fVel.x+' - '+_fVel.y );
						switch( mode ){

							case BOTH:
							 	b = BoxMath.length( _fVel.x , _fVel.y ) >= minVelocity;
							
							case X:
								b = ( _fVel.x * _fVel.x ) >= minVelocity;

							case Y:
								b = ( _fVel.y * _fVel.y ) >= minVelocity;
						}

						if( b ){
							onSwipe.emit( _fVel.x , _fVel.y );
							_bNeedChange = true;
						}
					}

			}else
				updateCenter( );

			#if debug
			_debug( );
			_debug_drawCenter( );
			#end
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchEnd( e : TouchEvent ) : Void{
			#if debug
			_clearDebug( );
			#end
			_bNeedChange = false;
			removeTouchPoint( e.touchPointID );
			_testActive( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _testActive( ) : Void{
			var b = _iCount == 2;
			if( _bActive != b && b )
				_fStartTime = Lib.getTimer( );
			_bActive = b;
		}

		#end
		
	// -------o misc
	
}
enum Mode2{
	BOTH;
	X;
	Y;
}
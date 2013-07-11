package org.shoebox.utils.frak;

import flash.display.Sprite;
import flash.events.Event;
import org.shoebox.patterns.frontcontroller.FrontController;

/**
 * ...
 * @author shoe[box]
 */

class Frak extends Sprite{

	public var fc : FrontController;

	private static var _sTriad : String;
	private static var __instance 		: Frak;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( e : SingletonEnforcer = null ) {
			
			super( );
			
			if( e == null )
				throw new flash.errors.Error( );
			
			fc = new FrontController( );
			fc.owner = this;
			
			_sTriad = fc.add( MFrak , VFrak , CFrak );
			fc.state = fc.registerState( [ _sTriad ] );
			
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function registerAlias( sAlias : String , o : Dynamic , sHelp : String , b : Bool = false ) : Void {
			return _getModel( ).registerAlias( sAlias , o , sHelp , b );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function unRegisterAlias( sAlias : String , o : Dynamic ) : Bool {
			return _getModel( ).unRegisterAlias( sAlias , o );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function registerVariable( s : String , target : Dynamic , prop : String ) : Bool {
			return _getModel( ).registerVariable( s , target , prop );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function unRegisterVariable( s : String ) : Bool {
			return _getModel( ).unRegisterVariable( s );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function log( s : String ) : Void {
			_getModel( ).log( s );
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _getModel( ) : MFrak{
			return cast getInstance( ).fc.getApp( _sTriad ).instance.model;
		}

	// -------o misc
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline static public function getInstance( ) : Frak {
			
			if( __instance == null )
				__instance = new Frak( new SingletonEnforcer( ) );

			return __instance;
		}

}

class SingletonEnforcer{
	
	public function new():Void{}

}
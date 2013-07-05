package org.shoebox.patterns.injector;

/**
 * ...
 * @author shoe[box]
 */

class Injector{

	private var _aInjections : Array<Injection<Dynamic>>;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		private function new() {
			_aInjections = [ ];
			#if cpp
			cpp.vm.Gc.doNotKill( this );
			cpp.vm.Gc.doNotKill( _aInjections );
			#end
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function get<T>( type : Class<T> , ?sName : String ) : T {

			var inj = _has( type , sName );
			//trace("inj :::: "+inj);
			if( inj == null )
				inj = _add( type , sName );

			try{
				if( inj.value == null ){
					inj.value = Type.createInstance( type , [ ] );
					#if cpp
					//cpp.vm.Gc.doNotKill( inj.value );
					#end
				}
			}catch( e : nme.errors.Error ){
				trace( e );
			}
			return inj.value;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function set( value : Dynamic , type : Class<Dynamic> , ?sName : String ) : Dynamic {
			//trace(Std.format("set ::: type : $type name : $sName value : $value"));
			var inj = _has( type , sName );
			if( inj == null )
				inj = _add( type , sName );
			return inj.value = value;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function add<T>( type : Class<T> , ?sName : String ) : Injection<T> {
			var inj = _add( type , sName );
			#if cpp
			cpp.vm.Gc.doNotKill( inj );
			#end
			return inj;
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _add<T>( type : Class<T> , ?sName : String ) : Injection<T>{
			var res : Injection<T> = new Injection( type , sName );
			_aInjections.push( res );
			return res;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _has( type : Class<Dynamic> , ?sName : String ) : Injection<Dynamic>{

			var res : Injection<Dynamic> = null;
			for( i in _aInjections ){
				if( i.type == type && i.sName == sName ){
					res = i;
					break;
				}
			}

			return res;

		}

	// -------o misc

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function getInstance( ) : Injector {
			if( __instance == null )
				__instance = new Injector( );

			return __instance;
		}

		private static var __instance : Injector = null;
}

/**
 * ...
 * @author shoe[box]
 */

class Injection<T>{

	public var value : T;
	public var sName : String;
	public var type : Class<T>;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( t : Class<T> , ?value : T , ?sName : String ) {
			this.type  = t;
			this.value = value;
			this.sName = sName;
		}

	// -------o public



	// -------o protected



	// -------o misc

}
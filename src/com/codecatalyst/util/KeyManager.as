package com.codecatalyst.util
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	
	public class KeyManager extends EventDispatcher
	{
		public var selected : Array 	= [];
		
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled(val:Boolean):void {
			if (_enabled != val) {
				_enabled = val;
				attachKeyListeners(_enabled);	
			} 
		}
		
		
		public function get target():IEventDispatcher {
			return _target;
		}
		public function set target(src : IEventDispatcher):void {
			if (src != _target) {
				attachKeyListeners(false);
				
				_target = src;

				attachKeyListeners(_enabled);
			}
		}
		
		public function KeyManager(source:IEventDispatcher=null) {
			super(null);		
			
			this._keyPoll    = new KeyPoll(source);
			this.target      = source;
		}

		public function forceDown(keyCode:uint):void    { return _keyPoll.markAsDown(keyCode); }
		public function isDown( keyCode:uint ):Boolean 	{	return _keyPoll.isDown(keyCode);  }
		public function isUp( keyCode:uint ):Boolean 		{	return _keyPoll.isUp(keyCode);				}





    private function attachKeyListeners(active:Boolean=true):void {
   	    if (target == null) return;
        
				if (active == true) 	{
					target.addEventListener(      KeyboardEvent.KEY_DOWN, onHandlesKeyDown, 	false, 6);  // Let keyPoll process event's first...
				}
			  else                		{
			  	target.removeEventListener(   KeyboardEvent.KEY_DOWN, onHandlesKeyDown, 	false);
			  }
			  
			  _keyPoll.attachTo(target as IEventDispatcher,active);
    }
		

		protected function onHandlesKeyDown(event:KeyboardEvent):void {
			// Subclasses should OVERRIDE this abstract method...
			//trace(event.toString());
		}		
					
		protected var _target     : IEventDispatcher = null;
		protected var _enabled    : Boolean          = true;
		
		private var _keyPoll      : KeyPoll          = null;
	}
}

        import flash.events.KeyboardEvent;
        import flash.events.Event;
        import flash.display.DisplayObject;
        import flash.utils.ByteArray;
        import flash.events.IEventDispatcher;
        
        /**
         * <p>Games often need to get the current state of various keys in order to respond to user input. 
         * This is not the same as responding to key down and key up events, but is rather a case of discovering 
         * if a particular key is currently pressed.</p>
         * 
         * <p>In Actionscript 2 this was a simple matter of calling Key.isDown() with the appropriate key code. 
         * But in Actionscript 3 Key.isDown no longer exists and the only intrinsic way to react to the keyboard 
         * is via the keyUp and keyDown events.</p>
         * 
         * <p>The KeyPoll class rectifies this. It has isDown and isUp methods, each taking a key code as a 
         * parameter and returning a Boolean.</p>
         */
        class KeyPoll
        {
                private var states:ByteArray;
                private var _target:IEventDispatcher;
                
                /**
                 * Constructor
                 * 
                 * @param stage A display object on which to listen for keyboard events.
                 * To catch all key events, this should be a reference to the stage.
                 */
                public function KeyPoll( eventSource:IEventDispatcher )
                {
                				initialize();
                        attachTo(eventSource,true);
                }
								
								public function attachTo(dispatcher:IEventDispatcher,active:Boolean=true):void {
									var currentTarget : IEventDispatcher = _target;
									addListener(false);
									
									_target = currentTarget = dispatcher;
									if (currentTarget == null) return;
									
									initialize();
									addListener(true);
									
											function addListener(active:Boolean):void {
												if (currentTarget == null) return;
												
												if (active == true) {
				                    currentTarget.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 4, true );
				                    currentTarget.addEventListener( KeyboardEvent.KEY_UP, 		keyUpListener, false, 4, true );
												} else {
				                    currentTarget.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false);
				                    currentTarget.removeEventListener( KeyboardEvent.KEY_UP, 		keyUpListener, false );
												}
											}
								}
								
								public function markAsDown(keyCode:uint):void {
									states[ keyCode >>> 3 ] |= 1 << (keyCode & 7);
								}

								private function initialize(event:Event=null):KeyPoll {
	                states = new ByteArray();
	
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                states.writeUnsignedInt( 0 );
	                
	                return this;
								}
                
                private function keyDownListener( ev:KeyboardEvent ):void
                {
                        states[ ev.keyCode >>> 3 ] |= 1 << (ev.keyCode & 7);
                }
                
                private function keyUpListener( ev:KeyboardEvent ):void
                {
                        states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
                }
                
                /**
                 * To test whether a key is down.
                 *
                 * @param keyCode code for the key to test.
                 *
                 * @return true if the key is down, false otherwise.
                 *
                 * @see #isUp()
                 */
                public function isDown( keyCode:uint ):Boolean
                {
                        return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
                }
                
                /**
                 * To test whether a key is up.
                 *
                 * @param keyCode code for the key to test.
                 *
                 * @return true if the key is up, false otherwise.
                 *
                 * @see #isDown()
                 */
                public function isUp( keyCode:uint ):Boolean
                {
                        return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
                }
        }

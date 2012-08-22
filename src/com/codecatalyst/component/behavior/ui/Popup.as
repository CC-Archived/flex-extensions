package com.codecatalyst.component.behavior.ui
{
	import com.codecatalyst.component.behavior.AbstractBehavior;
	import com.codecatalyst.component.behavior.IBehavior;
	import com.codecatalyst.component.behavior.ui.events.ContentEvent;
	import com.codecatalyst.factory.ClassFactory;
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.IFactory;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.UIComponent;
	import mx.effects.IEffect;
	import mx.events.CloseEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.styles.IStyleClient;
	
	[Event(name="contentChange",	 	type="com.codecatalyst.component.behavior.ui.events.ContentEvent")]
	[Event(name="contentInitialized",  	type="com.codecatalyst.component.behavior.ui.events.ContentEvent")]
	[Event(name="contentReady",  		type="com.codecatalyst.component.behavior.ui.events.ContentEvent")]
	[Event(name="contentReleased",  	type="com.codecatalyst.component.behavior.ui.events.ContentEvent")]
	[Event(name="close",				type="flash.events.Event")]
	[Event(name="keyDown",				type="flash.events.KeyboardEvent")]
	
	
	[DefaultProperty("renderer")]
	
	/**
	 *   The Popup Behavior provides easy-to-use functionality to show any content using the Flex PopupManager. 
	 *   The behavior, however, provides extra features such as autoClose, show/hide effects, positioning, and
	 *   management of interactions with the PopupManager.
	 * 
	 *   Best of all, the above extras are all handled internally by this behaviour; with no developer coding 
	 *   required. Content instances can be reused and memory cleanup requirements are also built-in.
	 *   
	 *   <p>
	 *   The content will be positioned according to:
	 * 	 <ul>
	 * 		<li>optional constraint styles (such as top, left, bottom, right, verticalCenter, horizontalCenter)</li>
	 * 		<li>can be positioned relative to the current mouse location, or </li> 
	 * 		<li>can be autoCentered</li>
	 * 	 </ul>
	 *   Positioning is relative to the specified parent; even thought the content's true parent is the [parent's]
	 *   SystemManager.
	 *   </p>
	 * 
	 *   <p>
	 *    The show action must be programmatically triggered. While the hide action can be triggered:
	 * 	  <ul>
	 * 	    <li>with a programmatically call to Popup::hide()</li>
	 * 	    <li>with a CloseEvent dispatched from the content instance, or</li> 
	 * 	    <li>with a MouseDown outside the popup content area [if autoClose is true].</li>
	 * 	  </ul>
	 * 	  The show and hide actions may also have effects (such as FadeIn or FadeOut) attached.
	 *   </p>
	 * 
	 *   <p>
	 *    Note that, by default, the popup content instance will be cached and reused. Popup::release(true) will
	 * 	  force the instance cache to be temporarily cleared.
	 *   <p>
	 *    
	 * 
	 *  <pre>
	 * 
	 *   &lt;mx:Script&gt;
	 *  	&lt;![CDATA[
	 *  		import com.codecatalyst.component.behavior.ui.Popup;
	 *  		import com.codecatalyst.factory.ClassFactory;
	 *  		import com.codecatalyst.factory.styleable.StyleableFactory;
	 * 
	 *          protected function onShowCorrelation(e:Event):void {
	 *          	_window = correlations.show() as CorrelationWindow;
	 *
	 *            // Register with Swiz so [Inject] will occur in CorrelationWindow
	 *          	_swiz.registerWindow(_window);
	 *          }
	 *          
	 *          protected function onProgrammaticPopup():void {
	 * 				// data, positioning configuration, and show/hide effects for the popup
	 * 
	 *          	var config       : Object 	= { histograms:this.availableHistograms, horizontalCenter:0, bottom:20 };
	 *          	var renderer     : IFactory = new StyleableFactory( Performances, null, config );
	 *          	var params       : Object 	= {  showEffect : new ClassFactory( Fade, null, {duration:1000} ),
	 *          								     hideEffect : new ClassFactory( Fade, null, {duration:300} ),
	 *          								     autoClose  : true };
	 * 
	 *          	// Since not instantiated via MXML, we MUST manually initialize
	 * 
	 *          	var performances : Popup  	= new Popup( renderer, this.testsDataGrid, params );
	 *          		performances.initialized(this,null);
	 * 
	 *          	// The show the poup and register the popup [DisplayObject instance] with Swiz
	 * 
	 *          	_swiz.registerWindow( performances.show() );
	 *           }
	 *           
	 *
	 *           protected var _window : CorrelationWindow = null;
	 *          
	 *      ]]&gt;
	 *  &lt;/mx:Script&gt;
	 * 
	 *	&lt;ui:Popup 	
	 *        id="correlations"
	 *				parent="{this}"
	 *				autoClose="true"	
	 *				modal="false" 
	 *				showEffect="{  new ClassFactory( Fade,null,{duration:600} )   }" 	
	 *				hideEffect="{  new ClassFactory( Fade,null,{duration:400} )   }" 	
	 *				renderer="{ new StyleableFactory( CorrelationWindow, null,{ bottom:100, right:100 } ) }"  
	 *				xmlns:ui="com.codecatalyst.component.behavior.ui.*" /&gt;
	 * 
	 *  &lt;!-- Enabled Swiz injection via SET_UP_BEAN --&gt;
	 * 
	 * 	&lt;ui:Popup	id="performances"
	 * 				parent="testsGrid"
	 * 				autoClose="true" modal="true"
	 * 				showEffect="{  new ClassFactory( Fade,null,{duration:600} )   }" 	
	 *				hideEffect="{  new ClassFactory( Fade,null,{duration:400} )   }"
	 * 				contentChange="dispatchEvent( new BeanEvent(BeanEvent.SET_UP_BEAN,popup.content) );"
	 * 				xmlns:ui="com.codecatalyst.component.behavior.ui.*" &gt;
	 * 
	 * 			&lt;mx:Component&gt;
	 * 				&lt;PerformanceHistory  
	 * 						histograms="{this.availableHistograms}" 
	 * 						horizontalCenter="0" 
	 * 						bottom="20" /&gt;
	 * 			&lt;/mx:Component&gt;
	 * 
	 *  &lt;/ui:Popup&gt;
	 * 
	 * </pre>
	 */	
	public class Popup extends AbstractBehavior implements IBehavior
	{
		[Bindable]
		[Invalidate("properties")]
		/**
		 * IFactory, class, or instance for the FadeIn effect 
		 * @return IEffect 
		 */
		public var showEffect 	 	: *;			   	
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * IFactory, class, or instance for the FadeOut effect 
		 * @return IEffect 
		 */
		public var hideEffect	 	: *;			   
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Boolean switch to enable/disable show/hide effects on content 
		 * @return IEffect 
		 */
		public var effectsEnabled	: Boolean = true;
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * IFactory used to generate instance of content 
		 */
		public var renderer  	: *;   	   
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Owner of the popup content. Used by PopupManager to determine
		 * the appropriate SystemManager and used to determine positioning if
		 * "center" is used. 
		 */
		public var parent    	: DisplayObject;  
		
		/**
		 *  Autoclose popup upon MouseDown outside the content popup area
		 */
		public var autoClose 	: Boolean = false;		    
		
		/**
		 * Show popup content modally with background blurred/dimmed 
		 */
		public var modal     	: Boolean = false;
		
		[Bindable("visibleChanged")]
		public function get visible() : Boolean
		{
			return (isContentReady && content.visible);	
		}
		
		/**
		 * Cache the content instance for multiple showings 
		 */
		public var cacheEnabled : Boolean = true;
		
		
		[Bindable("contentChange")]
		/**
		 * Internal builder that will create a new content instance
		 * and prepare it for management by the Popup behavior
		 *  
		 * @return IFlexDisplayObject 
		 */
		public function get content():UIComponent 
		{
			if (isInitialized && (renderer as IFactory) && !instance) {
				instance = renderer.newInstance();
				updateFadeEffects();
				
				// Listen to ready notification so positioning will work...
				instance.addEventListener(FlexEvent.CREATION_COMPLETE, onContentReady, false, 0, true);
				instance.addEventListener(CloseEvent.CLOSE, onCloseContent, false, 0, true);				
				instance.addEventListener(FlexEvent.INITIALIZE, onContentInitialized, false, 0 , true);
				
				dispatchEvent(new ContentEvent(ContentEvent.CONTENT_CHANGE,instance));
			}
			
			return instance;
		}
		
		// ========================================
		// Public Methods
		// ========================================
		
		/**
		 * Constructor  
		 * @param renderer IFactory used to create new instance of popup content
		 * @param parent DisplayObject that is the owner of the popup instance
		 * @param modal Boolean to determine if the popup is model
		 * 
		 */
		public function Popup(renderer	: IFactory		=null, 
							  parent	: DisplayObject	=null, 
							  params    : Object        =null) 
		{
			
			params ||= new Object;
			params.renderer = renderer;
			params.parent   = parent;
			
			init(params);
		}
		
		/**
		 * Initialize properties from hashmap of settings
		 * 
		 * @param config Object
		 * @return Popup
		 * 
		 */
		public function init(config:Object=null):Popup 
		{
			config ||= new Object;
			
			for (var key:String in config) {
				if ( this.hasOwnProperty(key) ) 
					this[key] = config[key];
				
				if ((key == "showEffect") || (key == "hideEffect")) 
					effectsEnabled ||= (config[key] != null); 
			}
			return this;
		}
		
		
		/**
		 * Show the popup content with modality option
		 * Use optional content style constraints to position content relative
		 * to parent or center on the SystemManager
		 */
		public function show():IFlexDisplayObject {
			
			if (parent != null) {
				
				PopUpManager.addPopUp(content, parent, modal);
				showInstance();
			}
			
			return content;
		}
		
		/**
		 * Show the popup content at the current mouse/cursor location
		 * with the specified topLeft offsets.
		 * 
		 * @param origin Point for top left positioning of the content
		 * @param offset Point to specify offset of the content top left  
		 * @return IFlexDisplayObject
		 * 
		 */
		public function showAt(origin:Point=null, offset:Point=null):IFlexDisplayObject {
			try {
				
				stopEffects();
				cursorAnchor = new MouseAnchor(content, origin, offset);
				
				show();
				
			} finally {
				
				if ( isContentReady ) 
					cursorAnchor = null;
			}
			
			return content;
		}
		
		
		/**
		 * Hide the popup content; use the fadeout features if configurated.
		 */
		public function hide():void {
			
			onCloseContent();
		}
		
		
		/**
		 * After the popup content is hidden, release the constraints
		 * and optionally release the cached instance.
		 *  
		 */
		public function release(clearCache:Boolean=false):void {
			
			if (constraints != null) 
				constraints.release();
			
			constraints  = null;
			cursorAnchor = null;
			
			if (instance && (!cacheEnabled || clearCache)) {
				
				instance.removeEventListener(EffectEvent.EFFECT_END, onHideFinished);
				instance.removeEventListener(CloseEvent.CLOSE, onCloseContent);
				instance.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				
				dispatchEvent( new ContentEvent(ContentEvent.CONTENT_RELEASED,instance) );
				instance = null;
				dispatchEvent(new ContentEvent(ContentEvent.CONTENT_CHANGE,null));
			}
		}
		
		// ========================================
		// Protected Overrides 
		// ========================================
		
		/**
		 * Processes the properties set on the component.
		 */
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if ( propertyTracker.invalidated( [ "effectsEnabled", "showEffect" ] ) )
			{
				showEffect 	= buildEffect(showEffect);
				updateFadeEffects();
			}
			
			if ( propertyTracker.invalidated( [ "effectsEnabled", "hideEffect" ] ) )
			{
				hideEffect	= buildEffect(hideEffect);
				updateFadeEffects();
			}
			
			if ( propertyTracker.invalidated( [ "renderer" ] ) )
			{
				buildRenderer();
			}
			
			if ( propertyTracker.invalidated( [ "parent" ] ) ) 
			{
				constraints = new Anchors(parent,instance);
			}
			
		}
		
		/**
		 * Override to auto-set the "parent" if not already initialized
		 *  
		 * @param document Object parent container for the tag 
		 * @param id String identifier for this popup instance
		 */
		override public function initialized( document:Object, id:String ):void 
		{
			if ((document is DisplayObject) && !parent) 
				this.parent = document as DisplayObject;
			
			super.initialized(document,id);
		}
		
		// ========================================
		// Protected EventHandlers 
		// ========================================
		
		
		/**
		 * Notify listeners that the content has initialized (but not yet creationComplete).
		 *  
		 * @param event
		 */
		protected function onContentInitialized(event:FlexEvent):void 
		{
			content.removeEventListener(FlexEvent.INITIALIZE, onContentInitialized);
			
			dispatchEvent( new ContentEvent(ContentEvent.CONTENT_INITIALIZED) );
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onContentReady(event:FlexEvent):void 
		{
			content.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,0,true);
			content.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			
			content.removeEventListener(FlexEvent.CREATION_COMPLETE, onContentReady);
			dispatchEvent( new ContentEvent(ContentEvent.CONTENT_READY,content) );
			
			showInstance();
			
			// Since positioning changes [in showInstance() above] may affect content rendering
			
			if (content is IInvalidating) 
				IInvalidating(content).invalidateDisplayList();
		}
		
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onCloseContent(event:CloseEvent=null):void 
		{
			if ( !content ) return;
			
			if ( content.stage ) 
			{
				content.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true);
				content.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
				
			
			// This will execute a hideEffect effect IF one has been configured
			
			content.visible = false;
			
			// Simulate hideEffect completion notification
			
			if (hideEffect == null) 
				onHideFinished();
			
			if (event != null)
				event.stopPropagation();
		}
		
		/**
		 * The keydown event is dispatched from the popup if no one
		 * else kills it first.
		 */
		protected function onKeyDown(event:KeyboardEvent):void 
		{
			dispatchEvent( event.clone() );
			event.stopImmediatePropagation();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onHideFinished(event:EffectEvent=null):void
		{
			if ( !event || (event.effectInstance.effect == hideEffect) ) {
				content.visible = false;
				
				if ( content.stage ) 
					PopUpManager.removePopUp(content);
				
				release();
				
				if (content is UIComponent) 
					UIComponent(content).isPopUp = false;
				
				dispatchEvent(new Event("visibleChanged") );
				dispatchEvent(new Event("close") );
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMouseDown(event:MouseEvent):void {
			
			if ( !mouseIsOver(content as DisplayObject) ) {
				var alreadyClosing : Boolean = (hideEffect is IEffect) && IEffect(hideEffect).isPlaying; 
				
				if ( autoClose && !alreadyClosing) 
				{
					content.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
				}
				
			}
		}
		
		// ========================================
		// Protected Fade methods
		// ========================================
		
		
		/**
		 * Attach or detach the show and hide effects for the content popup.
		 * Note: that only the hide effect will use an effect handler. 
		 */
		protected function updateFadeEffects():void 
		{
			if (content && content is IStyleClient) {
				IStyleClient(content).setStyle("showEffect",effectsEnabled ? showEffect  : null);
				IStyleClient(content).setStyle("hideEffect",effectsEnabled ? hideEffect : null);
				
				if (effectsEnabled && showEffect) 
					content.visible = false; 
				
				if (effectsEnabled && hideEffect) 
					content.addEventListener(EffectEvent.EFFECT_END, onHideFinished, false, 0, true);
			}
		}
		
		/**
		 * Build the show or hide effect using the specific source.
		 * 
		 * @param effect IFactory, Class, or IEffect instance
		 * @return IEffect
		 */
		protected function buildEffect(effect:*):IEffect 
		{
			var results : IEffect = (effect is IFactory) ?  IFactory(effect).newInstance() as IEffect :
				(effect is Class)    ?  new effect() as IEffect					  : 
				effect as IEffect;
			
			return results;
		}
		
		protected function stopEffects():void {
			
			function endPlay(effect:IEffect):void {
				
				if ( effect && effect.isPlaying)  
					effect.end();
				
			}
			
			endPlay( showEffect as IEffect);
			endPlay( hideEffect as IEffect); 
		}
		
		
		/**
		 * Build the content instance generator using the specified source;
		 * which may be an IFactory, Class, Qualified ClassName String, or sample instance.
		 * 
		 * Note: this does NOT build the instance; only the generator
		 */
		protected function buildRenderer():void {
			instance = null;
			
			if (renderer is IFactory) return;
			if (renderer == null)     return;
			
			
			renderer = new ClassFactory(renderer);
			release(true);
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Show the content instance positioned according to constraints or mouseAnchors
		 * Provide support for autoClose.
		 * 
		 */
		protected function showInstance():void 
		{
			adjustPosition();
			
			PopUpManager.bringToFront(content);
			
			// Make sure the PopUpmanager drag is enabled...
			
			if (content is UIComponent) 
				UIComponent(content).isPopUp = true;	
			
			if ( content.stage )
			{
				content.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,0,true);
				content.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			}
			
			content.visible = isContentReady;
			
			if ( content.visible && content.stage )
				dispatchEvent(new Event("visibleChanged") );
			
		}
		
		/**
		 * Move and resize (if needed) the popup content manually otherwise
		 * default to autoCenter the popup content. 
		 * 
		 */
		protected function adjustPosition():void 
		{
			if ( !parent || !parent.stage ) return;
			if ( !isContentReady )			return;
			if ( manuallyPositioned )		return;
			
			PopUpManager.centerPopUp(content);
		}
		
		
		/**
		 * Dynamically move and resize (if needed) the popup content according to the anchor
		 * styles or simply move the content according to current Mouse location and offset(s). 
		 */
		protected function get manuallyPositioned():Boolean {
			
			// Since the content constraint styles may change at any time, always create new Anchor instance 
			
			constraints = new Anchors(parent,content);
			
			// Apply cursorAnchor FIRST (if specified), fallback to constraints (if specified)
			
			return (cursorAnchor && cursorAnchor.apply()) || constraints.apply()
		}
		
		
		// ========================================
		// Protected Properties
		// ========================================
		
		/**
		 * Getter to determine if the content is ready 
		 * @return Boolean 
		 */
		[Bindable("contentReady")]
		
		protected function get isContentReady():Boolean {
			return (  content 							&& 
					  (content is UIComponent) 			&& 
					  UIComponent(content).initialized		);
		}
		
		/**
		 * Cached instance of the renderer instance 
		 * May be an instance of IDataRenderer
		 */
		protected var instance : UIComponent;
		
		
		/**
		 * Helper class to position content based on [Flex styling] constraints 
		 */
		protected var constraints : Anchors;
		
		
		/**
		 * Helper class to position content relative to current mouse 
		 */
		protected var cursorAnchor : MouseAnchor;
		
		
		/**
		 * @private
		 * Invalidation tracker.
		 */
		protected var propertyTracker:InvalidationTracker = new InvalidationTracker( this as IEventDispatcher );
		
		// **********************************************************
		// Utility Methods 
		// **********************************************************
		
		
		/**
		 *  @private
		 *  Returns true if the mouse is over the specified target.
		 * 
		 *  from ToolTipManagerImpl
		 */
		private function mouseIsOver(target:DisplayObject):Boolean
		{
			if (!target || !target.stage)	
				return false;
			
			/**
			 * If the mouse coordinates are (0,0), there  is a chance the component 
			 * has not been positioned yet and we'll end up mistakenly hitTest will 
			 * return true.
			 */ 
			if ( (target.stage.mouseX == 0) && (target.stage.mouseY == 0) )
				return false;
			
			return target.hitTestPoint(target.stage.mouseX,
				target.stage.mouseY,false);
		}
		
	}
}


////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: LayoutConstraints
//
////////////////////////////////////////////////////////////////////////////////



import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.styles.IStyleClient;


/**
 * This class manages the positioning of the popup target according
 * to [optional] mouse coordinates or specific pixel location.  
 */
class MouseAnchor {
	
	/**
	 * Constructor 
	 *  
	 * @param parent Simulated parent for the target; may not be actual parent
	 * @param child  DisplayObject that will be positioned relative to the parent
	 */
	public function MouseAnchor(child:Object, origin:Point=null, offset:Point=null) {
		this.child  = child as DisplayObject;
		
		this.origin = origin;
		this.offset = offset || new Point();
	}
	
	public function apply():Boolean {
		if ( !child || !child.stage ) return false;
		
		var mLoc: Point = new Point(child.stage.mouseX, child.stage.mouseY);
		var pnt : Point = origin || child.stage.localToGlobal(mLoc);
		
		pnt = child.parent.globalToLocal( pnt.add(offset) );
		
		child.x = pnt.x
		child.y = pnt.y;
		
		return true;
	}
	
	/**
	 * Popup target instance 
	 */
	protected var child  : DisplayObject;
	
	/**
	 * Offset of TopLeft wrt Origin 
	 */
	protected var offset : Point;
	/**
	 * LeftTop coordinates of the popup in Global coordinates 
	 */
	protected var origin : Point;
}



/**
 * Anchors manages position changes to conform to target anchor styles with respect
 * to the popup's parent
 * 
 */
class Anchors {
	
	public function get hasAnchors():Boolean {
		var results : Boolean 			= false;
		var anchors : LayoutConstraints = getLayoutConstraints(child as IStyleClient);
		
		return anchors ? anchors.hasConstraints : false;
	}	
	
	/**
	 * Constructor 
	 *  
	 * @param parent Simulated parent for the target; may not be actual parent
	 * @param child  DisplayObject that will be positioned relative to the parent
	 */
	public function Anchors(parent:Object, child:Object) {
		this.parent = parent as DisplayObject;
		this.child = child as DisplayObject;
	}
	
	
	public function apply():Boolean {
		if ( !hasAnchors ) return false;
		
		parent.addEventListener(Event.RESIZE,onParentResize,false,0,true);
		onParentResize();
		
		return true;
	}
	
	public function release():void {
		
		parent.removeEventListener(Event.RESIZE,onParentResize);
		
		parent = null;
		child  = null;
	}
	
	protected function onParentResize(event:Event=null):void {
		if (!parent || !parent.stage) return;
		
		var bounds : Rectangle = new Rectangle(parent.x, parent.y, parent.width, parent.height);
		
		applyAnchors(bounds, child as IUIComponent);
	}
	
	
	/**
	 *  @private
	 *  Here is a description of the layout algorithm.
	 *  It is described in terms of horizontal coordinates,
	 *  but the vertical ones are similar.
	 *
	 *  1. First the actual width for the child is determined.
	 *
	 *  1a. If both left and right anchors are specified,
	 *  the actual width is determined by them.
	 *  However, the actual width is subject to the child's
	 *  minWidth.
	 *
	 *  1b. Otherwise, if a percentWidth was specified,
	 *  this percentage is applied to the 
	 *  ConstraintColumn/Parent's content width
	 *  (the widest specified point of content, or the width of
	 *  the parent/column, whichever is greater).
	 *  The actual width is subject to the child's
	 *  minWidth and maxWidth.
	 *
	 *  1c. Otherwise, if an explicitWidth was specified,
	 *  this is used as the actual width.
	 *
	 *  1d. Otherwise, the measuredWidth is used is used as the
	 *  actual width.
	 *
	 *  2. Then the x coordinate of the child is determined.
	 *
	 *  2a. If a horizonalCenter anchor is specified,
	 *  the center of the child is placed relative to the center
	 *  of the parent/column. 
	 *
	 *  2b. Otherwise, if a left anchor is specified,
	 *  the left edge of the child is placed there.
	 *
	 *  2c. Otherwise, if a right anchor is specified,
	 *  the right edge of the child is placed there.
	 *
	 *  2d. Otherwise, the child is left at its previously set
	 *  x coordinate.
	 *
	 *  3. If the width is a percentage, try to make sure it
	 *  doesn't overflow the content width (while still honoring
	 *  minWidth). We need to wait
	 *  until after the x coordinate is set to test this.
	 */
	private function applyAnchors( bounds:Rectangle, child:IUIComponent = null):void
	{	
		var anchors	:LayoutConstraints = hasAnchors ? getLayoutConstraints(child as IStyleClient) : null;
		
		if (anchors == null) return;
		
		var checkWidth			:Boolean = !isNaN(child.percentWidth);
		var checkHeight			:Boolean = !isNaN(child.percentHeight);
		
		var availableWidth		:Number	 = bounds.width;
		var availableHeight		:Number	 = bounds.height; 
		
		var left				:Number = anchors.left;
		var right				:Number = anchors.right;
		var top					:Number = anchors.top;
		var bottom				:Number = anchors.bottom;
		var horizontalCenter	:Number = anchors.horizontalCenter;
		var verticalCenter		:Number = anchors.verticalCenter;
		
		//Variables to track the offsets
		
		var w			:Number;
		var h			:Number;
		var x			:Number;
		var y			:Number;
		
		// The width of the region which /the control will live in. 
		
		availableWidth  = Math.round(availableWidth);
		availableHeight = Math.round(availableHeight);
		
		// If a percentage size is specified for a child, it specifies a percentage of the parent's content size
		// minus any specified left, top, right, or bottom anchors for this child. Also, respect the child's minimum and maximum sizes.
		
		w 	=	( !isNaN(left) && !isNaN(right) )	?	Math.max(availableWidth - left - right, child.minWidth)									:
			( !isNaN(child.percentWidth) )		?	inBounds(child.percentWidth / 100 * availableWidth, child.minWidth, child.maxWidth)		:
			child.getExplicitOrMeasuredWidth();
		
		//The height of the region which the control will live in. 
		
		h 	=	( !isNaN(top) && !isNaN(bottom) )	?	Math.max(availableHeight - top - bottom, child.minHeight)								:
			( !isNaN(child.percentHeight) )		?	inBounds(child.percentHeight / 100 * availableHeight, child.minHeight, child.maxHeight)	:
			child.getExplicitOrMeasuredHeight();
		
		// The left, right, and horizontalCenter styles affect the child's x and/or its actual width.
		
		x = !isNaN(horizontalCenter) ?	Math.round((availableWidth - w) / 2 + horizontalCenter)	:
			!isNaN(left)             ?  left 													:
			!isNaN(right)            ?  availableWidth - right - w								: child.y;
		
		// The top, bottom, verticalCenter and baseline styles affect the child's y and/or its actual height.
		
		y = !isNaN(verticalCenter) 	 ?	Math.round((availableHeight - h) / 2 + verticalCenter)	:
			!isNaN(top)              ?  top 													:
			!isNaN(bottom)           ?  availableHeight - bottom - h							: child.x;
		
		// One last test here. If the width/height is a percentage,
		// limit the width/height to the available content width/height, 
		// but honor the minWidth/minHeight.
		
		w = checkWidth 	&& (x + w > availableWidth) 	? 	Math.max(availableWidth - x, child.minWidth) 		: NaN;
		h = checkHeight	&& (y + h > availableHeight)	?	Math.max(availableHeight - y, child.minHeight)		: NaN;
		
		var pnt : Point = parent.localToGlobal(new Point(x, y));
		pnt         = child.parent.globalToLocal(pnt);
		
		child.move(pnt.x, pnt.y);
		
		if ( !isNaN(w) && !isNaN(h) )
			child.setActualSize(w, h);
	}
	
	/**
	 *  @private
	 *  Collect all the layout constraints for this child and package
	 *  into a LayoutConstraints object.
	 *  Returns null if the child is not an IConstraintClient.
	 */
	private function getLayoutConstraints(constraintChild:IStyleClient):LayoutConstraints
	{
		if ( !constraintChild )	return null;
		
		var constraints	: LayoutConstraints = new LayoutConstraints();
		
		constraints.top 				= constraintChild.getStyle("top");
		constraints.left 				= constraintChild.getStyle("left");
		constraints.bottom 				= constraintChild.getStyle("bottom");
		constraints.right 				= constraintChild.getStyle("right");
		constraints.horizontalCenter 	= constraintChild.getStyle("horizontalCenter");
		constraints.verticalCenter 		= constraintChild.getStyle("verticalCenter");
		
		return constraints;
	}
	
	
	/**
	 *  @private
	 *  Restrict a number to a particular min and max.
	 */
	private function inBounds(a:Number, min:Number, max:Number):Number
	{
		return   ( a < min ) ? min	:
			( a > max ) ? max  : Math.floor(a);
	}
	
	protected var parent : DisplayObject;
	protected var child  : DisplayObject;
}



/**
 * A data structure snapshot of the target's current anchors/constraints 
 */
class LayoutConstraints
{
	public var top				:*;
	public var left				:*;
	public var bottom			:*;
	public var right			:*;
	public var horizontalCenter	:*;
	public var verticalCenter	:*;
	
	public function get hasConstraints():Boolean {
		return top || left || bottom || right || horizontalCenter || verticalCenter;		
	}
}

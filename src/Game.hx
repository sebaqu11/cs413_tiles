import starling.display.Sprite;
import starling.display.Image;
import flash.geom.Point;
import starling.core.Starling;
import starling.text.TextField;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.SelectorFilter;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundTransform;
import flash.media.SoundChannel;
import flash.media.Sound;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;
import haxe.Timer;
import flash.ui.Keyboard;
import Root;
import Tilemap;

class Game extends Sprite
{
	var rootSprite:Sprite;
	var map:Tilemap;
	var transitionSpeed = 0.5;

	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
	}
	
	public function start() {
		
		var stage = Starling.current.stage;
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		map = new Tilemap(Root.assets, "map");
		map.x = -192;
		map.y = -1680;
		stage.addChild(map);
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		this.removeFromParent;
		this.dispose;
	}
	
	function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.UP) {
			map.y += 160;
		}
		else if (event.keyCode == Keyboard.DOWN) {
			map.y -= 160;
		}
		else if (event.keyCode == Keyboard.LEFT) {
			map.x += 160;
		}
		else if (event.keyCode == Keyboard.RIGHT) {
			map.x -= 160;
		}
	}
	
	function onEnterFrame(event:EnterFrameEvent) {
		
	}
			
	
	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}

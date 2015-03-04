import starling.display.Sprite;
import starling.display.Image;
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

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var levelFile:String;
	var progress = 0;
	var errorsSkipped = 0;
	var strikes = 0;
	var numCorrect = 0;
	var fieldProgress = 0; // Determines what textobject should be popped next
	var fields:Array<TextObject>; // All of the textobject fields
	var introFields:Array<TextObject>; // All of the intro fields
	var outroFields:Array<TextObject>; // All of the outro fields
	
	var currentSpeaker:Speakers;
	var currentField:TextObject;
	var fieldState = FieldState.INTRO;
	var renderProgress = 0; // How far in rendering the text animation we are (in characters)
	var animating = false;
	var soundCounter = 0;
	var menuSelection = 0;
	var waveRate = 0.125;
	
	var animTimer:Timer;
	
	var textBox:TextField = new TextField(512, 50, "", "5x7");
	var angryFilter:SelectorFilter;
	var normalFilter:SelectorFilter;


	var bg:Image;
	var textBubble:Image;
	var speakerHead:Image;
	var grandpa:MovieClipPlus;
	var teacher:Teacher;
	var boy:Boy;
	var fire: Fire;
	var strikeImages:Array<Image>;
	
	var transitionSpeed = 0.5;
	
	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
		
	
	}
	
	public function start() {
		
		var stage = Starling.current.stage;
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		bg = new Image(Root.assets.getTexture("Background"));

		rootSprite.addChild(this);
		
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		this.removeFromParent;
		this.dispose;
	}
	
	function onKeyDown(event:KeyboardEvent) {


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

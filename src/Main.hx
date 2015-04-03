import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.geom.Vector3D;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Image;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.utils.Color;
import starling.events.KeyboardEvent;
import Std;
import Root;

class Main extends Sprite {
	
	public var rootSprite:Sprite;
	private var selection:Int;
	private var buttons:Array<TextField>;
	private var title:Image;
	private var rotateSpeed = 0.3;
	private var transitionSpeed = 0.5;
	private var tween:Tween;
	public var bgcolor = 255;
	public var bg:Image;
	public var gametitle:TextField;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2, Starling.current.stage.stageHeight / 2);

	public function new(rootSprite:Sprite) {
		this.rootSprite = rootSprite;
		super();
	}
	
	public function start() {
        TextField.getBitmapFont("gameBoy_0").smoothing = "none";
		this.pivotX = center.x;
		this.pivotY = center.y;
		this.x = center.x;
		this.y = center.y;
		this.scaleX = 8;
		this.scaleY = 8;
		Root.assets.playSound("song1", 0, 9999);
		bg = new Image(Root.assets.getTexture("startImage"));
		this.addChild(bg);
		rootSprite.addChild(this);

		this.addChild(bg);
		rootSprite.addChild(this);
		buttons = [new TextField(150, 50, "Begin Game", "gameBoy_0", 12, Color.WHITE), new TextField(150, 50, "Credits", "gameBoy_0", 12, Color.WHITE)];
		for (i in 0...buttons.length) {
			var button = buttons[i];
			button.x = center.x - 75;
			button.y = 32 + (i * 32);
			this.addChild(button);
		}

		//Enlarge the first highlighted option by default
		buttons[0].fontSize = 18;
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		
		selection = 0;
		
		rootSprite.addChild(this);
		//startAnim();
		transitionIn();

	}
	
	private function handleInput(event:KeyboardEvent){
		
		if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER) {
			
			if (selection == 0) {
				// NewGame
				var game = new Game(rootSprite);
				game.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				transitionOut(function() {
					
					this.removeFromParent();
					this.dispose();
					Root.assets.removeSound("song1");
				});
			}
			else if (selection == 1) {
				// Credits
				var credits = new Credits(rootSprite);
				credits.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				transitionOut(function() {
					
					this.removeFromParent();
					this.dispose();
					Root.assets.removeSound("song1");
			});

			}
		}
		else if (tween == null || tween.isComplete)
		{	
			// Only allow moving if the current tween does not exist.
			if (event.keyCode == Keyboard.UP) {
				
				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 12);
				Starling.juggler.add(tween);

				selection = arithMod(--selection, buttons.length);

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 18);
				Starling.juggler.add(tween);
			}
			else if (event.keyCode == Keyboard.DOWN) {

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 12);
				Starling.juggler.add(tween);

				selection = arithMod(++selection, buttons.length);

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("fontSize", 18);
				Starling.juggler.add(tween);
			}
		}
	}
	private function startAnim(){
		toLeft();

	}

	private function toLeft(){
		var t = new Tween(title, 0.619, Transitions.EASE_IN_OUT);
		t.animate("x", title.x - 80);
		t.onComplete = toRight;
		Starling.juggler.add(t);
	}

	private function toRight(){
		var t = new Tween(title, 0.619, Transitions.EASE_IN_OUT);
		t.animate("x", title.x + 80);
		t.onComplete = toLeft;
		Starling.juggler.add(t);
	}
	private function helpTrans(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1200);
		//t.animate("scaleY", 10);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}


	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1000);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
	
	private function transitionIn(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.animate("bgcolor", 0);
		t.onUpdate = function() {
			Starling.current.stage.color = this.bgcolor | this.bgcolor << 8 | this.bgcolor << 16;
		};
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	
	private function creditTrans(?callBack:Void->Void) {
		
		var t = new Tween(this, 0.3, Transitions.LINEAR);
		t.animate("y", -300);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}

	public static function arithMod(n:Int, d:Int) : Int {
		
		var r = n % d;
		if (r < 0)
			r += d;
		return r;
		
	}
	
}

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
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


class Credits extends Sprite {
	public var rootSprite:Sprite;
	public var highScore:Int;
	public var bg:Image;
	private var transitionSpeed = 0.5;
	public var bgcolor = 255;
	public var credits:TextField = new TextField(400, 500,"Credits", "gameBoy_0", 30, Color.WHITE);
	public function new(rootSprite:Sprite) {
		this.rootSprite = rootSprite;
		super();
	}

	public function start() {

			var center = new Vector3D(Starling.current.stage.stageWidth / 2, Starling.current.stage.stageHeight / 2);
			this.pivotX = center.x;
			this.pivotY = center.y;
			this.x = center.x;
			this.y = center.y;
			this.scaleX = 1;
			this.scaleY = 1;
			//bg = new Image(Root.assets.getTexture("Intro"));
			//this.addChild(bg);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);

			credits.x = center.x - 200;
			credits.y = 400;
			this.addChild(credits);
			rootSprite.addChild(this);
			scrollUp();
		}
		
	private function scrollUp(){
		var creditsTween = new Tween(credits, 10, Transitions.LINEAR);
		creditsTween.animate("y", credits.y - 450);
		Starling.juggler.add(creditsTween);
	}
	
	private function handleInput(event:KeyboardEvent) {
		
		if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER) {
		
			// Return
			var menu = new Main(rootSprite);
			menu.bgcolor = this.bgcolor;
			menu.start();
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			this.removeFromParent();
			this.dispose();

			/*transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});*/
		}
		
	}

}

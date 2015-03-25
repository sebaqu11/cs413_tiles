import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

class Root extends Sprite {

    public static var assets:AssetManager;
    public var rootSprite:Sprite;

	public static function init() {
		
	}
	
    public function new() {
        rootSprite = this;
        super();
    }
    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/sprites.png");
        assets.enqueue("assets/sprites.xml");
        assets.enqueue("assets/GameMap.tmx");
        assets.enqueue("assets/font/gameBoy_0.png");
        assets.enqueue("assets/font/gameBoy.fnt");
		
        assets.loadQueue(function onProgress(ratio:Float) {
            haxe.Log.clear();
            if (ratio == 1) {
                haxe.Log.clear();
                startup.removeChild(startup.loadingBitmap);
                var menu = new Main(rootSprite);
                menu.start();
            }
        });		
    }
}

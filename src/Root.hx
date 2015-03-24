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
        assets.enqueue("assets/Sprites.png");
        assets.enqueue("assets/Sprites.xml");
        //assets.enqueue("assets/GameMap.tmx");
		
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

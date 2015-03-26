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
        // Sprite sheet and font
        assets.enqueue("assets/sprites.png");
        assets.enqueue("assets/sprites.xml");
        assets.enqueue("assets/GameMap.tmx");
        assets.enqueue("assets/font/gameBoy_0.png");
        assets.enqueue("assets/font/gameBoy.fnt");
        // Tiles
        assets.enqueue("assets/old/black-block.png");
        assets.enqueue("assets/old/cement-block.png");
        assets.enqueue("assets/old/cement-block_01.png");
        assets.enqueue("assets/old/cement-block_02.png");
        assets.enqueue("assets/old/finish.png");
        assets.enqueue("assets/old/flame.png");
        assets.enqueue("assets/old/Ground_01.png");
        assets.enqueue("assets/old/Ground_02.png");
        assets.enqueue("assets/old/Ground_03.png");
        assets.enqueue("assets/old/Ground_04.png");
        assets.enqueue("assets/old/Lava_01.png");
        assets.enqueue("assets/old/Mud_01.png");
        assets.enqueue("assets/old/Player.png");
        assets.enqueue("assets/old/Wall_01.png");
        assets.enqueue("assets/old/Wall_02.png");
        assets.enqueue("assets/old/Wall_03.png");
        assets.enqueue("assets/old/Wall_04.png");
        assets.enqueue("assets/old/Wall_05.png");
        assets.enqueue("assets/old/Wall_06.png");
        assets.enqueue("assets/old/Water_01.png");

		
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

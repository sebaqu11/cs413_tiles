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
        //assets.enqueue("assets/sprites.png");
        //assets.enqueue("assets/sprites.xml");
        assets.enqueue("assets/GameMap.tmx");
        assets.enqueue("assets/font/gameBoy_0.png");
        assets.enqueue("assets/font/gameBoy.fnt");
        // Tiles
        assets.enqueue("assets/black-block.png");
        assets.enqueue("assets/cement-block.png");
        assets.enqueue("assets/cement-block_01.png");
        assets.enqueue("assets/cement-block_02.png");
        assets.enqueue("assets/finish.png");
        assets.enqueue("assets/flame.png");
        assets.enqueue("assets/Ground_01.png");
        assets.enqueue("assets/Ground_02.png");
        assets.enqueue("assets/Ground_03.png");
        assets.enqueue("assets/Ground_04.png");
        assets.enqueue("assets/Lava_01.png");
        assets.enqueue("assets/Mud_01.png");
        assets.enqueue("assets/Player.png");
        assets.enqueue("assets/Wall_01.png");
        assets.enqueue("assets/Wall_02.png");
        assets.enqueue("assets/Wall_03.png");
        assets.enqueue("assets/Wall_04.png");
        assets.enqueue("assets/Wall_05.png");
        assets.enqueue("assets/Wall_06.png");
        assets.enqueue("assets/Water_01.png");



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

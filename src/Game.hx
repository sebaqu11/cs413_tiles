import starling.display.Sprite;
import starling.display.Image;
import starling.utils.Color;
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
	var player:Image;
	var changeX:Int;
	var changeY:Int;
	var tileX:Int;
	var tileY:Int;
	var wall:Int = 2;
	var fire:Int = 3;
	var lava:Int = 4;
	var water:Int = 5;
	var mud:Int = 6;
	var finish:Int = 7;

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
		map.x = -16 * 22;
		map.y = -16 * 115;
		stage.addChild(map);
		player = new Image(Root.assets.getTexture("Player"));
		player.smoothing = "none";
		player.x = 16 * 5;
		player.y = 16 * 7;
		stage.addChild(player);
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		this.removeFromParent;
		this.dispose;
	}
	
	function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.UP) {
			changeX = 0;
			changeY = -1;
		}
		else if (event.keyCode == Keyboard.DOWN) {
			changeX = 0;
			changeY = 1;
		}
		else if (event.keyCode == Keyboard.LEFT) {
			changeX = -1;
			changeY = 0;
		}
		else if (event.keyCode == Keyboard.RIGHT) {
			changeX = 1;
			changeY = 0;
		}
		else {
			changeX = 0;
			changeY = 0;
		}
		tileX = -Math.round(map.x / 16) + 5 + changeX;
		tileY = -Math.round(map.y / 16) + 6 + changeY;
		if (map.layers[wall].data[tileY][tileX] == null) {
			if (map.layers[fire].data[tileY][tileX] == null) {
				if (map.layers[lava].data[tileY][tileX] == null) {
                    if (map.layers[water].data[tileY][tileX] == null) {
                        if (map.layers[mud].data[tileY][tileX] == null) {
                            if (map.layers[finish].data[tileY][tileX] == null) {
                                map.x -= changeX * 16;
                                map.y -= changeY * 16;
                                Root.assets.playSound("MoveNoise1");
                            } else {
                                map.x -= changeX * 16;
                                map.y -= changeY * 16;
                                Root.assets.playSound("MoveNoise1");
                                trace("You Win!");
                                cleanup();
                            }
                        } else {
                            Timer.delay(function() {
                                map.x -= changeX * 16;
                                map.y -= changeY * 16;
                                Root.assets.playSound("MudMoveSound1");
                            }, 500);
                        }
                    } else {
                        map.x -= changeX * 16;
                        map.y -= changeY * 16;
                        Root.assets.playSound("DrownSound1");
                        var deathWater:Image = new Image(Root.assets.getTexture("Bubble_01"));
                        deathWater.smoothing = "none";
                        deathWater.x = 16 * 5;
                        deathWater.y = 16 * 7;
                        Starling.current.stage.removeChild(player);
                        Starling.current.stage.addChild(deathWater);
                        // lose
                        trace("You Drowned!");
                        cleanup();
                    }
				} else {
					map.x -= changeX * 16;
					map.y -= changeY * 16;
					Root.assets.playSound("DieFromLavaSound1");
					var deathLava:Image = new Image(Root.assets.getTexture("flame"));
					deathLava.smoothing = "none";
                    deathLava.x = 16 * 5;
                    deathLava.y = 16 * 7;
                    Starling.current.stage.removeChild(player);
                    Starling.current.stage.addChild(deathLava);
                    // lose
                    trace("You Melted!");
                    cleanup();
				}
			} else {
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				map.x -= changeX * 16;
				map.y -= changeY * 16;
				Root.assets.playSound("FireSound1");
                trace("You Burned!");
				player.color = Color.RED;
				Timer.delay(function() {
					player.color = Color.WHITE; 
					Timer.delay(function() {
						player.color = Color.RED;
						Timer.delay(function() {
							player.color = Color.WHITE;
							Timer.delay(function() {
								map.x += changeX * 16;
								map.y += changeY * 16;
								Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
							}, 500);
						}, 500);
					}, 500);
				}, 500);
			}
		} else Root.assets.playSound("CollisionSound1");
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

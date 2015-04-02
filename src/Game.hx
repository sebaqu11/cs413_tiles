import starling.utils.Color;
import starling.core.Starling;
import starling.text.TextField;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.SelectorFilter;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Quad;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.display.Image;
import starling.display.Stage;
import starling.animation.Juggler;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundTransform;
import flash.media.SoundChannel;
import flash.media.Sound;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.system.System;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;
import haxe.Timer;
import Root;
import Tilemap;
import StopWatch;
import haxe.Timer;

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
	var timerText:TextField = null;
	var stepText:TextField;
	var stopwatch:StopWatch;
	var timeInt:Int = 0;
	var timeDisp:String;
	var running = true;
	var steps = 0;
	var sTime:Float;

	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
	}
	
	public function start() {
		var stage = Starling.current.stage;
		var stageWidth = Starling.current.stage.stageWidth;
		var stageHeight = Starling.current.stage.stageHeight;
		sTime = flash.Lib.getTimer()/1000;
		haxe.Log.clear();
		steps = 0;

		stopwatch = new StopWatch("Steps: ");

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		map = new Tilemap(Root.assets, "map");
		map.x = -16 * 22;
		map.y = -16 * 115;
		stage.addChild(map);

		player = new Image(Root.assets.getTexture("Player"));
		player.smoothing = "none";
		player.x = 16 * 5;
		player.y = 16 * 7;
		stage.addChild(player);

		// create timer in top left corner
		stepText = new TextField(100,25, "0", "gameBoy_0");
		stepText.fontSize = 10;
		stepText.color = 0xFFFFFF;
		stepText.hAlign = "left";
		stepText.x = 5;
		stage.addChild(stepText);
		
		timerText = new TextField(100,25, "0", "gameBoy_0");
		timerText.fontSize = 10;
		timerText.color = 0xFFFFFF;
		timerText.hAlign = "right";
		timerText.x = 75;
		stage.addChild(timerText);
		
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		this.removeFromParent;
		this.dispose;
		// after removing everything, listen for the space bar again for restarting the game
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, spaceRestart);
	}
	
	function onKeyDown(event:KeyboardEvent) {

		if (event.keyCode == Keyboard.UP) {
			changeX = 0;
			changeY = -1;
		    steps += 1;
		}
		else if (event.keyCode == Keyboard.DOWN) {
			changeX = 0;
			changeY = 1;
		    steps += 1;
		}
		else if (event.keyCode == Keyboard.LEFT) {
			changeX = -1;
			changeY = 0;
		    steps += 1;
		}
		else if (event.keyCode == Keyboard.RIGHT) {
			changeX = 1;
			changeY = 0;
		    steps += 1;
		}
		else if (event.keyCode == 32){
			restartGame();
		}	
		else {
			changeX = 0;
			changeY = 0;
		}
		
		stepText.text = '' + steps;



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
                                Root.assets.playSound("FinishSound1");
                                //win
                                endGame(0);
                                cleanup();
                            }
                        } else {
                            Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                            Timer.delay(function() {
                                map.x -= changeX * 16;
                                map.y -= changeY * 16;
                                Root.assets.playSound("MudMoveSound1");
                                Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
                        // lose with drown
                        endGame(1);
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
                    // lose with melt
                    endGame(2);
                    cleanup();
				}
			} else {
				//user runs into fire on the ground
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				map.x -= changeX * 16;
				map.y -= changeY * 16;
				Root.assets.playSound("FireSound1");

				// Flash red when they run into fire
             	var finalSplash = new Quad(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0, true);	
				finalSplash.alpha = 0.5;
				finalSplash.color = 0x990000;
				Starling.current.stage.addChild(finalSplash);
				var menuText = new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, "OW!! It burns!");
				menuText.fontSize = 24;
				menuText.color = 0xFFFFFF;
				Starling.current.stage.addChild(menuText);

				player.color = Color.RED;
				Timer.delay(function() {
					player.color = Color.WHITE; 
					Starling.current.stage.removeChild(finalSplash);
					Starling.current.stage.removeChild(menuText);
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
		timerText.text = '' + Std.int((flash.Lib.getTimer()/1000 - sTime)*1000)/1000;
		
	}

	private function endGame(death:Int){	

		// Depending on the type of death/win, change the game over screen
		var color = 0xFFFFFF;
		var phrase = null;

		if (death == 0){
			phrase = 'You Win!';
			phrase = 'You Win!';
			color = 0x000000;
		}
		else if (death == 1){
			phrase = 'You Drown..';
			color = 0x3399FF;
		}
		else if (death == 2){
			phrase = 'You Melted..';
			color = 0x990000;
		}

		var finalSplash = new Quad(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0, true);	
		finalSplash.alpha = 0.7;
		finalSplash.color = color;
		Starling.current.stage.addChild(finalSplash);
		
		var timeTemp = Std.int((flash.Lib.getTimer()/1000 - sTime)*1000)/1000;
		var time = Std.int(timeTemp);
		var menuText = new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, phrase + "\nTime:" + time + "s  Steps: " + steps + "\n Press <space> to restart");
		menuText.fontSize = 18;
		menuText.color = 0xFFFFFF;
		Starling.current.stage.addChild(menuText);

	}

	private function spaceRestart(event:KeyboardEvent) {
		if(event.keyCode == 32){
			restartGame();
		}
	}

	private function restartGame(){
		this.removeChildren();
		this.removeEventListeners();
		this.dispose();
		start();
	}
	
	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}

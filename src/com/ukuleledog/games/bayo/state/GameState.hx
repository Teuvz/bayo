package com.ukuleledog.games.bayo.state;

import com.ukuleledog.games.bayo.elements.Bayonetta;
import com.ukuleledog.games.bayo.elements.Bullet;
import com.ukuleledog.games.bayo.elements.Ennemy;
import com.ukuleledog.games.bayo.elements.Tamogoro;
import com.ukuleledog.games.bayo.elements.Zako;
import com.ukuleledog.games.core.State;
import haxe.Template;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Bounce;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.ui.Keyboard;
import openfl.Vector;

/**
 * ...
 * @author matt
 */
class GameState extends State
{

	private var background:Bitmap;
	private var backgroundMusic:Sound;
	private var music:SoundChannel;
	
	private var jumpSound:Sound;
	private var shootSound:Sound;
	
	private var bayonetta:Bayonetta;
	
	private var bullets:Array<Bullet>;
	private var bulletSpeed:UInt = 6;
	private var bulletLimit = 427;
	
	private var ascensionSpeed:UInt = 5;
	private var floor:UInt = 152;
	private var ceil:UInt = 50;
	
	private var ennemies:Array<Ennemy>;
	private var wave:UInt = 0;
	private var gameOverImage:Bitmap;
	
	private var pressedKeys:Array<Bool>;
	
	public function new() 
	{
		super();
				
		pressedKeys = new Array<Bool>();
		addEventListener( Event.ADDED_TO_STAGE, init );
		
		background = new Bitmap( Assets.getBitmapData( 'img/Background2.jpg' ) );
		backgroundMusic = Assets.getMusic( 'snd/BgmSound.mp3' );
		
		bullets = new Array<Bullet>();
		bayonetta = new Bayonetta();
		bayonetta.y = floor;
		
		jumpSound = Assets.getSound('snd/BayoJumpSound.mp3');
		shootSound = Assets.getSound('snd/BayoShotSound.mp3');
		
		ennemies = new Array<Ennemy>();
		gameOverImage = new Bitmap( Assets.getBitmapData( 'img/ui.png' ) );
	}
	
	private function loopMusic( e:Event )
	{
		music = backgroundMusic.play();
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		music = backgroundMusic.play();
		music.addEventListener( Event.SOUND_COMPLETE, loopMusic );
		
		addChild( background );
		addChild( bayonetta );
		
		addEventListener( Event.ENTER_FRAME, loop );
		stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );

	}
	
	private function generateEnnemyWave()
	{
		if ( wave == 0 )
		{
			var zako:Zako = new Zako(2);
			zako.x = 430;
			zako.y = 152;
			ennemies.push( zako );
			addChild( zako );
		}
		else if ( wave == 1 )
		{
			var zako:Zako = new Zako(5);
			zako.x = 430;
			zako.y = 152;
			ennemies.push( zako );
			addChild( zako );
			
			var tamo:Tamogoro = new Tamogoro(2);
			tamo.x = 430;
			tamo.y = 100;
			ennemies.push( tamo );
			addChild( tamo );
		}
		else if ( wave == 2 )
		{
			var zako:Zako = new Zako(10);
			zako.x = 430;
			zako.y = 152;
			ennemies.push( zako );
			addChild( zako );
			
			var tamo:Tamogoro = new Tamogoro(2);
			tamo.x = 430;
			tamo.y = 100;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo =new Tamogoro(2);
			tamo.x = 520;
			tamo.y = 120;
			ennemies.push( tamo );
			addChild( tamo );
		}
		else if ( wave == 3 )
		{
			var zako:Zako = new Zako(20);
			zako.x = 430;
			zako.y = 152;
			ennemies.push( zako );
			addChild( zako );
			
			zako = new Zako(2);
			zako.x = 510;
			zako.y = 152;
			ennemies.push( zako );
			addChild( zako );
			
			var tamo:Tamogoro = new Tamogoro(2);
			addChild( tamo );
			tamo.x = 430;
			tamo.y = 100;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo = new Tamogoro(4);
			tamo.x = 520;
			tamo.y = 120;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo = new Tamogoro(2);
			tamo.x = 600;
			tamo.y = 120;
			ennemies.push( tamo );
			addChild( tamo );
		}
		else if ( wave == 4 )
		{			
			var tamo:Tamogoro = new Tamogoro(2);
			addChild( tamo );
			tamo.x = 430;
			tamo.y = 100;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo = new Tamogoro(4);
			tamo.x = 520;
			tamo.y = 120;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo = new Tamogoro(2);
			tamo.x = 600;
			tamo.y = 120;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo = new Tamogoro(2);
			tamo.x = 700;
			tamo.y = 120;
			ennemies.push( tamo );
			addChild( tamo );
			
			tamo = new Tamogoro(2);
			tamo.x = 650;
			tamo.y = 50;
			ennemies.push( tamo );
			addChild( tamo );
		}
		
		wave++;
	}
	
	private function onKeyDown( e:KeyboardEvent )
	{
		pressedKeys[e.keyCode] = true;
	}
	
	private function onKeyUp( e:KeyboardEvent )
	{
		pressedKeys[e.keyCode] = false;
	}
	
	private function shoot()
	{
		shootSound.play();
		bayonetta.shoot();
		var bullet:Bullet = new Bullet();
		bullet.x = 64;
		bullet.y = bayonetta.y + 35;
		addChild(bullet);
		bullets.push( bullet );
	}
	
	private function loop( e:Event )
	{
		
		if ( ennemies.length == 0 && !bayonetta.isDead() )
			generateEnnemyWave();
		
		if ( !bayonetta.isDead() )
		{
			
			if ( bayonetta.y < floor && !bayonetta.isJumping() )
			{
				bayonetta.y+=ascensionSpeed;
				
				if ( bayonetta.y == floor )
				{
					bayonetta.setAnimation('idle');
					bayonetta.setCanJump(true);
				}
			}
			else if ( bayonetta.isJumping() && bayonetta.y > ceil )
			{
				bayonetta.y-=ascensionSpeed;
			}
			else if ( bayonetta.isJumping() && bayonetta.y <= ceil )
			{
				bayonetta.fall();
			}
			
			if ( bayonetta.y == floor && bayonetta.canShoot() )
				bayonetta.setAnimation('idle');
			
			if ( bayonetta.canJump() && pressedKeys[Keyboard.SPACE] == true )
			{
				jumpSound.play();
				bayonetta.jump();
				pressedKeys[Keyboard.SPACE] = false;
			}
			
			if ( bayonetta.canShoot() && ( pressedKeys[Keyboard.CONTROL] == true || pressedKeys[Keyboard.ENTER] == true ) )
			{
				shoot();
			}
		
		}
		else
		{
			bayonetta.setAnimation( 'die' );
		}
		
		var pos:UInt = 0;
		for ( bullet in bullets )
		{
			bullet.x += bulletSpeed;
			
			if ( bullet.x >= bulletLimit )
			{
				bullets.remove(bullet);
				removeChild( bullet );
				bullet = null;
			}
			pos++;
		}
		
		for ( ennemy in ennemies )
		{			
			if ( !ennemy.isAttacking() )
				ennemy.x--;
			
			for ( bullet in bullets )
			{
				if ( ennemy.hitTestObject( bullet ) )
				{
					removeChild( bullet );
					bullets.remove( bullet );
					bullet = null;
					
					if ( ennemy.hit() )
					{
						ennemies.remove( ennemy );
						ennemy.addEventListener( Event.COMPLETE, removeEnnemy );
						ennemy.die();
					}
				}
			}
			
			if ( (ennemy.hitTestObject( bayonetta ) || ennemy.x == 63) && !bayonetta.isDead() )
			{
				ennemy.attack();
				//removeEventListener( Event.ENTER_FRAME, loop );
				bayonetta.die();
				
				if ( bayonetta.y != floor )
				{
					Actuate.tween( bayonetta, 0.2, { y: floor } );
				}
				
				gameOverImage.x = (stage.stageWidth / 2) - (gameOverImage.width / 2);
				gameOverImage.y = (stage.stageHeight / 2) - (gameOverImage.height / 2);
				addChild( gameOverImage );
				
				Timer.delay( function() { 
					ennemy.stopAttacking();
				}, 1500 );
				
			}
			
		}
		
	}
	
	private function removeEnnemy( e:Event )
	{
		e.target.removeEventListener( Event.COMPLETE, removeEnnemy );
		removeChild( e.target );
	}
	
}
package com.ukuleledog.games.bayo.state;

import com.ukuleledog.games.bayo.elements.Bayonetta;
import com.ukuleledog.games.bayo.elements.Bullet;
import com.ukuleledog.games.core.State;
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
		
	}
	
}
package com.ukuleledog.games.bayo.elements;

import com.ukuleledog.games.core.AnimatedObject;
import openfl.media.Sound;
import openfl.Assets;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

/**
 * ...
 * @author matt
 */
class Bayonetta extends AnimatedObject
{

	private var jumping:Bool = false;
	private var canJumpVar:Bool = true;
	private var canShootVar:Bool = true;
	
	private var previousAnimation:String;
	private var shootTimer:Timer;
	private var shootDelay:Int = 300;
	
	private var dead:Bool = false;
	private var dieSound:Sound;
	
	public function new() 
	{
		super();
		
		dieSound = Assets.getSound( 'snd/BayoDamageSound.mp3' );
		
		this.bmd = Assets.getBitmapData('img/bayonetta.png');
		
		createAnimation( 'idle', 0, 0, 4, 64, 64, 0.1 );
		createAnimation( 'jump', 0, 64, 2, 64, 64, 0.1 );
		createAnimation( 'fall', 128, 64, 2, 64, 64, 0.1 );
		createAnimation( 'shoot', 0, 192, 4, 64, 64, 0.1, false );
		createAnimation( 'die', 0, 256, 5, 64, 64, 0.2, false );

		shootTimer = new Timer(shootDelay);
		shootTimer.addEventListener( TimerEvent.TIMER, resetShoot );
		
		animate();
	}
	
	public function isDead() : Bool
	{
		return dead;
	}
	
	public function die()
	{
		dieSound.play();
		dead = true;
		setAnimation( 'die' );
	}
	
	public function jump()
	{
		jumping = true;
		setAnimation('jump');
		canJumpVar = false;
	}
	
	public function fall()
	{
		jumping = false;
		setAnimation('fall');
	}
	
	public function isJumping() : Bool
	{
		return jumping;
	}
	
	public function canJump() : Bool
	{
		return canJumpVar;
	}
	
	public function setCanJump( value:Bool )
	{
		canJumpVar = value;
	}
	
	public function canShoot() : Bool
	{
		return canShootVar;
	}
	
	public function setCanShoot( value: Bool )
	{
		canShootVar = value;
	}
	
	public function shoot()
	{
		previousAnimation = currentAnimation;
		canShootVar = false;
		setAnimation( 'shoot' );
		shootTimer.start();
	}
	
	private function resetShoot( e:TimerEvent )
	{
		shootTimer.stop();
		setAnimation(previousAnimation);
		setCanShoot(true);
	}
	
}
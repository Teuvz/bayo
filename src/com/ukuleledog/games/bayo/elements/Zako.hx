package com.ukuleledog.games.bayo.elements;
import haxe.Timer;
import openfl._v2.media.Sound;
import openfl.Assets;
import openfl.events.Event;
import openfl.media.Sound;

/**
 * ...
 * @author matt
 */
class Zako extends Ennemy
{

	private var attackSound:Sound;
	
	public function new( _hp:UInt ) 
	{
		super();
		
		attackSound = Assets.getSound( 'snd/EnemySwingSound.mp3' );
		
		hp = _hp;
		
		bmd = Assets.getBitmapData('img/ennemy.png');
		
		createAnimation( 'idle', 0, 0, 4, 64, 64, 0.2 );
		createAnimation( 'damage', 256, 0, 1, 64, 64 );
		createAnimation( 'attack', 0, 128, 5, 64, 64, 0.1, false );
		
		animate();
	}
	
	override public function die()
	{
		setAnimation( 'damage' );
		this.alpha = 0.6;
		Timer.delay( function() { 
			dispatchEvent( new Event( Event.COMPLETE ) ); 
		}, 300 );
	}
	
	override public function attack()
	{
		attackSound.play();
		setAnimation( 'attack' );
		attacking = true;
	}
	
}
package com.ukuleledog.games.bayo.elements;

import com.ukuleledog.games.core.AnimatedObject;
import openfl.Assets;

/**
 * ...
 * @author matt
 */
class Bullet extends AnimatedObject
{

	public function new() 
	{
		super();
		
		this.bmd = Assets.getBitmapData('img/bayonetta.png');
		
		createAnimation( 'idle', 0, 128, 1, 8, 16 );
		
		animate();
	}
	
}
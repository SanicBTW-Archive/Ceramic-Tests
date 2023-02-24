package;

import ceramic.Color;
import ceramic.Quad;
import ceramic.Scene;
import ceramic.Sound;
import ceramic.Text;
import clay.Audio;
import clay.Clay;
import clay.web.WebAudio;
import js.html.audio.AnalyserNode;
import js.lib.Uint8Array;

using ceramic.VisualTransition;

class MainScene extends Scene
{
	var swagSex:Quad;
	var swagTex:Text;
	var ana:AnalyserNode;

	private var bars:Array<Quad> = [];
	private var sampleDat:Uint8Array;
	private var barIt:Int;

	override function preload()
	{
		assets.add("image:images/icons8-osu-96.png");
		assets.add(Fonts.FONTS__VCR);
		assets.add(Sounds.MUSIC__AUDIO);
	}

	override function create()
	{
		assets.sound(Sounds.MUSIC__AUDIO).play(0, true, 0.4);

		ana = Clay.app.audio.context.createAnalyser();
		ana.fftSize = 256;
		@:privateAccess
		Clay.app.audio.instances[assets.sound(Sounds.MUSIC__AUDIO).group].gainNode.connect(ana);
		ana.connect(Clay.app.audio.context.destination);

		sampleDat = new Uint8Array(ana.frequencyBinCount);

		swagSex = new Quad();
		swagSex.texture = assets.texture("image:images/icons8-osu-96.png");
		swagSex.size(100, 100);
		swagSex.color = Color.WHITE;
		swagSex.pos(width * 0.5, height * 0.5);
		swagSex.anchor(0.5, 0.5);
		swagSex.scale(0.0001);
		swagSex.alpha = 0;

		barIt = 10;
		for (i in 0...barIt)
		{
			var barshit:Quad = new Quad();
			barshit.size(10, 100);
			barshit.pos((width * 0.5) + (i * 15), (swagSex.y - swagSex.height) + 10);
			barshit.rotation = 180;
			barshit.color = Color.SLATEGREY;
			bars.push(barshit);
			add(barshit);
		}

		swagTex = new Text();
		swagTex.content = "Sexo con negros";
		swagTex.font = assets.font(Fonts.FONTS__VCR);
		swagTex.pos(swagSex.x, (swagSex.y + swagSex.height) + 5);
		swagTex.anchor(0.5, 0.5);
		swagTex.alpha = 0;

		add(swagSex);
		add(swagTex);

		swagSex.tween(QUAD_EASE_IN_OUT, 1, 0.0001, 1.0, (val, time) ->
		{
			swagSex.alpha = val;
			swagTex.alpha = val;
			swagSex.scale(val);
		});
	}

	override function update(delta:Float)
	{
		ana.getByteFrequencyData(sampleDat);

		if (swagSex.alpha == 1.0)
		{
			swagSex.rotation += Math.sin((Math.PI * (360 * delta)) / 360) * 50;
			for (i in 0...barIt)
			{
				bars[i].transition(BEZIER(0.4, 0, 0.2, 1), 0.05, bar ->
				{
					bar.scaleY = sampleDat[i] / 130;
				});
			}
		}
	}

	override function resize(width:Float, height:Float)
	{
		// Called everytime the scene size has changed
	}

	override function destroy()
	{
		// Perform any cleanup before final destroy

		super.destroy();
	}
}

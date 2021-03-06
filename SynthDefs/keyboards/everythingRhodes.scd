/* Retrieved from
http://sccode.org/1-5aD

By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
http://www.sussex.ac.uk/Users/nc81/index.html

Modified by Josh Mitchell and Bruno Ruviaro 8/19.

Edited by Martin Gius 02/21 to work with SuperDirt.
*/

SynthDef("everythingRhodes", {
	arg
	//Standard Definitions
	out = 0, freq = 440, att_ = 0.001, rel_ = 3, pan = 0.5,
	//Other Controls
	filterRange = 2000, rq = 0.5, harmonic = 2.pow(33.5/12),
	//These Range from 0 to 1
	width = 0.2, mix = 0.7;

    //Electric Piano
	var snd, env, lfo, amp;

	amp = 0.1;

	env = Env.perc(att_, rel_).kr(doneAction: 2); //Original used an ADSR envelope.

	snd = Pulse.ar(
	        	freq: freq * [1, harmonic], //Original used 33.5.midiratio here, which is just below the 7th harmonic.
	        	width: [width, width/2],
		        mul: [mix, (1 - mix)]
            );
	snd  = BLowPass4.ar(
		        in: snd,
		        freq: (filterRange * env) + (2 * freq),
		        rq: rq
		    );
    snd = Mix.ar(snd) * env * amp;

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
},
metadata: (
	credit: "Nick Collins, from Mitchell Sigman, 2011. http://www.sussex.ac.uk/Users/nc81/index.html",
	category: \keyboards,
	tags: [\rhodes, \piano, \pitched]
	)
).add
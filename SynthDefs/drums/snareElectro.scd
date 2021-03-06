/* Retrieved from
http://sccode.org/1-5aD

Original by Nathan Ho aka Snappizz
http://sccode.org/1-523

Modified by Bruno Ruviaro and Josh Mitchell 8/19.

//Edited by Martin Gius 02/21 to work with SuperDirt.
*/

SynthDef("snareElectro", {
    arg
	//Standard Values
	out = 0, pan = 0.5, att_ = 0.001, rel_ = 0.15, curve = -4,
	//Other Controls, blend ranges from 0 to 1
	popfreq = 160, sweep = 0.01, noisefreq = 810, rq = 1.6, blend = 0.41;

    var pop, popEnv, popSweep, noise, noiseEnv, snd, amp;

	amp = 0.4;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popSweep = Env.new(levels: [20.4, 2.6, 1] * popfreq, times: [sweep / 2, sweep], curve: \exp).ar;

    popEnv = Env.perc(attackTime: att_, releaseTime: 0.73 * rel_, level: blend, curve: curve).kr;

	pop = SinOsc.ar(freq: popSweep, mul: popEnv);

    // bandpass-filtered white noise
    noiseEnv = Env.perc(attackTime: att_, releaseTime: rel_, level: 1 - blend, curve: curve).kr(doneAction: 2);

	noise = BPF.ar(in: WhiteNoise.ar, freq: noisefreq, rq: rq, mul: noiseEnv);

    snd = Mix.ar(pop + noise) * amp;

    Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
},
metadata: (
	credit: "Nathan Ho aka Snappizz",
	category: \organ,
	tags: [\pitched]
	)
).add;
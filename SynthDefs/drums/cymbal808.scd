/*
Retrieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/cymbal808_ryan.scd

Published on sc-users 2007-08-25 by Ryan Brown

alternate freqs values found in original:
	[78.6, 140.44, 123.87, 219.4, 787.5, 531.3];
	[300, 402.6, 369.36, 495.96, 585.69, 645.69];
	[205.35, 254.29, 294.03, 304.41, 369.64, 522.71];

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
Edited by Martin Gius 02/21 to work with SuperDirt.
*/

(
SynthDef(\cymbal808, {
	arg
	//Standard Values:
	out = 0, pan = 0.5, att_ = 0.002, dec_ = 0.25, rel_ = 0.05,
	//Other Controls:
	freqMultiplier = 4.09, decLevel = 0.4, reverb_ = 0.33, size_ = 0.5, damp = 0.5;

	var snda, sndb, snd, env, pulseEnv, freqs, amp;

	amp = 0.1;

	freqs = [205.35, 304.41, 369.64, 522.71, 540.54, 812.21];

	env = Env.new(
		levels: [0, 1, decLevel, 0],
		times: [att_, dec_, rel_],
		curve: [0, -0.5, 0]
	).kr;

	pulseEnv = Env.new(
		levels: [1.0, 0.6],
		times: dec_,
		curve: -0.5
	).kr;

	snd = Mix.ar(LFPulse.ar(freq: freqs * 4.09));

	snd = (BinaryOpUGen('==', snd, 6.0) * 0.6) + (BinaryOpUGen('==', snd, 2.0) * 0.2) + (BinaryOpUGen('==', snd, 1.0) * 0.9);

	snd = (snd * pulseEnv) + Mix.ar(LFPulse.ar(freq: freqs, width: 0.55, mul: 0.9));

	snd = RLPF.ar(in: snd, freq: 7000, rq: 0.6);
 	snd = RHPF.ar(in: snd, freq: 6800, rq: 1.5);
	snd = RHPF.ar(in: snd, freq: 6800, rq: 1.5);
	snd = RHPF.ar(in: snd, freq: 1200, rq: 1.5);

	snd = snd + FreeVerb.ar(in: snd, mix: reverb_, room: size_, damp: damp);
	snd = Mix.ar(snd);
	snd = snd * env * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
},
metadata: (
	credit: "Published on sc-users 2007-08-25 by Ryan Brown",
	category: \drums,
	tags: [\808, \hihat, \percussion, \cymbal, \unpitched]
	)
).add;
)
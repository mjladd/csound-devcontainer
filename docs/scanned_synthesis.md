# Csound Opcodes for Scanned Synthesis

Scanned Synthesis represents a powerful and efficient technique for animating wavetables
and controlling them in real-time. Developed by Bill Verplank, Rob Shaw, and Max
Mathews between 1998 and 1999 at Interval Research, Inc. it is based on the
psychoacoustics of how we hear and appreciate timbres and on our motor control (haptic)
abilities to manipulate timbres during live performance.  Scanned Synthesis involves a
slow dynamic system whose frequencies of vibration are below about 15 Hz. The ear
cannot hear the low frequencies of the dynamic system.  So, to make audible frequencies,
the "shape" of the dynamic system, along a closed path, is scanned periodically. The
"shape" is converted to a sound wave whose pitch is determined by the speed of the
scanning function. Pitch control is completely separate from the dynamic system control.
Thus timbre and pitch are independent.  This system can be looked upon as a dynamic
wave table. The model can be compared to a slowly vibrating string, or a two
dimensional surface obeying the wave equation.

Verplank, Shaw and Mathews studied scanned synthesis chiefly with a finite element model of a generalized string – a collection of masses connected by springs and dampers that can be analyzed with Newton's laws. From there, they generalized a traditional string by adding dampers and springs to each mass.

All parameters – mass, damping, earth-spring strength, and string tension can vary along the "string." The model is manipulated by pushing or hitting different masses (the individual samples in a very short wavetable) and by manipulating parameters. What is unique here is that the wavetable itself is a dynamic model.

You are manipulating the mechanical model at haptic rates 0-10 Hz, and independent to this, you are scanning out the wavetable at the desired frequency. Although, the table has its own dynamics, there are no discontinuities because the model is implemented as a circular string, so you end up with a 128 point looping oscillator with a constantly evolving loop. It is hard to believe, but true, that what results is a short sample that is animated and harmonically rich because of the complex interactive nature of the elements in the underlying system – the mechanics of the model.

In fact, even enveloping can come directly from the model.  It turns out that the specific setting of the centering springs can affect the damping of the system – low values allowing the rich timbre to ring, high values causing the tone to die away quickly.

In June of 1999, a graduate student from the MIT Media Lab, Paris Smaragdis, further generalized the model by added two Scanned Synthesis opcodes to Csound.  The first is an opcode that defines the mass/spring network and sets it in motion (scanu); and the second is an opcode that follows a predefined path (trajectory) around the network and outputs the dynamic waveform at a user specified frequency and amplitude (scans).

Scanned synthesis is a variant of physical modeling, where a network of masses connected by springs is used to generate a dynamic waveform.  The opcode scanu defines the mass/spring network and sets it in motion.  The opcode scans follows a predefined path (trajectory) around the network and outputs the dynamic waveform.  Several scans instances may follow different paths around the same network.

These are highly efficient mechanical modeling algorithms for both synthesis and sonic animation via algorithmic processing. They should run in real-time. Thus, the output is useful either directly as audio, or as controller values for other parameters.

Please note that the generated dynamic wavetables are very unstable. Certain values for masses, centering, damping can cause the system to "blow up" and the most "interesting" sounds to emerge from your loudspeakers...

## SCANU

The syntax for scanu is:

```csound
 scanu     init, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass, kstif, \
                                kcentr, kdamp, ileft, iright, kx, ky, ain, idisp, id
```

* init: The initial position of the masses.  If this is a negative number, then the absolute of init
signifies the table to use as a hammer shape.  If init > 0, the length of it should be the same
as the number of masses (128),  otherwise it can be anything.
* irate:  The amount of time between successive updates of the mass state.  Kind of like the
sample period of the system.  If the number is big the string will update at a slow rate
showing little timbral variability, otherwise it will change rapidly resulting in a more
dynamic sound.
* ifnvel: The number of the ftable that contains the initial velocity for each mass.  It should
have the same size as the number of masses (128).
* ifnmass: The number of the ftable that contains the mass of each mass.  It should have the
same size as the number of masses (128).
* ifnstif: The number of the ftable that contains the spring stiffness of each connection.  It
should have the same size as the square of the number of masses (16384).  The data
ordering is a row after row dump of the connection matrix of the system.
* ifncentr: The number of the ftable that contains the centering force of each mass.  It should
have the same size as the number of masses (128).
* ifndamp: The number of the ftable that contains the damping factor of each mass.  It should
have the same size as the number of masses (128).
* kmass: Scales the masses.
* kstif: Scales the spring stiffness.
* kcentr: Scales the centering force.
* kdamp: Scales the damping.
* ileft: If init < 0, the position of the left hammer (ileft = 0 is hit at leftmost, ileft = 1 is hit at
rightmost).
* iright: If init < 0, the position of the right hammer (iright = 0 is hit at leftmost, iright = 1 is
hit at rightmost).
* kx: The position of an active hammer along the string (0 leftmost,1 rightmost).  The shape of
the hammer is determined by init.  The power it pushes with is ky.
* ky: The power that the active hammer uses.
* ain:  The audio input that adds to the velocity of the masses.
* idisp: If 0 then there is no display. If 1 then display the dynamic evolution of the masses.
* id:  The ID of the opcode.  This will be used to point the scanning opcode (scans) to the
proper waveform maker.  If this value is negative, it indicates the wavetable on which to write
the waveshape.  That wavetable can be used later from another opcode to generate sound.
Note: The initial contents of this table will be destroyed, so don't rely on them being there.

## SCANS

The syntax for scans is:

`ar scans      kamp, kfreq, ifntraj, id[, korder]`

kamp: The output amplitude.  Note that the resulting amplitude is also dependent to the state of the wavetable.

kfreq: The frequency of the scan rate.

ifntraj: The number of the ftable that contains the scanning trajectory.  This is a series of numbers that contains addresses of masses - the order of these addresses is used as the scan path.  It shouldn't contain more values than the number of masses (128), and it should not contain negative numbers.

id: The ID number of the scanu waveform to use.

korder: The order of interpolation used internally.  It can take any value in the range 1 to 4, and defaults to 4, which is quartic interpolation.  2 is quadratic and 1 is linear.  The higher numbers are slower, but not necessarily better.

What is unique about the Smaragdis Csound implementation of Scanned Synthesis is the fact that he added support for a scanning path or matrix.  Essentially this offers the possibility of reconnecting the samples (masses/dots) in different orders (not necessarily to their direct neighbors) causing the signal to propagate quite differently. Essentially, the matrix has the effect of "molding" this surface/mesh into radically different shapes

## MATRICES

To produce the matrices, the file format is straightforward.  For example, for 4 masses we would have the following grid describing the connections:

  | 1 | 2 | 3 | 4 |
1 |   |   |   |   |
2 |   |   |   |   |
3 |   |   |   |   |
4 |   |   |   |   |

Whenever two masses are connected then the point they define is 1, so for a unidirectional string we would have the following connections, (1,2), (2,3), (3,4) (if it was bi-directional we would also have (2,1), (3,2), (4,3)).  So we fill these out with ones and the rest with zeros and we get:
  | 1 | 2 | 3 | 4 |
1 | 0 | 1 | 0 | 0 |
2 | 0 | 0 | 1 | 0 |
3 | 0 | 0 | 0 | 1 |
4 | 0 | 0 | 0 | 0 |

Similarly for the other shapes, we find the connections and fill them out.  This gets saved in an ASCII file, column by column.  Thus, the string shown above would be saved as:

0
1
0
0
0
0
1
0
0
0
0
1
0
0
0
0

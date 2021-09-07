# glitchMonger
glitchMonger Renoise tool

**Pattern matrix section name prefixes:**
 - s_ : "seed" patterns
 - r_ : patterns to fill with data from seed
   patterns

**Track prefixes:**
  - r_ : RANDOM tracks
 - k_ : random tracks, but KEEP in parallel with other k_ tracks when randomizing
 - o_ : LOOP tracks in order from s_ patterns
 - g_NN : GLITCH, like r_, but also randomize groups of NN rows from different patterns, keeping row numbers the same. ex: g_8 pattern 22  rows 16-23 copied from random pattern rows 16-23
 - x_NN : CROSS-GLITCH, like g_, but also randomizes the NN rows groupings. ex: x_16 pattern 22  rows 16-31 copied from random pattern rows 32-47 or 0-15


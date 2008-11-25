#!/usr/bin/ruby -w

require 'test/unit'
require "../lib/mpd.rb"

class TC_MPD < Test::Unit::TestCase
  def test_basic_playback
    m = MPD.new
    #m.debug_on
    assert_equal(MPD, m.class, 'Create new MPD object')
    m.setvol(66) if m.status['volume'] == '0'
    
    assert(pl = m.playlistinfo, 'Able to get playlist')
    assert(m.play(0), 'Able to play song')
    
    sleep 1
    assert(m.stop, 'Stop playback')
    
    x = m.status['random'] # "Get current random value"
    x = x.nil? ? 75 : x
    assert(m.random('1'), 'Turn random on')
    assert_equal("1", m.status['random'], 'Random should be on')
    assert(m.random('0'), 'Turn random off')
    assert_equal('0', m.status['random'], 'Random should be off')
    assert(m.random, 'Toggle random on')
    assert_equal("1", m.status['random'], 'Random should be on')
    assert(m.random, 'Toggle random off')
    assert_equal('0', m.status['random'], 'Random should be off')
    m.random(x) #Random to previous state
    
    assert(x = m.status['repeat'].dup, "Get current repeat value")
    assert(m.repeat('1'), 'Turn repeat on')
    assert_equal("1", m.status['repeat'], "Repeat should be on")
    assert(m.repeat('0'), 'Turn repeat off')
    assert_equal("0", m.status['repeat'], "Repeat should be off")
    assert(m.repeat, 'Toggle repeat on')
    assert_equal("1", m.status['repeat'], "Repeat should be on")
    assert(m.repeat, 'Toggle repeat off')
    assert_equal("0", m.status['repeat'], "Repeat should be off")
    m.repeat(x) #return to previous state
    
    sleep 1
    assert(m.playid(pl[4].dbid), 'Play song from ID')
    
    sleep 1
    assert(m.next, 'Go to next song')
    
    sleep 1
    assert(m.prev, 'Go to previous song')
    
    sleep 1
    m.stop
    sleep 1
    assert(m.seek(30), 'Seek to 30 seconds in song')
    
    sleep 1
    assert(m.seekid(30, pl[5].dbid),
           'Seek to 30 seconds in song #4')
    
    sleep 1
    assert(x = m.status['volume'], "Get current value for volume")
    assert(m.setvol(105), "Set volume to very high level")
    assert_equal("100", m.status['volume'], "Volume should never be >100")
    sleep 1
    assert(m.setvol(-5), "Set volume to very low level")
    assert_equal("0", m.status['volume'], "Volume should never be <0")

    #MPD#volume is deprecated but let's test it anyway.
    21.times do 
      sleep 0.02
      assert(m.volume(5), "Increment volume up by 5")
    end
    21.times do 
      sleep 0.02
      assert(m.volume(-5), "Decrement volume down by 5")
    end
    sleep 1
    assert(m.setvol(x))
    
    m.stop
  end
end

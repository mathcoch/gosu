# Encoding: UTF-8
require_relative 'test_helper'

# All Soundfiles are from http://www.bigsoundbank.com/ and "These files are free and completely royalty free for all uses."
class TestAudio < Minitest::Test
  include TestHelper
  include InteractiveTests
  
  def test_sample
    sound = Gosu::Sample.new(media_path('0614.ogg'))
    channel = sound.play(1,1,true)
    interactive_cli("Do you hear a StarWars like Blaster sound?")
    
    channel.volume = 0.5
    interactive_cli("Is the volume lowered?")
    channel.volume = 1.0
    
    channel.speed = 2.0
    interactive_cli("Does it play faster?")
    
    channel.pan = -1.0
    interactive_cli("Only left speaker?")
    
    channel.pan =  1.0
    interactive_cli("Only right speaker?")
    
    channel.pan =  0.0
    interactive_cli("Both speaker again?")
    
    refute channel.paused?
    assert channel.playing?
    
    channel.pause
    interactive_cli("Did it stop?")
    
    assert channel.paused?
    refute channel.playing?

    channel.resume
    interactive_cli("Back again?")
    
    refute channel.paused?
    assert channel.playing?    
    
    channel.stop
    
    refute channel.paused?
    refute channel.playing?
    
    channel = sound.play_pan(1,1,0.5,false)
    interactive_cli("Right speaker again but slowmotion this time?")
    
  ensure
    channel && channel.stop
  end
  
  class SongTestWindow < Gosu::Window
    def initialize
      super(50,50)
      self.caption = "Song-Test"
    end
  end
  
  def test_song
    # At the moment we need a window to hear more than one "tick" of a song.
    win = SongTestWindow.new
    
    assert_nil Gosu::Song.current_song
    
    song = Gosu::Song.new(media_path('0830.ogg'))

    song.play(true)
    interactive_cli("Do you hear a churchbell?") do
      200.times do win.tick end
    end
    
    song.volume = 0.5
    interactive_cli("Is the volume lowered?") do
      200.times do win.tick end
    end
    song.volume = 1.0
    
    assert_equal song, Gosu::Song.current_song
    
    refute song.paused?
    assert song.playing?
    
    song.pause
    interactive_cli("Did it stop?") do
      200.times do win.tick end
    end
    
    assert_equal song, Gosu::Song.current_song
    
    assert song.paused?
    refute song.playing?

    song.resume
    interactive_cli("Back again?") do
      200.times do win.tick end
    end
    
    refute song.paused?
    assert song.playing?    
    
    song.stop
    
    refute song.paused?
    refute song.playing?    
    
    assert_nil Gosu::Song.current_song
  end
end
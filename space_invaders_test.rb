require './space_invaders'
require 'test/unit'



class SpaceInvadersTest < Test::Unit::TestCase

  def test_move_player
    input ='#XX                                          %       #'
    invaders = SpaceInvaders.new(input)
    invaders.move_player(11)
    assert_match(/#XX          %                                       #/,invaders.field, 'Player not on position 11')
  end

  def test_move_invaders_right
    input ='#01 *****                                            #'
    invaders = SpaceInvaders.new(input)
    invaders.move_invaders_right
    assert_match(/#01  \*{5}                                           #/,invaders.field, 'Invaders not moved right')
  end

  def test_move_invaders_left
    input ='#01 *****                                            #'
    invaders = SpaceInvaders.new(input)
    invaders.move_invaders_left
    assert_match(/#01\*{5}                                             #/,invaders.field, 'Invaders not moved left')
  end

  def test_move_invaders_down
    input = "#01*****                                             #\n#02                                                  #"
    invaders = SpaceInvaders.new(input)
    invaders.move_invaders_down
	assert_match(/#01                                                  #\n#02\*{5}                                             #/,invaders.field,'Invaders not moved down')
  end

  def test_move_invaders_down_removed_the_last_line
    input = '#01*****                                             #\n#02                                                  #'
    invaders = SpaceInvaders.new(input)
    invaders.move_invaders_down
    assert_equal(2,invaders.field.split("\n").length,'The last line of the field is not removed')
  end

  def test_last_line_regex
    input = '#01*****                                             #\n#02                                                  #'
    invaders = SpaceInvaders.new(input)
	input.match(invaders.last_line_regex)
    assert_equal($1,'#02                                                  #')
  end
  
  def test_player_can_shoot
	input= "#01                                                  #\n#XX                                          %       #"
	invaders = SpaceInvaders.new(input)
	invaders.player_shoot(11)
	assert_match(/#01          i                                       #\n#XX          %                                       #/,invaders.field,'Player has not shot')
  end
	
end


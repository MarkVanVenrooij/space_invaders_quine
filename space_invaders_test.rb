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
    input = "#01*****                                             #\n#02                                                  #"
    invaders = SpaceInvaders.new(input)
    invaders.move_invaders_down
    assert_equal(2,invaders.field.split("\n").length,'The last line of the field is not removed')
  end

  def test_max_field_line
    input = "#01*****                                             #\n#02                                                  #"
    invaders = SpaceInvaders.new(input)
    assert_equal("02",invaders.max_field_line,'Max field line not correct')
  end

end


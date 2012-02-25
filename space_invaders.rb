class SpaceInvaders
  def initialize
    @field =
'######################################################
#01 *****                                            #
#02                                                  #
#03                                                  #
#04                                                  #
#05                                                  #
#06                                                  #
#07                                                  #
#08                                                  #
#09                                                  #
#XX                                          %       #
###0        1         2         3         4         5#
###12345678901234567890123456789012345678901234567890#'
  end

  def print_state
    puts @field
  end

  def move_player(position)
    #on player_line move % to position
    #get line 10
    player_line = @field.match(/^#XX\s*%\s*/)
    new_line = new_player_line(position)
    @field.sub!(player_line.to_s,new_line)
  end

  def new_player_line(position)
    return new_player_line(1) if position < 1
    return new_player_line(50) if position > 50
    result = '#XX'
    (position - 1).times() { result += ' '}
    result += '%'
    (50 - position).times() { result += ' '}
    result
  end

  def move_invaders_right
     lines = @field.split(/\n/)
     result_lines = lines.collect {|s| s = move_line_right(s)}

     lines.each do |s|
       i = lines.index(s)
       @field.sub!(lines[i],result_lines[i]) if(result_lines[i] != nil)
     end
  end



  def move_line_right(line)
     if line.chomp.end_with?('*#')
       return line  + 'collision'
     elsif line.match(/(#\d\d)(.*)#/)
       return $1 + move_stars_right_in_line($2) + '#'
     else
       return nil
     end

  end

  def move_stars_right_in_line(line)
    line.split(//).rotate(-1).join
  end

  def move_invaders_left
    lines = @field.split(/\n/)
    result_lines = lines.collect {|s| s = move_line_left(s)}

    lines.each do |s|
      i = lines.index(s)
      @field.sub!(lines[i],result_lines[i]) if(result_lines[i] != nil)
    end
  end

  def move_line_left(line)
    if line.chomp.match(/(#\d\d)\*(.*)#/)
      return line  + 'collision'
    elsif line.match(/(#\d\d)(.*)#/)
      return $1 + move_stars_left_in_line($2) + '#'
    else
      return nil
    end

  end

  def move_stars_left_in_line(line)
    line.split(//).rotate(1).join
  end

end

#detect collision with bounds

invader = SpaceInvaders.new
invader.print_state
#invader.move_player(11)
#invader.print_state
invader.move_invaders_left
#invader.move_invaders_left
invader.print_state


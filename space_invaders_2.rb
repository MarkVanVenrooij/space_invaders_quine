class SpaceInvaders
  attr_reader :field

  def initialize(field)
    @field = field
                @initial_field = field
  end

  def print_state
    puts @field
  end

  def next

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

  def move_invaders_down
    lines = @field.split(/\n/)
    result_lines = lines.collect {|s| s = move_line_down(s)}

        #remove last field line
    lines.each do |s|
      i = lines.index(s)
      @field.sub!(lines[i],result_lines[i]) if(result_lines[i] != nil)
    end

    #add an extra first line
    @field.insert(0,"#01                                                  #\n")
    #remove the last field line
    @field.sub!(last_line_regex,'')
  end

  def move_line_down(line)
    if(line.match(/#\d(\d)(.*)#/))
      '#0' + (Integer($1) + 1).to_s + $2 + '#'
    end
  end

  def last_line_regex
		index = @field.rindex(/#(\d\d)[\s|\*|i]{50}#\n*/)
						@field.match(/#(\d\d)[\s|\*|i]{50}#\n*/,index)
		Regexp.new('(#' + $1 + '[\s|\*|i]{50}#\n*)')
  end

  def player_shoot(position = 1)
		position = Integer(ARGV[0]) unless ARGV[0] == nil
		move_player(position)
		field.match(last_line_regex)
		old_line = $1
		new_line_arr = old_line.split(//)
		new_line_arr[position + 2] = 'i'
		field.gsub!(old_line, new_line_arr.join)
  end

  def write_file
		input = "";
		File.open(__FILE__) do |file|
			while line = file.gets
				input += line
			end
		end

		input.gsub!(/\n#####(.|\n)+#######\n/,@field)

		result = File.open("space_invaders_2.rb",'w')
		result.puts input
		result.close
		puts input
  end

end

field =
"
######################################################
#01 *****                                            #
#02                                                  #
#03                                                  #
#04                                                  #
#05                                                  #
#06                                                  #
#07                                                  #
#08                                                  #
#09i                                                 #
#XX%                                                 #
###0        1         2         3         4         5#
###12345678901234567890123456789012345678901234567890#
######################################################
"

invaders =  SpaceInvaders.new field
#puts invaders.field
invaders.player_shoot 
#puts invaders.field
#invaders.print_state
invaders.write_file



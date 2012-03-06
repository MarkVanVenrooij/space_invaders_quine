class SpaceInvaders

  def initialize(field)
    @field = field
	  init(field)
  end
	
	def init (field)
		@invaders = filter(field, 'i')
		@darts = filter(field, '\*')
	end
	
	def filter (field, char_to_replace) 
		arr = field.split(/\n/)
	  result = ''
		arr.each do |row|
			if row.match(/^#\d\d.*#/) then 
				result += row.gsub(Regexp.new(char_to_replace),' ') + "\n"
			end	
		end
		result
	end

  def game_over_message
"  ____  ____ ___ ___   ___       ___  __ __   ___ ____ 
 /    |/    |   |   | /  _]     /   \\|  |  | /  _]    \\
|   __|  o  | _   _ |/  [_     |     |  |  |/  [_|  D  )
|  |  |     |  \\_/  |    _]    |  O  |  |  |    _]    /
|  |_ |  _  |   |   |   [_     |     |  :  |   [_|    \\
|     |  |  |   |   |     |    |     |\\   /|     |  .  \\
|___,_|__|__|___|___|_____|     \\___/  \\_/ |_____|__|\\_|


game has been reset for next try"	
	end	

	def you_saved_the_world
"
 __     ______  _    _                           _   _   _                               _     _ 
 \\ \\   / / __ \\| |  | |                         | | | | | |                             | |   | |
  \\ \\_/ / |  | | |  | |  ___  __ ___   _____  __| | | |_| |__   ___  __      _____  _ __| | __| |
   \\   /| |  | | |  | | / __|/ _` \\ \\ / / _ \\/ _` | | __| '_ \\ / _ \\ \\ \\ /\\ / / _ \\| '__| |/ _` |
    | | | |__| | |__| | \\__ \\ (_| |\\ V /  __/ (_| | | |_| | | |  __/  \\ V  V / (_) | |  | | (_| |
    |_|  \\____/ \\____/  |___/\\__,_| \\_/ \\___|\\__,_|  \\__|_| |_|\\___|   \\_/\\_/ \\___/|_|  |_|\\__,_|


game has been reset for next time"	
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
		arr = @invaders.split(/\n/)
		result = ''
		#if any line has a colision move down in stead of right
		if(arr.index { |s| s.end_with?("*#")} != nil)
			#make sure direction is changed
			@field.gsub!(/#####r$/,'#####l')
		  return move_invaders_down
		else		
			arr.map { |row| result += move_line_right(row) + "\n"}
			@invaders = result
		end
	end
	
	

  def move_line_right(line)
		if line.match(/^(#\d\d)(.*)#/)
		 return $1 + $2.split(//).rotate(-1).join + '#'
		else
		 return nil
		end
  end

  def move_invaders_left
		arr = @invaders.split(/\n/)
		result = ''
		#if any line has a colision move down in stead of right
		if(arr.index { |s| s.match(/^#\d\d\*/)} != nil)
			#change direction
			@field.gsub!(/#####l$/,'#####r')
		  return move_invaders_down
		else		
			arr.map { |row| result += move_line_left(row) + "\n"}
			@invaders = result
		end
  end

  def move_line_left(line)
		if line.match(/^(#\d\d)(.*)#/)
      return $1 + $2.split(//).rotate(1).join + '#'
    else
      return nil
    end
  end

  def move_invaders_down
		lines = @invaders.split(/\n/)
    lines.map! {|s| s = move_line_down(s)}
		
		#remove last line
		last_line = lines.pop
		if(last_line.match(/\*+/)) then
			raise game_over_message
		end
		#add extra first line 
		lines.insert(0,"#01                                                  #")
    result = ''
		
		lines.each {|line| result += line + "\n"}
		@invaders = result;
	end

  def move_line_down(line)
    if(line.match(/#\d(\d)(.*)#/))
      return '#0' + (Integer($1) + 1).to_s + $2 + '#'
    end
  end

  def last_line_regex
		index = @field.rindex(/^#(\d\d)[\s|\*|i]{50}#\n*/)
						@field.match(/#(\d\d)[\s|\*|i]{50}#\n*/,index)
		Regexp.new('(#' + $1 + '[\s|\*|i]{50}#\n*)')
  end

  def player_shoot(position = 1)
		position = Integer(ARGV[0]) unless ARGV[0] == nil
		move_player(position)
		@field.match(last_line_regex)
		old_line = $1
		new_line_arr = old_line.split(//)
		new_line_arr[position + 2] = 'i'
		@field.gsub!(old_line, new_line_arr.join)
  end

  def write_file
		input = "";
		File.open(__FILE__) do |file|
			while line = file.gets
				input += line
			end
		end

		input.gsub!(/(\r?\n#####(l|r|.|\n|\r)+?#######\r?\n)/,@field)

		result = File.open("space_invaders_2.rb",'w')
		result.puts input
		result.close
		puts input
  end
	
	def calculate_new_field
		arr = @field.split(/\n/)
		result = ''
		i = 0
		arr.each do |line|
			if line.match(/^#\d\d.*#/) then 
				result += merge_darts_and_invaders(i)  + "\n"
				i += 1
				result
			else 
			  result += line + "\n"
			end
		end
		if(!result.match(/\*/)) then
			raise you_saved_the_world
		end
		@field = result
		init(@field)
	end
	
	def merge_darts_and_invaders(index)
	  invaders_arr = @invaders.split(/\n/)
		darts_arr = @darts.split(/\n/)
		merge_darts_and_invaders_line(darts_arr[index],invaders_arr[index])
	end
	
	def merge_darts_and_invaders_line(darts, invaders)
		i = 0
		darts_arr = darts.split(//)
		invaders_arr = invaders.split(//)
		darts_arr.map! do |s| 
			result = calculate_new_char(s,  invaders_arr[i])
			i += 1
			result
		end.join	
	end
	
	def calculate_new_char(dart,invader)
		if(invader == ' ' ) 
			return dart
		elsif (dart == 'i')
		  return ' ' 
		else
		  invader
		end
		
	end
	
	def move_darts_up
		lines = @darts.split(/\n/)
    lines.map! {|s| s = move_line_up(s)}
	
		#add extra first line 
		lines.insert(9,"#09                                                  #")
    result = ''
		
		#remove first line
	  lines.rotate!(1).pop
		
		lines.each {|line| result += line + "\n"}
		@darts = result;
	end
	
	def reset_field
		@field = 
"
_____________________________________________________r
#01   **********                                     #
#02   **********                                     #
#03   **********                                     #
#04   **********                                     #
#05                                                  #
#06                                                  #
#07                                                  #
#08                                                  #
#09                                                  #
#XX                       %                          #
###0        1         2         3         4         5#
###12345678901234567890123456789012345678901234567890#
______________________________________________________
".gsub(/_/,'#')
	end
	
	def move_line_up(line)
    if(line.match(/#\d(\d)(.*)#/))
      return '#0' + (Integer($1) - 1).to_s + $2 + '#'
    end
  end
	
	def next_move
		begin
			move_invaders
			calculate_new_field
			move_darts_up
			calculate_new_field
			player_shoot
		rescue Exception => msg
      reset_field
      message = msg
    ensure
      puts @field
			write_file
			if(message != nil) then
				puts message
			end
		end
	
	end
	
	def move_invaders
		if @field.match(/####r/)
			move_invaders_right
		else
			move_invaders_left
		end
	end
	
end

field =
"
#####################################################r
#01       **********                                 #
#02       **********                                 #
#03       **********                                 #
#04       **********                                 #
#05                                                  #
#06   i                                              #
#07   i                                              #
#08   i                                              #
#09   i                                              #
#XX   %                                              #
###0        1         2         3         4         5#
###12345678901234567890123456789012345678901234567890#
######################################################
"

invaders =  SpaceInvaders.new(field)
invaders.next_move

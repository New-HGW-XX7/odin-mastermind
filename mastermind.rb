class Code
  attr_accessor :solution, :feedback

  def initialize
    @solution = []
    @feedback = []
  end 

  def evaluate_guess(guess)
    self.feedback = []
    puts "Guess: #{guess}"
    solution_copy = Array.new(solution)

    if guess == solution
      puts "Code found: #{guess}"
      return true
    end

    guess.each_with_index do |x, i|

      if x == solution[i]
        self.solution[i] = nil
        guess[i] = nil
        self.feedback << 'black'


      elsif solution.include?(x)
        if guess[i + 1..3].count(x) >= solution.count(x)
          self.feedback << 'wrong'
          guess[i] = nil
        else
          self.feedback << 'white'
          guess[i] = nil
        end


      else
        feedback << 'wrong'
        guess[i] = nil

      end
    end

    self.solution = solution_copy

    puts "Feedback: #{feedback}"
    return feedback
  end
end


class Setter

  def set_code(code, arr)
    code.solution = arr 
  end
end

class Player
  attr_accessor :guess_tracker, :feedback_tracker, :improved_guess
  def initialize
    @guess_tracker = []
    @feedback_tracker = []
    @improved_guess = []
  end

  def random_colour(out)
    result = ['red', 'blue', 'green', 'yellow', 'orange', 'brown'].select { |el| el != out }
    y = result.sample

    random_position(4, y)
  end

  def random_position(out, colour)
    result = [0, 1, 2, 3].select { |el| el != out }
    x = result.sample
    unless improved_guess.none? { |el| el == nil }
    if improved_guess[x] == nil
      self.improved_guess[x] = colour
    else
      random_position(out, colour)
    end
    end

  end

  def guess_code(code, guess)
    self.guess_tracker = Array.new(guess)


    eval_result = code.evaluate_guess(guess) 
    return true if eval_result == true

    self.feedback_tracker = eval_result
    #puts "Feedbacktracker: #{feedback_tracker}"
    self.improved_guess = [nil, nil, nil, nil]

    feedback_tracker.each_with_index do |el, i|
      self.improved_guess[i] = guess_tracker[i] if el == 'black'
      puts "Improved guess on Black #{improved_guess}"
    end

    feedback_tracker.each_with_index do |el, i|
      if el == 'white'
        colour = guess_tracker[i]
        random_position(i, colour)
        puts "Improved guess on White #{improved_guess}"
      end
    end

    feedback_tracker.each_with_index do |el, i|
      if el == 'wrong'
        colour = guess_tracker[i]
        random_colour(colour) 
        puts "Improved guess on Wrong #{improved_guess}"
      end
    end
    return improved_guess
  end

end
#####
def framework
  setter = Setter.new
  player = Player.new
  code = Code.new
  puts "Player (1) or Setter (2)?"
  role_choice = gets.chomp.to_i

  if role_choice == 1
    computer_generated_solution = []
    4.times { computer_generated_solution << ['red', 'blue', 'green', 'yellow', 'orange', 'brown'].sample }
    code.solution = computer_generated_solution

    i = 0
    while i < 12
      puts "\nAttempt #{i + 1} out of 12"

      puts "Choose 4 colours in order"
      #puts "Solution: #{code.solution}"
      player_guess = []
      4.times { player_guess << gets.chomp }

      result = code.evaluate_guess(player_guess)
      i = 12 if result == true
      i += 1
      puts "You lose. The solution is #{code.solution}" if i == 12
    end

  elsif role_choice == 2
    puts "Choose 4 colours in order to generate a code"
    player_code = []
    4.times { player_code << gets.chomp }
    setter.set_code(code, player_code)

    computer_generated_guess = []
    4.times { computer_generated_guess << ['red', 'blue', 'green', 'yellow', 'orange', 'brown'].sample }

    i = 0
    while i < 12
      puts "\nAttempt #{i + 1} out of 12"

      player.guess_code(code, computer_generated_guess) if i == 0

      result = player.guess_code(code, player.improved_guess)
      i = 12 if result == true
      i += 1
      puts "Computer loses. The solution is #{code.solution}" if i == 12
    end

  else
    puts "Please choose 1 or 2"
    framework
  end
end
framework
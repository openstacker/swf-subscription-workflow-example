require 'aws'

# The RegistrationWorkflowSample demonstrates a simple site subscription workflow in Ruby, using the AWS SDK for Ruby,
# Amazon Simple Workflow and Amazon Simple Notification Service.
#
# The workflow is:
#
# 1. The user runs the program and a new workflow is generated
# 2. The first activity queries the user for an email address and/or phone number.
# 3. The second activity creates an sns topic and attempts to subscribe the user with it.
# 4. The third and fourth activities wait for the customer to confirm subscription by either email or phone.
# 5. The final activity removes any remaining sns confirmation requests, and then uses the same sns topic to notify the
#    user of success.
# 6. The workflow ends.
#
class SubscriptionWorkflowExample

  # Obtains the user's email, phone number, or both.
  #
  # @return [Hash]
  #   The entered email and phone values in a hash using the keys `:email` and `:sms`. If a value was not entered, it
  #   will be `nil`.
  #
  #   Example:
  #     { :email => "me@example.com", :phone => "12345678910" }
  #
  def get_subscription_data
    puts ".---------------------------------------------."
    puts "| How would you like to subscribe? You can    |"
    puts "| subscribe with either:                      |"
    puts "|                                             |"
    puts "| * your email address                        |"
    puts "| * your phone number                         |"
    puts "|                                             |"
    puts "| Note: your phone must be able to accept SMS |"
    puts "| messages to subscribe by phone.             |"
    puts "'---------------------------------------------'"
    puts "                                               "
    puts "Please enter one, or both, of these values now."
    return_values = {
      :email => prompt_with_confirmation("\nEmail address (you@example.com)"),
      :sms => prompt_with_confirmation("\nPhone number (numbers *only*)") }
  end

  def get_subscriber_info
    puts ".---------------------------------------------."
    puts "| Enter your subscription id. This can be     |"
    puts "| either your confirmed email address or sms  |"
    puts "| phone number.                               |"
    puts "|                                             |"
    puts "| Enter ':exit' to cancel.                    |"
    puts "'---------------------------------------------'"
    return prompt_with_confirmation("\nID")
  end

  # Prints the site banner
  def print_banner
    puts "#=============================================#"
    puts "|                                             |"
    puts "|          Welcome to Data-Frobotz!           |"
    puts "|                                             |"
    puts "#---------==========================----------#"
  end

  # Prints the site splash-screen and prompts the user to make a selection.
  # Once the user has made a selection, the method will call one of:
  #
  # * {#do_login}
  # * {#do_subscribe}
  # * {#do_unsubscribe}
  #
  def show_splash
    print_banner
    puts "|                                             |"
    puts "| Choose one of the following options:        |"
    puts "|                                             |"
    puts "| 1. login                                    |"
    puts "| 2. subscribe                                |"
    puts "| 3. unsubscribe                              |"
    puts "|                                             |"
    puts "#=============================================#"
    puts "                                               "
    puts "You can enter either the option number or name "
    puts "here. Case is irrelevant (in this case, haha). "
    puts "                                               "
    print "Option: "
    response = gets.strip.downcase
    case response
      when '1', 'login'
        do_login
      when '2', 'subscribe'
        do_subscribe
      when '3', 'unsubscribe'
        do_unsubscribe
    end
  end

  # Starts the "login" workflow.
  def do_login
    puts "\n**          Log in to Data-Frobotz           **"
    data = get_subscriber_info
    puts "  #{data}"
  end

  # Starts the "subscribe" workflow.
  def do_subscribe
    puts "\n**        Subscribe to Data-Frobotz          **"
    data = get_subscription_data
    puts "  #{data}"
  end

  # Starts the "unsubscribe" workflow.
  def do_unsubscribe
    puts "\n**      Unsubscribe from Data-Frobotz        **"
    data = get_subscriber_info
    puts "  #{data}"
  end

  # Prompts the user for input, confirming the choice by printing it back to the user and asking for a Yes/No (Y/N)
  # response. If the user responds with anything other than 'y' or 'Y', the prompt will be displayed again and the
  # user can re-enter the input.
  #
  # If the user wants to exit the prompt without providing input, he or she can type ':exit' at the prompt and exit
  # input.
  #
  # @param [String] prompt_text
  #   The text that will be used to prompt the user. If *prompt_text* set to "Name", for instance, the prompt before
  #   user input will be "Name: ". If *prompt_text* is not set, then a simple colon ':' will be the prompt.
  #
  # @return [String]
  #   The the text that was entered (and agreed upon), or `nil` if the user exited.
  #
  def prompt_with_confirmation(prompt_text = "")
    confirmed = :false
    user_text = nil
    while confirmed == :false

      # get the user's input for the field.
      print "#{prompt_text}: "
      user_text = gets.strip

      # if the user types ':exit', exit and return nil.
      if user_text == ':exit'
        return nil
      end

      # confirm the choice.
      puts "You entered: #{user_text}"
      print "Use this value? (y/n): "
      confirmation = gets.strip.downcase
      if confirmation == 'y'
        confirmed = :true
      else
        if confirmation.start_with?("y")
          puts "You can enter only 'y' or 'Y' to confirm your choice."
          puts "Extra characters in the response aren't recognized."
        else
          puts "Please re-enter your input, or type ':exit' to cancel input."
        end
      end
    end
    return user_text
  end # prompt_with_confirmation
end

# If this file is run, show the splash screen.
app = SubscriptionWorkflowExample.new
app.show_splash

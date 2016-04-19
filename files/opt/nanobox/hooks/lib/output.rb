module Nanobox
  module Output

    def logger
      $logger ||= ::Nanobox::Stderr.new(log_level: payload[:log_level])
    end


    # header
    #
    # Print a header, formatted to 70 characters, with the label
    #
    # Example:
    #
    # header "headline here"
    #
    # would produce:
    # ::::::::::::::::::::::::::: HEADLINE HERE :::::::::::::::::::::::::::
    def header(label)
      label = label.upcase
      max_len = 70
      middle = label.length + 2
      remainder = max_len - middle
      left = remainder / 2

      if remainder % 2 == 0
        right = left
      else
        right = left + 1
      end

      res = ""

      # start with a newline
      # res << "\n"

      # print the left column
      left.times { res << ':' }

      # print a space
      res << " "

      # print the label
      res << label

      # print the right column
      right.times { res << ':' }

      # end with a newline
      res << "\n"

      res
    end

    # process_start
    #
    # Print a header indicating the start of a process.
    #
    # Example:
    #
    # process_start "installing ruby-2.2"
    #
    # would produce:
    # INSTALLING RUBY-2.2 ------------------------------------------------>
    def process_start(label)
      label = label.upcase
      max_len = 70
      left = label.length + 1
      right = 1
      middle = max_len - (left + right)

      res = ""

      # start with a newline
      res << "\n"

      # print label
      res << label

      # print a space
      res << " "

      # print middle column
      middle.times { res << '-'}

      # print the right column
      res << ">"

      # end with a newline and the first column
      res << "\n   "

      res
    end

    # process_end
    #
    # Creates a hard delineation after a process
    def process_end
      "\n"
    end

    # subtask_start
    #
    # Print a header indicating the start of a sub task
    #
    # Example:
    #
    # subtask_start "after build hook 1"
    #
    # would produce:
    # AFTER BUILD HOOK 1 -------------------->
    def subtask_start(label)
      label = label.upcase
      max_len = 40
      left = label.length + 1
      right = 1
      middle = max_len - (left + right)

      res = ""

      # start with a newline
      res << "\n"

      # print label
      res << label

      # print a space
      res << " "

      # print middle column
      middle.times { res << '-'}

      # print the right column
      res << ">"

      # end with a newline and the column for the first output
      res << "\n   "

      res
    end

    # subtask_info
    #
    # Print subtask info formatted properly
    #
    # Example:
    #
    # subtask_info "blablablablablabla"
    #
    # would produce:
    #    blablablablablabla
    def subtask_info(data)
      data.gsub(/\n\n/, "\n").gsub(/\n/, "\n   ")
    end

    # subtask_success
    #
    # Print a footer indicating a successful sub task
    #
    # Example:
    #
    # subtask_success
    #
    # would produce:
    #    [√] SUCCESS
    def subtask_success
      "   [√] SUCCESS\n\n"
    end

    # subtask_fail
    #
    # Print a footer indicating a failed sub task
    #
    # Example:
    #
    # subtask_fail
    #
    # would produce:
    #    [!] FAILED
    def subtask_fail
      "   [!] FAILED\n\n"
    end

    # bullet
    #
    # Print a line item in the form of a bullet point
    #
    # Example:
    #
    # bullet "Language Detected : Ruby"
    #
    # would produce:
    # +> Language Detected : Ruby
    def bullet(message)
      "+> #{message}\n"
    end

    # bullet_info
    #
    # Print a line item in the form of a bullet point
    #
    # Example:
    #
    # bullet_info "Language Detected : Ruby"
    #
    # would produce:
    #  Language Detected : Ruby
    def bullet_info(message)
      "   #{message}"
    end

    # bullet_sub
    #
    # Print a line item in the form of a bullet point
    #
    # Example:
    #
    # bullet_sub "Language Detected : Ruby"
    #
    # would produce:
    #  - Language Detected : Ruby
    def bullet_sub(message)
      "   - #{message}"
    end

    # warning
    #
    # Print a warning message, formatted to a 70 character block paragraph
    #
    # Example:
    #
    # warning "We've detected you may be using... (abbreviated for clarity)"
    #
    # would produce:
    # -----------------------------  WARNING  -----------------------------
    # We've detected you may be using sessions in a way that could cause
    # unexpected behavior. Feel free to review the following guide for
    # more information : bit.ly/2sA9b
    def warning(message)
      res = "\n-----------------------------  WARNING  -----------------------------\n"

      res << format_block(message)

      res
    end

    # fatal
    #
    # Example:
    #
    # fatal "deploy stream disconnected", "Oh snap... (abbreviated for clarity)"
    #
    # would produce:
    # ! DEPLOY STREAM DISCONNECTED !
    #
    # Oh snap the deploy stream just disconnected. No worries, you can
    # visit the dashboard to view the complete output stream.
    def fatal(title, message=nil)
      res = "\n! #{title.upcase} !\n"

      if message
        res << format_block(message)
      end

      res
    end

    # format_block
    #
    # Print a message formatted as a block of text, wrapped at 70 characters
    #
    # Example:
    #
    # block "We've detected you may be using... (abbreviated for clarity)"
    #
    # would produce:
    # We've detected you may be using sessions in a way that could cause
    # unexpected behavior. Feel free to review the following guide for
    # more information : bit.ly/2sA9b
    def format_block(message)
      max_line_len = 70
      res = ""
      word = ""
      j = 0

      message.length.times do |i|
        char = message[i]

        if char == " "
          if j <= max_line_len
            # terminate the current line
            res << "\n"
            res << "#{word} "
            j = word.length + 1
            word = ""
          else
            res << "#{word} "
            word = ""
          end
        elsif i == message.length - 1
          if j <= max_line_len
            # terminate the current line
            res << "\n"
          end
          res << word
        else
          word << char
        end
      end

      res << "\n"

      res
    end

  end
end

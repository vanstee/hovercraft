module Hovercraft
  class Caller
    CALLERS_TO_IGNORE = [
      /\/hovercraft(\/(caller|loader|builder|server))?\.rb$/, # hovercraft libary
      /\/sinatra(\/(base|main|showexceptions))?\.rb$/,        # sinatra library
      /^\(.*\)$/,                                             # generated code
      /lib\/ruby/,                                            # ruby core libraries
      /rubygems\/custom_require\.rb$/,                        # rubygems require hacks
      /active_support/,                                       # active_support require hack
      /bundler(\/runtime)?\.rb/,                              # bundler require hacks
      /<internal:/,                                           # internal in ruby >= 1.9.2
      /src\/kernel\/bootstrap\/[A-Z]/                         # maglev kernel files
    ]

    def directory
      File.dirname(caller_file)
    end

    def caller_file
      cleaned_caller_files.first || $PROGRAM_NAME
    end

    def cleaned_caller_files
      caller(1).map    { |line| line.split(/:(?=\d|in )/, 3)[0, 1] }.
                reject { |file, *_| CALLERS_TO_IGNORE.any? { |pattern| file =~ pattern } }.
                flatten
    end
  end
end

require 'bundler/setup'
require 'codebreaker'

APP_ROOT = File.expand_path('../..', __FILE__)

def capture_output(&block)
  orig_stdout = $stdout.dup
  catcher = StringIO.new
  $stdout = catcher
  begin
    yield
  ensure
    $stdout = orig_stdout
  end
  catcher.string
end

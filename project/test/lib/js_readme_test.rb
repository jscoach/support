require 'test_helper'
require './lib/js'

describe "JS::ReadMe" do
  it "processes a README from GitHub" do
    package = {
      name: "hello",
      repo: "hello/world",
      description: "Hello, World!"
    }
    input = '''
      <h1>hello</h1>
      <a href="/world">Olá Mundo!</a>
    '''
    output = JS::ReadMe.execute(input, package)
    output.must_equal '''
      <h1 id="hello" class="deep-link package-name-redundant"><a href="#hello">hello</a></h1>
      <a href="https://github.com/hello/world/blob/master/world">Ol&#xE1; Mundo!</a>
    '''
  end
end

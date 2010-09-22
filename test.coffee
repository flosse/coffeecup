render = require('coffeekup').render

exports.run = ->
  test 'Literal text', ->
    'Just text' is render ->
      text 'Just text'

  test 'Default DOCTYPE', ->
    '<!DOCTYPE html>' is render ->
      doctype()

  test 'DOCTYPE', ->
    '<?xml version="1.0" encoding="utf-8" ?>' is render ->
      doctype 'xml'

  test 'Self-closing tags', ->
    '<br />' is (render -> br()) and
    '<img src="icon.png" alt="Icon" />' is render -> img src: 'icon.png', alt: 'Icon'

  test 'Normal tags', ->
    '<h1>hi</h1>' is render ->
      h1 'hi'

  test 'Attributes', ->
    '<a href="/" title="Home"></a>' is render ->
      a href: '/', title: 'Home'

  test 'HereDocs', ->
    "<script>$(document).ready(function(){\n  alert('test');\n});</script>" is render ->
      script """
        $(document).ready(function(){
          alert('test');
        });
      """

  test 'CoffeeScript', ->
    expected = """
      <script>(function () {
                return $(document).ready(function() {
                  return alert('hi!');
                });
              })();</script>"""
    rendered = render ->
      coffeescript ->
        $(document).ready ->
          alert 'hi!'

    rendered is expected

  test 'Context vars', ->
    expected = """
      <h1>bar</h1>
      <ul><li>pong</li>
      </ul>
    """
    tpl = ->
      h1 @foo
      ul ->
        li @ping
        
    expected is render tpl, context: {foo: 'bar', ping: 'pong'}

  test 'Comments', ->
    '<!--Comment-->' is render ->
      comment 'Comment'

  puts "\nTests: #{tests.length} | Passed: #{passed.length} | Failed: #{failed.length} | Errors: #{errors.length}"

[tests, passed, failed, errors] = [[], [], [], []]

test = (name, code) ->
  tests.push name
  print "Testing \"#{name}\"... "
  try
    if code()
      passed.push name
      puts "[OK]"
    else
      failed.push name
      puts "[Failed]"
  catch ex
    errors.push name
    puts "[Error] (#{ex.message})"

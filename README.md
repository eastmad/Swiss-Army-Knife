Hello.

The six folders contain step by step examples of application development around Sinatra. 
Folder 'one' is the simplest example, all the way to six that is based on a live application. 
Jump through to what you find most interesting!

While it is assumed you know a little about ruby, the examples are based on showing
development practices

# One

This folder contains the simplest possible Sinatra example. Sinatra is often considered to be more a DSL than 
a framework - a DSL for defining restful HTTP.

To run this, you will need to get the sinatra gem

    gem install sinatra

then run

    ruby simple.rb

and you will see the simple result at http://localhost:4567/hi

So looking at the code and the result, you will guess that:

1. We wrote some code to respond to the request 'GET /hi'
2. The Sinatra default port must be 4567

One other thing. If you just browse http://localhost:4567, Sinatra provides a nice error page.


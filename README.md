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

# Two

Now we add the joys of Bundler, and take more control of the webserver.

If you haven't already used it, [Bundler](http://gembundler.com/) gives you version level control of your gems.
So you can see that the Gems we will need are listed in the Gemfile.

Start by getting Bundler

    gem install bundler
    
and from now on install gems as listed in the Gemfile

    bundle install

Follow the site for more details.
To run the example, this time use 

    bundle exec ruby simple.rb

In example One, Sintra used whatever web server it could find. Now we will make sure we are using [Thin](http://code.macournoyer.com/thin/).


# Three
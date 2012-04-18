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

Now we add four files to support and configure Thin the way we want it.

So what should we want to do?

- to start the Thin server
- to stop it
- to define the name of the Sinatra app to run
- to set the port
- to set some logging
- to make a nice process

The files we add do that.

Use the start bash script:

    ./start

Then stop the server when you are done.

    ./stop

The **rackup.ru** sets up the ruby app, wheras the **config.yml** configures Rack, the main bit of Thin. 

Taking a look at the business part of the **start** script, we have:

    bundle exec thin -s 1 -C config.yml -R rackup.ru start

which asks Bundler to start one Thin process within its Gemfile environment.

How about some code now?

# Four

So, some more interesting Sinatra code. The application file is now called **svnstats.rb** (with one change in **rackup.ru**) which indicates what we will be doing a bit later.

    get '/developers/:name' do

      #get the name paramater
      name = params[:name]

      #Create filename
      filename = "userdata/user_#{name}@company.com.html"

      #render
      File.read(File.join(File.dirname(__FILE__), filename
    
    end

(To be continued)

# Five
# Six
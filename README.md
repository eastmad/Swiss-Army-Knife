Hello.

The six folders contain step by step examples of application development around Sinatra. 
Folder 'one' is the simplest example, all the way to six that is based on a live application. 
Jump through to what you find most interesting!

While it is assumed you know a little about ruby, the examples are based on showing development practices.
I'll assume you have ruby installed, a healthy internet connection, and don't get too flustered about installing or building things on your machine.

I have tried to [document the problems](https://github.com/eastmad/Swiss-Army-Knife/wiki/iceberg-ahead) I confronted getting things to work - and if you are new to any of the tools used, you will hit issues.  

Windows users will bump into even more problems, and some things do not actually work - but I have made [notes on these](https://github.com/eastmad/Swiss-Army-Knife/wiki/windows) as well.   

# One

This folder contains the simplest possible Sinatra example. Sinatra is often considered to be more a DSL than 
a framework - a DSL for defining restful HTTP.

To run this, you will need to get the sinatra gem

    gem install sinatra

then run

    ruby simple.rb

and you will see the simple result at *'http://localhost:4567/hi'*

So looking at the code and the result, you will guess that:

1. We wrote some code to respond to the request 'GET /hi'
2. The Sinatra default port must be 4567

Note that the Sintra output stated that it had "backup from WEBrick". That's the default web server.
If you just browse http://localhost:4567, Sinatra provides a nice error page.

# Two

Now we add the joys of Bundler, and take more control of the webserver.

If you haven't already used it, [Bundler](http://gembundler.com/) gives you version level control of your gems. 
So you can see that the Gems we will need are listed in the Gemfile.

Start by getting Bundler

    gem install bundler
    
and from now on install gems as listed in the Gemfile

    bundle install

Do this for each working directory we go to.
Follow the site for more details.
To run the example, this time use 

    bundle exec ruby simple.rb

In example One, Sintra used whatever web server it could find. Now the bundle has made it available, Sintra should use [Thin](http://code.macournoyer.com/thin/).


# Three

Now we add four files to support and configure Thin the way we want it.
We are in a different directory now, so don't forget

 bundle install

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

Start with:
 
 bundle install

So, some more interesting Sinatra code. The application file is now called **svnstats.rb** (with one change in **rackup.ru**) which indicates what we want this example app to do.

    get '/developers/:name' do

      #get the name paramater
      name = params[:name]

      #Create filename
      filename = "userdata/user_#{name}@company.com.html"

      #render
      File.read(File.join(File.dirname(__FILE__), filename))
    
    end

We have some generated svn statistics in the directory **userdata**, and we just want to display them.

A few steps beyond Hello World. First of all, Sintra can represent a varibale part of the url with named parameter, placed in the *params* hash. We use this to get a developers name, and then extract the file that holds the stats for that developer.

Remember that with ruby, the last statement of a method to be evaluated is the return value. So the File.read statement is the thing to be rendered.  That odd \_\_FILE\_\_ construct means "the file that we are currently in". 

What sort of error handling should exist here? Clearly we shouldn't attempt to relate a file to name if the file may not exist.

Use the start bash script:

    ./start

Looking at the pre-existing data in the userdata folder, entering the url:

    http://localhost:4567/developers/david.eastman 
   
should render a statistics screen that states I made almost 7% of 144 commits.

As we have't fixed them up, no other links are working. And notice Sintra is not supplying a default error page anymore.

# Five

Now the server responds to http://localhost:4567/developers, and the individual developers listed.

This had been done by use of a template.

In **svnstats.rb**, we have the extra route:

    get '/developers' do
      erb :developers
    end

This tells Sinatra to render the erb template called :developers in response. Sinatra can use quite a few [template languages](http://www.sinatrarb.com/intro#Available%20Template%20Languages)

As Sinatra follows convention over configuration, you can be sure the template sits in /views/developers.rhtml.

The template **developers.rhtml** contains the code fragment

    ..
    <% @user_data.each do | dev | %>
      <tr><td><b><a href="developers/<%=dev[:name]%>"><%=dev[:name]%><b></td></tr>
    <% end %>
    ..

which enumerates over the instance collection @user_data to produce the links for the developers.

So before the developers page is rendered, somewhere the array @user_data is populated with the developer names.

It is done in **svnstats.rb** in a before block.

    ..
    before do
      @user_data = []

      Dir.entries(File.join(File.dirname(__FILE__),"userdata")).each do | f |
	    
        #regex for name
        md = /user_(.*)@company.com/.match(f)

        @user_data << {:name => md[1], :file => f} unless md.nil?
      end
    end
    .. 

Sintra passes any instance variable, in this case **@users_data** to any template that a route renders.
The rest of the block enumerates over the **usersdata** directory, and extracts the developer's name from the filename using a simple regex. If match data exists, a hash is added to **@user_data** with the group match.

# Six

Say hello to [nokogiri](http://nokogiri.org). This guide is called Swiss Army Knife because it uses a few of the more useful bits of ruby, and one of them is nokogiri. This gem makes using xpath, for example, very simple. 

Running our app using

    ./start

you will see that instead of just rendering the generated stats files directly for each developer, we have extracted the information as needed and passed it to a template: 

    get '/developers/:name' do
      #get the name paramater
      name = params[:name]
      
      #Create filename
      @filename = "userdata/user_#{name}@company.com.html"

      #render
      erb :developer
    end

And the *:developer* template, faithfully sitting in **views/developer.rhtml** works pretty much like the other template we used in the previous section. However it calls a method called *find_developer_stats* passing in *@filename*; where does this come from?

At the top of **statsvn.rb** we have included a helper file:

    require_relative 'lib/helpers/developers_helper'
    helpers DeveloperStatsHelper

which effectively allows any methods in the module DeveloperStatsHelper to be called directly.

    def find_developer_stats filename
        @doc = Nokogiri::XML(File.open(filename))
        
        def_list = @doc.css("dl[class='attributes']")    
      
        login_name = def_list.css("dt:contains('Login name') + dd").text
        total_commits = def_list.css("dt:contains('Total Commits') + dd").text
        lines_of_code = def_list.css("dt:contains('Lines of Code') + dd").text
        recent_commit = def_list.css("dt:contains('Most Recent Commit') + dd span")
        
        {:name => login_name, :commits => total_commits, :linesofcode => lines_of_code, :recent => recent_commit}
    end

In this case, we choose a CSS style selector and with no ceremony ask for the "dl tags that have a 'class' value of 'attriutes'".

An example of the html we will hit from the filename was pass in appears here:

    <dl class="attributes">
        <dt>Login name:</dt>
        <dd>bill.chapman@company.com</dd>
        <dt>Total Commits:</dt>
        <dd>264 (12.7%)</dd>
        <dt>Lines of Code:</dt>
        <dd>9,830 (14.1%)</dd>
        <dt>Most Recent Commit:</dt>
        <dd><span class="date">2011-04-08 17:21</span></dd>
    </dl>

Hence, the *login_name* is extracted with the instruction meaning "get me the inner text of the tag following the *dt* tag that contains the string 'Login name'"

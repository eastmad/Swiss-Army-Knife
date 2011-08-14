#<h1>VMP Developers: george.sibley@bt.com</h1>
#<div id="parentlink">&#171; <a href="index.html">Development Statistics for VMP</a> &#171; <a href="developers.html">Developers</a></div>
#<dl class="attributes">
#    <dt>Login name:</dt>
#    <dd>george.sibley@bt.com</dd>
#    <dt>Total Commits:</dt>
#
#    <dd>141 (6.8%)</dd>
#    <dt>Lines of Code:</dt>
#    <dd>310 (0.4%)</dd>
#    <dt>Most Recent Commit:</dt>
#    <dd><span class="date">2011-03-25 15:12</span></dd>
#</dl>

require 'nokogiri'

module DeveloperStatsHelper
  def find_developer_stats filename
    @doc = Nokogiri::XML(File.open(filename))
    dev_stats = {}
    
    def_list = @doc.css("dl[class='attributes']")    
  
    login_name = def_list.css("dt:contains('Login name') + dd").text
    total_commits = def_list.css("dt:contains('Total Commits') + dd").text
    lines_of_code = def_list.css("dt:contains('Lines of Code') + dd").text
    recent_commit = def_list.css("dt:contains('Most Recent Commit') + dd span")
    
    {:name => login_name, :commits => total_commits, :linesofcode => lines_of_code, :recent => recent_commit}
  end
end

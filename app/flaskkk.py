from flask import Flask, render_template, request
import json
import feedparser
app = Flask(__name__, template_folder='.')
RSS_FEEDS = {
	'1': 'https://www.reddit.com/r/PowerShell.rss',
	'2': 'http://powershell-scripting.com/index2.php?option=com_joomlaboard&func=sb_rss&no_html=1'
}

@app.route('/')
def login():
    
    return "<b><a href = '/Powershell'>Powershell</a></b>" + ' ' + "<b><a href = '/pscripting'>Powershell Scripting</a></b>"
   

@app.route('/Powershell')
def homepage():
    feed = feedparser.parse(RSS_FEEDS['1'])
    return render_template("templates/pscripting.html", ent = feed.entries)

@app.route('/pscripting')
def homepage2():
    feed = feedparser.parse(RSS_FEEDS['2'])
    return render_template("/templates/pscripting.html", ent = feed.entries)





if __name__ == '__main__':
  app.run(host='0.0.0.0', debug=True)
# DankMemer_Spammer
Automatically spams any command(s) of your choosing at definable frequencies to best take advantage of free coins

Requires dankmemer.lol bot to be installed on the server of your expected use, however could be customized to use with any bot.

Setup is simple.
* Edit beggar_config.json
<table>
  <thead><tr><td colspan=3>Commands:</td></tr><tr><th>Key</th><th>What does it do?</th><th>Type</th></tr></thead>
  <tr><td>id</td><td>Gives a unique id to be used for counters (no spaces, alphanumeric only pls)</td><td>String</td></tr>
  <tr><td>command</td><td>Defines the command to be run. (Don't add the bot prefix here)</td><td>String</td></tr>
  <tr><td>freq</td><td>How often, in seconds, this command should run.</td><td>String</td></tr>
  <tr></tr>
  <thead><tr><td colspan=3>Preferences:</td></tr><tr><th>Key</th><th>What does it do?</th><th>Type</th></tr></thead>
  <tr><td>application.winTitle</td><td>This is a string that the title of the discord window should contain in order to be discovered properly</td><td>String</td></tr>
  <tr><td>application.winClass</td><td>This is the class of the window. Default is best unless you know what you are doing.</td><td>String</td></tr>
  <tr><td>application.hideGui</td><td>This enables / disables a gui on launch which shows what windows were found (Disabled by default</td><td>IntBool</td></tr>
  <tr><td>application.debug</td><td>This enables / disables debugging to debug.ini (Enabled by default)</td><td>IntBool</td></tr>
  <tr><td>bot.prefix</td><td>This is the prefix to be added to every command</td><td>String</td></tr>
</table>
-- this is the file to which the selected tweet will be appended; revise as needed
set aliasPathFiche to alias ((path to documents folder from user domain as text) & "filepath.txt")

-- tweet info: username - name - tweet - retweeted info (if exists) - date/time
-- we parse this tweet for username and tweet, discarding remaining
-- doing this results in space at end of tweet. fix.
set textRegExPattern to "([A-Za-z0-9_]+)(?: - .+? - )(.+?)(?: - Retweeted by [A-Za-z0-9_]+)?(?: - [0-9]{1,2} [A-Z]{1}[a-z]{2} [0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2})(?: )?"

-- this is the text written to the file between each tweet; revise for your preferences
set textTweetSpaceDivider to return & "--------" & return & return


-- get info from selected tweet (app only allows one selection)
tell application "System Events"
	tell application process "YoruFukurou"
		tell front window
			-- find the selected row (this will be a list of one item)
			set listRowSelected to every row of table 1 of scroll area 2 whose selected is true
			
			-- get tweet info, which will be in the form of: username - name - tweet - retweeted info (if exists) - date/time
			set textTweetInfo to value of static text 1 of item 1 of listRowSelected
		end tell
	end tell
end tell



-- capture username and tweet from tweet info, reformatting as a retweet
tell application "ASObjC Runner"
	set textRetweet to look for textRegExPattern in textTweetInfo replacing with "RT @$1: $2"
end tell



-- write retweet to file, ensuring file access is closed even if there's an error.
try
	open for access aliasPathFiche with write permission
	
	write (textRetweet & textTweetSpaceDivider) to aliasPathFiche starting at eof as text
	
	delay 0.4
end try

close access aliasPathFiche
